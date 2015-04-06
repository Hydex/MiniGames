//
//  MainController.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit

class MainController : NSViewController {
    
    @IBOutlet weak var gameChoose: NSPopUpButton!
    
    @IBAction func donePressed(sender: AnyObject) {
        switch gameChoose.indexOfSelectedItem {
        case 0:
            self.performSegueWithIdentifier("minesweeper", sender: self)
        case 1:
            self.performSegueWithIdentifier("ballGame", sender: self)
        case 2:
            self.performSegueWithIdentifier("sudoku", sender: self)
        default:
            break
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
        self.view.window?.title = "MiniGames"
        self.view.window?.orderFront(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
