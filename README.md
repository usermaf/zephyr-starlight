![Screenshot](assets/2026-01-01_01.25.04.png)

<font size="6"><h1 align = "center">⭐ zephyr-starlight</h1></font>
<font size="3"><p align = "center">An experimental path traced shaderpack for Minecraft</p></font>

# About

Unlike (almost) all other path traced shaders for Minecraft, this one uses a completely different approach to voxelization, allowing it to voxelize block entities and (some) entities. This comes at a  performance cost compared to regular voxelization. The performance is very scene dependant, so it can be hard to predict how the pack performs. The shaderpack has been developed & tested on an RTX 4060 at 1440p, which gives an average of 50-60 FPS. Currently the best way to know how the pack performs is to just try it and see.

## 📃 Features

* Path traced diffuse, reflections and sun shadows
* Temporal Anti-Aliasing
* Normal & specular mapping support
* Basic sky rendering
* Sparse irradiance cache for diffuse multi-bounce approximation
* Spatiotemporal denoising
* Optional TAAU (TAA Upscaling)
* Post-processing: auto exposure & chromatic aberration

## 💡 Acknowledgements

* [lucysir](https://github.com/kadir014) - Blue noise sampling for path tracing
* [jbritain](https://github.com/jbritain) - Blue noise texture (https://discordapp.com/channels/237199950235041794/525510804494221312/1416364500591837216)
* [agentclone8](https://github.com/agentclone8) - BRDF Function
* [Player2950](https://github.com/ArslanShakirov) - Playtesting

## 🔧 Compatibility

* Minecraft - version 1.21 and above
* Iris - version 1.8.0 and above
* Optifine - not supported (and not planned)
* Distant Horizons/Voxy - not supported (but planned)
* Zephyr Starlight is also one of the very few shaders to fully support the OrthoCamera mod (although it's still broken in a few cases), which can be used to create some really cool screenshots.

## 📋 TODO / Known Issues

* TAAU looks *very* bad currently. I don't recommend using it unless you really need FPS.
* Rain particles are not rendered.
* Reflections (especially mirror-like ones) show a lot of noise and flickering. Increasing IRC Update Interval and reflection samples in path tracing settings can improve it.
* The shaderpack takes very long to load on first use, but it should be faster on subsequent loads.
* In some cases, parts of the terrain will fail to voxelize. Increasing Triangle and Voxel Array Size usually fixes it.
* TAA produces a lot of ghosting on smooth reflections in movement. It might be possible to improve on this by using a reflection virtual depth buffer for TAA reprojection.