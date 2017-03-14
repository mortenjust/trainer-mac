//
//  ProgressIndicator.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 11/1/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class ProgressIndicator: NSObject {
    var loaderView : NSImageView!
    var placeholderImage : NSImage!
    
    init(v:NSImageView){
        loaderView = v
        placeholderImage = loaderView.image
        loaderView.wantsLayer = true
    }
    
    func start(){
        print(">>progstart")
        loaderView.alphaValue = 1.0
        startAnimation()
    }
    
    func stop(){
        loaderView.alphaValue = 1.0
        loaderView.image = NSImage(named: "arrow")
        print(">>stopanimation")
        loaderView.layer?.removeAllAnimations()
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fillMode = kCAFillModeForwards
        rotate.toValue = 0.0
        rotate.duration = 1
        rotate.repeatCount = 0
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        loaderView.layer?.position = CGPoint(x: loaderView.frame.midX, y: loaderView.frame.midY)
        loaderView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderView.layer?.add(rotate, forKey: nil)
    }
    
    func showInvite(){
        loaderView.image = NSImage(named: "inviter")
        print(">>showinvitestart")
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fillMode = kCAFillModeForwards
        rotate.fromValue = 0.0
        rotate.toValue = CGFloat(M_PI * 2.0)
        rotate.duration = 50
        rotate.repeatCount = Float.infinity
        loaderView.layer?.position = CGPoint(x: loaderView.frame.midX, y: loaderView.frame.midY)
        loaderView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderView.layer?.add(rotate, forKey: nil)

    }
    
    func hideInvite(){
        loaderView.image = NSImage(named: "arrow")
        loaderView.layer?.removeAllAnimations()
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fillMode = kCAFillModeForwards
        rotate.toValue = 0.0
        rotate.duration = 1
        rotate.repeatCount = 0
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        loaderView.layer?.position = CGPoint(x: loaderView.frame.midX, y: loaderView.frame.midY)
        loaderView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderView.layer?.add(rotate, forKey: nil)
    }
    
    func startAnimation(){
        loaderView.image = NSImage(named: "loading")
        print(">>progstartAnimation")
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fillMode = kCAFillModeForwards
        rotate.fromValue = 0.0
        rotate.toValue = CGFloat(M_PI * 2.0)
        rotate.duration = 2
        rotate.repeatCount = Float.infinity
        loaderView.layer?.position = CGPoint(x: loaderView.frame.midX, y: loaderView.frame.midY)
        loaderView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderView.layer?.add(rotate, forKey: nil)
    }
    
   
    
}
