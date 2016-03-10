//
//  Playlist+CoreDataProperties.swift
//  
//
//  Created by Zac Adams on 28/09/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Playlist {

    @NSManaged var title: String?
    @NSManaged var videos: NSSet?


    
}
