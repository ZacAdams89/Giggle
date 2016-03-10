//
//  VideoDataSource.swift
//  Giggle
//
//  Created by Zac Adams on 20/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//


import Foundation
import UIKit

class VideoDataSource: NSObject {
    
    
    let supportedVideoExtensions = ["mp4", "mov"]
    
    private var videos:[Video]?
    
    override init() {
        super.init()
    }
    
    /**
    Loads all supported video files from the apps documents directory. 
    The app is flagged as being able to accepts documents so users can sync any media
    they wish to the app via iTunes.
    
    :returns: All suported videos found in the apps documents directory as Video objects.
    */
    func loadVideosInDocumentsDirectory() -> [Video]?{
     
        // Load the videos placed into the apps documents folder 
        // through itunes. This is done by scanning the documents folder
        // for mp4 and mov file extensions.
        NSLog("Documents directory contents")
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        
        var error:NSError? = nil
        
        // Get the documents directory path
        let documentsDirectoryPath:NSURL = NSURL(fileURLWithPath:appDelegate.applicationDocumentsDirectory.path!)
        
        do {
            let directoryContents = try fileManager.contentsOfDirectoryAtPath(documentsDirectoryPath.path!)
            
            if(nil == error){
                
                NSLog("Found files in documents directory %@", directoryContents)
                
                
                // Filter our the supported video files.
                let predicate:NSPredicate = NSPredicate(format: "pathExtension IN %@", self.supportedVideoExtensions)
                let videoFilePaths = (directoryContents as NSArray).filteredArrayUsingPredicate(predicate)//({predicate.evaluateWithObject($0)})
                NSLog("Found video files %@", videoFilePaths)
                
                var videos:[Video] = []
                
                // Create the videos models from these found files.
                for videoFilePath:String in videoFilePaths as! [String]{
                    
                    let video = Video.create()
                    video.title = videoFilePath
                    video.url = documentsDirectoryPath.URLByAppendingPathComponent(videoFilePath).path!
                    videos.append(video)
                }
                
                
                // Cache the results
                self.videos = videos
                
                return videos

            }
        } catch let error1 as NSError {
            error = error1
        }
        catch _{
            
        }
        return nil
    }
}


//MARK:- DataSource
extension VideoDataSource : DataSource{
    
    func hasData() -> Bool{
        var hasData = false
        if let videos = self.videos{
            hasData = videos.count != 0
        }
        return hasData
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    
    func numberOfObjectsForSection(section: Int) -> Int {
        var count = 0
        if let videos = self.videos{
            count = videos.count
        }
        return count
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?{
        if let videos = self.videos {
            return videos[indexPath.row]
        }
        
        return nil
    }
    
    func indexPathOfObject(object: AnyObject) -> NSIndexPath {
        
        var indexPath = NSIndexPath(forRow: Foundation.NSNotFound, inSection: Foundation.NSNotFound)
        
        if let videos = self.videos{
         
            let index = videos.indexOf(object as! Video)
            indexPath = NSIndexPath(forRow: index!, inSection: 0)
            
        }
        
        return indexPath
       
    }
}

