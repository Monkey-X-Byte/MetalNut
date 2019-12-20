//
//  AdenFilter.metal
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/10.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void adenKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::read> inputTexture [[texture(1)]],
                        texture2d<half, access::sample> lookup [[texture(2)]],
                        constant float *intensity [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    half4 base = inputTexture.read(gid);
    half3 texCoord = base.rgb;
    float size = 33;
    
    constexpr sampler s;
    
    float sliceSize = 1.0 / size;
    float slicePixelSize = sliceSize / size;
    float sliceInnerSize = slicePixelSize * (size - 1.0);
    float xOffset = 0.5 * sliceSize + texCoord.x * (1.0 - sliceSize);
    
    float yOffset = 0.5 * slicePixelSize + texCoord.y * sliceInnerSize;
    float zOffset = texCoord.z * (size - 1.0);
    float zSlice0 = floor(zOffset);
    float zSlice1 = zSlice0 + 1.0;
    float s0 = yOffset + (zSlice0 * sliceSize);
    float s1 = yOffset + (zSlice1 * sliceSize);
    half4 slice0Color = lookup.sample(s, float2(xOffset, s0));
    half4 slice1Color = lookup.sample(s, float2(xOffset, s1));
    const half4 newColor = mix(slice0Color, slice1Color, zOffset - zSlice0);
    
    const half4 outColor(mix(base, newColor, half(*intensity)));
    
    outputTexture.write(outColor, gid);
    
}
