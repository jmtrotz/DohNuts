//
//  GameViewController.swift
//  DohNuts
//
//  Created by Jeffery Trotz on 3/24/19.
//  Final Project for CS 430
//  Copyright © 2019 Jeffery Trotz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set size of the scene
        let scene = StartScene(size: CGSize(width: 2048, height: 1536))
        let view = self.view as! SKView

        scene.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        view.showsFPS = false
        view.showsNodeCount = false
        view.presentScene(scene)
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return .allButUpsideDown
        }
        
        else
        {
            return .all
        }
    }
    
    
    // Release any cached data, images, etc that aren't in use.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
}
