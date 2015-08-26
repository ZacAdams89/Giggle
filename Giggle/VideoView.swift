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
    
    var videoPlayer:MPMoviePlayerController?;
    var video:Video?{
        didSet{
            self.setupVideo();
        }
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.whiteColor();
    }
    
    
    func setupVideo(){
        
        /* let's try to stop it */
        if let _ = self.videoPlayer{
            
            stopPlayingVideo()
        }
        
        
        /* Now create a new movie player using the URL */
        self.videoPlayer = MPMoviePlayerController(contentURL: NSURL(self.video?.url));
        
        if let player = self.videoPlayer{
            
            player.view.fill();
            player.setFullscreen(false, animated: false)
            player.controlStyle = MPMovieControlStyle.None;
            
            player.movieSourceType = MPMovieSourceType.File;
            
            player.prepareToPlay();
            
            /* Listen for the notification that the movie player sends us
            whenever it finishes playing */
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "videoHasFinishedPlaying:",
                name: MPMoviePlayerPlaybackDidFinishNotification,
                object: nil)
            
            print("Successfully instantiated the movie player")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .AspectFit;
            
            self.addSubview(player.view)
            
            /* Let's start playing the video in full screen mode */
            player.play()
            
        } else {
            print("Failed to instantiate the movie player")
        }
    }
    
    func videoHasFinishedPlaying(notification: NSNotification){
        
        print("Video finished playing")
        
        /* Find out what the reason was for the player to stop */
        let reason =
        notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
            as! NSNumber?
        
        if let theReason = reason{
            
            let reasonValue = MPMovieFinishReason(rawValue: theReason.integerValue)
            
            switch reasonValue!{
            case .PlaybackEnded:
                /* The movie ended normally */
                print("Playback Ended")
            case .PlaybackError:
                /* An error happened and the movie ended */
                print("Error happened")
            case .UserExited:
                /* The user exited the player */
                print("User exited")
            }
            
            print("Finish Reason = \(theReason)")
            stopPlayingVideo()
        }
        
    }
    
    func stopPlayingVideo() {
        
        if let player = self.videoPlayer{
            NSNotificationCenter.defaultCenter().removeObserver(self)
            player.stop()
            player.view.removeFromSuperview()
        }
        
    }

    
}

