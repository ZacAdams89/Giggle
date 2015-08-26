//
//  VideoTableViewCell.swift
//  Giggle
//
//  Created by Zac Adams on 20/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    
    static let kCellHeight:CGFloat = 100;
    
// MARK:- Properties
    
    var video:Video?{
        didSet{
            self.updateUI();
        }
    }
    
    
// MARK:- UI
    
    let videoContentView:VideoContentView = VideoContentView();

// MARK:- Functions
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView .addSubview(self.videoContentView);
        self.backgroundColor = UIColor.clearColor();
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func updateUI() -> Void{
        self.videoContentView.video = self.video;
    }
    
    
    override func layoutSubviews() {
    
        self.videoContentView .fill();
        
    }
}
