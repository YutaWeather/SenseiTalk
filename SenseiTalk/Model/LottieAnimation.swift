//
//  LottieAnimation.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/02/01.
//

import Foundation
import Lottie
import UIKit

class LottieAnimation{
    
    func startAnimation(name:String,view:UIView){
        

        let animationView = AnimationView()
        
        let animation = Animation.named(name)
        animationView.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play()
        
//        animationView.play { finished in
//            if finished {
//                animationView.removeFromSuperview()
//            }
//        }
    
    }
    
}

