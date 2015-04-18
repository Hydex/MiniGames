//
//  AppDelegate.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa

var activeGame = ""

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var timer = NSTimer()
    var sudAct = false

    @IBAction func PausePressed(sender: NSMenuItem) {
        
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("testFunc:"), userInfo: nil, repeats: true)
    }
    
    func testFunc(sender : AnyObject?) {
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

