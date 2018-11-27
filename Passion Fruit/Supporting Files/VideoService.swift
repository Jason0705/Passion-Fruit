//
//  VideoService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-25.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit
import AVFoundation

class VideoService {
    
    static func cropVideo( _ outputFileUrl: URL, callback: @escaping ( _ newUrl: URL ) -> () )
    {
        // Get input clip
        let videoAsset: AVAsset = AVAsset( url: outputFileUrl )
        let clipVideoTrack = videoAsset.tracks( withMediaType: AVMediaType.video ).first! as AVAssetTrack
        
        // Make video to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize( width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.height )
        videoComposition.frameDuration = CMTimeMake( value: 1, timescale: 30 )
        
        // Rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction( assetTrack: clipVideoTrack )
        let transform1 = CGAffineTransform( translationX: clipVideoTrack.naturalSize.height, y: -( clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height ) / 2 )
        let transform2 = transform1.rotated(by: CGFloat( M_PI_2 ) )
        transformer.setTransform( transform2, at: CMTime.zero)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds( 60, preferredTimescale: 30 ) )
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export
        let croppedOutputFileUrl = URL( fileURLWithPath: self.getOutputPath( randomString(length: 16) ) )
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        exporter.outputURL = croppedOutputFileUrl
        exporter.outputFileType = AVFileType.mov
        
        exporter.exportAsynchronously( completionHandler: { () -> Void in
            DispatchQueue.main.async(execute: {
                callback( croppedOutputFileUrl )
            })
        })
    }
    
    static func getOutputPath( _ name: String ) -> String
    {
        let documentPath = NSSearchPathForDirectoriesInDomains(      .documentDirectory, .userDomainMask, true )[ 0 ] as NSString
        let outputPath = "\(documentPath)/\(name).mov"
        return outputPath
    }
    
    static func createAVPlayerLayer(on view: UIView, with url: URL) {
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
}
