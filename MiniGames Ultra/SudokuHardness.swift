//
//  SudokuHardness.swift
//  MiniGames Ultra
//
//  Created by Nik on 06.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa

class SudokuHardness: NSViewController {

    @IBOutlet weak var highlight: NSButton!
    @IBOutlet weak var hardnessInfo: NSTextField!
    @IBOutlet weak var HardnessPopUp: NSPopUpButton!
    @IBAction func showHardnessInfo(sender: AnyObject) {
        if hardnessInfo.hidden {
            hardnessInfo.hidden = false
        }
        else {
            hardnessInfo.hidden = true
        }
    }
    
    var storage = NSUserDefaults.standardUserDefaults()
    
    ///TODO: - Add game continuation
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
    }
    @IBAction func donePressed(sender: AnyObject) {
        storage.setInteger(HardnessPopUp.indexOfSelectedItem, forKey: "sudokuHardness")
        storage.setInteger(highlight.state, forKey: "highlight")
        storage.synchronize()
        self.dismissController(SudokuHardness)
        self.performSegueWithIdentifier("sudoku", sender: self)
    }
    
}
