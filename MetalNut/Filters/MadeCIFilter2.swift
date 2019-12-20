//
//  MadeCIFilter2.swift
//  MetalNut
//
//  Created by 김지수 on 2019/12/16.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import CoreImage

class MadeCIFilter2: CIFilter {
    
    @objc dynamic var inputImage: CIImage?
    
    func displayName() -> String
    {
        return "Face2"
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
        colorControls?.setDefaults()
        
        let vibrance = CIFilter(name: "CIVibrance")
        vibrance?.setValue(colorControls?.outputImage, forKey: kCIInputImageKey)
        vibrance?.setDefaults()
        
        let hueAdjust = CIFilter(name: "CIHueAdjust")
        hueAdjust?.setValue(vibrance?.outputImage, forKey: kCIInputImageKey)
        hueAdjust?.setValue(CGFloat(0.1619718372821808), forKey: "inputAngle")
        
        return hueAdjust?.outputImage!
    }
}
