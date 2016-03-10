//
//  VideoContentView.swift
//  Giggle
//
//  Created by Zac Adams on 24/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit


enum VideoContentMode : Int {
    case Cell
    case Header
}

class VideoContentView: UIView {
    
    var videoContentMode:VideoContentMode?{
        didSet{
            self.layoutSubviews()
        }
    }
    
    let titleLabel:UILabel = UILabel();
    let videoView = VideoView();
    
    var video:Video?{
        didSet{
            self.updateUI();
        }
    }
    
    func play(){
        videoView.setupVideo()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame:frame);
        
        self.initUI();
        
        self.backgroundColor = UIColor.clearColor();
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        self.titleLabel.textColor = UIColor.blackColor();
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        self.titleLabel.font = UIFont.systemFontOfSize(13);
        
        
        self.backgroundColor = UIColor.orangeColor()
    }
    
    
    func updateUI() -> Void{
        self.titleLabel.text = self.video?.title;
        self.videoView.video = self.video
    }
    
    
    override func layoutSubviews() {
        
        if let contentMode = videoContentMode{
        
            switch contentMode {
                case VideoContentMode.Cell:
                    
                    // Bank the video thumbnail against the left edge.
                    self.videoView.left = 20;
                    self.videoView.setEdge(UIViewEdge.Left, length: 160, insets: UIEdgeInsets(top: 5, right: 0, bottom: 5, left: 5));
                    
                    // Fit the title in the reamining space
                    self.titleLabel.fillWithInsets(UIEdgeInsets(top: 5, right: 5, bottom: 5, left: self.videoView.right + 5));
                    self.titleLabel.sizeToFit();
                    break
                
                case VideoContentMode.Header:
                    
                    // Bank the title to the bottom of the view
                    self.titleLabel.setEdge(.Bottom, length: 20)
                    self.titleLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
                    
                    // Fill the video into the remaaining space with a 10px border inset
                    //self.videoView.fillWithInsets(UIEdgeInsets(top: 10, left: 10, bottom: titleLabel.height + 10, right: 10))
                    self.videoView.fill()
                    

                    break
                
                default:
                    break;
            }
        }
    }
}
