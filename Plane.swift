//
//  BoatMainScene.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 29/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit

var rightDown = false, leftDown = false

class PlaneScene: SKScene, SKPhysicsContactDelegate {

    struct Detection {
        static var planem : UInt32 = 1 << 1
        static var obstaclem : UInt32 = 1 << 2
    }

    var d = NSTimeInterval()
    var plane = SKSpriteNode()
    var down = false

    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = NSColor.blueColor()
        d = 3


        plane = SKSpriteNode(texture: SKTexture(image: NSImage(named: "plane.png")!))
        planeCr(NSImage(named: "plane.png")!)
        plane.position = CGPoint(x: size.width / 2, y: 200)
        addChild(plane)

        let actionob = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(CrObstacle), SKAction.waitForDuration(NSTimeInterval(0.3))]), count: 10000000)
        let actionmove = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(movefunc), SKAction.waitForDuration(NSTimeInterval(0.001))]), count: 10000000)
        runAction(actionob)
        runAction(actionmove)
    }

    func planeCr(image : NSImage) {
        plane.texture = SKTexture(image: image)
        plane.size = image.size
        plane.physicsBody = SKPhysicsBody(texture: SKTexture(image: image), size: plane.size)
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = Detection.planem
        plane.physicsBody?.collisionBitMask = Detection.obstaclem
        plane.physicsBody?.contactTestBitMask = Detection.obstaclem
    }

    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSRightArrowFunctionKey:
            if (!down) {rightDown = true}
        case NSLeftArrowFunctionKey:
            if (!down) {leftDown = true}
        case NSDownArrowFunctionKey:
            planeCr(NSImage.swatchWithColor(NSColor.redColor(), size: CGSize(width: 30, height: 120)))
            down = true
        default:
            return
        }
    }

    override func keyUp(theEvent: NSEvent) {
        switch theEvent.character {
        case NSRightArrowFunctionKey:
            rightDown = false
        case NSLeftArrowFunctionKey:
            leftDown = false
        case NSDownArrowFunctionKey:
            planeCr(NSImage(named: "plane.png")!)
            down = false
        default:
            return
        }
    }

    func movefunc() {
        
        if (rightDown) {
            plane.position.x += 5
        }
        if (leftDown) {
            plane.position.x -= 5
        }
    }
    func CrObstacle() {
        var r = Int(arc4random_uniform(500))

        d = (d - 0.002)

        let obstacle = SKSpriteNode(texture: SKTexture(image: NSImage.swatchWithColor(SKColor.blackColor(), size: CGSize(width: 50, height: 100))))
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.size)
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = Detection.obstaclem
        obstacle.physicsBody?.collisionBitMask = Detection.planem
        obstacle.physicsBody?.contactTestBitMask = Detection.planem
        obstacle.position = CGPoint(x: r, y: 800)
        addChild(obstacle)

        obstacle.runAction(SKAction.moveTo(CGPoint(x: r, y: -200), duration: d))
    }
}