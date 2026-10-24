# Daruma Guitar Rack

Max for Live audio effect for electric guitar (Live 11 / Max 8), DSP written in gen~.

Chain: Gate -> Tight -> Distortion (4 modes, oversampled) -> Tone -> EQ -> Cab -> Glue Compressor -> Static Chorus -> Spring Reverb

## Install
Drag `DarumaGuitarRack.amxd` onto an audio track (or into your User Library).

## Controls
| Section | Control | What it does |
|---|---|---|
| Top | **Mode** | Clean (headroom, Drive = gain) / OD (warm tanh) / Dist (biased cubic, crunch) / Fuzz (starved hard clip) / Metal (two cascaded stages) |
| AMP | **Drive** | Gain into the clipper, 0-150% (range differs per mode) |
| | **Tone** | Post-drive low-pass, 1 kHz - 12 kHz |
| | **Volume** | Output level of the distorted signal (dB) |
| | **Mix** | Distortion dry/wet blend |
| EQ | **Bass / Middle / Treble** | Low shelf 120 Hz, peak 800 Hz, high shelf 3.2 kHz, +/-12 dB |
| SHAPE | **Tight** | High-pass before the drive, 20-400 Hz |
| | **Gate** | Noise gate threshold; fully left (-80 dB) = off |
| Bottom | **Cab** | Off / 1x12 open-back / 2x12 / 4x12 closed-back |
| | **OS** | Oversampling 1x/2x/4x/8x for the clipper |
| COMP | **Thresh** | Compressor threshold, -40..0 dB |
| | **Ratio** | 2:1 / 4:1 / 10:1 (6 dB soft knee) |
| | **Attack / Release** | 0.1-30 ms / 50-1200 ms |
| | **Makeup** | Output gain after compression, 0-20 dB |
| | **Mix** | Compressor dry/wet (parallel compression) |
| CHORUS | **Depth** | Level of the delayed voices, 0-200% |
| | **Spread** | Distance between the voices, 0.5-12 ms (no LFO, static) |
| | **Mix** | Chorus dry/wet (0 = off) |
| SPRING | **Decay** | Spring tail length (RT60), 0.3-10 s |
| | **Size** | 0 = pure spring, up = room -> hall (spring chirp kept) |
| | **Tone** | Spring brightness (damping) |
| | **Mix** | Reverb dry/wet (0 = off) |

Each section except AMP has an on/off toggle next to its name (EQ, SHAPE, COMP, CHORUS, SPRING).

Input is summed to mono; the chorus and spring spread the output to stereo.

## Editing
- DSP: `DarumaGuitarRack.genexpr` (same code as the codebox inside the device's gen~).
- UI/patch: `build.ps1` generates the patcher.
- Rebuild: `powershell -ExecutionPolicy Bypass -File build.ps1`
