//
//  ArcadeGameController.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 21.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! ArcadeGameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class ArcadeGameController: NSViewController {
    
    let storage = NSUserDefaults.standardUserDefaults()
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
        self.view.window?.title = "Ninja fight"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = ArcadeGameScene(size : self.view.bounds.size)
        let skView = SKView(frame: NSRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        self.view.addSubview(skView)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        storage.setInteger(0, forKey: "stage")
        storage.synchronize()
        for i in self.view.subviews {
            i.removeFromSuperview()
        }
    }
    
}
