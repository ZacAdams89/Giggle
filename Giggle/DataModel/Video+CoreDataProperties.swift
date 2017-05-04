//
//  Video+CoreDataProperties.swift
//  
//
//  Created by Zac Adams on 1/11/16.
//
//

import Foundation
import CoreData
import Giggle

extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video");
    }

    @NSManaged public var index: NSNumber?
    @NSManaged public var isPlaying: NSNumber?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var parentPlaylist: Playlist?

}
