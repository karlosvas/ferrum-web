#include <emissivemap_fragment>

vec2 crtUv = tubeCurve(vEmissiveMapUv);
float edgeMask =
    smoothstep(0.0, 0.08, crtUv.x) * smoothstep(1.0, 0.92, crtUv.x) *
    smoothstep(0.0, 0.08, crtUv.y) * smoothstep(1.0, 0.92, crtUv.y);
float vignette = 1.0 - dot(crtUv - 0.5, crtUv - 0.5) * 1.1;
float flicker = 0.95 + 0.05 * sin(uTime * 26.0);
float refreshBand =
    smoothstep(0.02, 0.0, abs(fract(crtUv.y + uTime * 0.22) - 0.5) - 0.47);
float staticNoise = (vnoise(crtUv * 220.0 + uTime * 140.0) - 0.5) * 0.16;
float interference = step(0.985, hash(vec2(floor(uTime * 7.0), 3.0))) * 0.35;

totalEmissiveRadiance *=
    flicker * scanlines(crtUv) * phosphorMask(crtUv) * edgeMask * vignette;
totalEmissiveRadiance += staticNoise + interference;
totalEmissiveRadiance += refreshBand * 0.06;
totalEmissiveRadiance *= vec3(0.2, 0.2, 0.2);

float lum = dot(totalEmissiveRadiance, vec3(0.299, 0.587, 0.114));
totalEmissiveRadiance += lum * vec3(0.04, 0.12, 0.08);
