//
//  FootballController.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 05/05/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit
import SpriteKit

class FootballController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = FootballMainScene(size : self.view.bounds.size)
        let skView = CustomView(frame: NSRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        self.view.addSubview(skView)
    }
}