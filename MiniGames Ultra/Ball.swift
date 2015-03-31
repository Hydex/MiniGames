//
//  Ball.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 30/03/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit
import Cocoa



class BallGame: NSViewController {
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "BallGame"
        self.view.window?.orderFront(self)
    }
    
}
