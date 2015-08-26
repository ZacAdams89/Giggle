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
    
    var video:Video?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.whiteColor();
    }
}
