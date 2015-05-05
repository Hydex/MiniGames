//
//  GameOverScene.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 21.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGS, won : Bool, stage : Int) {
        super.init(size: size)
        
        var message = won ? "You completed stage \(stage)!" : "You lost!"
        
        backgroundColor = Col.lightGrayColor()
        
        let label = SKLN(fontNamed: "Chalkduster")
        label.fontColor = Col.blackColor()
        label.fontSize = 40.0
        label.text = message
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(label)
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(2.0), SKAction.runBlock() {
            self.view?.presentScene(ArcadeGameScene(size: self.size), transition: SKTransition.flipVerticalWithDuration(0.5))
            }]))
        if !won {
            NSUD.standardUserDefaults().setInteger(500, forKey: "ninjaLives")
            NSUD.standardUserDefaults().synchronize()
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.view?.presentScene(ArcadeGameScene(size: self.size), transition: SKTransition.flipHorizontalWithDuration(0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
