//
//  Playlist.swift
//  Giggle
//
//  Created by Zac Adams on 31/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import Foundation
import CoreData

class Playlist: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var videos: NSSet

}
