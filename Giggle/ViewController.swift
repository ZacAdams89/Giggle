//
//  ViewController.swift
//  Giggle
//
//  Created by Zac Adams on 19/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//


import UIKit
//import Simplicity


class ViewController: UIViewController {

    var videoTableView:UITableView?;
    let currentlyPlayingVideoView:CurrentlyPlayingVideoView = CurrentlyPlayingVideoView();

    let dataSource = VideoDataSource();
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Setup the video table view header
        self.currentlyPlayingVideoView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: CurrentlyPlayingVideoView.kCurrentlyPlayingVideoViewHeight);
        self.view.addSubview(self.currentlyPlayingVideoView);
        
        // Create the video table view
        self.videoTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain);
        self.view .addSubview(self.videoTableView!);
        self.videoTableView?.delegate = self;
        self.videoTableView?.dataSource = self;
        self.videoTableView?.fillWithInsets(UIEdgeInsets.topInset(self.currentlyPlayingVideoView.height));
        self.videoTableView?.backgroundColor = UIColor.charcoalColor();
        self.videoTableView?.separatorColor = UIColor.lightGrayColor();
        
        self.videoTableView?.registerClass(VideoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(VideoTableViewCell.self));
        
    
        // Load the videos.
        self.dataSource.loadVideos();
        
        // Set the first video as the current video.
        if(dataSource.hasData()){
            currentlyPlayingVideoView.video = dataSource.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? Video;
        }
        
        
        videoTableView?.reloadData();
    }
}

// MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections();
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfObjectsForSection(section) - 1; // -1 beacuse 1 video will always be in the current playing view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(VideoTableViewCell.self)) as? VideoTableViewCell{
            
            // Ensure we skip the currently playing video's index. 
            // The table only displays videos that are not playing.
            var videoIndexPath = indexPath;
            
            let currentlyPlayingVideoIndexPath = dataSource.indexPathOfObject(currentlyPlayingVideoView.video!);
            if(currentlyPlayingVideoIndexPath.row == indexPath.row){
                videoIndexPath = NSIndexPath(forRow: videoIndexPath.row + 1, inSection: videoIndexPath.section);
            }
            
            let video = dataSource.objectAtIndexPath(indexPath) as! Video;
            cell.video = video;
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell;
        }
        
        return UITableViewCell();
    }
}


// MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VideoTableViewCell.kCellHeight;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VideoTableViewCell.kCellHeight;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Stop the current playing video.
        
        // Swap the current playing video with the selected cell.
        
        // Play the selected video.
    }
}

