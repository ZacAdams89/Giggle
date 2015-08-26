//
//  GiggleCoreDataStor.swift
//  Giggle
//
//  Created by Zac Adams on 25/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import Foundation
import CoreData

let GiggleDataStore = DataStore

class GiggleCoreDataStore: CoreDataStore {
    
    override class var sharedInstance: GiggleCoreDataStore {
        struct Static {
            static let instance: GiggleCoreDataStore = GiggleCoreDataStore()
        }
        return Static.instance
    }
    
    override init(){
        
    }
}


extension GiggleCoreDataStore: CoreDataStoreDelegate{
    
    func configureDataStore(dataStore: CoreDataStore, persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        
        // Since this app only reads data from the documents directory which is volatile
        // we only want the data to be stored in local memory so that it does not persist between
        // instances of the app.
        var error: NSError? = nil
        if let store = persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: "nil", URL: dataStore.storeURL, options: nil, error: &error){
            
        }
        else{
            
            if let error = error{
                NSLog("Failed to create store")
            }
        }
    }
    
    func defaultContextForDataStore(dataStore: CoreDataStore ) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = dataStore.persistentStoreCoordinator
        return context
    }

    
}



// Configure the apps data store configuration
// An app may have mutiple configurations for different purposes
// But the app may want to specify a default store / context
//