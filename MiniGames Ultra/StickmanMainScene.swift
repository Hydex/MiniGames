//
//  StickmanMainScene.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 28/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit


class StickmanMainScene: SKScene, SKPhysicsContactDelegate {

    struct Detection {
        static var manm : UInt32 = 1 << 1
        static var obstaclem : UInt32 = 1 << 2
    }

    var letjump = true, letlie = true, down = false
    var man = SKSpriteNode()
    var floor = SKSpriteNode(), ObDead = SKSpriteNode()
    var d = NSTimeInterval(2.5)
    var scr = 0, h = 0
    let lifeLabel = SKLabelNode(fontNamed: "Helvetica")

    override func didMoveToView(view: SKView) {

        physicsWorld.contactDelegate = self
        backgroundColor = NSColor.redColor()
        physicsWorld.gravity = CGVectorMake(0.0, -30)

        lifeLabel.position = CGPoint(x: size.width / 2, y: 320)
        lifeLabel.fontColor = SKColor.blackColor()
        lifeLabel.fontSize = 50
        lifeLabel.text = "0"
        addChild(lifeLabel)

        floor = SKSpriteNode(texture: SKTexture(image: NSImage.swatchWithColor(SKColor.blackColor(), size: CGSize(width: size.width, height: 10))))
        floor.position = CGPoint(x: size.width / 2, y: 0)
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.dynamic = false
        addChild(floor)


        man = SKSpriteNode(texture: SKTexture(image: NSImage(named: "stickman.png")!))
        man.position = CGPoint(x: size.width / 2, y: 35.5)
        man.physicsBody = SKPhysicsBody(rectangleOfSize: man.size)
        man.physicsBody?.allowsRotation = false
        man.color = SKColor.blackColor()
        man.physicsBody?.categoryBitMask = Detection.manm
        man.physicsBody?.collisionBitMask = Detection.obstaclem
        man.physicsBody?.contactTestBitMask = Detection.obstaclem
        addChild(man)

       let actionob = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(ob), SKAction.waitForDuration(NSTimeInterval(0.7))]), count: 10000)
       runAction(actionob)

        let actionjump = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(allowmove), SKAction.waitForDuration(NSTimeInterval(0.1))]), count: 700000)
        runAction(actionjump)


    }

    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        switch contactMask {
        case Detection.manm | Detection.obstaclem:
            self.view?.presentScene(OverScene(size: size, won: false, scr: scr))
        default: return
        }
    }

    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSUpArrowFunctionKey:
            if (letjump) {
                man.physicsBody?.applyImpulse(CGVectorMake(0.0, 90))
                letjump = false
                letlie = false
            }
        case NSDownArrowFunctionKey:
            if (letlie) {
                down = true
                man.texture = SKTexture(image: NSImage(named: "lie.png")!)
                man.size = CGSize(width: 60, height: 30)
                man.physicsBody = SKPhysicsBody(rectangleOfSize: man.size)
                man.physicsBody?.categoryBitMask = Detection.manm
                man.physicsBody?.collisionBitMask = Detection.obstaclem
                man.physicsBody?.contactTestBitMask = Detection.obstaclem
                letjump = false
                letlie = false
            }
        default:
            return
        }
        man.physicsBody?.allowsRotation = false
    }
    override func keyUp(theEvent: NSEvent) {
        super.keyUp(theEvent)
        switch theEvent.character {
        case NSDownArrowFunctionKey:
            down = false
            man.texture = SKTexture(image: NSImage(named: "stickman.png")!)
            man.size = CGSize(width: 30, height: 60)
            man.physicsBody = SKPhysicsBody(rectangleOfSize: man.size)
            man.physicsBody?.categoryBitMask = Detection.manm
            man.physicsBody?.collisionBitMask = Detection.obstaclem
            man.physicsBody?.contactTestBitMask = Detection.obstaclem
        default:
            return
        }
        man.physicsBody?.allowsRotation = false
    }


    func allowmove() {
        if (man.position.y < 40) {
            letjump = true
        }
        letlie = true
        scr += 2
        lifeLabel.text = String(scr)
    }
    func ob() {
        var r = Int(arc4random_uniform(2) + 1)
        CrObstacle(r)
    }
    func CrObstacle(type: Int) {
        println(type)
        var r = Int(arc4random_uniform(20) + 70)
        var p = arc4random_uniform(2) + 1
        var rd = Int(arc4random_uniform(2) + 1)
        if (type != 3) {let type = rd}
        d = (d - 0.015)

        var obstacle = SKSpriteNode()
        switch type {
        case 3:
            println(5)
            obstacle = SKSpriteNode(texture: SKTexture(image: NSImage.swatchWithColor(SKColor.yellowColor(), size: CGSize(width: 10, height: 10))))
            obstacle.position = CGPoint(x: 600, y: 150)
            obstacle.runAction(SKAction.moveTo(CGPoint(x: -50, y: 150), duration: d + 0.03))
        case 2:
            obstacle = SKSpriteNode(texture: SKTexture(image: NSImage.swatchWithColor(SKColor.blackColor(), size: CGSize(width: 30, height: r))))
            obstacle.position = CGPoint(x: 600, y: r/2 + 45)
            obstacle.runAction(SKAction.moveTo(CGPoint(x: -50, y: r/2 + 45), duration: d))
            CrObstacle(3)
        case 1:
            obstacle = SKSpriteNode(texture: SKTexture(image: NSImage.swatchWithColor(SKColor.blackColor(), size: CGSize(width: 30, height: r))))
            obstacle.position = CGPoint(x: 600, y: r/2 + 5)
            obstacle.runAction(SKAction.moveTo(CGPoint(x: -50, y: r/2 + 5), duration: d))

        default: break
        }
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.size)
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = Detection.obstaclem
        obstacle.physicsBody?.collisionBitMask = Detection.manm
        obstacle.physicsBody?.contactTestBitMask = Detection.manm
        addChild(obstacle)
    }
}
