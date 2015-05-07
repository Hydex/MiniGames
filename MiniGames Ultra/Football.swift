//
//  Football.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 05/05/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit
import SpriteKit

class FootballMainScene: SKScene, SKPhysicsContactDelegate {

    var GP = SKSpriteNode()
    var gatesel = Selector()
    func CrObject(img: NSImage, pos: CGPoint, inout obj: SKSpriteNode, d:  Bool, sel: Selector) {
        obj = SKSpriteNode(texture: SKTexture(image: img))
        obj.position = pos
        obj.physicsBody = SKPhysicsBody(texture: SKTexture(image: img), size: obj.size)
        addChild(obj)
    }

    override func didMoveToView(view: SKView) {
        CrObject(NSImage.swatchWithColor(NSColor.redColor(), size: NSSize(width: 20, height: 100)), pos: CGPoint(x: 10, y: 50), obj: &GP, d: false, sel: gatesel)
    }
}
