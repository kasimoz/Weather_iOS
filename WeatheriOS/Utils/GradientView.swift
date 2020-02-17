//
//  GradientView.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 28.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = Contants.clearSkyStartColor { didSet { updateColors() }}
    @IBInspectable var centerColor:     UIColor = Contants.clearSkyCenterColor { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = Contants.clearSkyEndColor { didSet { updateColors() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func setGradient(type : DescriptionType){
        switch type {
        case .clearSky:
            startColor = Contants.clearSkyStartColor
            centerColor = Contants.clearSkyCenterColor
            endColor = Contants.clearSkyEndColor
            break
        case .fewClouds:
            startColor = Contants.fewCloudsStartColor
            centerColor = Contants.fewCloudsCenterColor
            endColor = Contants.fewCloudsEndColor
            break
        case .scatteredClouds:
            startColor = Contants.scatteredCloudsStartColor
            centerColor = Contants.scatteredCloudsCenterColor
            endColor = Contants.scatteredCloudsEndColor
            break
        case .brokenClouds:
            startColor = Contants.brokenCloudsStartColor
            centerColor = Contants.brokenCloudsCenterColor
            endColor = Contants.brokenCloudsEndColor
            break
        case .showerRain:
            startColor = Contants.showerRainStartColor
            centerColor = Contants.showerRainCenterColor
            endColor = Contants.showerRainEndColor
            break
        case .rain:
            startColor = Contants.rainStartColor
            centerColor = Contants.rainCenterColor
            endColor = Contants.rainEndColor
            break
        case .thunderstorm:
            startColor = Contants.thunderstormStartColor
            centerColor = Contants.thunderstormCenterColor
            endColor = Contants.thunderstormEndColor
            break
        case .snow:
            startColor = Contants.snowStartColor
            centerColor = Contants.snowCenterColor
            endColor = Contants.snowEndColor
            break
        case .mist:
            startColor = Contants.mistStartColor
            centerColor = Contants.mistCenterColor
            endColor = Contants.mistEndColor
            break
        }
    }
    
    func updatePoints() {
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint   = .init(x: 0.5, y: 1)
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, centerColor.cgColor,endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateColors()
    }
}



