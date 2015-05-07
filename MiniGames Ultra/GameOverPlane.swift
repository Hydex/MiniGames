//
//  GameOverPlane.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 30/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit

var storage = NSUserDefaults.standardUserDefaults()

class OverPlaneScene: SKScene {
    init(size: CGSize, won : Bool, scr : Int, tg: Int) {
        super.init(size: size)
        backgroundColor = SKColor.blackColor()
        var message = ""
        var col = NSColor()
        if (scr > storage.integerForKey("bestScorePlane")) {
            storage.setInteger(scr, forKey: "bestScorePlane")
            message = "Great! New best score: " + String(scr)
            col = NSColor.greenColor()
        } else {
            message = "Score: " + String(scr) + ", Best score: " + String(storage.integerForKey("bestScorePlane"))
            col = NSColor.redColor()
        }

        func newlab(pos: CGPoint, mess : String, col: NSColor) {
            let label = SKLabelNode(fontNamed: "Chalkduster")
            label.fontColor = col
            label.fontSize = 18.0
            label.text = mess
            label.position = pos
            addChild(label)
        }
        newlab(CGPoint(x: self.size.width / 2, y: self.size.height / 2), message, col)
        let tg = Int(((tg / 15) - 9) / (storage.integerForKey("maxG")-4))
        if (tg+9 > storage.integerForKey("maxG")) {
            storage.setInteger(tg+9, forKey: "maxG")
            var mes =  "Wow! Now your pilot can maintain up to " + String(tg+9) + "g"
            newlab(CGPoint(x: self.size.width / 2, y: ((self.size.height / 2) - 50)), mes, NSColor.whiteColor())
        }
    }
    override func keyDown(theEvent: NSEvent) {
        if (theEvent.character == 32) {
            self.view?.presentScene(PlaneMainScene(size: self.size), transition: SKTransition.flipHorizontalWithDuration(0.5))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}