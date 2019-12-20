//
//  AshbyFilter.metal
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/10.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void ashbyKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::read> inputTexture [[texture(1)]],
                        texture2d<half, access::sample> levels [[texture(2)]],
                        texture2d<half, access::sample> tonemap [[texture(3)]],
                        constant float *intensity [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    half4 base = inputTexture.read(gid);
    const half4 baseCopy = base;
    
    constexpr sampler s;
    
    half luma = dot(half3(0.2126, 0.7152, 0.0722), base.rgb);
    half adjustCoeff = tonemap.sample(s, float2(luma, 0.5)).r;
    half diff = 1.0 + adjustCoeff - luma;
    base.rgb = mix(base.rgb, base.rgb * diff, 0.5);
    
    // levels 2
    base.r = levels.sample(s, float2(base.r, 0.5)).r;
    base.g = levels.sample(s, float2(base.g, 0.5)).g;
    base.b = levels.sample(s, float2(base.b, 0.5)).b;
    
    half3 lumaFinal = half3(dot(half3(0.2126, 0.7152, 0.0722), base.rgb));
    base.rgb = mix(base.rgb, lumaFinal, -0.1);
    const half4 outColor(mix(baseCopy, base, half(*intensity)));
    outputTexture.write(outColor, gid);
    
}
