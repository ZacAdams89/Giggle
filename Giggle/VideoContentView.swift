//
//  VideoContentView.swift
//  Giggle
//
//  Created by Zac Adams on 24/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit


enum VideoContentMode : Int {
    case cell
    case header
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
    
    
    var showTitle:Bool{
        didSet{
            self.titleLabel.isHidden = !self.showTitle
        }
    }
    
    func play(){
        videoView.setupVideo()
    }
    
    override init(frame: CGRect) {
        
        self.showTitle = true
        
        super.init(frame:frame);
        
        self.initUI();
        
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.showTitle = true
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
        self.titleLabel.textColor = UIColor.white;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        self.titleLabel.font = UIFont.systemFont(ofSize: 13);
        
        
        self.backgroundColor = UIColor.orange
    }
    
    
    func updateUI() -> Void{
        self.titleLabel.text = self.video?.title;
        self.videoView.video = self.video
    }
    
    
    override func layoutSubviews() {
        
        if let contentMode = videoContentMode{
        
            switch contentMode {
                case VideoContentMode.cell:
                    
                    // Bank the video thumbnail against the left edge.
                    self.videoView.left = 20;
                    self.videoView.setEdge(UIViewEdge.left, length: 160, insets: UIEdgeInsets(top: 5, right: 0, bottom: 5, left: 5));
                    
                    // Fit the title in the reamining space
                    self.titleLabel.fillWithInsets(UIEdgeInsets(top: 5, right: 5, bottom: 5, left: self.videoView.right + 5));
                    self.titleLabel.sizeToFit();
                    break
                
                case VideoContentMode.header:
                    
                    // Bank the title to the bottom of the view
                    self.titleLabel.setEdge(.bottom, length: 20)
                    self.titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                    
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
