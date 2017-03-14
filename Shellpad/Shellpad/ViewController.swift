//
//  ViewController.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 10/30/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, DropDelegate {
    @IBOutlet weak var dropReceiver: DropReceiverView!
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var allContainer: DropReceiverView!

    @IBOutlet weak var browseButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var xCodeButton: NSButton!
    @IBOutlet weak var studioButton: NSButton!
    @IBOutlet weak var revealButton: NSButton!
    @IBOutlet weak var tensorboardButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    var taskStarted = Double()
    
    var enableButtons = Array<NSButton>()
    
    @IBAction func openFolderClicked(_ sender: Any) {
        let folder = "\(Constants.TF_FILES)/images/originals"
        print("Constants.TF_Files: \(Constants.TF_FILES)")
        print("NSHomeDirectory dir \(NSHomeDirectory())")
        print("openfolderclicked. Opening this folder: \(folder) ")
        NSWorkspace.shared().openFile(folder)
    }
    
    func startIndicator(status:String) {
        taskStarted = NSDate().timeIntervalSince1970
        indicator.startAnimation(nil)
        setStatusLabel(text: status)
        allContainer.alphaValue = 1.0
        
        for element  in enableButtons  {
            element.isEnabled = false
        }
    }
    
    func setStatusLabel(text:String){
        statusLabel.stringValue = text
        allContainer.alphaValue = 1.0
    }
    
    
    func stopIndicator(taskName:String="Task"){
        let completed = NSDate().timeIntervalSince1970
        
        let taskTook = completed - taskStarted
        
        
        let taskTimerMessage = "\n- Done. \(taskName) took \(taskTook.roundTo(places:2) )s\n"
        
        let m = NSString(string: taskTimerMessage)
        
        postNotification(m, channel: Constants.NOTIF_NEWDATA)
        
        indicator.stopAnimation(nil)
        setStatusLabel(text: "")
        
        for element in enableButtons  {
            element.isEnabled = true
        }
    }
    
    override func viewDidAppear() {
        print("did appear")
        bootDocker() // calls isDockerInstalled.sh, then getDockerId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // VIEW.unregisterDraggedTypes() to avoid drags
        
        dropReceiver.delegate = self

        (NSApplication.shared().delegate as! AppDelegate).vc = self
        
        indicator.controlTint = NSControlTint.clearControlTint
        
        indicator.isDisplayedWhenStopped = false
        
        // not included: studioButton, tensorboardButton
        enableButtons = [browseButton, startButton, xCodeButton, revealButton, resetButton]
        
    }
    @IBAction func revealModelClicked(_ sender: Any) {
                NSWorkspace.shared().openFile("\(Constants.TF_FILES)/model")
    }
    
    @IBAction func studioProjectClicked(_ sender: Any) {
        print("studio clicked")
    }
    
    @IBAction func xcodeProjectClicked(_ sender: Any) {        
        print("xcode clicked")
        startIndicator(status: "Generating Xcode project")
        let setupTask = ShellTasker(scriptFile: "createXcodeProject.sh")
        setupTask.run(arguments: []) { (output) in
            print("Done setting up xocde project")
            self.stopIndicator(taskName: "Xcode project")
        }
    }
    
    func setupWorkspace(){
        startIndicator(status: "Setting up folders")
        let setupTask = ShellTasker(scriptFile: "setupTfFiles.sh")
        setupTask.run(arguments: [Constants.TF_FILES]) { (output) in
            print("Done setting up folders")
            self.stopIndicator(taskName: "Setting up folders")
        }
    }
    
    @IBAction func startTrainingClicked(_ sender: Any) {
        startIndicator(status: "Training")
        let trainTask = ShellTasker(scriptFile: "startTraining.sh")
        let id = CurrentDockerImage.sharedInstance.imageId
        trainTask.run(arguments: [id]) { (output) in
            //
            self.stopIndicator(taskName:"Training")
        }
    }
    
    func startTensorboard(){
        startIndicator(status: "Starting Tensorboard")
        print("starting tensorboard")
        let boardTask = ShellTasker(scriptFile: "startTensorboard.sh")
        boardTask.run(arguments: [CurrentDockerImage.sharedInstance.imageId]) { (result) in
            print("tensorboardresults: \(result)")
            self.stopIndicator(taskName:"Starting tensorboard")
        }
    }
    
    @IBAction func tensorboardClicked(_ sender: Any) {
        // open browser to http://localhost:7007
        NSWorkspace.shared().open(URL(string: "http://localhost:7007")!)
    }
    
    
    func bootDocker(){
        // docker in the haus?
        let checkForDocker = ShellTasker(scriptFile: "isDockerInstalled.sh")
        
        startIndicator(status: "Finding Docker...")
        
        checkForDocker.run(arguments: []) { (result) in
            self.stopIndicator(taskName:"Finding Docker")
            
            let r = (result as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            // yes
            if r == "yes" {
                print("Dude's got docker")
                
                let shell = ShellTasker(scriptFile: "boot.sh")
                self.setupWorkspace()
                
                self.startIndicator(status: "Booting Ubuntu")
                shell.run(arguments: []) { (output) in
                    print("done launching. Output below ----\n--- \(output as String)")
                    self.stopIndicator(taskName:"Booting docker")
                    self.getDockerId()
                    self.startTensorboard()
                }
                
            } else if r == "no" {
                // docker not here. TODO: Tell the user
                print("not there, asking for docker")
                
                self.askForDocker()
                
            } else {
                print("Seems it's =\(r)=")
                
            }
        }
        
    }

    
    func askForDocker(){

        let vc = self.storyboard!.instantiateController(withIdentifier: "docker") as! NSViewController
        self.presentViewControllerAsSheet(vc)

    }
    
    
    func getDockerId(){
        startIndicator(status: "Getting Docker id...")
        let shell = ShellTasker(scriptFile: "getDockerId.sh")
        shell.run { (output) in
            var imageId = output as String
            imageId = imageId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            CurrentDockerImage.sharedInstance.imageId = imageId
            self.stopIndicator(taskName:"Getting docker id")
        }
    }
    
    
    func dropDragEntered(_ filePath: String) {
        print("entered")
     
    }
    
    func dropDragExited() {
        print("exited")
     
    }
    
    func dropDragPerformed(_ filePath: String) {
        print("boom \(filePath)")
        let url = URL(fileURLWithPath: filePath)
        let ext = url.pathExtension
        switch ext {
            case "jpg":
                print("handle jpg")
        default:
            print("default")
        }
    }
    
    func dropUpdated(_ mouseAt: NSPoint) {
//        print("droip update")
    }
    
    func postNotification(_ message:NSString, channel:String){
        NotificationCenter.default.post(name: Notification.Name(rawValue: channel), object: message)
    }
    
    
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
