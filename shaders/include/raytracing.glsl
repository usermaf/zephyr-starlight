#ifndef INCLUDE_RAYTRACING
    #define INCLUDE_RAYTRACING

    #include "/include/octree.glsl"

    RayHitInfo TraceRay (in Ray ray, float maxDist, bool useBackFaceCulling, bool alphaBlend)
    {   
        #include "/include/rtfunc.glsl"
    }

    vec4 TraceShadowRay (in Ray ray, float maxDist, bool useBackFaceCulling)
    {   
        #define RT_SHADOW
        #include "/include/rtfunc.glsl"
    }

#endif