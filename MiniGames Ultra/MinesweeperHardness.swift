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
    
    func checkLabel(label : NSTextField) -> Bool {
        return !(countElements(label.stringValue) > 0 && (label.integerValue < 4 || label.integerValue > 32))
    }
    
    func check(sender : AnyObject?) {
        if checkLabel(heightLabel) && checkLabel(widthLabel) {
            testLabel.hidden = true
        }
        else {
            testLabel.hidden = false
        }
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if checkLabel(heightLabel) && checkLabel(widthLabel) {
            storage.setInteger(hardnessPopUp.indexOfSelectedItem, forKey: "mwHardness")
            storage.setInteger(heightLabel.integerValue, forKey: "mwHeight")
            storage.setInteger(widthLabel.integerValue, forKey: "mwWidth")
            storage.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("check:"), userInfo: nil, repeats: true)
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        timer.invalidate()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
    }
    
    
}
