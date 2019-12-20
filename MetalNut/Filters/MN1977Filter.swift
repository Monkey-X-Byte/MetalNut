//
//  MN1997Filter.swift
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/10.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import Metal

public class MN1977Filter: BaseFilter {
    public var intensity: Float
    
    public init(intensity: Float = 1) {
        self.intensity = intensity
        super.init(kernelFunctionName: "MN1977Kernel", samplers: ["map": "1977map.png",
        "screen": "screen30.png"])
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
    }
}
