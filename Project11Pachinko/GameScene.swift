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
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //UITouch provides information about a touch such as its position and when it happened
        if let touch = touches.first as? UITouch {
            //Find out where the screen was touched in relation to the game scene
            let location = touch.locationInNode(self)
            let box = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 64, height: 64))
            box.position = location
            addChild(box)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
