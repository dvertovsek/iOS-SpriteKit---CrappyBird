//
//  GameScene.swift
//  CrappyBird
//
//  Created by FOI on 15/06/16.
//  Copyright (c) 2016 Darijan Vertovsek. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Dino: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Wall: UInt32 = 0x1 << 3
    static let Score: UInt32 = 0x1 << 4
}

class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Dino = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    let scoreLbl = SKLabelNode()
    
    var died = Bool()
    var restartBTN = SKSpriteNode()
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene(){
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background .anchorPoint = CGPointZero
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            background.name = "background"
            background.size = self.view!.bounds.size
            self.addChild(background)
        }
        
        scoreLbl.position = CGPoint(x: self.frame.width/2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = ("\(score)")
        scoreLbl.fontName = "04b_19"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 60
        self.addChild(scoreLbl)
        
        Ground = SKSpriteNode(imageNamed: "ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOfSize: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Dino
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Dino
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.dynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        Dino = SKSpriteNode(imageNamed: "dino")
        Dino.size = CGSize(width: 60, height: 70)
        Dino.position = CGPoint(x: self.frame.width / 2 - Dino.frame.width, y: self.frame.height / 2)
        
        Dino.physicsBody = SKPhysicsBody(circleOfRadius: Dino.frame.height / 2)
        Dino.physicsBody?.categoryBitMask = PhysicsCategory.Dino
        Dino.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        Dino.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score
        Dino.physicsBody?.affectedByGravity = false
        Dino.physicsBody?.dynamic = true
        
        Dino.xScale = Dino.xScale * -1;
        
        Dino.zPosition = 2
        
        self.addChild(Dino)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        createScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameStarted == false{
            
            gameStarted = true
            
            Dino.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.waitForDuration(2.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            
            let spawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
            
            self.runAction(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + 20 + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance - 50, y: 0, duration: NSTimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Dino.physicsBody?.velocity = CGVectorMake(0,0)
            Dino.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        
        } else {
            
            if died == true{
                
            } else {
                Dino.physicsBody?.velocity = CGVectorMake(0,0)
                Dino.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            }
        
        }
        
        for touch in touches{
        
            let location = touch.locationInNode(self)
            if(died == true){
                
                if restartBTN.containsPoint(location){
                    restartScene()
                }
                
            }
        }
    }
   
    func createWalls(){
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Dino
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "wall")
        let btmWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 350)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Dino
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Dino
        topWall.physicsBody?.dynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCategory.Dino
        btmWall.physicsBody?.contactTestBitMask = PhysicsCategory.Dino
        btmWall.physicsBody?.dynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.addChild(scoreNode)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.runAction(moveAndRemove)
        
        self.addChild(wallPair)
    
    }
    override func update(currentTime: CFTimeInterval) {
        
        if gameStarted == true && died == false{
            enumerateChildNodesWithName("background", usingBlock: ({
                (node,error) in
                let bg = node as! SKSpriteNode
                bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                
                if bg.position.x <= -bg.size.width{
                    bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y)
                }
            }))
        }
    }
    
    func createBTN(){
        restartBTN = SKSpriteNode(imageNamed: "RestartBtn")
        restartBTN.size = CGSizeMake(200,100)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        
        restartBTN.runAction(SKAction.scaleTo(1.0, duration: 0.3))
    }
}

extension GameScene: SKPhysicsContactDelegate{

    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Dino
        {
    
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
            
        else if firstBody.categoryBitMask == PhysicsCategory.Dino && secondBody.categoryBitMask == PhysicsCategory.Score
        {
            
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        }
        
        else if firstBody.categoryBitMask == PhysicsCategory.Dino && secondBody.categoryBitMask == PhysicsCategory.Wall
            ||
            firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Dino
        {
            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                createBTN()
            }
        }
        
        else if firstBody.categoryBitMask == PhysicsCategory.Dino && secondBody.categoryBitMask == PhysicsCategory.Ground
            ||
            firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Dino
        {
            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                createBTN()
            }
        }

        
        
        
    }
}
