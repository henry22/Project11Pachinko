//
//  GameScene.swift
//  Project11Pachinko
//
//  Created by Henry on 6/3/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
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
        
        makeSlotAt(CGPoint(x: 128, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: false)
        makeSlotAt(CGPoint(x: 640, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncerAt(CGPoint(x: 0, y: 0))
        makeBouncerAt(CGPoint(x: 256, y: 0))
        makeBouncerAt(CGPoint(x: 512, y: 0))
        makeBouncerAt(CGPoint(x: 768, y: 0))
        makeBouncerAt(CGPoint(x: 1024, y: 0))
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
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
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        
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
            //Add circular physics to the ball
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            //Giving the ball's physics body a bounciness level of 0.4
            ball.physicsBody!.restitution = 0.4
            ball.position = location
            addChild(ball)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
