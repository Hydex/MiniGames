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
        default:
            break
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
