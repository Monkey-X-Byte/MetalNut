//
//  SaturationFilter.metal
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/20.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

#include <metal_stdlib>
#include "MetalNutShaderTypes.h"
using namespace metal;

kernel void saturationKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                             texture2d<half, access::read> inputTexture [[texture(1)]],
                             constant float *saturation [[buffer(0)]],
                             uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half luminance = dot(inColor.rgb, kLuminanceWeighting);
    const half4 outColor(mix(half3(luminance), inColor.rgb, half(*saturation)), inColor.a);
    outputTexture.write(outColor, gid);
}


