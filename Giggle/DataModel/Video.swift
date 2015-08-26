//
//  Video.swift
//  Giggle
//
//  Created by Zac Adams on 26/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var url: String

}
