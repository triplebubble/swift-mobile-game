//
//  MyUtils.swift
//  ZombieConga
//
//  Created by User on 9/6/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
import CoreGraphics
import AVFoundation


var backgroundMusicPlayer: AVAudioPlayer!
func playBackGroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil){
        print("Cannot find the file: \(filename)")
        return
    }
    var error: NSError? = nil
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url!)
    } catch let error1 as NSError {
        error = error1
        backgroundMusicPlayer = nil
    }
    if backgroundMusicPlayer == nil {
        print("Could not create audio player: \(error)")
        return
    }
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

func randomInRange(range: Range<Int>) ->Int {
    let count = UInt32(range.endIndex - range.startIndex)
    return Int(arc4random_uniform(count)) + range.startIndex
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (inout point: CGPoint, scalar: CGFloat)  {
    point = point / scalar
}
func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (inout point: CGPoint, scalar: CGFloat)  {
    point = point * scalar
}


#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y),Float(x)))
}
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    func normalize() -> CGPoint {
        return self / length()
    }
    
    var angle: CGFloat {
        return atan2(y, x)
    }
    
}

let pi = CGFloat(M_PI)

func shortestAngleBetween(angel1 : CGFloat, angel2: CGFloat) ->CGFloat {
    let twopi = pi * 2.0
    var angel = (angel2 - angel1) % twopi
    if (angel >= pi) {
        angel = angel - twopi
    }
    if (angel <= -pi){
        angel = angel + twopi
    }
    return angel
}
extension CGFloat {
    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
    static func random() ->CGFloat {
        return CGFloat(Float(arc4random())/Float(UInt32.max))
    }
    static func random(min min: CGFloat, max: CGFloat) -> CGFloat{
        assert(min<max)
        return CGFloat.random() * (max - min) + min
    }
}


