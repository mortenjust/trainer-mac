    //
//  ShellTasker.swift
//
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa


protocol ShellTaskDelegate {
    func shellTaskDidBegin()
    func shellTaskDidFinish(_ output:String)
    func shellTaskDidUpdate(_ update:String)
}

class ShellTasker: NSObject {
    var scriptFile:String!
    var task:Process!
    var delegate:ShellTaskDelegate?
    var observer:NSObjectProtocol!
    var entireOutput:String = ""
    var isEOF = false;
    var times = 0
    
    
    init(scriptFile:String){
        self.scriptFile = scriptFile
    }
    
    func stop(){
        task.terminate()
    }
    
    func run(arguments args:[String]=[], complete:@escaping (_ output:NSString)-> Void) {
        
        if scriptFile == nil {
            return
        }
        
        print("running \(scriptFile)")
        
        var notifArgs:String = ""
        for arg in args {
            notifArgs = "\(notifArgs) \(arg)"
        }

        postNotification("", channel: Constants.NOTIF_NEWDATA)
        postNotification("\n$ \(scriptFile) \(notifArgs)" as NSString, channel: Constants.NOTIF_NEWSESSION)
        
        let sp:AnyObject = Bundle.main.path(forResource: scriptFile, ofType: "") as AnyObject
        let scriptPath = sp as! String

        let bash = "/bin/bash"
        task = Process()
        let pipe = Pipe()
        task.launchPath = bash
    
        var allArguments = [String]()
        
        allArguments.append("-l")
        allArguments.append("-c")
        
//        allArguments.append("\(scriptPath)") //

        let allArgs = args.joined(separator: " ")
        let shellCommand = "\(scriptPath) \(allArgs)"
        
        allArguments.append(shellCommand)
        
        task.arguments = allArguments
    
        task.standardOutput = pipe
        task.standardError = pipe

        self.task.launch()
        delegate?.shellTaskDidBegin()
        
        
        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: pipe.fileHandleForReading, queue: nil) { (notification) -> Void in
            self.updateOrEndOfFile(notification, complete: { (output) -> Void in
                print("mj.eof and output of length: \(output.length)")
                complete(output)
            })
        }
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
    }
    
    func postNotification(_ message:NSString, channel:String){
        NotificationCenter.default.post(name: Notification.Name(rawValue: channel), object: message)
    }
    
    fileprivate func updateOrEndOfFile(_ notification:Notification, complete:@escaping (_ output:NSString) -> Void){
        let handle = notification.object as! FileHandle
        let data = handle.availableData
        
        let outputString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        if let os = outputString {
            self.postNotification(os, channel: Constants.NOTIF_NEWDATA)
            self.entireOutput = "\(self.entireOutput)\(os)"
            self.delegate?.shellTaskDidUpdate(os as String)
        }
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            
            if(data.count>0 && self.isEOF == false){
                self.isEOF = false
            } else {
                    self.isEOF = true
                    self.times += 1
                    if self.times == 1 { // shit, todo: find out why the fuck this is necessary
                        let output = ""
                        print("eofing for the \(self.times) time")
                        DispatchQueue.main.async(execute: { () -> Void in
                            // todo: make sure this one only gets called once per file
                            self.delegate?.shellTaskDidFinish(output as String)
                            //NSNotificationCenter.defaultCenter().removeObserver(self.observer)
                            print("EOF for \(self.scriptFile!)")
                            complete(self.entireOutput as NSString)
                            self.postNotification(self.entireOutput as NSString, channel: Constants.NOTIF_ALLOUTPUT)
                            self.entireOutput = ""
                        })
                    }
                }
        })
        
        if self.isEOF == false {
            handle.waitForDataInBackgroundAndNotify()
        }
        else {
            self.postNotification("EOF", channel: Constants.NOTIF_EOF)
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
