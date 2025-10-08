//
//  RippleShader.metal
//  RippleModifier
//
//  Created by Nozhan A. on 9/28/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float ring(float2 dir, float radius, float thickness, float intensity) {
    float d = length(dir)-radius;
    d *= 1. - smoothstep(0.,thickness,abs(d)); // mask center ripple
    d *= smoothstep(0.,thickness,radius); // intro
    d *= 1. - smoothstep(.5,1.,radius); // outro
    return d*intensity;
}

float3 chromaticAberratedRing(float aberration, float2 dir, float radius, float thickness, float intensity) {
    float d = length(dir)-radius;
    d *= 1. - smoothstep(0.,thickness,d);
    float rD = ring(dir,radius+aberration*d,thickness,intensity);
    float gD = ring(dir,radius,thickness,intensity);
    float bD = ring(dir,radius-aberration*d,thickness,intensity);
    return float3(rD, gD, bD);
}

[[stitchable]] half4 ripple(float2 position,
                             SwiftUI::Layer layer,
                             float2 center,
                             float2 size,
                             float time,
                             float speed,
                             float aberration,
                             float thickness,
                             float intensity) {
    float2 uv = position/size;
    
    float t = smoothstep(0., 1., time) * speed;
    float radius = t*1.1;
    
    float2 dir = uv-center;
    float aspect = size.x/size.y;
    dir.x *= aspect;
    float3 res = chromaticAberratedRing(aberration,dir,radius,thickness,intensity);
    dir = normalize(dir);
    dir *= size/2;
    float r = layer.sample(uv*size+dir*res.r).r;
    float g = layer.sample(uv*size+dir*res.g).g;
    float b = layer.sample(uv*size+dir*res.b).b;
    float shading = res.g*4.;
    float a = layer.sample(uv*size+dir*res.g).a;
    return half4(r,g,b,a)+shading;
}
