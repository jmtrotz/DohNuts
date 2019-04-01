//
//  GameScene.swift
//  DohNuts
//
//  Created by Jeffery Trotz on 3/24/19.
//  Copyright © 2019 Jeffery Trotz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Stores the number of donuts that have been collected
    var collectedDonuts: Int = 0
    
    // Stores the number of lives the player has remaining
    var lives: Int = 3
    
    // Stores the change in time between each frame
    var deltaTime: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    
    // SK Camera for a scrolling background
    let cameraNode: SKCameraNode = SKCameraNode()
    let cameraMovePointsPerSec: CGFloat = 200.0
    
    // Stores the size of the playable area
    var playableArea: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    // Labels to show the number of collected donuts and lives remaining
    let collectedDonutsLabel: SKLabelNode = SKLabelNode(fontNamed: "PWYummyDonuts")
    let livesRemainingLabel: SKLabelNode = SKLabelNode(fontNamed: "PWYummyDonuts")
    
    let homerCategory: UInt32 = 0x1 << 1
    let donutCategory: UInt32 = 0x1 << 2
    let broccoliCategory: UInt32 = 0x1 << 3
    let beerCategory: UInt32 = 0x1 << 4
    //let floorAndCeilingCategory: UInt32 = 0x1 << 5
    
    // SKNodes for the images used for Homer, donuts, and broccoli
    //let homer: SKSpriteNode = SKSpriteNode(imageNamed: "homer.png")
    let donut: SKSpriteNode = SKSpriteNode(imageNamed: "donut.png")
    let broccoli: SKSpriteNode = SKSpriteNode(imageNamed: "broccoli.png")
    let beer: SKSpriteNode = SKSpriteNode(imageNamed: "beer.png")
    
    // Sound effects for when a donut, piece of broccoli, or beer is hit
    let donutHitSound: SKAction = SKAction.playSoundFileNamed("wohoo.wav", waitForCompletion: false)
    let broccoliHitSound: SKAction = SKAction.playSoundFileNamed("doh.wav", waitForCompletion: false)
    let beerHitSound: SKAction = SKAction.playSoundFileNamed("mmmmBeer.wav", waitForCompletion: false)
    
    // Calculates the current visible playable area
    var cameraArea: CGRect
    {
        let x = cameraNode.position.x - size.width/2 + (size.width - playableArea.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - playableArea.height)/2
        return CGRect(x: x, y: y, width: playableArea.width, height: playableArea.height)
    }
    
    // Initializer required by SKScene
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initializes the scene
    override init(size: CGSize)
    {
        // Calculate the playable area
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight: CGFloat = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - playableHeight) / 2.0
        playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var homerImages: [SKTexture] = []
        
        for i in 0...9
        {
            homerImages.append(SKTexture(imageNamed: "homer\(i).png"))
        }
        
        super.init(size: size)
    }
    
    // Sets up the scene before it is rendered
    override func didMove(to view: SKView)
    {
        // Creates an endlessly scrolling background
        for i in 0...1
        {
            let background = self.backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0)
            background.name = "background"
            background.zPosition = -1
            addChild(background)
            
            // Add camera and set its position
            addChild(cameraNode)
            camera = cameraNode
            cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            
            // Start backgound music for the game
            playBackgroundMusic(filename: "backgroundMusic.mp3")
        }
        
        // Set properties for the label that shows the number of collected donuts and add it to the scene
        collectedDonutsLabel.text = "Donuts: X"
        collectedDonutsLabel.fontColor = SKColor.white
        collectedDonutsLabel.fontSize = 100
        collectedDonutsLabel.zPosition = 150
        collectedDonutsLabel.horizontalAlignmentMode = .left
        collectedDonutsLabel.verticalAlignmentMode = .top
        cameraNode.addChild(collectedDonutsLabel)
        
        // Set properties for the label that shows the number of lives remaining and add it to the scene
        livesRemainingLabel.text = "Lives: X"
        livesRemainingLabel.fontColor = SKColor.white
        livesRemainingLabel.fontSize = 100
        livesRemainingLabel.zPosition = 150
        livesRemainingLabel.horizontalAlignmentMode = .left
        livesRemainingLabel.verticalAlignmentMode = .top
        cameraNode.addChild(livesRemainingLabel)
        
        physicsWorld.contactDelegate = self
    }
    
    // Updates the scene. Called just before the scene is rendered
    override func update(_ currentTime: TimeInterval)
    {
        // Calculate change in time since last update
        if lastUpdateTime > 0
        {
            deltaTime = currentTime - lastUpdateTime
        }
            
        else
        {
            deltaTime = 0
        }
        
        // Move the camera
        moveCamera()
    }
    
    // Combines two background images to make one large image
    func backgroundNode() -> SKSpriteNode
    {
        // Create node to store both backgrounds
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        
        // Load background image #1 and pin it to the bottom left
        let background1 = SKSpriteNode(imageNamed: "background1")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        
        // Load background image #2 and pin it next to background #1
        let background2 = SKSpriteNode(imageNamed: "background2")
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y: 0)
        backgroundNode.addChild(background2)
        
        // Set background node to the size of both images
        backgroundNode.size = CGSize(width: background1.size.width + background2.size.width, height: background1.size.height)
        
        // Return the new background
        return backgroundNode
    }
    
    // Checks for contact between Homer and donuts or broccoli
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.categoryBitMask == donutCategory
        {
            contact.bodyA.node?.removeFromParent()
            collectedDonuts += 1
            collectedDonutsLabel.text = "Donuts: \(collectedDonuts)"
        }
        
        if contact.bodyB.categoryBitMask == donutCategory
        {
            contact.bodyB.node?.removeFromParent()
            collectedDonuts += 1
            collectedDonutsLabel.text = "Donuts: \(collectedDonuts)"
        }
        
        if contact.bodyA.categoryBitMask == broccoliCategory
        {
            contact.bodyA.node?.removeFromParent()
            lives -= 1
            livesRemainingLabel.text = "Lives: \(lives)"
        }
        
        if contact.bodyB.categoryBitMask == broccoliCategory
        {
            contact.bodyB.node?.removeFromParent()
            lives -= 1
            livesRemainingLabel.text = "Lives: \(lives)"
        }
        
        if contact.bodyA.categoryBitMask == beerCategory
        {
            contact.bodyA.node?.removeFromParent()
            lives += 1
            livesRemainingLabel.text = "Lives: \(lives)"
        }
        
        if contact.bodyB.categoryBitMask == beerCategory
        {
            contact.bodyB.node?.removeFromParent()
            lives += 1
            livesRemainingLabel.text = "Lives: \(lives)"
        }
    }
    
    // Moves the camera
    func moveCamera()
    {
        let backgroundVelocity = CGPoint(x: cameraMovePointsPerSec, y: 0)
        let amountToMove = backgroundVelocity * CGFloat(deltaTime)
        cameraNode.position += amountToMove
        
        enumerateChildNodes(withName: "background")
        {
            node, _ in
            let background = node as! SKSpriteNode
            
            if (background.position.x + background.size.width) < self.cameraArea.origin.x
            {
                background.position = CGPoint(x: background.position.x + (background.size.width * 2),
                                              y: background.position.y)
            }
        }
    }
}
