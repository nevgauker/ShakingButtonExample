//
//  ShakingButton.swift
//  Test
//
//  Created by rotem nevgauker on 3/18/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit
import AVFoundation

enum EndAnimation {
    case bigger
    case smaller
}

class ShakingButton: UIButton {
    // onn and off colors
    let startColor = UIColor.red
    let endColor = UIColor.green
    //touch time
    let timeFactor = 3
    //amoute of shake
    let shakingFactor:CGFloat = 5.0
    let endAnimation:EndAnimation = EndAnimation.bigger
    var singleTime = true
    var didEnd = false

    private  var isShaking = false
    private let soundName = "beep"
    private var timer: Timer!
    private var runningTime = 0
    var player = AVPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        self.backgroundColor = startColor
        self.layer.cornerRadius = self.frame.size.width/2
        
        if let urlpath = Bundle.main.path(forResource: soundName, ofType: "mp3") {
            let playerItem = AVPlayerItem(url: URL(fileURLWithPath: urlpath))
            self.player = AVPlayer(playerItem:playerItem)
            self.player.pause()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isShaking {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            let animation = self.shakeAnimation()
            layer.add(animation, forKey: "position")
            isShaking = true
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.removeAllAnimations()
        isShaking = false
    }
    func shakeAnimation()-> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - shakingFactor, y: self.center.y - shakingFactor))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + shakingFactor, y: self.center.y + shakingFactor))
        return animation
    }
    
    @objc private func handleTimer() {
        self.runningTime += 1
        if runningTime >= timeFactor {
           self.handleEnd()
        }
    }
    func handleEnd() {
        if didEnd && singleTime {
            return
        }
        self.runningTime = 0
        self.layer.removeAllAnimations()
        self.isShaking = false
        timer.invalidate()
        timer = nil
        self.backgroundColor = self.endColor
        self.playSound()
        if self.endAnimation == EndAnimation.bigger  {
            self.getBiggerAnimation()
        }else {
            self.getSmallerAnimation()
        }
        didEnd = true
        if singleTime {
            self.isEnabled = false
        }
        self.player.seek(to: kCMTimeZero)

    }
    
    func playSound() {
        self.player.play()
        
    }
    
    
    func getBiggerAnimation () {
        UIView.animate(withDuration: 0.3) {
            var frame = self.frame
            frame.size.width *= 1.2
            frame.size.height *= 1.2
            self.frame = frame
            self.layer.cornerRadius = self.frame.size.width / 2
        }
    }
    
    func getSmallerAnimation () {
        UIView.animate(withDuration: 0.3) {
            var frame = self.frame
            frame.size.width *= 0.8
            frame.size.height *= 0.8
            self.frame = frame
            self.layer.cornerRadius = self.frame.size.width / 2
        }
    }
}
