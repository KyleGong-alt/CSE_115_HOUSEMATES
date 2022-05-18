//
//  HorizontalSegue.swift
//  Housemates
//
//  Created by Jackson Tran on 4/29/22.
//

import UIKit
import SwiftUI

class RightSegue: UIStoryboardSegue {
    override func perform() {
        let initialView = self.source.view as UIView
        let destView = self.destination.view as UIView
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        initialView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        destView.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        
        let appWindow = UIApplication.shared.connectedScenes.lazy.compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil}.first(where: {$0.keyWindow != nil})?.keyWindow
        appWindow?.insertSubview(destView, aboveSubview: initialView)
        
        UIView.animate(withDuration: 0.3, animations: {
            initialView.frame = (initialView.frame.offsetBy(dx: -screenWidth, dy: 0))
            destView.frame = (destView.frame.offsetBy(dx: -screenWidth, dy: 0))
        }) { (Bool) in
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}

class LeftSegue: UIStoryboardSegue {
    override func perform() {
        let initialView = self.source.view as UIView
        let destView = self.destination.view as UIView
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        initialView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        destView.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
        
        let appWindow = UIApplication.shared.connectedScenes.lazy.compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil}.first(where: {$0.keyWindow != nil})?.keyWindow
        appWindow?.insertSubview(destView, aboveSubview: initialView)
        
        UIView.animate(withDuration: 0.3, animations: {
            initialView.frame = (initialView.frame.offsetBy(dx: screenWidth, dy: 0))
            destView.frame = (destView.frame.offsetBy(dx: screenWidth, dy: 0))
        }) { (Bool) in
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}

//https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/DefiningCustomPresentations.html#//apple_ref/doc/uid/TP40007457-CH25-SW1
let dimmingView = DimmingVC().view as UIView

class RightNavSegue: UIStoryboardSegue {
    override func perform() {
        let initialView = self.source.view as UIView
        initialView.tag = 100
        let destView = self.destination.view as UIView
        destView.tag = 100
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
    
        dimmingView.frame = initialView.frame
        
        let appWindow = UIApplication.shared.connectedScenes.lazy.compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil}.first(where: {$0.keyWindow != nil})?.keyWindow
        appWindow?.rootViewController = self.destination
        appWindow?.insertSubview(initialView, belowSubview: destView)
        appWindow?.insertSubview(dimmingView, aboveSubview: initialView)
   
        initialView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        destView.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        UIView.animate(withDuration: 0.3, animations: {
            initialView.frame = (initialView.frame.offsetBy(dx: -screenWidth + 80, dy: 0))
            dimmingView.frame = (dimmingView.frame.offsetBy(dx: -screenWidth + 80, dy: 0))
            dimmingView.alpha = 1
            destView.frame = (destView.frame.offsetBy(dx: -screenWidth + 80, dy: 0))
        }) { (Bool) in
            //self.source.present(self.destination, animated: false, completion: nil)
            //self.source.
            //appWindow?.rootViewController = self.destination

        }
    }
}

class CloseRightNavSegue: UIStoryboardSegue {
    override func perform() {
        let initialView = self.source.view as UIView
        let destView = self.destination.view as UIView
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let appWindow = UIApplication.shared.connectedScenes.lazy.compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil}.first(where: {$0.keyWindow != nil})?.keyWindow
        
        while(appWindow?.viewWithTag(100) != nil) {
            appWindow?.viewWithTag(100)?.removeFromSuperview()
        }
        
        appWindow?.rootViewController = self.destination
        appWindow?.insertSubview(initialView, belowSubview: destView)
        appWindow?.insertSubview(dimmingView, aboveSubview: destView)
        
        initialView.frame = CGRect(x: 80, y: 0, width: screenWidth, height: screenHeight)
        destView.frame = CGRect(x: -screenWidth + 80, y: 0, width: screenWidth, height: screenHeight)
        dimmingView.frame = destView.frame
        
        UIView.animate(withDuration: 0.3, animations: {
            initialView.frame = (initialView.frame.offsetBy(dx: -80 + screenWidth, dy: 0))
            dimmingView.frame = (dimmingView.frame.offsetBy(dx: -80 + screenWidth, dy: 0))
            dimmingView.alpha = 0
            destView.frame = (destView.frame.offsetBy(dx: -80 + screenWidth, dy: 0))
            
        }) { (Bool) in
            //self.source.present(self.destination, animated: false, completion: nil)
            //self.source.
            //appWindow?.rootViewController = self.destination

        }
        
    }
}
