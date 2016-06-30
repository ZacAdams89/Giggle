//
//  VideoTableViewCell.swift
//  Giggle
//
//  Created by Zac Adams on 20/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    
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
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        videoContentView.videoContentMode = .Cell
        self.contentView .addSubview(self.videoContentView);
        self.contentView.fill()
        self.backgroundColor = UIColor.clearColor();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func updateUI() -> Void{
        self.videoContentView.video = self.video;
    }
    
    
    override func layoutSubviews() {
        self.videoContentView .fill();
    }
    
    class func cellSize() -> CGSize{
        let maxWidth:CGFloat = 375.0; // Iphone 6s
        var width:CGFloat = UIScreen.mainScreen().bounds.size.width;
        width = min(width, maxWidth)
        
        return CGSize(width: width, height: 100)
    }
}
