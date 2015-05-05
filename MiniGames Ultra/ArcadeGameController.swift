//
//  ArcadeGameController.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 21.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa
import SpriteKit

class CustomView: SKView {
    override func rightMouseDown(theEvent: NSEvent) {
        self.scene?.rightMouseDown(theEvent)
    }
}

class ArcadeGameController: NSViewController {
    
    let storage = NSUD.standardUserDefaults()
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
        self.view.window?.title = "Ninja fight"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        storage.setInteger(500, forKey: "ninjaLives")
        let scene = ArcadeGameScene(size : self.view.bounds.size)
        let skView = CustomView(frame: NSRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        self.view.addSubview(skView)
        storage.synchronize()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        storage.setInteger(0, forKey: "stage")
        storage.setInteger(500, forKey: "ninjaLives")
        storage.synchronize()
        for i in self.view.subviews {
            i.removeFromSuperview()
        }
    }
    
}
