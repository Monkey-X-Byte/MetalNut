//
//  newLookupFilter.swift
//  MetalNut
//
//  Created by 김지수 on 2019/12/13.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import Metal

public class TestLookupFilter: BaseFilter {
    public var intensity: Float
    
    public init?(intensity: Float = 1, resourceIndex: Int) {
        self.intensity = intensity
        super.init(kernelFunctionName: "lookupKernel", samplers: ["lookup": "test_lookup\(resourceIndex).png"])
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
    }
}
