#ifndef INCLUDE_IRC
    #define INCLUDE_IRC

    uint packOrigin (vec3 pos, vec3 normal) {
        uvec3 packedOrigin = uvec3(clamp(256.0 * ((normal * 0.02 + pos - floor(cameraPositionFract + pos + normal * 0.475) + cameraPositionFract + 0.5) * 0.5), 0.0, 255.0));
        uvec2 packedNormal = uvec2(14.0 * octEncode(normal) + 0.5);

        return (packedOrigin.x << 24u) | (packedOrigin.y << 16u) | (packedOrigin.z << 8u) | (packedNormal.x << 4u) | (packedNormal.y);
    }

    IRCResult queryIRC (vec3 pos, vec3 normal, uint rank)
    {   
        ivec3 voxelPos = cameraPositionInt + ivec3(floor(cameraPositionFract + pos + normal * 0.475));

        uint hashedPos = hashPosition(voxelPos);
        uint packedPos = packPosition(voxelPos);

        if (packedPos == 0u) return IRCResult(vec3(0.0), vec3(0.0));

        for (uint attempt = 0u; attempt < uint(IRC_PROBE_ATTEMPTS); attempt++)
        {   
            uint index = (hashedPos + attempt * attempt) % IRC_VOXEL_ARRAY_SIZE;

            if (irradianceCache.entries[index].packedPos == packedPos && irradianceCache.entries[index].radiance != IRC_INV_MARKER) {
                if (atomicMin(irradianceCache.entries[index].rank, rank + 1u) >= rank + 1u) {
                    if (atomicExchange(irradianceCache.entries[index].lastFrame, frameCounter) != frameCounter) {
                        irradianceCache.entries[index].traceOrigin = packOrigin(pos, normal);
                    }
                }

                return IRCResult(unpackHalf4x16(irradianceCache.entries[index].radiance).rgb, unpack3x10(irradianceCache.entries[index].direct));
            }
        }

        for (uint attempt = 0u; attempt < uint(IRC_PROBE_ATTEMPTS); attempt++)
        {   
            uint index = (hashedPos + attempt * attempt) % IRC_VOXEL_ARRAY_SIZE;

            if (atomicCompSwap(irradianceCache.entries[index].packedPos, 0u, packedPos) == 0u) {
                irradianceCache.entries[index].traceOrigin = packOrigin(pos, normal);
                irradianceCache.entries[index].rank = rank + 1u;
                irradianceCache.entries[index].lastFrame = frameCounter;
                break;
            }
        }

        return IRCResult(vec3(0.0), vec3(0.0));
    }

    IRCResult readIRC (vec3 pos, vec3 normal)
    {   
        ivec3 voxelPos = cameraPositionInt + ivec3(floor(pos + cameraPositionFract + normal * 0.475));

        uint packedPos = packPosition(voxelPos);
        uint hashedPos = hashPosition(voxelPos);

        for (uint attempt = 0u; attempt < uint(IRC_PROBE_ATTEMPTS); attempt++)
        {   
            uint index = (hashedPos + attempt * attempt) % IRC_VOXEL_ARRAY_SIZE;

            if (irradianceCache.entries[index].packedPos == packedPos && irradianceCache.entries[index].radiance != uvec2(0u)) {
                return IRCResult(unpackHalf4x16(irradianceCache.entries[index].radiance).rgb, unpack3x10(irradianceCache.entries[index].direct));
            }
        }

        return IRCResult(vec3(0.0), vec3(0.0));
    }

#endif