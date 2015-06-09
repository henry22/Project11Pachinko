//
//  GameScene.swift
//  Project11Pachinko
//
//  Created by Henry on 6/3/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        //Use the property observers to make the label update itself when the score value changes
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        //SKSpriteNode can load any picture from the app bundle just like UIImage
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        //Blend modes determine how a node is drawn, and the .Replace option means "just draw it, ignoring any alpha values"
        background.blendMode = .Replace
        //In the game means "draw this behind everything else."
        background.zPosition = -1
        //To add any node to the current screen
        addChild(background)
        //Adds a physics body to the whole scene that is a line on each edge
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        //Assign the current scene to be the physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        makeSlotAt(CGPoint(x: 128, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: false)
        makeSlotAt(CGPoint(x: 640, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncerAt(CGPoint(x: 0, y: 0))
        makeBouncerAt(CGPoint(x: 256, y: 0))
        makeBouncerAt(CGPoint(x: 512, y: 0))
        makeBouncerAt(CGPoint(x: 768, y: 0))
        makeBouncerAt(CGPoint(x: 1024, y: 0))
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        
        //The object will still collide with other things, but it won't ever be moved as a result
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
    
    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody!.dynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        //Rotate the node by 90 degrees over 10 seconds, repeating forever
        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //UITouch provides information about a touch such as its position and when it happened
        if let touch = touches.first as? UITouch {
            //Find out where the screen was touched in relation to the game scene
            let location = touch.locationInNode(self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            
            ball.name = "ball"
            
            //Add circular physics to the ball
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            //We're saying, "tell me about every collision"
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            
            //Giving the ball's physics body a bounciness level of 0.4
            ball.physicsBody!.restitution = 0.4
            ball.position = location
            addChild(ball)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "ball" {
            collisionBetweenBalls(contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "ball" {
            collisionBetweenBalls(contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    func collisionBetweenBalls(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroyBall(ball)
            ++score
        } else if object.name == "bad" {
            destroyBall(ball)
            --score
        }
    }
    
    func destroyBall(ball: SKNode) {
        //It removes the node from the game
        ball.removeFromParent()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
