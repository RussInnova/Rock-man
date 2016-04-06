//
//  ViewController.swift
//  RockPet
//
//  Created by Keith Russell on 3/29/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var rockMan: RockMan!
    @IBOutlet weak var heart: DragImg!
    @IBOutlet weak var food: DragImg!
    @IBOutlet weak var skull1: UIImageView!
    @IBOutlet weak var skull2: UIImageView!
    @IBOutlet weak var skull3: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var rockManHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath:AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skull1.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        
        food.dropTarget = rockMan
        heart.dropTarget = rockMan
        
        NSNotificationCenter.defaultCenter().addObserver (self, selector:#selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
             try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError{
            print (err.debugDescription)
        }
        
        startTimer()
    }
    
    func itemDroppedOnCharacter (notif: AnyObject){
        rockManHappy = true
        startTimer()
        food.alpha = DIM_ALPHA
        food.userInteractionEnabled = false
        heart.alpha = DIM_ALPHA
        heart.userInteractionEnabled = false
        
        if currentItem == 0 {
            
            sfxHeart.play()
        } else {
            
            sfxBite.play()
        }
            
        
    }
    
    func startTimer(){
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        
        if !rockManHappy{
            
            penalties++
            sfxSkull.play()
            
                if penalties == 1 {
                skull1.alpha = OPAQUE
                skull2.alpha = DIM_ALPHA
                
                } else if penalties == 2 {
                    skull2.alpha = OPAQUE
                    skull3.alpha = DIM_ALPHA
                    
                } else if penalties >= 3 {
                    skull3.alpha = OPAQUE
                    
                } else {
                    skull1.alpha = DIM_ALPHA
                    skull2.alpha = DIM_ALPHA
                    skull3.alpha = DIM_ALPHA
                }
                if penalties >= MAX_PENALTIES {
                    gameOver()
                }
            
            }
        
        let rand = arc4random_uniform(2)
        if rand == 0 {
            
            food.alpha = DIM_ALPHA
            food.userInteractionEnabled = false
            
            heart.alpha = OPAQUE
            heart.userInteractionEnabled = true
            
        } else {
            
            heart.alpha = DIM_ALPHA
            heart.userInteractionEnabled = false
            
            food.alpha = OPAQUE
            food.userInteractionEnabled = true
        }
        currentItem = rand
        rockManHappy = false
        
    }
    func gameOver(){
        timer.invalidate()
        rockMan.playDeathAnimation()
        sfxDeath.play()
    }
}
