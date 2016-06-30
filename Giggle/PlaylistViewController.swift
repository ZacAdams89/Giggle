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

    var videoCollectionView:UICollectionView?;
    let currentlyPlayingVideoView:CurrentlyPlayingVideoView = CurrentlyPlayingVideoView()
    var playlist:Playlist?
    var fetchedResultsController:NSFetchedResultsController?

    // Full screen tap to reveal videos
    var revealVideosTapGestureRecogniser:UITapGestureRecognizer?;
    

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
        
        videoCollectionView?.reloadData()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Setup the video table view header
        self.currentlyPlayingVideoView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: CurrentlyPlayingVideoView.kCurrentlyPlayingVideoViewHeight);
        self.view.addSubview(self.currentlyPlayingVideoView);
        
        //
        self.revealVideosTapGestureRecogniser = UITapGestureRecognizer(target: self, action: Selector("toggleVideoPane"))
        self.currentlyPlayingVideoView.addGestureRecognizer(self.revealVideosTapGestureRecogniser!)
        
        // Create the video table view
        
        let collectionLayoutFlow = UICollectionViewFlowLayout()
        collectionLayoutFlow.itemSize = VideoCollectionViewCell.cellSize()
        
        self.videoCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionLayoutFlow)
        self.view .addSubview(self.videoCollectionView!);
        self.videoCollectionView?.delegate = self;
        self.videoCollectionView?.dataSource = self;
        self.videoCollectionView?.fillWithInsets(UIEdgeInsets.topInset(self.currentlyPlayingVideoView.height));
        self.videoCollectionView?.backgroundColor = UIColor.charcoalColor();
        
//        self.videoCollectionView?.registerClass(VideoCollectionViewCell.self, forCellReuseIdentifier: NSStringFromClass(VideoCollectionViewCell.self));
        self.videoCollectionView?.registerClass(VideoCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCollectionViewCell.self))
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
        self.videoCollectionView?.fillWithInsets(UIEdgeInsets.topInset(self.currentlyPlayingVideoView.height));
    }
    
    
    
    func toggleVideoPane() -> Void{
        
        if(self.videoCollectionView?.y >= self.view.height){
            // Show
            self.videoCollectionView?.setEdge(UIViewEdge.Bottom, length: 100)
        }
        else{
            // Hide
            self.videoCollectionView?.top = self.view.bottom
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PlaylistViewController : UICollectionViewDataSource{
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController!.numberOfSections()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController!.numberOfRowsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCollectionViewCell.self), forIndexPath: indexPath)
        
        configureCell(cell, atIndexPath: indexPath)
        return cell;
    }
    
    func configureCell(cell: AnyObject?, atIndexPath indexPath: NSIndexPath) -> Void{
        
        if let cell = cell as? VideoCollectionViewCell{
            if let video = fetchedResultsController?.objectAtIndexPath(indexPath) as? Video{
                cell.video = video
            }
        }
    }
}


// MARK: - UICollectionViewDelegate
extension PlaylistViewController : UICollectionViewDelegate{


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let video = fetchedResultsController?.objectAtIndexPath(indexPath) as? Video{
            currentlyPlayingVideoView.video = video
        }
    }
}



//MARK:- NSFetchedResultsControllerDelegate
extension PlaylistViewController : NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.videoCollectionView?.reloadData()
    }
}

