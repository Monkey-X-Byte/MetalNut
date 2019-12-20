//
//  CustomCIFilter.swift
//  MetalNut
//
//  Created by 김지수 on 2019/12/17.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import CoreImage
import MetalKit

public class CustomCIFilter: BaseFilter {
    public var intensity: Float

    let filter: CIFilter = MadeCIFilter()

    lazy var context: CIContext =
    {
        CIContext(mtlDevice: MetalDevice.sharedDevice)
    }()
    
    public init(intensity: Float = 1) {
        self.intensity = intensity
        
        super.init(kernelFunctionName: "")
    }
    
    public override func newTextureAvailable(_ texture: Texture, from source: ImageSource) {
       
        guard let ciImage = CIImage(mtlTexture: texture.metalTexture, options: nil) else {
            return
        }

        if filter.inputKeys.contains("inputImage") == true{
            filter.setValue(ciImage, forKey: kCIInputImageKey)
        }

        if let outputImage = filter.outputImage{
            let commandBuffer = MetalDevice.shared.commandQueue.makeCommandBuffer()
            
            context.render(outputImage,
                           to: texture.metalTexture,
                           commandBuffer: commandBuffer,
                           bounds: outputImage.extent,
                           colorSpace: MetalDevice.shared.colorSpace)

            let output = Texture(mtlTexture: texture.metalTexture, type: texture.type)
            for consumer in consumers { consumer.newTextureAvailable(output, from: self)}
        }
        
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
    }
    
    public func outputTexture(from image: CGImage) -> MTLTexture {
            
       let loader = MTKTextureLoader(device: MetalDevice.sharedDevice)
       do {
           let textureOut = try loader.newTexture(cgImage: image, options: [MTKTextureLoader.Option.SRGB : false])
           let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: textureOut.pixelFormat, width: textureOut.width, height: textureOut.height, mipmapped: false)
           let outTexture = MetalDevice.sharedDevice.makeTexture(descriptor: textureDescriptor)
           return textureOut
       }
       catch {
           fatalError("Can't load texture")
       }
   }
}
