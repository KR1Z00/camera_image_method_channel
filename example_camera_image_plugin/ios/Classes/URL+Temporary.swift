extension URL {
    
    static func randomTemporaryFileUrl(withExtension fileExtension: String) -> URL {
        return temporaryFileUrl(named: UUID().uuidString, withFileExtension: fileExtension)
    }
    
    static func temporaryFileUrl(named filename: String, withFileExtension fileExtension: String) -> URL {
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = URL(fileURLWithPath: directoryPath.absoluteString, isDirectory: true)
        return url.appendingPathComponent("\(filename).\(fileExtension)")
    }
    
}
