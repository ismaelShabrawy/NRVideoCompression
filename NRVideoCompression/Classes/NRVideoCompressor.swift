//
//  NRVideoCompressor.swift
//  Pods
//
//  Created by Naveen Rana on 24/10/16.
//
//

import Foundation
import AVFoundation

/// This class is used for video compression you can compress the video taken from camera or choose from library.

public class NRVideoCompressor {

    /**
     This function is used for compressing the video from iphone camera or camera roll.
     - Parameters:
     - presetName: AVAssetExportPresetLowQuality, AVAssetExportPresetMediumQuality, AVAssetExportPresetHighQuality.
     - inputURL: This is the input video url which need to be compressed.
     - completionHandler: This completion handler will give you output url of compressed video.

     */
    public class func compressVideoWithQuality(presetName: String, inputURL : NSURL, completionHandler: @escaping (_ outputUrl: NSURL) -> ()) {

        let videoFilePath = NSTemporaryDirectory() + "/compressVideo.mp4"
        let savePathUrl =  NSURL(fileURLWithPath: videoFilePath)
        let sourceAsset = AVURLAsset(url: inputURL as URL, options: nil)

        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: presetName)!
        assetExport.outputFileType = AVFileType.mov
        assetExport.outputURL = savePathUrl as URL
        if FileManager.default.fileExists(atPath: videoFilePath) {
            try! FileManager.default.removeItem(atPath: videoFilePath)
        }
        assetExport.exportAsynchronously { () -> Void in

            switch assetExport.status {
            case AVAssetExportSession.Status.completed:

                DispatchQueue.main.async(execute: {
                    print("successfully exported at \(savePathUrl.path!))")
                    completionHandler(savePathUrl)
                })


            case  AVAssetExportSession.Status.failed:
                print("failed (assetExport.error)")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled (assetExport.error)")
            default:
                print("complete")
            }
        }
    }
}
