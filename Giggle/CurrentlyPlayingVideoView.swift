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
            video?.isPlaying = true
            oldValue?.isPlaying = false
            
            videoContentView.play()
            
            DataStore.save()
        }
    }
    
    
    var showTitle:Bool{
        didSet{
            self.videoContentView.showTitle = self.showTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.showTitle = true
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        self.showTitle = true
        super.init(frame: frame);
        self.backgroundColor = UIColor.white;
        
        videoContentView.videoContentMode = .header
        addSubview(videoContentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContentView.fill()
    }
    
}
