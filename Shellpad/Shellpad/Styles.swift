//
//  Styles.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 10/31/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Styles: NSObject {


    override init() {
        super.init()
    }
    
    func terminalAtts() -> [String:AnyObject]{
        var atts = [String:AnyObject]()
        atts[NSForegroundColorAttributeName] = NSColor(red:0.392, green:0.294, blue:0.890, alpha:1);
        atts[NSFontAttributeName] = NSFont(name: "Courier", size: 10.0)
        return atts
    }
    
}
