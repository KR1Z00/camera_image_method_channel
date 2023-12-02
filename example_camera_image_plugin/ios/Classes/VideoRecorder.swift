import AVFoundation

/**
 Records an MP4 H.264 video to an output `URL`, by appending video frames as `CVPixelBuffer` representations
 */
class VideoRecorder: NSObject {
    
    private let stillCapturingDispatchGroup = DispatchGroup()
    private var photoCount = 0
    private var currentOutputURL: URL!
    
    private var recording = false
    
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var videoInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var presentationTime: CMTime!
    private var videoFrameDuration = CMTime(value: 1, timescale: 30)
    
    /**
     - returns: The frames per second for the video, as a `Float`
     */
    func getFPS() -> Float {
        return 1.0 / Float(videoFrameDuration.seconds)
    }
    
    /**
     Prepares this `VideoRecorder` to record a new video to the given `url`
     
     - parameter url: The `URL` to which the video will be written
     */
    func prepareToRecord(toURL url: URL) throws {
        guard !recording else { throw VideoRecorderError.alreadyRecording }
        currentOutputURL = url
        guard setupWriter() else { throw VideoRecorderError.cannotSetupWriter }
    }
    
    /**
     Makes this `VideoRecorder` ready accept pixel buffers, via the `appendPixelBuffer` function
     */
    func startRecording() throws {
        guard let _ = assetWriter else { throw VideoRecorderError.wasNotPreparedToRecord }
        recording = true
    }
    
    /**
     Appends a frame to the video
     
     - parameter cvPixelBuffer: A `CVPixelBuffer` representation of the video frame
     */
    func appendPixelBuffer(_ cvPixelBuffer: CVPixelBuffer) throws {
        guard recording,
              let videoInput = videoInput,
              let videoInputPixelBufferAdaptor = videoInputPixelBufferAdaptor else { return }
        
        guard try manageAssetWriterIfNecessaryAndCheckIfCanContinueWritingVideo() else {
            return
        }
        
        stillCapturingDispatchGroup.enter()
        if videoInput.isReadyForMoreMediaData {
            videoInputPixelBufferAdaptor.append(cvPixelBuffer, withPresentationTime: presentationTime)
            presentationTime = CMTimeAdd(presentationTime, videoFrameDuration)
        }
        stillCapturingDispatchGroup.leave()
    }
    
    /**
     Stops recording the video, renders the output, and then emits the `URL` containing the video file upon completion
     
     - parameter completion: A closure that is passed the new video file's `URL` once the rendering is complete
     */
    func stopRecording(completion: @escaping (URL) -> ()) {
        guard recording, let assetWriter = assetWriter else {
            return
        }
        
        recording = false
        assetWriter.finishWriting {
            completion(self.currentOutputURL)
        }
    }
    
    /**
     Cleans up the existing `AVAssetWriter` if it exists and is currently writing
     */
    private func cleanUpExistingAssetWriterIfNeeded() {
        if let assetWriter = assetWriter, assetWriter.status == .writing {
            assetWriter.cancelWriting()
        }
    }
    
    /**
     Sets up a new `AVAssetWriter` to render the video
     */
    private func setupWriter() -> Bool {
        cleanUpExistingAssetWriterIfNeeded()
        guard let assetWriter = try? AVAssetWriter(outputURL: currentOutputURL, fileType: .mp4) else { return false }
        self.assetWriter = assetWriter
        
        let videoOutputSettings = AVAssetWriterInput.h264VideoSettingsDictionary(withHeight: 1920, andWidth: 1080)
        
        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
        videoInput.expectsMediaDataInRealTime = true
        videoInputPixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput, sourcePixelBufferAttributes: nil)
        guard assetWriter.canAdd(videoInput) else { return false }
        assetWriter.add(videoInput)
        
        self.videoInput = videoInput
        
        return true
    }
    
    private func manageAssetWriterIfNecessaryAndCheckIfCanContinueWritingVideo() throws -> Bool {
        guard let assetWriter = assetWriter else { return false }
        
        func throwError() throws {
            if let error = assetWriter.error as? NSError {
                throw error
            }
        }
        
        switch assetWriter.status {
        case .unknown:
            if assetWriter.startWriting() {
                self.presentationTime = .zero
                assetWriter.startSession(atSourceTime: .zero)
                return true
            } else {
                try throwError()
                return false
            }
        case .writing: return true
        default:
            try throwError()
            return false
        }
    }
    
}

/**
 The `Error`s that a `VideoRecorder` can encounter
 */
enum VideoRecorderError: Error, LocalizedError {
    /**
     There was already a video recording when the `prepareToRecord` function was called
     */
    case alreadyRecording
    
    /**
     An error occurred setting up the `AVAssetWriter`
     */
    case cannotSetupWriter
    
    /**
     The `prepareToRecord` function had not been called, when the `startRecoding` function was called
     */
    case wasNotPreparedToRecord
    
    public var errorDescription: String? {
        switch self {
        case .alreadyRecording: return "Tried to call prepareToRecord while already recording"
        case .cannotSetupWriter: return "Something went wrong setting up the AVAssetWriter"
        case .wasNotPreparedToRecord: return "Called startRecording before prepareToRecord"
        }
    }
}

extension AVAssetWriterInput {
    
    /**
     - returns: A `Dictionary` for the `outputSettings` of an `AVAssetWriterInput`, to write H.264 video frames to the file
     */
    static func h264VideoSettingsDictionary(withHeight height: Int, andWidth width: Int) -> [String : Any] {
        return [AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : width,
               AVVideoHeightKey : height] as [String : Any]
    }
    
}
