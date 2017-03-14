//
//  ZipHandler.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 11/1/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol ZipHandlerDelegate {
    func zipHandlerDidStart()
    func zipHandlerDidFinish()
}

class ZipHandler: NSObject {
    var filepath:String!
    var delegate:ZipHandlerDelegate?
    
    init(filepath:String){
        print(">>zip init ziphandler")
        super.init()
        self.filepath = filepath
    }
    
    func flash(){
        print(">>zip flash")
        delegate?.zipHandlerDidStart()
        let shell = ShellTasker(scriptFile: "installZip.sh")
        shell.run(arguments: [self.filepath]) { (output) -> Void in
            print("done flashing")
            self.delegate?.zipHandlerDidFinish()
        }
    }
}
