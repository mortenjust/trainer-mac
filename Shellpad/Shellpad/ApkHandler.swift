//
//  ApkHandler.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 11/1/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol ApkHandlerDelegate {
    func apkHandlerDidStart()
    func apkHandlerDidGetInfo(_ apk:Apk)
    func apkHandlerDidUpdate(_ update:String)
    func apkHandlerDidFinish()
}

class ApkHandler: NSObject {
    var filepath:String!
    var delegate:ApkHandlerDelegate?
    
    init(filepath:String){
        print(">>apk init apkhandler")
        super.init()
        self.filepath = filepath
    }
    
    func installAndLaunch(){
        delegate?.apkHandlerDidStart()
        print(">>apkhandle")
        
        getInfoFromApk(self.filepath) { (apk) -> Void in
            self.install(self.filepath, completion: { () -> Void in
                if let appName = apk.appName {
                    self.delegate?.apkHandlerDidUpdate("Launching \(appName)...")
                    }
                self.launch(apk)
            })
        }
    }
    
    func install(_ filepath:String, completion:@escaping ()->Void){
        print(">>apkinstall")
        let s = ShellTasker(scriptFile: "installApk.sh")
        s.run(arguments: [filepath]) { (output) -> Void in
            completion()
        }
    }
    
    func getInfoFromApk(_ filepath:String, complete:@escaping (Apk) -> Void){
        print(">>apkgetinfofromapk")
        let shell = ShellTasker(scriptFile: "getApkInfo.sh")
        shell.run(arguments: [filepath]) { (output) -> Void in
            let apk = self.parseApkInfo(output as String)
            self.delegate?.apkHandlerDidGetInfo(apk)
            complete(apk)
        }
    }
    
    func parseApkInfo(_ rawdata:String) -> Apk {
        print(">>apkparskeapkinfo")
        let u = Util()
        let apk = Apk()
        
        if let l = u.findMatchesInString(rawdata, regex: "launchable-activity: name='(.*?)'") {
            apk.launcherActivity = l[0]
        }
        
        if let n = u.findMatchesInString(rawdata, regex: "application-label:'(.*?)'") {
            apk.appName = n[0]
        }
        
        if let p = u.findMatchesInString(rawdata, regex: "package: name='(.*?)'") {
            apk.packageName = p[0]
        }
        
        return apk
        }

    func launch(_ apk:Apk){
        print(">>apklaunch")
        if let packageName = apk.packageName, let launcherActivity = apk.launcherActivity {
            
                let ac = "\(packageName)/\(launcherActivity)"
                print("apklaunch of \(ac)")

                let s = ShellTasker(scriptFile: "launchActivity.sh")
                s.run(arguments: [ac]) { (output) -> Void in
                    print("apk done launching")
                    self.delegate?.apkHandlerDidFinish()
                }
        }
    }
}
