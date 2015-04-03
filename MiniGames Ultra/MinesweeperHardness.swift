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
    
    var storage = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var hardnessPopUp: NSPopUpButton!
    
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
        if pattern == 1 {
            return !(countElements(label.stringValue) > 0 && (label.integerValue < 4 || label.integerValue > 24))
        }
        else {
            return !(countElements(label.stringValue) > 0 && (label.integerValue < 4 || label.integerValue > 40))
        }
    }
    
    func check(sender : NSTimer) {
        if checkLabel(heightLabel, pattern: 1) && checkLabel(widthLabel, pattern: 2) {
            testLabel.hidden = true
        }
        else {
            testLabel.hidden = false
        }
        
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if checkLabel(heightLabel, pattern: 1) && checkLabel(widthLabel, pattern: 2) {
            storage.setInteger(hardnessPopUp.indexOfSelectedItem, forKey: "mwHardness")
            storage.setInteger(heightLabel.integerValue, forKey: "mwHeight")
            storage.setInteger(widthLabel.integerValue, forKey: "mwWidth")
            storage.synchronize()
            self.dismissController(MinesweeperHardness)
            self.performSegueWithIdentifier("startGameMinesweeper", sender: self)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("check:"), userInfo: nil, repeats: true)
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.dismissController(MinesweeperHardness)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask
        self.view.window?.title = "Сапер"
        self.view.window?.orderFront(self)
    }
    
    
}
