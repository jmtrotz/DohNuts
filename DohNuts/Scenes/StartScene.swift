//
//  MainMenuScene.swift
//  DohNuts
//
//  Created by Jeffery Trotz on 3/30/19.
//  CS 430 Final Project
//  Copyright © 2019 Jeffery Trotz. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene
{
    // Sets up the scene before it is rendered
    override func didMove(to view: SKView)
    {
        // Image shown as the main menu screen
        var mainMenu: SKSpriteNode
        
        // Set the image and its position
        mainMenu = SKSpriteNode(imageNamed: "main")
        mainMenu.position = CGPoint(x: (size.width / 2), y: (size.height / 2))
        
        // Add the image to the scene and set the scale mode
        self.addChild(mainMenu)
        self.scaleMode = .aspectFill
    }
    
    // Transitions the user to the game when they touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Create new scene to be shown and set scale mode
        let scene = GameScene(size: self.size)
        scene.scaleMode = self.scaleMode
        
        // Set transition type/duration and present the new scene
        let transition = SKTransition.doorway(withDuration: 1.5)
        view?.presentScene(scene, transition: transition)
    }
}
