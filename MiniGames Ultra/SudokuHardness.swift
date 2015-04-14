//
//  SudokuHardness.swift
//  MiniGames Ultra
//
//  Created by Nik on 06.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa

class SudokuHardness: NSViewController {

    @IBOutlet weak var colorPicker: NSColorWell!
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
        if storage.boolForKey("continue") {
            storage.setBool(false, forKey: "continue")
            var al = NSAlert()
            al.showsHelp = false
            al.messageText = "You haven't finished previous game!"
            al.informativeText = "Do you wanna continue or start a new game?"
            al.addButtonWithTitle("Continue previous game")
            al.addButtonWithTitle("Start new game")
            var response = al.runModal()
            if response == NSAlertFirstButtonReturn {
                storage.setBool(true, forKey: "isContinuation")
                self.dismissController(SudokuHardness)
                self.performSegueWithIdentifier("sudoku", sender: self)
            }
            else {
                storage.setBool(false, forKey: "isContunuation")
            }
            storage.synchronize()
        }
        var color = NSColor.blackColor();
        if storage.objectForKey("sudokuColor") != nil {
            if let data = storage.objectForKey("sudokuColor") as? NSData {
                if let myLoadedColor =  NSUnarchiver.unarchiveObjectWithData(data) as? NSColor {
                    color = myLoadedColor
                }
            }
        }
        colorPicker.color = color
    }
    @IBAction func donePressed(sender: AnyObject) {
        var data = NSArchiver.archivedDataWithRootObject(colorPicker.color)
        storage.setObject(data, forKey: "sudokuColor")
        storage.setInteger(HardnessPopUp.indexOfSelectedItem, forKey: "sudokuHardness")
        storage.setInteger(highlight.state, forKey: "highlight")
        storage.synchronize()
        self.dismissController(SudokuHardness)
        self.performSegueWithIdentifier("sudoku", sender: self)
    }
    
}
