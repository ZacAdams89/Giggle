//
//  VideoContentView.swift
//  Giggle
//
//  Created by Zac Adams on 24/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit

class VideoContentView: UIView {
    
    let titleLabel:UILabel = UILabel();
    let videoView = VideoView();
    
    var video:Video?{
        didSet{
            self.updateUI();
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame);
        
        self.initUI();
        
        self.backgroundColor = UIColor.clearColor();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}


// MARK:- UI
extension VideoContentView{
    
    func initUI(){
        
        // Video view
        self.addSubview(self.videoView);
        
        // Title
        self.addSubview(self.titleLabel);
        self.titleLabel.textColor = UIColor.whiteColor();
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        self.titleLabel.font = UIFont.systemFontOfSize(13);
    }
    
    
    func updateUI() -> Void{
        self.titleLabel.text = self.video?.title;
    }
    
    
    override func layoutSubviews() {
        
        // Bank the video thumbnail against the left edge.
        self.videoView.left = 20;
        self.videoView.setEdge(UIViewEdge.Left, length: 160, insets: UIEdgeInsets(top: 5, right: 0, bottom: 5, left: 5));
        
        // Fit the title in the reamining space
        self.titleLabel.fillWithInsets(UIEdgeInsets(top: 5, right: 5, bottom: 5, left: self.videoView.right + 5));
        self.titleLabel.sizeToFit();
    }
}
