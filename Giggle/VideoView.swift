//
//  ViedeoView.swift
//  Giggle
//
//  Created by Zac Adams on 24/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit
import MediaPlayer


/**
*  Wrapper view for iOS native video players
*/
class VideoView: UIView {
    
    static let kVideoPlayerTableHeaderheight:CGFloat = 200;
    
    var thumbnailImageView:UIImageView?
    var videoPlayer:MPMoviePlayerController?;
    var video:Video?{
        didSet{
            //var thumbImage: UIImage?
            let videoUrl = URL(fileURLWithPath:self.video!.url!)
            let asset = AVAsset(url: videoUrl)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(asset.duration.value / 3, asset.duration.timescale)
            if let cgImage = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) {
                self.thumbnailImageView?.image = UIImage(cgImage: cgImage)
            }

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.thumbnailImageView = UIImageView()
        self.addSubview(self.thumbnailImageView!)
        
        
        self.backgroundColor = UIColor.white;
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let thumbnailView = thumbnailImageView{
            thumbnailView.fill()
        }
        
        if let videoPlayer = videoPlayer{
            videoPlayer.view.fill()
        }
    }
    
    /**
    Configures and plays the video player
    */
    func setupVideo(){
        
        /* let's try to stop it */
        if let _ = self.videoPlayer{
            
            stopPlayingVideo()
        }
        
        let videoUrl = URL(fileURLWithPath:self.video!.url!)
        
        
        /* Now create a new movie player using the URL */
        self.videoPlayer = MPMoviePlayerController(contentURL: videoUrl);
        
        if let player = self.videoPlayer{
            
            player.setFullscreen(false, animated: false)
            player.controlStyle = MPMovieControlStyle.embedded;
            
            player.movieSourceType = MPMovieSourceType.file;
            
            player.prepareToPlay();
            
            /* Listen for the notification that the movie player sends us
            whenever it finishes playing */
            NotificationCenter.default.addObserver(self,
                selector: #selector(VideoView.videoHasFinishedPlaying(_:)),
                name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
                object: nil)
            
            print("Successfully instantiated the movie player", terminator: "")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .aspectFill;
            
            self.addSubview(player.view)
            player.view.fill()
            
            /* Let's start playing the video in full screen mode */
            player.play()
            
        } else {
            print("Failed to instantiate the movie player", terminator: "")
        }
    }
    
    /**
    Observes when the video has finsihed paying and handles errors
    */
    func videoHasFinishedPlaying(_ notification: Notification){
        
        print("Video finished playing", terminator: "")
        
        /* Find out what the reason was for the player to stop */
        let reason =
        (notification as NSNotification).userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
            as! NSNumber?
        
        if let theReason = reason{
            
            let reasonValue = MPMovieFinishReason(rawValue: theReason.intValue)
            
            switch reasonValue!{
            case .playbackEnded:
                /* The movie ended normally */
                print("Playback Ended", terminator: "")
            case .playbackError:
                /* An error happened and the movie ended */
                print("Error happened", terminator: "")
            case .userExited:
                /* The user exited the player */
                print("User exited", terminator: "")
            }
            
            print("Finish Reason = \(theReason)", terminator: "")
            stopPlayingVideo()
        }
        
    }
    
    /**
    Stops playing the video
    */
    func stopPlayingVideo() {
        
        if let player = self.videoPlayer{
            NotificationCenter.default.removeObserver(self)
            player.stop()
            player.view.removeFromSuperview()
        }
        
    }

    
}

