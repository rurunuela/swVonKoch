//
//  GameScene.swift
//  vonKoch2
//
//  Created by richard urunuela on 17/01/2018.
//  Copyright © 2018 richard urunuela. All rights reserved.
//

import SpriteKit
import GameplayKit

class point{
    var x = 0.0
    var y = 0.0
    var suc:point?
    init (x:Double,y:Double){
        self.x = x
        self.y = y
    }
}


func aff (pt:inout point){
    debugPrint(" --> ")
    debugPrint(" \(pt.x) \(pt.y)")
    while let ptcrt = pt.suc as point? {
        debugPrint(" \(ptcrt.x) \(ptcrt.y)")
        pt = ptcrt
    }
    
}

func vonKock(pt:point , generation:Int) {
    if generation  == 0 {return }
    
    if let next = pt.suc {
    
       
        //B Xb = Xe/4 + 3/4Xa et Yb =Ye/4 + 3/4Ya
        var x = next.x/4 + ((0.75)*pt.x)
        //Yb =Ye/4 + 3/4Ya
        var y = next.y/4  + (0.75)*pt.y
        
        let B = point(x:x,y:y)
        //Xc=(Xa+Xe)/2+(Ya-Ye)/4
        x = (next.x + pt.x)/2 + (pt.y - next.y ) / 4
        //Yc=(Ya+Ye)/2 + (Xe – Xa)/4
        y = (next.y + pt.y)/2 + (next.x - pt.x) / 4
        let C = point(x:x,y:y)
        //Xd = 3/4Xe + Xa/4
        x =  (0.75)*next.x + pt.x/4
        //Yd = 3/4Ye +Ya/4
        y = (0.75)*next.y + pt.y/4
        let D = point(x:x,y:y)
        
        
        
        
        pt.suc = B
        vonKock(pt: pt, generation:generation-1)
        
        B.suc = C
        vonKock(pt: B, generation:generation-1)
        
        C.suc = D
        vonKock(pt: C, generation:generation-1)
        
        D.suc = next
        vonKock(pt: D, generation:generation-1)
       
        
       
        
    }
    
    
}



class GameScene: SKScene {
    var generation = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    func getRandomColor() -> NSColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return NSColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    override func sceneDidLoad() {
    }
    func maj(gen:Int){
        //
        
        let path = CGMutablePath()
        
        // Definition des points
        var A = point(x : -400,y : 0)
        let B = point(x : 400,y : 0)
        var C = point (x:400 , y : -200)
        
        var D = point (x:-200 , y : -200)
        var E = point (x:-200 , y : 200)
        var F = point (x:200 , y : 200)
        var G = point (x:200 , y : -200)
        var H = point (x:-400 , y : -200)
        var FIN = point (x:-400 , y : 0)

        
        A.suc = B
        B.suc = C
        C.suc = D
        D.suc = E
        E.suc = F
        F.suc = G
        G.suc = H
        H.suc = FIN
        
        var points = [A,B,C,D,E,F,G,H]
        for pt in points{
            vonKock(pt: pt, generation: gen )
        }
        //vonKock(pt: A, generation: gen )
        //vonKock(pt: B, generation: gen)
        //vonKock(pt: C, generation: gen)

        //aff(pt: &A)
        var pnt = A
        while let ptcrt = pnt.suc as point? {
            
            
            
            let path: CGMutablePath = CGMutablePath()
            path.move(to: CGPoint(x:pnt.x, y:  pnt.y))
            path.addLine(to: CGPoint(x:ptcrt.x, y:  ptcrt.y))
            
            
        
        let shapeNode = SKShapeNode()
        shapeNode.path = path
        shapeNode.name = "line"
        shapeNode.strokeColor = getRandomColor()
        shapeNode.lineWidth = 4
        shapeNode.zPosition = 1
        
        self.addChild(shapeNode)
            pnt = ptcrt
        }
        
        
    
        
        
    }
    
    
  
    
    var cpt = 0
    override func update(_ currentTime: TimeInterval) {
        debugPrint(" t \(cpt)")

        if cpt > 20 {
        self.removeAllChildren()
        //
                debugPrint(" teet ")
            self.maj(gen:generation)
            generation =  generation + 1
            if (generation > 5 ) {generation = 0}
            cpt = 0
        }
        cpt = cpt  + 1
    }
}
