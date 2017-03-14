//
//  AppDelegate.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 10/30/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var vc:ViewController!
    var terminateReply = NSApplicationTerminateReply.terminateCancel

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let win = NSApplication.shared().windows.first!
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        win.styleMask = [win.styleMask, NSFullSizeContentViewWindowMask]
        win.title = ""
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
        
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        
        // staaaahp the docka
    
        let id = CurrentDockerImage.sharedInstance.imageId
        print("\nready to kill id: -->\(id)<--\n")
        let shell = ShellTasker(scriptFile: "stopDocker.sh")
        
        shell.run(arguments: [id]) { (output) in
            print(output)
            print("\ndone killing \(id)\n")
            self.terminateReply = NSApplicationTerminateReply.terminateNow
            NSApp.terminate(nil)
        }
        
        return terminateReply
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
    }
    
    
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        

        // Delay 2 seconds
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.vc.dropDragPerformed(filename)
        }
        

        return true
    }


}

