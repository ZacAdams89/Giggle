//
//  DataSource.swift
//  Giggle
//
//  Created by Zac Adams on 24/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import Foundation


// Base functionality of a data source
protocol DataSource : NSObjectProtocol{
    
    func hasData() -> Bool
    func numberOfSections() -> Int
    func numberOfObjectsForSection(section: Int) -> Int
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
    func indexPathOfObject(object: AnyObject) -> NSIndexPath
}
