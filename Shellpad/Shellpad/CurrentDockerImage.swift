//
//  CurrentDockerImage.swift
//  Trainer
//
//  Created by Morten Just Petersen on 1/30/17.
//  Copyright © 2017 Morten Just Petersen. All rights reserved.
//

import Cocoa

class CurrentDockerImage: NSObject {

    static let sharedInstance : CurrentDockerImage = {
        let instance = CurrentDockerImage(imageId : String())
        return instance
    }()
    
    var imageId : String
    
    
    init(imageId:String){
        self.imageId = imageId
    }
    
}
