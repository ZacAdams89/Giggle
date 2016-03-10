//
//  Video.swift
//  Giggle
//
//  Created by Zac Adams on 31/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var is_playing: NSNumber
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var parent_playlist: Playlist

}
