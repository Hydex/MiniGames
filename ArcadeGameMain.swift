//
//  ArcadeGameMain.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 21.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import SpriteKit

struct Detection {
    static var no : UInt32 = 0
    static var all : UInt32 = UInt32.max
    static var monster : UInt32 = 0b1
    static var suric : UInt32 = 0b10
}

class ArcadeGameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "player.png")
    let lifeLabel = SKLabelNode(fontNamed: "Helvetica")
    let stageLabel = SKLabelNode(fontNamed: "Helvetica")
    
    var lives = 3
    var storage = NSUserDefaults.standardUserDefaults()
    var stage = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        lives = 3
        storage.setInteger(storage.integerForKey("stage") + 1, forKey: "stage")
        stage = storage.integerForKey("stage")
        storage.synchronize()
        
        physicsWorld.gravity = CGVectorMake(0.0, -10)
        physicsWorld.contactDelegate = self
        player.position = CGPoint(x: self.size.width * 0.1, y: self.size.height / 2)
        addChild(player)
        
        lifeLabel.position = CGPoint(x: self.size.width / 2 + 100, y: self.size.width * 0.05)
        lifeLabel.fontColor = SKColor.blackColor()
        lifeLabel.fontSize = 15
        lifeLabel.text = "lives: \(lives)"
        addChild(lifeLabel)
        
        stageLabel.position = CGPoint(x: self.size.width / 2 - 100, y: self.size.width * 0.05)
        stageLabel.fontSize = 15
        stageLabel.fontColor = SKColor.blackColor()
        stageLabel.text = "stage: \(stage)"
        addChild(stageLabel)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(createMonster), SKAction.waitForDuration(1)])))
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        
        let suric = SKSpriteNode(imageNamed: "projectile.png")
        suric.position = player.position
        suric.physicsBody = SKPhysicsBody(circleOfRadius: suric.size.width / 2)
        suric.physicsBody?.categoryBitMask = Detection.suric
        suric.physicsBody?.collisionBitMask = Detection.no
        suric.physicsBody?.contactTestBitMask = Detection.monster
        suric.physicsBody?.usesPreciseCollisionDetection = true
        suric.physicsBody?.dynamic = true
        suric.physicsBody?.angularVelocity = -10.0
        suric.physicsBody?.mass = 2.5
        
        let offset = location - suric.position
        
        if offset.x < 0 {
            return
        }
        
        addChild(suric)
        
        let direc = offset.normalized()
        
        suric.physicsBody?.applyImpulse(CGVector(dx: offset.x * 10, dy: offset.y * 10))
        
    }
    
    func suricHit(suric : SKSpriteNode?, monster : SKSpriteNode?) {
        if suric != nil && monster != nil {
            suric!.removeFromParent()
            monster!.removeFromParent()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var first : SKPhysicsBody
        var second : SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        }
        else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if ((first.categoryBitMask & Detection.monster != 0) && (second.categoryBitMask & Detection.suric != 0)) {
            suricHit(first.node as? SKSpriteNode, monster: second.node as? SKSpriteNode)
        }
    }
    
    func createMonster() {
        let monster = SKSpriteNode(imageNamed: "monster.png")
        
        let y = random(min: monster.size.height / 2, size.height - monster.size.height)
        monster.position = CGPoint(x: self.size.width + monster.size.width / 2, y: y)
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody?.usesPreciseCollisionDetection = true
        monster.physicsBody?.categoryBitMask = Detection.monster
        monster.physicsBody?.contactTestBitMask = Detection.suric
        monster.physicsBody?.collisionBitMask = Detection.no
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.dynamic = true
        addChild(monster)
        
        let duration = random(min: 2.0, 4.0)
        let move = SKAction.moveTo(CGPoint(x: -monster.size.width / 2, y: y), duration: NSTimeInterval(duration))
        let done = SKAction.removeFromParent()
        let lose = SKAction.runBlock() {
            self.lives--
            if self.lives == 0 {
                self.storage.setInteger(0, forKey: "stage")
                self.view!.presentScene(GameOverScene(size: self.size, won: false, stage: self.storage.integerForKey("stage")), transition: SKTransition.flipVerticalWithDuration(0.5))
            }
        }
        
        monster.runAction(SKAction.sequence([move, lose, done]))
    }
    
    override func update(currentTime: NSTimeInterval) {
        lifeLabel.text = "lives: \(lives)"
        backgroundColor = SKColor.whiteColor()
    }
}