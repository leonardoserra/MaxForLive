# Changelog

All notable changes to this project are documented in this file.

## 0.6.1 - 2026-10-24

- Changed
  - The repo has a README that lists the devices, each with a screenshot and a link to its docs, and explains how to
    use a device in Live and how to build one.
  - Daruma Guitar Rack's README shows a screenshot of the device.
  - The device is built with `build.sh` on every machine: bash or zsh on macOS/Linux, Git Bash on Windows.
    `DarumaGuitarRack.amxd` is rebuilt with it and works the same in Live; the file is 47 KB instead of 281 KB.
- Removed
  - `build.ps1`, replaced by `build.sh`.
  - `DarumaGuitarRack.maxpat` from the repo. The build still writes it, but git ignores it.

## 0.6.0 - 2026-10-24

- Changed
  - EQ, SHAPE, COMP, CHORUS and SPRING each have an on/off toggle next to their name; AMP is always on. Switching
    fades over ~30 ms, so it does not click.
  - COMP has a Mix dial (dry/wet, default 100%) for parallel compression.
  - Device is 1170 px wide; CHORUS and SPRING moved right to make room.

## 0.5.0 - 2026-10-24

- Changed
  - New Clean mode, first in the Mode switch (Clean / OD / Dist / Fuzz / Metal; default stays OD). Drive works as a
    clean-amp gain: louder and clean at low settings, gentle break-up when pushed past 50%.

## 0.4.0 - 2026-10-24

- Changed
  - Spring reverb has a Size dial: 0 is a pure spring, turning it up goes to room and hall while keeping the spring
    chirp and Tone. The reverb now runs 4 cross-mixed loops instead of 2, so tails are denser.
  - New glue compressor (COMP section) after SHAPE: Thresh (-40..0 dB), Ratio 2:1 / 4:1 / 10:1 with a 6 dB soft knee,
    Attack (0.1-30 ms), Release (50-1200 ms), Makeup (0-20 dB).
  - Device is 1120 px wide.

## 0.3.0 - 2026-10-24

- Changed
  - Drive goes up to 150% in every mode; 0-100% sounds as before, above that adds up to +26 dB more gain.
  - Chorus is stronger: Depth goes up to 200% (default 100%) and Mix x Depth push the voices up to 3:1 over the dry
    signal, with level compensation.
  - Spring Decay is set in seconds (0.3-10 s, default 2.5 s) as the tail's fall to -60 dB. Before, the tail topped out
    around 1 s.

## 0.2.0 - 2026-10-24

- Changed
  - Device renamed DarumaDistorsion → Daruma Guitar Rack; file is `DarumaGuitarRack.amxd` in `DarumaGuitarRack/`.
  - New static chorus after the distortion, with no LFO: three fixed delay voices (left, right, centre). Depth, Spread
    (0.5-12 ms between voices) and Mix.
  - New spring reverb at the end of the chain: Decay, Tone and Mix. Output is stereo.
  - Device is 850 px wide.
- Removed
  - `DarumaDistorsion.amxd` and `DarumaDistorsion.maxpat`, replaced by the `DarumaGuitarRack` files.

## 0.1.1 - 2026-10-24

- Changed
  - Device title is Ferrari red (Rosso Corsa, `#D40000`).
- Fix
  - Device no longer goes silent when switched on: gen~ compiles again. It failed with "use of undeclared identifier
    'fs'" because gen~ moves sample-rate-only expressions out of the per-sample loop.

## 0.1.0 - 2026-10-24

- Changed
  - First version of DarumaDistorsion, a Max for Live audio effect for electric guitar (Live 11 / Max 8), with its
    DSP in gen~.
  - Modes OD / Dist / Fuzz / Metal, with Drive, Tone, Volume and Mix (dry/wet).
  - 3-band EQ: Bass (120 Hz shelf), Middle (800 Hz), Treble (3.2 kHz shelf), +/-12 dB.
  - SHAPE section: Tight (20-400 Hz high-pass before the drive) and a noise Gate (fully left = off).
  - Cabinet simulation Off / 1x12 / 2x12 / 4x12, and oversampling 1x / 2x / 4x / 8x for the distortion (less
    aliasing fizz).
  - `build.ps1` rebuilds the `.amxd` and `.maxpat` from the `.genexpr` DSP source.
