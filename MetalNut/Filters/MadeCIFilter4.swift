//
//  MadeCIFilter4.swift
//  MetalNut
//
//  Created by 김지수 on 2019/12/16.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import CoreImage

class MadeCIFilter4: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    func displayName() -> String
    {
        return "Face4"
    }
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: displayName()
        ]
    }
    
    override var outputImage: CIImage! {
        
        guard let inputImage = self.inputImage else {
            return nil
        }
        
        let highlightShadowAdjust = CIFilter(name: "CIHighlightShadowAdjust")
        highlightShadowAdjust?.setValue(inputImage, forKey: kCIInputImageKey)
        highlightShadowAdjust?.setValue(CGFloat(0.5187793374061584), forKey: "inputHighlightAmount")
        highlightShadowAdjust?.setValue(CGFloat(3.638497591018677), forKey: "inputRadius")
        highlightShadowAdjust?.setValue(CGFloat(0.0594678707420826), forKey: "inputShadowAmount")
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls?.setValue(highlightShadowAdjust?.outputImage, forKey: kCIInputImageKey)
        colorControls?.setValue(CGFloat(0.9154929518699646), forKey: "inputSaturation")
        colorControls?.setValue(CGFloat(0.9982394576072693), forKey: "inputContrast")
        colorControls?.setValue(CGFloat(-0.02816901355981828), forKey: "inputBrightness")
        
        let toneCurve = CIFilter(name: "CIToneCurve")
        toneCurve?.setValue(colorControls?.outputImage, forKey: kCIInputImageKey)
        toneCurve?.setValue(CIVector(x: 0.0723938, y: 0.0802708), forKey: "inputPoint0")
        toneCurve?.setValue(CIVector(x: 0.203668, y: 0.25), forKey: "inputPoint1")
        toneCurve?.setValue(CIVector(x: 0.464286, y: 0.509671), forKey: "inputPoint2")
        toneCurve?.setValue(CIVector(x: 0.722973, y: 0.766925), forKey: "inputPoint3")
        toneCurve?.setValue(CIVector(x: 0.929537, y: 1), forKey: "inputPoint4")
        
        let temperatureAndTint = CIFilter(name: "CITemperatureAndTint")
        temperatureAndTint?.setValue(toneCurve?.outputImage, forKey: kCIInputImageKey)
        temperatureAndTint?.setValue(CIVector(x: 6311.775390625, y: 0), forKey: "inputNeutral")
        temperatureAndTint?.setValue(CIVector(x: 5759.65234375, y: 0), forKey: "inputTargetNeutral")
        
        
        let colorMatrix = CIFilter(name: "CIColorMatrix")
        colorMatrix?.setValue(temperatureAndTint?.outputImage, forKey: kCIInputImageKey)
        colorMatrix?.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")
        colorMatrix?.setValue(CIVector(x: 0.0876776, y: 0.149289, z: 1, w: 0), forKey: "inputBVector")
        colorMatrix?.setValue(CIVector(x: 0.869668, y: 0.187204, z: 0, w: 0), forKey: "inputRVector")
        colorMatrix?.setValue(CIVector(x: 0, y: 0.902844, z: 0.159524, w: 0), forKey: "inputGVector")
        colorMatrix?.setValue(CIVector(x: 0, y: 0, z: 0, w: 0.93128), forKey: "inputAVector")
        
        
        return colorMatrix?.outputImage!
    }
}
