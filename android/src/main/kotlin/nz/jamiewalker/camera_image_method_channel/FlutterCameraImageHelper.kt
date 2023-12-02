package nz.jamiewalker.fh_vitals_sdk_flutter

import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.imgproc.Imgproc
import java.nio.ByteBuffer

class FlutterCameraImageHelper {
    companion object {
        fun convertFlutterCameraImageMapToRgbaMat(map: HashMap<*, *>): Mat? {
            val width = map.let { it["width"] as? Int }
            val height = map.let { it["height"] as? Int  }

            // Parse the list of planes as a List<HashMap<*,*>>
            val planesList = map
                    .let { it["planes"] as? List<*> }
                    ?.let { listOfMaps -> listOfMaps.mapNotNull { element -> element as? HashMap<*,*> }
                            .let { list -> list.ifEmpty { null }}}

            // Parse the ByteArray data from each plane HashMap
            val planeBytes = planesList
                    ?.mapNotNull { planeMap -> planeMap["bytes"] as? ByteArray }
                    ?.let { mappedList -> mappedList.ifEmpty { null } }

            if (width == null || height == null || planesList == null || planeBytes == null) {
                return null
            }

            return yuvBuffersToBGRMat(
                    ByteBuffer.wrap(planeBytes[0]),
                    ByteBuffer.wrap(planeBytes[1]),
                    ByteBuffer.wrap(planeBytes[2]),
                    width,
                    height)
        }

        private fun yuvBuffersToBGRMat(yBuffer: ByteBuffer,
                                       uBuffer: ByteBuffer,
                                       vBuffer: ByteBuffer,
                                       width: Int,
                                       height: Int): Mat {
            val nv21: ByteArray
            val ySize = yBuffer.remaining()
            val uSize = uBuffer.remaining()
            val vSize = vBuffer.remaining()
            nv21 = ByteArray(ySize + uSize + vSize)

            // U and V are swapped
            yBuffer[nv21, 0, ySize]
            vBuffer[nv21, ySize, vSize]
            uBuffer[nv21, ySize + vSize, uSize]

            val toReturn = Mat(height + height / 2, width, CvType.CV_8UC1)
            toReturn.put(0, 0, nv21)
            Imgproc.cvtColor(toReturn, toReturn, Imgproc.COLOR_YUV2BGR_NV21, 3)
            return toReturn
        }
    }
}