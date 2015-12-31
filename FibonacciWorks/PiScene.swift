//
//  GameScene.swift
//  FibonacciWorks
//
//  Created by Leonard Mehlig on 31/12/15.
//  Copyright (c) 2015 Leo Mehlig. All rights reserved.
//

import SpriteKit

class PiScene: SKScene {
    
    var index: Int = 0
    var lastUpdate: CFTimeInterval = 0
    lazy var piGen: AnyGenerator<SKColor> = {
        let path = NSBundle.mainBundle().pathForResource("pi_10_000_000", ofType: "txt")
        let string = try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
        return anyGenerator {
            if self.index >= 10_000_000 { self.index = 0 }
            return self.colors[Int(String(string[string.startIndex.advancedBy(self.index)])) ?? 0]
        }
    }()
    
    
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches {
            let location = t.locationInNode(self)
            print(location)
            if let spark = NSBundle.mainBundle().pathForResource("FireSpark", ofType: "sks").flatMap({ NSKeyedUnarchiver.unarchiveObjectWithFile($0) as? SKEmitterNode }) {
                spark.position = location
                // spark.particleColor = color
                spark.numParticlesToEmit = 1
                spark.targetNode = self.scene
                self.addChild(spark)
            }
            
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if currentTime - self.lastUpdate > 0.1 {
            self.lastUpdate = currentTime
            guard let color = self.piGen.next() else { return }
            if let spark = NSBundle.mainBundle().pathForResource("FireSpark", ofType: "sks").flatMap({ NSKeyedUnarchiver.unarchiveObjectWithFile($0) as? SKEmitterNode }) {
                print(self.frame.maxY)
                spark.position = CGPoint(x: self.frame.midX, y: 0)
                spark.particleColorSequence = nil
                spark.particleColor = color
                spark.particlePositionRange = CGVector(dx: self.frame.width, dy: 0)
                spark.targetNode = self.scene
                spark.runAction(SKAction.sequence([SKAction.waitForDuration(Double(spark.particleLifetime)), SKAction.runBlock {
                    if let s = NSBundle.mainBundle().pathForResource("FireSpark1", ofType: "sks").flatMap({ NSKeyedUnarchiver.unarchiveObjectWithFile($0) as? SKEmitterNode }) {
                        print(self.frame.maxY)
                        s.position = CGPoint(x: self.frame.midX, y: 0)
                        s.particleColorSequence = nil
                        s.particleColor = color
                        s.particlePositionRange = CGVector(dx: self.frame.width, dy: 0)
                        s.targetNode = self.scene
                    }
                    }])) {
                    
                }
                self.addChild(spark)
                index++
            }
            
        }
    }
    
    
    func newSpark() -> SKEmitterNode {
        let s = SKEmitterNode()
        s.particleTexture = SKTexture(imageNamed: "spark.png")
        s.numParticlesToEmit = 1
        s.xAcceleration = 0
        s.yAcceleration = 1000
        s.particleLifetime = 1
        s.particleBirthRate = 1
        s.speed = 1000
        s.particleColorBlendFactor = 1
        s.particleColorSequence = nil
        
        return s
    }
}
