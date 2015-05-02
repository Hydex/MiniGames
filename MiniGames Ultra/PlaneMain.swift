//
//  BoatMainScene.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 29/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit

var rightDown = false, leftDown = false, down = false, g = 2, tg = 0, d = NSTimeInterval(), upDown = true
var glabel = SKLabelNode()
class PlaneMainScene: SKScene, SKPhysicsContactDelegate {

    var scr = 0
    struct Detection {
        static var planem : UInt32 = 1 << 1
        static var obstaclem : UInt32 = 1 << 2
        static var delm: UInt32 = 1 << 3
    }

    var plane = SKSpriteNode()

    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = 0
        backgroundColor = NSColor(red: 0.3, green: 0.8, blue: 1, alpha: 1)
        d = 4.5
        tg = 0

        glabel = SKLabelNode(fontNamed: "Helvetica")
        glabel.position = CGPoint(x: 470, y: 20)
        glabel.fontColor = SKColor.blackColor()
        glabel.fontSize = 50
        glabel.text = "G: 2"
        addChild(glabel)

        var del = SKSpriteNode(texture: SKTexture(image: NSImage.swatchWithColor(NSColor.greenColor(), size: CGSize(width: 550, height: 900))))
        del.physicsBody = SKPhysicsBody(texture: SKTexture(image: NSImage.swatchWithColor(NSColor.greenColor(), size: size)), size: del.size)
        del.position = CGPoint(x: 275, y: -560)
        del.physicsBody?.dynamic = false
        del.physicsBody?.categoryBitMask = Detection.delm
        del.physicsBody?.collisionBitMask = Detection.obstaclem
        del.physicsBody?.contactTestBitMask = Detection.obstaclem
        addChild(del)

        plane = SKSpriteNode(texture: SKTexture(image: NSImage(named: "plane-1.png")!))
        planeCr(NSImage(named: "plane-1.png")!)
        plane.position = CGPoint(x: size.width / 2, y: 200)
        plane.physicsBody?.allowsRotation = false
        
        addChild(plane)

        let actiong = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(teg), SKAction.waitForDuration(NSTimeInterval(0.5))]), count: 10000000)
        let actionob = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(CrObstacle), SKAction.waitForDuration(NSTimeInterval(0.45))]), count: 10000000)
        let actionmove = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(movefunc), SKAction.waitForDuration(NSTimeInterval(0.01))]), count: 10000000)
        runAction(actiong)
        runAction(actionob)
        runAction(actionmove)
    }

    func planeCr(image : NSImage) {
        plane.texture = SKTexture(image: image)
        plane.size = image.size
        plane.physicsBody = SKPhysicsBody(texture: SKTexture(image: image), size: plane.size)
        plane.physicsBody?.allowsRotation = false
        plane.physicsBody?.categoryBitMask = Detection.planem
        plane.physicsBody?.collisionBitMask = Detection.obstaclem
        plane.physicsBody?.contactTestBitMask = Detection.obstaclem
    }

    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSRightArrowFunctionKey:
            rightDown = true
        case NSLeftArrowFunctionKey:
            leftDown = true
        case NSDownArrowFunctionKey:
            down = true
        case NSUpArrowFunctionKey:
            upDown = true
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
            planeCr(NSImage(named: "plane-1.png")!)
            down = false
        case NSUpArrowFunctionKey:
            upDown = false
        default:
            return
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        switch contactMask {
        case Detection.planem | Detection.obstaclem:
            planeCr(NSImage(named: "plane-1.png")!)
            var act = SKAction.waitForDuration(1)
            runAction(act)
            self.view?.presentScene(OverPlaneScene(size: size, won: false, scr: scr, tg: tg))
            rightDown = false
            leftDown = false
            down = false
            g = 2
        case Detection.delm | Detection.obstaclem:
            println("contact")
            if (contact.bodyA.categoryBitMask == Detection.obstaclem) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        default: return
        }

    }
    func movefunc() {
        scr += 1
        if (plane.position.x < 0) {
            plane.position.x = 529
        }
        if (plane.position.x > 530) {
            plane.position.x = 0
        }
        if (down) {
            if (rightDown) {
                planeCr(NSImage(named: "careen-1")!)
                plane.position.x += 1.5
            }
            if (leftDown) {
                    planeCr(NSImage(named: "careen")!)
                    plane.position.x -= 1.5
            }
            if (!leftDown)&&(!rightDown) {
                planeCr(NSImage(named: "careen-1")!)
            }
        } else {
            if (rightDown) {
                plane.position.x += 7
            }
            if (leftDown) {
                plane.position.x -= 7
            }
        }
        if (upDown)&&(plane.position.y < 200) {
            plane.position.y += 5
        }
    }
    func teg() {
        if (down) {
            g += 1
        } else {
            if (g > 2) {
                g -= 1
            }
        }
        glabel.text = "G: " + String(g)
        if (g >= storage.integerForKey("maxG")) {
            self.view?.presentScene(OverPlaneScene(size: size, won: false, scr: scr, tg: tg))
            rightDown = false
            leftDown = false
            down = false
            g = 2
        }
        tg += (g - 2)
        switch g {
        case (storage.integerForKey("maxG") - 3):
            backgroundColor = NSColor.yellowColor()
        case (storage.integerForKey("maxG") - 2):
            backgroundColor = NSColor.orangeColor()
        case (storage.integerForKey("maxG") - 1):
            backgroundColor = NSColor.redColor()
        default:
            backgroundColor = NSColor(red: 0.3, green: 0.8, blue: 1, alpha: 1)
        }
    }

    func CrObject(obj: SKSpriteNode, img: NSImage, tr: Bool, posy: Int) {
        var r = Int(arc4random_uniform(500) + 30)
        let obj = SKSpriteNode(texture: SKTexture(image: img))
        obj.position = CGPoint(x: r, y: posy)
        if (tr) {
            obj.physicsBody = SKPhysicsBody(texture: SKTexture(image: img), size: obj.size)
            obj.physicsBody?.allowsRotation = false
            obj.physicsBody?.affectedByGravity = false
        }
        obj.runAction(SKAction.moveTo(CGPoint(x: r, y: -300), duration: d))
        addChild(obj)
    }

    func CrCloud() {
        var cloud = SKSpriteNode()
        CrObject(cloud, img: NSImage(named: "cloud.png")!, tr: false, posy: 1000)
    }
    func check(obj: SKSpriteNode) {
        if (obj.position.y < -200) {
            obj.removeFromParent()
        }

    }
    func CrObstacle() {

        d = (d - 0.006)
        var r = Int(arc4random_uniform(470) + 30)
        var rc = UInt32(0), rfp = UInt32(0), rt = UInt32(0)
        rc = arc4random_uniform(5)
        rt = arc4random_uniform(20)
        if (rc == 2) {
            CrCloud()
        }
        var obstacle = SKSpriteNode(texture: SKTexture(image: NSImage(named: "frontplane.png")!))
        obstacle.physicsBody = SKPhysicsBody(texture: SKTexture(image: NSImage(named: "frontplane.png")!), size: obstacle.size)
        obstacle.position = CGPoint(x: r, y: 1600)
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.categoryBitMask = Detection.obstaclem
        obstacle.physicsBody?.collisionBitMask = Detection.planem | Detection.obstaclem
        obstacle.physicsBody?.contactTestBitMask = Detection.planem | Detection.obstaclem
        obstacle.runAction(SKAction.repeatAction(SKAction.sequence([SKAction(check(obstacle)), SKAction.waitForDuration(NSTimeInterval(0.45))]), count: 10000000))
        obstacle.runAction(SKAction.moveTo(CGPoint(x: r, y: -300), duration: d))
        addChild(obstacle)
    }
}