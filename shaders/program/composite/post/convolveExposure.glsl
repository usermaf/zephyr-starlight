#include "/include/uniforms.glsl"
#include "/include/config.glsl"
#include "/include/constants.glsl"
#include "/include/common.glsl"
#include "/include/pbr.glsl"
#include "/include/main.glsl"
#include "/include/textureSampling.glsl"
#include "/include/text.glsl"

layout (local_size_x = 128) in;
const ivec3 workGroups = ivec3(1, 1, 1);

shared float averageExposure[256];

void main ()
{
    for (int i = 0; i < 2; i++) {
        averageExposure[gl_LocalInvocationID.x * 2 + i] = clamp(luminance(texelFetch(colortex10, ivec2(screenSize * R2(256 * (frameCounter & 3) + 2 * gl_LocalInvocationID.x + i)), 0).rgb), 0.001, 0.05);
    }

    barrier();

    for (int i = 0; i < 8; i++) {
        uint index = ((2 * gl_LocalInvocationID.x) & ~((1 << (i + 1)) - 1)) + (1 << i) - 1;
        uint offset = 1 + (gl_LocalInvocationID.x & ((1 << i) - 1));

        averageExposure[index + offset] += averageExposure[index];

        barrier();
    }

    if (gl_LocalInvocationID.x == 0) renderState.globalLuminance = mix(renderState.globalLuminance, averageExposure[255] / 256.0, ADAPTATION_SPEED);
}