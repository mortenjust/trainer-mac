//
//  DropThroughImageView.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 11/1/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class DropThroughImageView: NSImageView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy
    }
    

    override func mouseUp(with theEvent: NSEvent) {
        // let's not do anything here, shall we?
    }
    
}
