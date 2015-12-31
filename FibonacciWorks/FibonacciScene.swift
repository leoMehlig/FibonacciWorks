//
//  Fibonacci.swift
//  FibonacciWorks
//
//  Created by Leonard Mehlig on 31/12/15.
//  Copyright © 2015 Leo Mehlig. All rights reserved.
//

import SpriteKit
import AVFoundation

class FibonacciScene: SKScene {
    
    let colors: [SKColor] = [
        SKColor(hex: "#000000"),
        SKColor(hex: "#FFFFFF"),
        SKColor(hex: "#929292"),
        SKColor(hex: "#E7B24C"),
        SKColor(hex: "#E74F43"),
        SKColor(hex: "#75BAE7"),
        SKColor(hex: "#5F5F5F"),
        SKColor(hex: "#F4F4F4"),
        SKColor(hex: "#7E3513"),
        SKColor(hex: "#B84A2B")
    ]
    
    let boomPlayer = try! AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("boom", withExtension: "mp3")!)
    let launchPlayer = try! AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("launch", withExtension: "mp3")!)
    
    let label: SKLabelNode = SKLabelNode()
    
    lazy var fibonacciGenerator: AnyGenerator<[SKColor]> = {
        var n1: UInt = 0
        var n2: UInt = 1
        return anyGenerator {
            let newN = n1 + n2
            (n1, n2) = (n2, newN)
            if newN >= 2971215073 { (n1, n2) = (0, 1) }
            print(newN)
            self.label.text = String(newN)
            return String(newN).characters.flatMap { Int(String($0)).map { self.colors[$0] } }
        }
    }()
    
    
    override func didMoveToView(view: SKView) {
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Top
        label.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 20)
        label.fontSize = 30
        self.addChild(label)
        firework()
    }
    
    func firework() {
        var array = self.fibonacciGenerator.next()
        _ = (array?.removeLast()).map {
            addSpark($0, index: (array?.count ?? 1),  completion: firework)
            self.boomPlayer.play()
        }
        
        array?.enumerate().forEach {
            addSpark($1, index: $0)
        }
        self.launchPlayer.play()
        
        
        
    }
    
    
    func addSpark(color: SKColor, index: Int, completion: () -> Void = { _ in }) {
        if let spark = NSBundle.mainBundle().pathForResource("FireSpark1", ofType: "sks").flatMap({ NSKeyedUnarchiver.unarchiveObjectWithFile($0) as? SKEmitterNode }) {
            spark.particleColorSequence = nil
            spark.particleColor = color
            spark.position = CGPoint(x: self.frame.midX, y: CGFloat(50 * index))
            spark.runAction(SKAction.sequence([SKAction.waitForDuration(NSTimeInterval(spark.particleLifetime)), SKAction.removeFromParent()]), completion: completion)
            self.addChild(spark)
        }
    }
}
