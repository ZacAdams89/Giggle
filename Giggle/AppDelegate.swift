//
//  AppDelegate.swift
//  Giggle
//
//  Created by Zac Adams on 19/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
    
        DataStore.delegate = self
        
        let playlist = createPlaylistFromVideosInDocumentsDirectory()
        
        let playlistViewController = PlaylistViewController(playlist: playlist)
        window?.rootViewController = playlistViewController
        
        return true
    }
    
    
    func createPlaylistFromVideosInDocumentsDirectory() -> Playlist{
        
        // Load the videos.
        
        let videoDataSource = VideoDataSource()
        
        if let videos = videoDataSource.loadVideosInDocumentsDirectory(){
            
            if(videos.count > 0){
                
                let playlist = Playlist.create()
                playlist.title = "Documents collection"
                let videoSet = NSSet(array:videos)
                playlist.videos = videoSet
                
                DataStore.save()
                
                return playlist;
            }
        }
        
        // Default to an empty playlist
        return Playlist.create()
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.zacattack.Giggle" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()
}



extension AppDelegate: CoreDataStoreDelegate{
    
    func configureDataStore(dataStore: CoreDataStore, persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        
        // Since this app only reads data from the documents directory which is volatile
        // we only want the data to be stored in local memory so that it does not persist between
        // instances of the app.
        var error: NSError? = nil
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration:nil, URL: dataStore.storeURL, options: nil)
            
        } catch let error1 as NSError {
            error = error1
            
            if let error = error{
                NSLog("Failed to create store with error %@", error)
            }
        }
    }
    
    func defaultContextForDataStore(dataStore: CoreDataStore ) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = dataStore.persistentStoreCoordinator
        return context
    }
    
    
}
