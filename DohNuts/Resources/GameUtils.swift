//
//  GameUtils.swift
//  DohNuts
//
//  Created by Jeffery Trotz on 3/24/19.
//  Final Project for CS 430
//  This class provides various utilities (mostly math related) used in the game.
//  The math functions are required by the SK camera for the endlessly scrolling
//  background. The audio player is just to play backround music for the game.
//  Copyright © 2019 Jeffrey Trotz. All rights reserved.
//

import Foundation
import CoreGraphics
import AVFoundation

// Audio player for background music
var backgroundMusicPlayer: AVAudioPlayer!

// Extension of CGPoint class to get length,
// a normalized version, and angle of a point
extension CGPoint
{
    // Returns length of a point
    func length() -> CGFloat
    {
        return sqrt(x * x + y * y)
    }
    
    // Returns a normalized version of a point
    func normalized() -> CGPoint
    {
        return self / length()
    }
    
    // Returns the angle of a point
    var angle: CGFloat
    {
        return atan2(y, x)
    }
}

// Returns 1 if the CGFloat is grater than or equal to 0, else it returns -1
extension CGFloat
{
    func sign() -> CGFloat
    {
        return self >= 0.0 ? 1.0 : -1.0
    }
}

// Extension of CGFloat class to return
// various types of random numbers
extension CGFloat
{
    // Returns a random number between 0 and 1
    static func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    // Returns a random number between the specified max/min
    static func random(min: CGFloat, max: CGFloat) -> CGFloat
    {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}

// All functions below this comment override various
// math functons (add, subtract, etc) for CGPoints
func + (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint)
{
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint)
{
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint)
{
    left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (point: inout CGPoint, scalar: CGFloat)
{
    point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= ( left: inout CGPoint, right: CGPoint)
{
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (point: inout CGPoint, scalar: CGFloat)
{
    point = point / scalar
}

// Creates audio player and plays background music for the game
func playBackgroundMusic(filename: String)
{
    // Load music file
    let resourceURL = Bundle.main.url(forResource: filename, withExtension: nil)
    
    guard let url = resourceURL else
    {
        print("Failed to locate '\(filename)'")
        return
    }
    
    // Create audio player and play music
    do
    {
        try backgroundMusicPlayer = AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
        
    // Catch error if the audio player could not be created
    catch
    {
        print("Failed to create audio player")
        return
    }
}
