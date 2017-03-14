//
//  DockerViewController.swift
//  Trainer
//
//  Created by Morten Just Petersen on 2/1/17.
//  Copyright © 2017 Morten Just Petersen. All rights reserved.
//

import Cocoa

class DockerViewController: NSViewController {
    
    
    @IBAction func getGitPressed(_ sender: Any) {
        getGit()
    }
    
    func relaunchSelf(){
        print("relaunching self")
        let task = Process()
        var args = [String]()
        args.append("-c")
        let bundle = Bundle.main.bundlePath
        args.append("sleep 0.2; open \"\(bundle)\"")
        task.launchPath = "/bin/sh"
        task.arguments = args
        task.launch()
        NSApplication.shared().terminate(nil)
    }

    @IBAction func getDockerPressed(_ sender: Any) {
        getDocker()
    }

    
    @IBAction func OkPressed(_ sender: Any) {
        dismiss(nil)
        relaunchSelf()
     
    }
    
    

    func getGit(){
        print("getgit clicked")
        if let url = URL(string: "https://git-scm.com/download/mac"), NSWorkspace.shared().open(url) {
            
        }
    }
    
    func getDocker() {
        
        print("dockerClicked")
        
        if let url = URL(string: "https://download.docker.com/mac/stable/Docker.dmg"), NSWorkspace.shared().open(url) {
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
