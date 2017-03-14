//
//  TerminalOutputTextView.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 11/1/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class TerminalOutputTextView: NSTextView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        Swift.print("TerminalOutputTextView")
        font = NSFont(name: "Courier", size: 12)
        backgroundColor = NSColor(red:0.090, green:0.149, blue:0.220, alpha:1)
        textColor = NSColor(red:0.392, green:0.294, blue:0.890, alpha:1)
        startListening()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func startListening(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constants.NOTIF_NEWDATA), object: nil, queue: nil) { (notif) -> Void in
            Swift.print("#mj.newData notif")
            
            DispatchQueue.main.async(execute: { () -> Void in
                let s = notif.object as! String
                self.append(s)
            })
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constants.NOTIF_NEWSESSION), object: nil, queue: nil) { (notif) -> Void in
            Swift.print("#mj.newSession notif")
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.newSession()
            })
        }
    }
    
    func newSession(){
        append("\n\n----\n\n")
    }
    
    func append(_ appended: String) {
        let s = NSAttributedString(string: appended, attributes: Styles().terminalAtts())
        self.textStorage?.append(s)
        self.scrollToEndOfDocument(nil)
    }
}
