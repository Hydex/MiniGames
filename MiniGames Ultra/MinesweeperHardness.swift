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
    
    
    
    func check(sender : AnyObject?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("check:"), userInfo: nil, repeats: true)
    }
    
    
}
