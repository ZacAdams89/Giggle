//
//  Colors.swift
//  Giggle
//
//  Created by Zac Adams on 20/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import UIKit

extension UIColor{
    
    class func charcoalColor() -> UIColor{
        return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1);
    }
    
    
    class func randomColor() -> UIColor{
        return UIColor.rgbColor((Int)(arc4random() % 256),
                       g: (Int)(arc4random() % 256),
                        b: (Int)(arc4random() % 256));
    }
    
    class func rgbColor(r: Int, g: Int, b: Int) -> UIColor{
    
        let red:CGFloat = CGFloat(r);
        let green:CGFloat = CGFloat(g);
        let blue:CGFloat = CGFloat(b);
        return UIColor (red: red/255, green: green/255, blue: blue/255, alpha: (1.0));
    }
    
}