#include <common>
uniform float uTime;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float vnoise(vec2 uv) {
  vec2 i = floor(uv);
  vec2 f = fract(uv);
  f = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
             mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

float scanlines(vec2 uv) {
  float fine = 0.5 + 0.5 * sin(uv.y * 6.2831853 * 220.0);
  float coarse = 0.5 + 0.5 * sin(uv.y * 6.2831853 * 22.0 - uTime * 6.0);
  return 0.82 + fine * 0.16 + coarse * 0.02;
}

vec3 phosphorMask(vec2 uv) {
  float s = sin(uv.x * 6.2831853 * 160.0);
  return vec3(1.0 + s * 0.22, 1.0 - abs(s) * 0.12, 1.0 + s * 0.10);
}

vec2 tubeCurve(vec2 uv) {
  vec2 c = uv - 0.5;
  return c * (1.0 + dot(c, c) * 0.6) + 0.5;
}
