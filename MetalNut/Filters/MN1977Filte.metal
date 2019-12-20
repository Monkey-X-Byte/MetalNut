//
//  MN1997Filte.metal
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/10.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void MN1977Kernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::read> inputTexture [[texture(1)]],
                        texture2d<half, access::sample> map [[texture(2)]],
                        texture2d<half, access::sample> screen [[texture(3)]],
                        constant float *intensity [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    half4 base = inputTexture.read(gid);
    const half4 baseCopy = base;
    float2 lookup;
    
    lookup.y = .5;
    
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    lookup.x = base.r;
    base.r = screen.sample(s, lookup).r;
    base.r = map.sample(s, lookup).r;
    
    lookup.x = base.g;
    base.g = screen.sample(s, lookup).g;
    base.g = map.sample(s, lookup).g;
    
    lookup.x = base.b;
    base.b = screen.sample(s, lookup).b;
    base.b = map.sample(s, lookup).b;
    
    half4 outColor(mix(baseCopy, base, half(*intensity)));
    
    outputTexture.write(outColor, gid);
    
}
