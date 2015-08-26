//
//  SimplicityView.swift
//  Giggle
//
//  Created by Zac Adams on 19/08/15.
//  Copyright (c) 2015 zacattack. All rights reserved.
//

import Foundation
import UIKit;

extension UIView{
    
    var width:CGFloat{
        get{
            return frame.size.width;
        }
    }
    
    var height:CGFloat{
        get{
            return frame.size.height;
        }
    }
    
    
    func fill()->Void {
        if(nil != self.superview){
            self.frame = self.superview!.frame;
        }
    }
    
    func fillWithInsets(){
        if(nil != self.superview){
            self.frame;
        }
    }
}