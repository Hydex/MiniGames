//
//  GameOverStick.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 28/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit

class OverScene: SKScene {
    init(size: CGSize, won : Bool, scr : Int) {
        super.init(size: size)
        var message = ""
        var storage = NSUserDefaults.standardUserDefaults()
        if (scr > storage.integerForKey("bestScoreStick")) {
            storage.setInteger(scr, forKey: "bestScoreStick")
            message = "Great! New best score: " + String(scr)
        } else {
            message = "Score: " + String(scr) + ", Best score: " + String(storage.integerForKey("bestScoreStick"))
        }


        backgroundColor = SKColor.blueColor()
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.fontColor = SKColor.whiteColor()
        label.fontSize = 30.0
        label.text = message
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(label)

        
    }

    override func keyDown(theEvent: NSEvent) {
        self.view?.presentScene(StickmanMainScene(size: self.size), transition: SKTransition.flipHorizontalWithDuration(0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}