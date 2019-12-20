//
//  RotateFilter.swift
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/10.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import Metal

/// Rotates an image
public class RotateFilter: BaseFilter {
    /// Angle (degree) to rotate
    public var angle: Float {
        get { return _angle / Float.pi * 180 }
        set { _angle = newValue * Float.pi / 180 }
    }
    private var _angle: Float
    
    /// True to change image size to fit rotated image, false to keep image size
    public var fitSize: Bool
    
    public init(angle: Float, fitSize: Bool) {
        _angle = angle * Float.pi / 180
        self.fitSize = fitSize
        super.init(kernelFunctionName: "rotateKernel")
    }
    
    public override func outputTextureSize(withInputTextureSize inputSize: IntSize) -> IntSize {
        if fitSize {
            let width = Int(abs(sin(_angle) * Float(inputSize.height)) + abs(cos(_angle) * Float(inputSize.width)))
            let height = Int(abs(sin(_angle) * Float(inputSize.width)) + abs(cos(_angle) * Float(inputSize.height)))
            return IntSize(width: width, height: height)
        }
        return inputSize
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&_angle, length: MemoryLayout<Float>.size, index: 0)
    }
}
