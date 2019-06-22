//
//  Panda.swift
//  KongfuPanda
//
//  Created by HooJackie on 15/7/1.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

import SpriteKit
enum Status :Int{
    case run = 1, jump, jump2,roll
}

class Panda:SKSpriteNode {
    //定义跑，跳，滚动等动作动画
    let runAtlas = SKTextureAtlas(named: "run.atlas")
    var runFrames = [SKTexture]()
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames = [SKTexture]()
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]()
    //增加跳起的逼真效果动画
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    var jumpEffectFrames = [SKTexture]()
    var jumpEffect = SKSpriteNode()
    
    var status = Status.run
    var jumpStart:CGFloat = 0.0
    var jumpEnd:CGFloat = 0.0
    
    
    init(){

        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: SKColor.white, size: size)
        //跑
        for i in 1...runAtlas.textureNames.count {
            let tempName = String(format: "panda_run_%.2d", i)
            let runTexture = runAtlas.textureNamed(tempName)
            
            
            runFrames.append(runTexture)

           
        }
        
        //跳
        for i in 1...jumpAtlas.textureNames.count {
            let tempName = String(format: "panda_jump_%.2d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            
            
            jumpFrames.append(jumpTexture)

            
        }
        
        //滚
        for i in 1...rollAtlas.textureNames.count {
            let tempName = String(format: "panda_roll_%.2d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            
            
            rollFrames.append(rollTexture)
            
        }
        
        // 跳的时候的点缀效果
        for i in 1...jumpEffectAtlas.textureNames.count {
            let tempName = String(format: "jump_effect_%.2d", i)
            let effectexture = jumpEffectAtlas.textureNamed(tempName)
            jumpEffectFrames.append(effectexture)

        }
        
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPoint(x: -80, y: -30)
        jumpEffect.isHidden = true
        self.addChild(jumpEffect)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.1 //反弹力
        self.physicsBody?.categoryBitMask = BitMaskType.panda
        self.physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform | BitMaskType.apple
        self.physicsBody?.collisionBitMask = BitMaskType.platform
        self.zPosition = 20
        run()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func run(){
        //清楚所有动作
        self.removeAllActions()
        self.status = .run
        //重复跑动动作
        self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05)))
    }
    func jump(){
        self.removeAllActions()
        if status != .jump2 {
            //Adds an action to the list of actions executed by the node.
            //Creates an action that animates changes to a sprite’s texture.
            
            self.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.05),withKey:"jump")
            //The physics body’s velocity vector, measured in meters per second.
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 450)
            if status == Status.jump {
                self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05))
                status = Status.jump2
                self.jumpStart = self.position.y
            }else {
                showJumpEffect()
                status = .jump
            }
        }
        
        
    }
    func roll(){
        self.removeAllActions()
        self.status = .roll
        self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05),completion:{
            self.run()
            })
    }
    
    func showJumpEffect(){
        jumpEffect.isHidden = false
        let ectAct = SKAction.animate( with: jumpEffectFrames, timePerFrame: 0.05)
        let removeAct = SKAction.run({() in
            self.jumpEffect.isHidden = true
        })
        // 执行两个动作，先显示，后隐藏
        jumpEffect.run(SKAction.sequence([ectAct,removeAct]))
    }
    
    
    
}
