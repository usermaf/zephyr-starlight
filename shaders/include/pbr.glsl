#ifndef INCLUDE_PBR
    #define INCLUDE_PBR

    void applySpecularMap (vec4 specularData, inout vec3 albedo, out vec3 f0, out float roughness, out float emission) 
    {
        roughness = pow(1.0 - specularData.r, 2.0);
        emission = EMISSION_BRIGHTNESS * (specularData.a < 254.5 / 255.0 ? specularData.a * 255.0 / 254.0 : 0.0);

        int reflectanceValue = int(specularData.g * 255.0 + 0.5);
        float metallic;

        if (reflectanceValue < 230) {
            f0 = mix(vec3(0.04), vec3(1.0), specularData.g);
            metallic = 0.0;
        } else {
            f0 = albedo;
            metallic = float(roughness <= REFLECTION_ROUGHNESS_THRESHOLD);
        }

        albedo *= (1.0 - metallic);
    }

    void applyIntegratedSpecular (inout vec3 albedo, inout vec4 specularData, vec2 localUv, uint blockId) {
        if (blockId < 4) {
            if (blockId < 2) {
                if (blockId < 1) {

                } else {
                    
                }
            } else {
                if (blockId < 3) {
                    specularData.a = dot(albedo, vec3(0.2, 0.5, 0.1)) * 180.0 / 255.0;
                } else {
                    albedo *= vec3(0.95, 0.8, 0.77);
                    specularData.a = smoothstep(0.3, 1.01, luminance(albedo.rgb));
                }
            }
        } else {
            if (blockId < 6) {
                if (blockId < 5) {
                    specularData.a = luminance(albedo.rgb) * 254.0 / 255.0;
                } else {
                    specularData.a = smoothstep(3.0, 10.0, floor((1.0 - localUv.y) * 16.0) + 0.5) + 0.006;

                    albedo = mix(albedo, vec3(1.0, 0.45, 0.18), specularData.a);
                }
            } else {
                if (blockId < 7) {
                    specularData.a = 130.0 / 255.0;
                } else {
                    
                }
            }
        }
    }

#endif