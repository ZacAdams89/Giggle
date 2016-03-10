//
//  VideoPlayerTableHeaderView.swift
//  Giggle
//
//  Created by Zac Adams on 19/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit
import MediaPlayer

/**
 * Video player table header.
 */
class CurrentlyPlayingVideoView: UIView {
    static let kCurrentlyPlayingVideoViewHeight:CGFloat = 200;
    
    let videoContentView = VideoContentView()
    
    var video:Video?{
        didSet{
            videoContentView.video = video
            video?.is_playing = true
            oldValue?.is_playing = false
            
            videoContentView.play()
            
            DataStore.save()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.whiteColor();
        
        videoContentView.videoContentMode = .Header
        addSubview(videoContentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContentView.fill()
    }
    
}
