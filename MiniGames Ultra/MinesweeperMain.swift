//
//  MinesweeperMain.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit

class MinesweeperMain: NSViewController {
    
    var height = 0
    var width = 0
    
    var ar : Array<NSButton> = []
    
    var storage = NSUserDefaults.standardUserDefaults()
    
    func buttonPressed(sender : NSButton) {
        
    }
    
    func addFlag(sender : NSGestureRecognizer) {
        if let but = sender.view as? NSButton {
            but.image = NSImage(named: "Flag.png")
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.title = "Сапер"
        
        self.view.window?.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
        height = storage.integerForKey("mwHeight")
        width = storage.integerForKey("mwWidth")
        
        var frame = self.view.window?.frame
        var newHeight = CGFloat(height * 30 + 100)
        var newWidth = CGFloat(width * 30)
        frame?.size = NSMakeSize(newWidth, newHeight)
        self.view.window?.setFrame(frame!, display: true)

        var x = 0
        var y = 0
        var k = 1
        for i in 1...height {
            for j in 1...width {
                var but = NSButton(frame: NSRect(x: x, y: y + 78, width: 30, height: 30))
                but.tag = k
                but.title = ""
                but.action = Selector("buttonPressed:")
                but.target = self
                but.bezelStyle = NSBezelStyle(rawValue: 6)!
                
                var ges = NSClickGestureRecognizer()
                ges.target = self
                ges.buttonMask = 0x2
                ges.numberOfClicksRequired = 1
                ges.action = Selector("addFlag:")
                but.addGestureRecognizer(ges)
                
                ar.append(but)
                self.view.addSubview(but)
                x += 30
                k++
            }
            y += 30
            x = 0
        }
        
    }
    
    
}