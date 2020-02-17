//
//  UIExtensions.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 28.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


extension UITabBarController {
    func setTextItemTintColor(isDay : Bool){
        self.tabBar.unselectedItemTintColor = isDay ?  Contants.unselectedItemTintColor : Contants.unselectedItemTintColorNight
        UITabBar.appearance().tintColor = isDay ? Contants.selectedImageTintColor : Contants.selectedImageTintColorNight
    }
}

extension UIViewController {
    func addBackgroundView(type : DescriptionType) {
        removeBackgroundView()
        DispatchQueue.main.async {
            let share = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let uiview = GradientView.init(frame: CGRect.init(x: 0, y: 0, width: (share?.bounds.width)!, height: (share?.bounds.height)!))
            uiview.tag = 777
            uiview.setGradient(type: type)
            self.view?.insertSubview(uiview, at: 0)
            
        }
        
    }
    
    func removeBackgroundView() {
        DispatchQueue.main.async {
            if let uiview = self.view.subviews.filter(
                { $0.tag == 777}).first {
                uiview.removeFromSuperview()
            }
        }
    }
    
    func addNightView(isDay : Bool) {
        removeNightView()
        if isDay {
            return
        }
        DispatchQueue.main.async {
            let share = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let uiview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (share?.bounds.width)!, height: (share?.bounds.height)!))
            uiview.tag = 888
            uiview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.view?.insertSubview(uiview, at: 1)
            
        }
    }
    
    func removeNightView() {
        DispatchQueue.main.async {
            if let uiview = self.view.subviews.filter(
                { $0.tag == 888}).first {
                uiview.removeFromSuperview()
            }
        }
    }
}


extension UISlider {
    func addGradientTrack() {
        superview?.layoutIfNeeded()
        setMaximumTrackImage(imageForColors(colors: [Contants.sliderMaxStartColor.cgColor, Contants.sliderMaxEndColor.cgColor], offset: 4.0), for: .normal)
        setMinimumTrackImage(imageForColors(colors: [Contants.sliderMinStartColor.cgColor, Contants.sliderMinEndColor.cgColor]), for: .normal)
        let thumbImage = UIImage.init(named: "sun")?.withRenderingMode(.alwaysTemplate)
        setThumbImage(thumbImage, for: .normal)
        setThumbImage(thumbImage, for: .highlighted)
    }
    
    private func imageForColors(colors: [CGColor], offset: CGFloat = 0.0) -> UIImage? {
        let layer = CAGradientLayer()
        layer.cornerRadius = 2.5
        layer.frame = CGRect(x: 0, y: 0, width: bounds.width - offset, height: 5.0)
        layer.colors = colors
        layer.endPoint = CGPoint(x: 1.0, y:  1.0)
        layer.startPoint = CGPoint(x: 0.0, y:  1.0)
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let layerImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return layerImage?.resizableImage(withCapInsets: .zero)
    }
}


extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont.init(name: "SairaExtraCondensed-Regular", size: 16.0)!, color: UIColor = Contants.scNormalTextColor) {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.init(name: "SairaExtraCondensed-Regular", size: 16.0)!, color: UIColor = Contants.scSelectedTextColor) {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}



