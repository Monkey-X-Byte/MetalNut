//
//  MadeCIFilter5.swift
//  MetalNut
//
//  Created by 김지수 on 2019/12/16.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import CoreImage

class MadeCIFilter5: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    func displayName() -> String
    {
        return "BL1"
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
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls?.setValue(inputImage, forKey: kCIInputImageKey)
        colorControls?.setValue(CGFloat(1.231611847877502), forKey: "inputSaturation")
        colorControls?.setValue(CGFloat(1.180164217948914), forKey: "inputContrast")
        colorControls?.setValue(CGFloat(0.06572769582271576), forKey: "inputBrightness")
        
        let gammaAdjust = CIFilter(name: "CIGammaAdjust")
        gammaAdjust?.setValue(colorControls?.outputImage, forKey: kCIInputImageKey)
        gammaAdjust?.setValue(CGFloat(0.8456572294235229), forKey: "inputPower")
        
        let highlightShadowAdjust = CIFilter(name: "CIHighlightShadowAdjust")
        highlightShadowAdjust?.setValue(gammaAdjust?.outputImage, forKey: kCIInputImageKey)
        highlightShadowAdjust?.setValue(1, forKey: "inputHighlightAmount")
        highlightShadowAdjust?.setValue(CGFloat(1.682315826416016), forKey: "inputRadius")
        highlightShadowAdjust?.setValue(CGFloat(-0.1345853805541992), forKey: "inputShadowAmount")
        
        let temperatureAndTint = CIFilter(name: "CITemperatureAndTint")
        temperatureAndTint?.setValue(highlightShadowAdjust?.outputImage, forKey: kCIInputImageKey)
        temperatureAndTint?.setValue(CIVector(x: 10185.7724609375, y: 0), forKey: "inputTargetNeutral")
        temperatureAndTint?.setValue(CIVector(x: 7143.861328125, y: 0), forKey: "inputNeutral")
        
        let exposureAdjust = CIFilter(name: "CIExposureAdjust")
        exposureAdjust?.setValue(temperatureAndTint?.outputImage, forKey: kCIInputImageKey)
        exposureAdjust?.setValue(CGFloat(-0.4694835543632507), forKey: "inputEV")
        
        
        return exposureAdjust?.outputImage!
    }
}
