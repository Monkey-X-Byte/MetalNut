//
//  AshbyFilter.swift
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/10.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import Metal

public class AshbyFilter: BaseFilter {
    public var intensity: Float
    
    public init(intensity: Float = 1) {
        self.intensity = intensity
        super.init(kernelFunctionName: "ashbyKernel", samplers: ["levels": "classy_look_levels2.png",
        "tonemap": "classy_look_tonemap1.png"])
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
    }
}
