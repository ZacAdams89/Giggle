//
//  ViewController.swift
//  Giggle
//
//  Created by Zac Adams on 19/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//


import UIKit
import CoreData


class PlaylistViewController: UIViewController {

    var videoListTableView:UITableView?;
    let currentlyPlayingVideoView:CurrentlyPlayingVideoView = CurrentlyPlayingVideoView()
    var playlist:Playlist?
    var fetchedResultsController:NSFetchedResultsController?
    

    convenience init(playlist:Playlist){
        self.init()
        self.playlist = playlist
        
        // Load all of the videos into the table view
        let fetchRequest = NSFetchRequest(entityClass: Video.self)
        fetchRequest.setSortDescriptor(NSSortDescriptor(key: "index", ascending: true))
        fetchRequest.predicate = NSPredicate(format: "parent_playlist == %@ && is_playing != true", playlist)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest)
        fetchedResultsController?.delegate = self
        do{
            try self.fetchedResultsController?.performFetch()
        }
        catch _{
            // Fetch failed
        }
        
        videoListTableView?.reloadData()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Setup the video table view header
        self.currentlyPlayingVideoView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: CurrentlyPlayingVideoView.kCurrentlyPlayingVideoViewHeight);
        self.view.addSubview(self.currentlyPlayingVideoView);

        
        // Create the video table view
        self.videoListTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain);
        self.view .addSubview(self.videoListTableView!);
        self.videoListTableView?.delegate = self;
        self.videoListTableView?.dataSource = self;
        self.videoListTableView?.fillWithInsets(UIEdgeInsets.topInset(self.currentlyPlayingVideoView.height));
        self.videoListTableView?.backgroundColor = UIColor.charcoalColor();
        self.videoListTableView?.separatorColor = UIColor.lightGrayColor();
        
        self.videoListTableView?.registerClass(VideoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(VideoTableViewCell.self));
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Play the first video in the playlist
        if let videos = fetchedResultsController?.fetchedObjects{
            if let video = videos[0] as? Video{
                currentlyPlayingVideoView.video = video
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        switch(self.interfaceOrientation){
            
            case UIInterfaceOrientation.Portrait:
                // Compact against the top of the screen
                self.currentlyPlayingVideoView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: CurrentlyPlayingVideoView.kCurrentlyPlayingVideoViewHeight);
                break
            
            case UIInterfaceOrientation.LandscapeLeft: fallthrough
            case UIInterfaceOrientation.LandscapeRight:
                // Full screen
                self.currentlyPlayingVideoView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height);
                break
            
        default:
            break;
        }
    
        // Fill the rest of the screen.
        self.videoListTableView?.fillWithInsets(UIEdgeInsets.topInset(self.currentlyPlayingVideoView.height));
    }
    
    
}

// MARK: - UITableViewDataSource
extension PlaylistViewController : UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController!.numberOfSections()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController!.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(VideoTableViewCell.self)){
            
            configureCell(cell, atIndexPath: indexPath)
            return cell;
        }
        
        return UITableViewCell();
    }
    
    
    func configureCell(cell: AnyObject?, atIndexPath indexPath: NSIndexPath) -> Void{
        
        if let cell = cell as? VideoTableViewCell{
            if let video = fetchedResultsController?.objectAtIndexPath(indexPath) as? Video{
                cell.video = video
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
        }
    }
}


// MARK: - UITableViewDelegate
extension PlaylistViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VideoTableViewCell.kCellHeight;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VideoTableViewCell.kCellHeight;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let video = fetchedResultsController?.objectAtIndexPath(indexPath) as? Video{
            currentlyPlayingVideoView.video = video
        }
    }
}



//MARK:- NSFetchedResultsControllerDelegate
extension PlaylistViewController : NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.videoListTableView?.beginUpdates()
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.videoListTableView?.endUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch(type) {
        case NSFetchedResultsChangeType.Insert:
            videoListTableView?.insertSections(NSIndexSet(index:sectionIndex), withRowAnimation:UITableViewRowAnimation.Automatic)
            break
        case NSFetchedResultsChangeType.Delete:
            videoListTableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation:UITableViewRowAnimation.Automatic)
            break
            
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
            case NSFetchedResultsChangeType.Insert:
                self.videoListTableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                break
            
            case NSFetchedResultsChangeType.Delete:
                self.videoListTableView?.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                break

            case NSFetchedResultsChangeType.Update:
                self.configureCell(self.videoListTableView?.cellForRowAtIndexPath(indexPath!), atIndexPath: indexPath!);
                break

            case NSFetchedResultsChangeType.Move:
                self.videoListTableView?.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.videoListTableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                break
            
            default:
                break
        }
    }
}

