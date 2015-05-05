//
//  MinesweeperHardness.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit

class MinesweeperHardness : NSViewController {
    
    var timer = NSTimer()
    
    var storage = NSUD.standardUserDefaults()
    
    @IBOutlet weak var hardnessPopUp: NSPopUpButton!
    
    @IBOutlet weak var heightHelpLabel: NSTextField!
    @IBOutlet weak var helpLabel: NSTextField!
    
    @IBAction func helpButtonPressed(sender: AnyObject) {
        if helpLabel.hidden {
            helpLabel.hidden = false
        }
        else {
            helpLabel.hidden = true
        }
    }
    
    @IBOutlet weak var heightLabel: NSTextField!
    @IBOutlet weak var widthLabel: NSTextField!
    
    @IBOutlet weak var testLabel: NSTextField!
    
    func checkLabel(label : NSTextField, pattern : Int) -> Bool {
        if count(label.stringValue) == 0 {
            return false
        }
        else {
            if pattern == 1 {
                return (label.integerValue < 4 || label.integerValue > 24)
            }
            else {
                return (label.integerValue < 4 || label.integerValue > 40)
            }
        }
    }
    
    func check(sender : NSTimer) {
        if checkLabel(heightLabel, pattern: 1) {
            heightHelpLabel.hidden = false
        }
        else {
            heightHelpLabel.hidden = true
        }
        
        if checkLabel(widthLabel, pattern: 2) {
            testLabel.hidden = false
        }
        else {
            testLabel.hidden = true
        }
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if !checkLabel(heightLabel, pattern: 1) && !checkLabel(widthLabel, pattern: 2) && heightLabel.integerValue != 0 && widthLabel.integerValue != 0 {
            storage.setInteger(hardnessPopUp.indexOfSelectedItem, forKey: "mwHardness")
            storage.setInteger(heightLabel.integerValue, forKey: "mwHeight")
            storage.setInteger(widthLabel.integerValue, forKey: "mwWidth")
            storage.synchronize()
            self.dismissController(MinesweeperHardness)
            self.performSegueWithIdentifier("startGameMinesweeper", sender: self)
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.dismissController(MinesweeperHardness)
        self.view.window?.close()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
        self.view.window?.title = "Сапер"
        self.view.window?.orderFront(self)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("check:"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.view.window?.center()
    }
    
    
}
