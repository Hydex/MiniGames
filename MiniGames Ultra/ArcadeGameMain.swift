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
    static var ninja : UInt32 = 0b11
}

class ArcadeGameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "player.png")
    let lifeLabel = SKLabelNode(fontNamed: "Helvetica")
    let stageLabel = SKLabelNode(fontNamed: "Helvetica")
    
    var lives = 3
    var storage = NSUserDefaults.standardUserDefaults()
    var stage = 0
    var nOfMon = 0
    var durat : (min: CGFloat, max: CGFloat) = (0, 0)
    var movingTime : CGFloat = 0.0
    
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
        nOfMon = 10 + stage * 5
        
        physicsWorld.gravity = CGVectorMake(0.0, -10)
        physicsWorld.contactDelegate = self
        player.position = CGPoint(x: self.size.width * 0.1, y: self.size.height / 2)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = Detection.ninja
        player.physicsBody?.collisionBitMask = Detection.no
        player.physicsBody?.contactTestBitMask = Detection.monster
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
        
        let win = SKAction.runBlock() {
            self.view?.presentScene(GameOverScene(size: size, won: true, stage: stage))
        }
        let action = SKAction.repeatAction(SKAction.sequence([SKAction.runBlock(createMonster), SKAction.waitForDuration(2 - 0.15 * NSTimeInterval(stage - 1))]), count: 10 + stage * 5)
        runAction(SKAction.sequence([action, SKAction.waitForDuration(NSTimeInterval(movingTime)), win]))
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        var s = ""
        var r = arc4random_uniform(4)
        switch r {
        case 0:
            s = "starBlack.png"
        case 1:
            s = "starCyclone.png"
        case 2:
            s = "starDragon.png"
        default:
            s = "ninjaStar.png"
        }
        
        let suric = SKSpriteNode(imageNamed: s)
        suric.position = player.position
        suric.physicsBody = SKPhysicsBody(circleOfRadius: suric.size.width / 2)
        suric.physicsBody?.categoryBitMask = Detection.suric
        suric.physicsBody?.collisionBitMask = Detection.no
        suric.physicsBody?.contactTestBitMask = Detection.monster
        suric.physicsBody?.usesPreciseCollisionDetection = true
        suric.physicsBody?.dynamic = true
        suric.physicsBody?.angularVelocity = -10.0
        suric.physicsBody?.mass = 2.5 + CGFloat(abs(suric.size.width - 30) * 0.05)
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
        
        if ((first.categoryBitMask == 1) && (second.categoryBitMask == 2)) {
            suricHit(first.node as? SKSpriteNode, monster: second.node as? SKSpriteNode)
        }
        else if second.categoryBitMask == 3 && first.categoryBitMask == 1 {
            first.node?.removeFromParent()
            lose(2)
        }
    }
    
    func createMonster() {
        var n = arc4random_uniform(100)
        var s = ""
        var scale : CGFloat
        switch n {
        case 0...59:
            durat = (3 - 0.25 * CGFloat(stage - 1), 3.5 - 0.25 * CGFloat(stage - 1))
            s = "GhostSmall.png"
            scale = 0.3
        case 60...85:
            durat = (3.5 - 0.25 * CGFloat(stage - 1), 4 - 0.25 * CGFloat(stage - 1))
            s = "GhostMedium.png"
            scale = 0.14
        default:
            durat = (4.5 - 0.25 * CGFloat(stage - 1), 5 - 0.25 * CGFloat(stage - 1))
            s = "GhostBig.png"
            scale = 0.1666
        }
        
        let monster = SKSpriteNode(imageNamed: s)
        monster.setScale(scale)
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
        
        let duration = random(min: durat.min, durat.max)
        let move = SKAction.moveTo(CGPoint(x: -monster.size.width / 2, y: y), duration: NSTimeInterval(duration))
        let done = SKAction.removeFromParent()
        let lose = SKAction.runBlock() {
            self.lose(1)
        }
        monster.runAction(SKAction.sequence([move, lose, done]))
        movingTime = duration
    }
    
    func lose(n : Int) {
        lives -= n
        if lives <= 0 {
            self.view?.presentScene(GameOverScene(size: size, won: false, stage: stage), transition: SKTransition.flipHorizontalWithDuration(0.5))
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if lives < 0 {
            lives = 0
        }
        lifeLabel.text = "lives: \(lives)"
        backgroundColor = SKColor.whiteColor()
    }
}