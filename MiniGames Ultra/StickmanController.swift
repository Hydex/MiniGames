//
//  StickmanController.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 28/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa
import SpriteKit

class StickmanController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = StickmanMainScene(size : self.view.bounds.size)
        let skView = CustomView(frame: NSRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        self.view.addSubview(skView)
    }
    
}
