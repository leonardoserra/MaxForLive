{
    "patcher":  {
                    "fileversion":  1,
                    "appversion":  {
                                       "major":  8,
                                       "minor":  5,
                                       "revision":  5,
                                       "architecture":  "x64",
                                       "modernui":  1
                                   },
                    "classnamespace":  "box",
                    "rect":  [
                                 80,
                                 80,
                                 1100,
                                 520
                             ],
                    "openrect":  [
                                     0,
                                     0,
                                     0,
                                     169
                                 ],
                    "bglocked":  0,
                    "openinpresentation":  1,
                    "default_fontsize":  10,
                    "default_fontface":  0,
                    "default_fontname":  "Arial Bold",
                    "gridonopen":  1,
                    "gridsize":  [
                                     8,
                                     8
                                 ],
                    "boxes":  [
                                  {
                                      "box":  {
                                                  "id":  "obj-plugin",
                                                  "maxclass":  "newobj",
                                                  "text":  "plugin~",
                                                  "numinlets":  2,
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "signal",
                                                                     "signal"
                                                                 ],
                                                  "patching_rect":  [
                                                                        30,
                                                                        20,
                                                                        60,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-thisdev",
                                                  "maxclass":  "newobj",
                                                  "text":  "live.thisdevice",
                                                  "numinlets":  1,
                                                  "numoutlets":  3,
                                                  "outlettype":  [
                                                                     "bang",
                                                                     "int",
                                                                     "int"
                                                                 ],
                                                  "patching_rect":  [
                                                                        200,
                                                                        20,
                                                                        90,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-gen",
                                                  "maxclass":  "newobj",
                                                  "text":  "gen~",
                                                  "numinlets":  2,
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "signal",
                                                                     "signal"
                                                                 ],
                                                  "patching_rect":  [
                                                                        30,
                                                                        330,
                                                                        900,
                                                                        22
                                                                    ],
                                                  "patcher":  {
                                                                  "fileversion":  1,
                                                                  "appversion":  {
                                                                                     "major":  8,
                                                                                     "minor":  5,
                                                                                     "revision":  5,
                                                                                     "architecture":  "x64",
                                                                                     "modernui":  1
                                                                                 },
                                                                  "classnamespace":  "dsp.gen",
                                                                  "rect":  [
                                                                               100,
                                                                               100,
                                                                               700,
                                                                               600
                                                                           ],
                                                                  "bglocked":  0,
                                                                  "openinpresentation":  0,
                                                                  "default_fontsize":  12,
                                                                  "default_fontface":  0,
                                                                  "default_fontname":  "Arial",
                                                                  "gridonopen":  1,
                                                                  "gridsize":  [
                                                                                   15,
                                                                                   15
                                                                               ],
                                                                  "boxes":  [
                                                                                {
                                                                                    "box":  {
                                                                                                "id":  "obj-1",
                                                                                                "maxclass":  "newobj",
                                                                                                "text":  "in 1",
                                                                                                "numinlets":  0,
                                                                                                "numoutlets":  1,
                                                                                                "outlettype":  [
                                                                                                                   ""
                                                                                                               ],
                                                                                                "patching_rect":  [
                                                                                                                      20,
                                                                                                                      20,
                                                                                                                      30,
                                                                                                                      22
                                                                                                                  ]
                                                                                            }
                                                                                },
                                                                                {
                                                                                    "box":  {
                                                                                                "id":  "obj-2",
                                                                                                "maxclass":  "newobj",
                                                                                                "text":  "in 2",
                                                                                                "numinlets":  0,
                                                                                                "numoutlets":  1,
                                                                                                "outlettype":  [
                                                                                                                   ""
                                                                                                               ],
                                                                                                "patching_rect":  [
                                                                                                                      400,
                                                                                                                      20,
                                                                                                                      30,
                                                                                                                      22
                                                                                                                  ]
                                                                                            }
                                                                                },
                                                                                {
                                                                                    "box":  {
                                                                                                "id":  "obj-3",
                                                                                                "maxclass":  "codebox",
                                                                                                "code":  "// Daruma Guitar Rack - gen~ DSP core\n// Chain: gate detect -> tight HP -> mode voicing -> oversampled clipper -> DC block\n//        -> tone LP -> 3-band EQ -> cab sim -> gate -> dry/wet -> volume\n//        -> glue compressor -> static chorus -> spring reverb\n// Modes: 0 Clean, 1 Overdrive, 2 Distortion, 3 Fuzz, 4 Metal\n// Cab:   0 Off, 1 1x12, 2 2x12, 3 4x12\n// OS:    0 1x, 1 2x, 2 4x, 3 8x\n\n// ---------- RBJ biquad coefficient helpers (return b0, b1, b2, a1, a2) ----------\ncf_lp(f, q, fs) {\n\tw = twopi * clamp(f, 10, fs * 0.49) / fs;\n\tcw = cos(w);\n\tal = sin(w) / (2 * q);\n\ta0 = 1 + al;\n\tb0 = (1 - cw) * 0.5 / a0;\n\treturn b0, 2 * b0, b0, -2 * cw / a0, (1 - al) / a0;\n}\n\ncf_hp(f, q, fs) {\n\tw = twopi * clamp(f, 10, fs * 0.49) / fs;\n\tcw = cos(w);\n\tal = sin(w) / (2 * q);\n\ta0 = 1 + al;\n\tb0 = (1 + cw) * 0.5 / a0;\n\treturn b0, -2 * b0, b0, -2 * cw / a0, (1 - al) / a0;\n}\n\ncf_pk(f, q, gdb, fs) {\n\tA = pow(10, gdb / 40);\n\tw = twopi * clamp(f, 10, fs * 0.49) / fs;\n\tcw = cos(w);\n\tal = sin(w) / (2 * q);\n\ta0 = 1 + al / A;\n\treturn (1 + al * A) / a0, -2 * cw / a0, (1 - al * A) / a0, -2 * cw / a0, (1 - al / A) / a0;\n}\n\ncf_ls(f, gdb, fs) {\n\tA = pow(10, gdb / 40);\n\tw = twopi * clamp(f, 10, fs * 0.49) / fs;\n\tcw = cos(w);\n\tsa = sqrt(A) * sin(w) * sqrt(2);\n\ta0 = (A + 1) + (A - 1) * cw + sa;\n\treturn A * ((A + 1) - (A - 1) * cw + sa) / a0, 2 * A * ((A - 1) - (A + 1) * cw) / a0, A * ((A + 1) - (A - 1) * cw - sa) / a0, -2 * ((A - 1) + (A + 1) * cw) / a0, ((A + 1) + (A - 1) * cw - sa) / a0;\n}\n\ncf_hs(f, gdb, fs) {\n\tA = pow(10, gdb / 40);\n\tw = twopi * clamp(f, 10, fs * 0.49) / fs;\n\tcw = cos(w);\n\tsa = sqrt(A) * sin(w) * sqrt(2);\n\ta0 = (A + 1) - (A - 1) * cw + sa;\n\treturn A * ((A + 1) + (A - 1) * cw + sa) / a0, -2 * A * ((A - 1) + (A + 1) * cw) / a0, A * ((A + 1) + (A - 1) * cw - sa) / a0, 2 * ((A - 1) - (A + 1) * cw) / a0, ((A + 1) - (A - 1) * cw - sa) / a0;\n}\n\n// transposed direct form II biquad tick: returns output and the two new states\nbq(x, b0, b1, b2, a1, a2, s1, s2) {\n\ty = b0 * x + s1;\n\tn1 = fixdenorm(b1 * x - a1 * y + s2);\n\tn2 = fixdenorm(b2 * x - a2 * y);\n\treturn y, n1, n2;\n}\n\n// ---------- parameters ----------\nParam mode(1, min=0, max=4);\nParam drive(50, min=0, max=150);\nParam tone(55, min=0, max=100);\nParam volume(-6, min=-36, max=12);\nParam bass(0, min=-12, max=12);\nParam middle(0, min=-12, max=12);\nParam treble(0, min=-12, max=12);\nParam drywet(100, min=0, max=100);\nParam tight(30, min=0, max=100);\nParam gatethr(-80, min=-80, max=-20);\nParam cabtype(3, min=0, max=3);\nParam oversamp(2, min=0, max=3);\nParam chodepth(100, min=0, max=200);\nParam chospread(4, min=0.5, max=12);\nParam chomix(0, min=0, max=100);\nParam spdecay(2500, min=300, max=10000);   // reverb decay time (RT60) in ms\nParam sptone(50, min=0, max=100);\nParam spmix(0, min=0, max=100);\nParam spsize(30, min=0, max=100);\nParam compthr(-10, min=-40, max=0);\nParam comprat(1, min=0, max=2);       // 0 = 2:1, 1 = 4:1, 2 = 10:1\nParam compatk(3, min=0.1, max=30);    // ms\nParam comprel(300, min=50, max=1200); // ms\nParam compmake(3, min=0, max=20);     // dB\nParam compmix(100, min=0, max=100);\n// section on/off switches (AMP is always on)\nParam eqon(1, min=0, max=1);\nParam shapeon(1, min=0, max=1);\nParam compon(1, min=0, max=1);\nParam choon(1, min=0, max=1);\nParam spon(1, min=0, max=1);\n\n// ---------- state ----------\nHistory s_drive(0.5); History s_tone(0.55); History s_vol(0.5); History s_mix(1);\nHistory s_tight(0.3); History s_bass(0); History s_mid(0); History s_treb(0);\nHistory h_genv(0); History h_gopen(1); History h_ggain(1);\nHistory h_t1(0); History h_t2(0);\nHistory h_p1(0); History h_p2(0);\nHistory h_xprev(0);\nHistory h_su1(0); History h_su2(0); History h_su3(0); History h_su4(0);\nHistory h_sd1(0); History h_sd2(0); History h_sd3(0); History h_sd4(0);\nHistory h_ms(0);\nHistory h_dcx(0); History h_dcy(0);\nHistory h_n1(0); History h_n2(0);\nHistory h_l1(0); History h_l2(0);\nHistory h_m1(0); History h_m2(0);\nHistory h_h1(0); History h_h2(0);\nHistory h_c11(0); History h_c12(0); History h_c21(0); History h_c22(0);\nHistory h_c31(0); History h_c32(0); History h_c41(0); History h_c42(0);\nHistory h_c51(0); History h_c52(0); History h_c61(0); History h_c62(0);\nHistory s_cdep(1); History s_cspr(4); History s_cmx(0);\nHistory s_sdec(2.5); History s_ston(0.5); History s_smx(0);\nHistory h_sp1(0); History h_sp2(0); History h_sp3(0); History h_sp4(0);\nHistory h_lp1(0); History h_lp2(0); History h_lp3(0); History h_lp4(0);\nHistory s_ssz(0.3); History h_cenv(0); History s_cmk(1.4125);\nHistory s_cpm(1); History s_eqs(1); History s_shp(1); History s_cps(1); History s_chs(1); History s_sps(1);\nDelay cdl(8192);\nDelay pd1(12000);\nDelay pd2(12000);\nDelay sdl1(40000);\nDelay sdl2(40000);\nDelay sdl3(40000);\nDelay sdl4(40000);\nData ap(64);\n\n\n// ---------- parameter smoothing ----------\nsk = 1 - exp(-1 / (0.03 * samplerate));\ndrv = s_drive + (drive * 0.01 - s_drive) * sk;  s_drive = drv;\nton = s_tone + (tone * 0.01 - s_tone) * sk;     s_tone = ton;\nvol = s_vol + (dbtoa(volume) - s_vol) * sk;     s_vol = vol;\nmx = s_mix + (drywet * 0.01 - s_mix) * sk;      s_mix = mx;\ntgt = s_tight + (tight * 0.01 - s_tight) * sk;  s_tight = tgt;\nbas = s_bass + (bass - s_bass) * sk;            s_bass = bas;\nmdl = s_mid + (middle - s_mid) * sk;            s_mid = mdl;\ntre = s_treb + (treble - s_treb) * sk;          s_treb = tre;\ncdep = s_cdep + (chodepth * 0.01 - s_cdep) * sk; s_cdep = cdep;\ncspr = s_cspr + (chospread - s_cspr) * sk;       s_cspr = cspr;\ncmx = s_cmx + (chomix * 0.01 - s_cmx) * sk;      s_cmx = cmx;\nsdec = s_sdec + (spdecay * 0.001 - s_sdec) * sk;  s_sdec = sdec;\nston = s_ston + (sptone * 0.01 - s_ston) * sk;   s_ston = ston;\nsmx = s_smx + (spmix * 0.01 - s_smx) * sk;       s_smx = smx;\ncpm = s_cpm + (compmix * 0.01 - s_cpm) * sk;     s_cpm = cpm;\neqs = s_eqs + (eqon - s_eqs) * sk;               s_eqs = eqs;\nshp = s_shp + (shapeon - s_shp) * sk;            s_shp = shp;\ncps = s_cps + (compon - s_cps) * sk;             s_cps = cps;\nchs = s_chs + (choon - s_chs) * sk;              s_chs = chs;\nsps = s_sps + (spon - s_sps) * sk;               s_sps = sps;\n\nm = floor(clamp(mode, 0, 4) + 0.5);\n\n// guitar is mono: sum the two channels\nx = (in1 + in2) * 0.5;\ndry = x;\n\n// ---------- noise gate detector (on the clean input) ----------\nax = abs(x);\nea = 1 - exp(-1 / (0.0005 * samplerate));\ner = 1 - exp(-1 / (0.03 * samplerate));\ngenv = h_genv + (ax - h_genv) * ((ax > h_genv) ? ea : er);\nh_genv = genv;\nthr = dbtoa(gatethr);\ngopen = h_gopen;\nif (gatethr <= -79.5) {\n\tgopen = 1;\n}\nelse if (genv > thr) {\n\tgopen = 1;\n}\nelse if (genv < thr * 0.5) {\n\tgopen = 0;\n}\nh_gopen = gopen;\nga = 1 - exp(-1 / (0.001 * samplerate));\ngr = 1 - exp(-1 / (0.08 * samplerate));\nggain = h_ggain + (gopen - h_ggain) * ((gopen > h_ggain) ? ga : gr);\nh_ggain = ggain;\n\n// ---------- tight: pre-drive high-pass 20..400 Hz ----------\nb0, b1, b2, a1, a2 = cf_hp(20 * pow(20, tgt), 0.707, samplerate);\ny, n1, n2 = bq(x, b0, b1, b2, a1, a2, h_t1, h_t2);\nh_t1 = n1; h_t2 = n2;\ny = x + (y - x) * shp;   // SHAPE off -> no tight filter\n\n// ---------- mode voicing + gain ----------\nvf = 720; vq = 0.8; vg = 6; gain = 1;\nif (m == 0) {\n\tvf = 2000; vq = 0.7; vg = 2; gain = dbtoa(6 + drv * 30);\n}\nelse if (m == 1) {\n\tvf = 720; vq = 0.8; vg = 6; gain = dbtoa(drv * 40);\n}\nelse if (m == 2) {\n\tvf = 1000; vq = 0.7; vg = 3; gain = dbtoa(6 + drv * 42);\n}\nelse if (m == 3) {\n\tvf = 450; vq = 0.5; vg = 2; gain = dbtoa(10 + drv * 46);\n}\nelse {\n\tvf = 1400; vq = 0.9; vg = 7; gain = dbtoa(14 + drv * 52);\n}\nb0, b1, b2, a1, a2 = cf_pk(vf, vq, vg, samplerate);\ny, n1, n2 = bq(y, b0, b1, b2, a1, a2, h_p1, h_p2);\nh_p1 = n1; h_p2 = n2;\n\n// ---------- oversampled clipper ----------\nosf = 1;\nif (oversamp > 2.5) {\n\tosf = 8;\n}\nelse if (oversamp > 1.5) {\n\tosf = 4;\n}\nelse if (oversamp > 0.5) {\n\tosf = 2;\n}\nofs = samplerate * osf;\n// 4th-order Butterworth anti-alias low-pass (two sections) at 0.45 * base rate\nab0, ab1, ab2, aa1, aa2 = cf_lp(samplerate * 0.45, 0.5412, ofs);\nbb0, bb1, bb2, ba1, ba2 = cf_lp(samplerate * 0.45, 1.3066, ofs);\nkms = 1 - exp(-twopi * 250 / ofs);\ng2 = sqrt(gain);\n\nsu1 = h_su1; su2 = h_su2; su3 = h_su3; su4 = h_su4;\nsd1 = h_sd1; sd2 = h_sd2; sd3 = h_sd3; sd4 = h_sd4;\nms = h_ms;\nxp = h_xprev;\nxi = 0; u = 0; c = 0; s1 = 0; z = 0; yo = 0;\n\nfor (i = 0; i < osf; i += 1) {\n\t// linear-interpolated upsample + anti-image filter\n\txi = xp + (y - xp) * ((i + 1) / osf);\n\tif (osf > 1) {\n\t\txi, su1, su2 = bq(xi, ab0, ab1, ab2, aa1, aa2, su1, su2);\n\t\txi, su3, su4 = bq(xi, bb0, bb1, bb2, ba1, ba2, su3, su4);\n\t}\n\n\tu = xi * gain;\n\tif (m == 0) {\n\t\t// clean: lots of headroom, Drive mostly raises level, breaks up gently when pushed\n\t\tz = tanh(u * 0.3) * 0.75;\n\t}\n\telse if (m == 1) {\n\t\t// overdrive: smooth, slightly asymmetric tanh\n\t\tz = (tanh(u + 0.1) - 0.0997) * 0.8;\n\t}\n\telse if (m == 2) {\n\t\t// distortion: biased cubic clipper, harder knee\n\t\tc = clamp(u * 0.7 + 0.15, -1, 1);\n\t\tz = (1.5 * (c - c * c * c / 3) - 0.2233) * 0.75;\n\t}\n\telse if (m == 3) {\n\t\t// fuzz: starved, asymmetric hard clip\n\t\tc = clamp(u + 0.25, -0.8, 1);\n\t\tz = tanh(2.5 * c) * 0.6;\n\t}\n\telse {\n\t\t// metal: two cascaded stages with an interstage high-pass\n\t\ts1 = tanh(xi * g2);\n\t\tms = ms + (s1 - ms) * kms;\n\t\tz = tanh((s1 - ms) * g2 * 1.5 + 0.05) * 0.6;\n\t}\n\n\t// anti-alias filter before decimation\n\tif (osf > 1) {\n\t\tz, sd1, sd2 = bq(z, ab0, ab1, ab2, aa1, aa2, sd1, sd2);\n\t\tz, sd3, sd4 = bq(z, bb0, bb1, bb2, ba1, ba2, sd3, sd4);\n\t}\n\tyo = z;\n}\n\nh_su1 = su1; h_su2 = su2; h_su3 = su3; h_su4 = su4;\nh_sd1 = sd1; h_sd2 = sd2; h_sd3 = sd3; h_sd4 = sd4;\nh_ms = fixdenorm(ms);\nh_xprev = y;\n\n// ---------- DC blocker (asymmetric clipping adds DC) ----------\ndcy = yo - h_dcx + 0.9995 * h_dcy;\nh_dcx = yo;\nh_dcy = fixdenorm(dcy);\nw = dcy;\n\n// ---------- tone: low-pass 1k..12k ----------\nb0, b1, b2, a1, a2 = cf_lp(1000 * pow(12, ton), 0.707, samplerate);\nw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_n1, h_n2);\nh_n1 = n1; h_n2 = n2;\n\n// ---------- 3-band EQ ----------\nweq = w;\nb0, b1, b2, a1, a2 = cf_ls(120, bas, samplerate);\nw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_l1, h_l2);\nh_l1 = n1; h_l2 = n2;\nb0, b1, b2, a1, a2 = cf_pk(800, 0.8, mdl, samplerate);\nw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_m1, h_m2);\nh_m1 = n1; h_m2 = n2;\nb0, b1, b2, a1, a2 = cf_hs(3200, tre, samplerate);\nw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_h1, h_h2);\nh_h1 = n1; h_h2 = n2;\nw = weq + (w - weq) * eqs;   // EQ off -> flat\n\n// ---------- cabinet simulation ----------\nct = floor(clamp(cabtype, 0, 3) + 0.5);\nif (ct > 0) {\n\t// default: 1x12 open-back combo (brighter, less thump)\n\tf1 = 75;   q1 = 0.8;\n\tf2 = 130;  q2 = 1.2; k2 = 2;\n\tf3 = 450;  q3 = 1.0; k3 = -2;\n\tf4 = 2500; q4 = 1.2; k4 = 4;\n\tf5 = 5800; q5 = 0.9;\n\tf6 = 7500; q6 = 0.6;\n\tif (ct == 2) {\n\t\t// 2x12: fuller lows, scooped low-mids\n\t\tf1 = 85;   q1 = 0.9;\n\t\tf2 = 110;  q2 = 1.4; k2 = 3;\n\t\tf3 = 500;  q3 = 0.9; k3 = -3.5;\n\t\tf4 = 2200; q4 = 1.1; k4 = 3.5;\n\t\tf5 = 5200; q5 = 0.85;\n\t\tf6 = 6800; q6 = 0.6;\n\t}\n\telse if (ct == 3) {\n\t\t// 4x12 closed-back: resonant thump, dark top\n\t\tf1 = 70;   q1 = 1.1;\n\t\tf2 = 100;  q2 = 1.5; k2 = 4.5;\n\t\tf3 = 400;  q3 = 0.8; k3 = -5;\n\t\tf4 = 1900; q4 = 1.0; k4 = 4;\n\t\tf5 = 4600; q5 = 0.9;\n\t\tf6 = 6000; q6 = 0.6;\n\t}\n\tb0, b1, b2, a1, a2 = cf_hp(f1, q1, samplerate);\n\tw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_c11, h_c12);\n\th_c11 = n1; h_c12 = n2;\n\tb0, b1, b2, a1, a2 = cf_pk(f2, q2, k2, samplerate);\n\tw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_c21, h_c22);\n\th_c21 = n1; h_c22 = n2;\n\tb0, b1, b2, a1, a2 = cf_pk(f3, q3, k3, samplerate);\n\tw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_c31, h_c32);\n\th_c31 = n1; h_c32 = n2;\n\tb0, b1, b2, a1, a2 = cf_pk(f4, q4, k4, samplerate);\n\tw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_c41, h_c42);\n\th_c41 = n1; h_c42 = n2;\n\tb0, b1, b2, a1, a2 = cf_lp(f5, q5, samplerate);\n\tw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_c51, h_c52);\n\th_c51 = n1; h_c52 = n2;\n\tb0, b1, b2, a1, a2 = cf_lp(f6, q6, samplerate);\n\tw, n1, n2 = bq(w, b0, b1, b2, a1, a2, h_c61, h_c62);\n\th_c61 = n1; h_c62 = n2;\n\tw = w * 1.4;\n}\n\n// ---------- gate, distortion mix ----------\nw = w * (1 + (ggain - 1) * shp) * vol;   // SHAPE off -> no gate\no = w * mx + dry * (1 - mx);\n\n// ---------- glue compressor: feed-forward, 6 dB soft knee, smoothing in dB ----------\ncrat = 4;\nif (comprat < 0.5) {\n\tcrat = 2;\n}\nelse if (comprat > 1.5) {\n\tcrat = 10;\n}\nov = atodb(max(abs(o), 0.000001)) - compthr;\ngrt = 0;\nif (ov >= 3) {\n\tgrt = ov * (1 - 1 / crat);\n}\nelse if (ov > -3) {\n\tgrt = (1 - 1 / crat) * (ov + 3) * (ov + 3) / 12;\n}\ncatk = 1 - exp(-1 / (compatk * 0.001 * samplerate));\ncrel = 1 - exp(-1 / (comprel * 0.001 * samplerate));\ncenv = h_cenv + (grt - h_cenv) * ((grt > h_cenv) ? catk : crel);\nh_cenv = fixdenorm(cenv);\ncmk = s_cmk + (dbtoa(compmake) - s_cmk) * sk;\ns_cmk = cmk;\noc = o * dbtoa(-cenv) * cmk;\no = o + (oc - o) * cpm * cps;   // comp dry/wet, then on/off\n\n// ---------- static chorus: fixed delay voices, no LFO ----------\n// voice 1 left, voice 2 right, voice 3 centre; Spread sets the spacing between them\nsms = samplerate * 0.001;\ncdl.write(o);\nd1 = cdl.read((7) * sms);\nd2 = cdl.read((7 + cspr) * sms);\nd3 = cdl.read((7 + 2 * cspr) * sms);\n// Mix and Depth together set how loud the voices are vs the dry signal (up to 3:1)\nck = cmx * cdep;\ncl = (o + ck * (d1 + 0.5 * d3)) / (1 + ck * 0.75);\ncr = (o + ck * (d2 + 0.5 * d3)) / (1 + ck * 0.75);\ncl = o + (cl - o) * chs;\ncr = o + (cr - o) * chs;\n\n// ---------- spring reverb: 4 dispersive loops, Hadamard mixed ----------\n// Size scales the loops and adds diffusion: spring -> room -> hall, keeping the spring chirp\nspin = (cl + cr) * 0.5;\nb0, b1, b2, a1, a2 = cf_hp(150, 0.707, samplerate);\nspin, n1, n2 = bq(spin, b0, b1, b2, a1, a2, h_sp1, h_sp2);\nh_sp1 = n1; h_sp2 = n2;\nb0, b1, b2, a1, a2 = cf_lp(5000, 0.707, samplerate);\nspin, n1, n2 = bq(spin, b0, b1, b2, a1, a2, h_sp3, h_sp4);\nh_sp3 = n1; h_sp4 = n2;\n\n// size is smoothed slowly so turning it does not warble\nssz = s_ssz + (spsize * 0.01 - s_ssz) * (1 - exp(-1 / (0.2 * samplerate)));\ns_ssz = ssz;\nscl = 1 + 2.5 * ssz;\ndif = 0.7 * ssz;\n\n// two Schroeder allpass diffusers (pure short pre-delay when Size = 0)\ntp = pd1.read(4.7 * scl * sms);\nwv = spin + dif * tp;\npd1.write(wv);\nspin = tp - dif * wv;\ntp = pd2.read(11.3 * scl * sms);\nwv = spin + dif * tp;\npd2.write(wv);\nspin = tp - dif * wv;\n\n// loop lengths (s) and feedback gain so each loop falls 60 dB in sdec seconds\nlen1 = 0.0337 * scl; len2 = 0.0413 * scl; len3 = 0.0479 * scl; len4 = 0.0551 * scl;\ng1 = min(pow(10, -3 * len1 / sdec), 0.995);\ng2l = min(pow(10, -3 * len2 / sdec), 0.995);\ng3 = min(pow(10, -3 * len3 / sdec), 0.995);\ng4 = min(pow(10, -3 * len4 / sdec), 0.995);\ndampk = 1 - exp(-twopi * 1500 * pow(5, ston) / samplerate);\napc = 0.6;\nst = 0; yy = 0;\n\nr1 = sdl1.read(len1 * samplerate);\nr2 = sdl2.read(len2 * samplerate);\nr3 = sdl3.read(len3 * samplerate);\nr4 = sdl4.read(len4 * samplerate);\n\n// spring dispersion: 12 first-order allpasses per loop\nfor (j = 0; j < 12; j += 1) {\n\tst = peek(ap, j);\n\tyy = apc * r1 + st;\n\tpoke(ap, fixdenorm(r1 - apc * yy), j);\n\tr1 = yy;\n\tst = peek(ap, j + 16);\n\tyy = apc * r2 + st;\n\tpoke(ap, fixdenorm(r2 - apc * yy), j + 16);\n\tr2 = yy;\n\tst = peek(ap, j + 32);\n\tyy = apc * r3 + st;\n\tpoke(ap, fixdenorm(r3 - apc * yy), j + 32);\n\tr3 = yy;\n\tst = peek(ap, j + 48);\n\tyy = apc * r4 + st;\n\tpoke(ap, fixdenorm(r4 - apc * yy), j + 48);\n\tr4 = yy;\n}\n\n// damping (Spring Tone)\nl1 = h_lp1 + (r1 - h_lp1) * dampk; h_lp1 = fixdenorm(l1);\nl2 = h_lp2 + (r2 - h_lp2) * dampk; h_lp2 = fixdenorm(l2);\nl3 = h_lp3 + (r3 - h_lp3) * dampk; h_lp3 = fixdenorm(l3);\nl4 = h_lp4 + (r4 - h_lp4) * dampk; h_lp4 = fixdenorm(l4);\n\n// Hadamard feedback mix (energy preserving)\nv1 = l1 * g1; v2 = l2 * g2l; v3 = l3 * g3; v4 = l4 * g4;\nsdl1.write(spin * 0.5 + 0.5 * (v1 + v2 + v3 + v4));\nsdl2.write(spin * 0.5 + 0.5 * (v1 - v2 + v3 - v4));\nsdl3.write(spin * 0.5 + 0.5 * (v1 + v2 - v3 - v4));\nsdl4.write(spin * 0.5 + 0.5 * (v1 - v2 - v3 + v4));\n\nrevl = (l1 + l3) * 1.2;\nrevr = (l2 + l4) * 1.2;\n\nsmxe = smx * sps;   // SPRING off -> dry\nout1 = cl * (1 - smxe) + revl * smxe;\nout2 = cr * (1 - smxe) + revr * smxe;\n",
                                                                                                "fontface":  0,
                                                                                                "fontname":  "<Monospaced>",
                                                                                                "fontsize":  12,
                                                                                                "numinlets":  2,
                                                                                                "numoutlets":  2,
                                                                                                "outlettype":  [
                                                                                                                   "",
                                                                                                                   ""
                                                                                                               ],
                                                                                                "patching_rect":  [
                                                                                                                      20,
                                                                                                                      60,
                                                                                                                      600,
                                                                                                                      450
                                                                                                                  ]
                                                                                            }
                                                                                },
                                                                                {
                                                                                    "box":  {
                                                                                                "id":  "obj-4",
                                                                                                "maxclass":  "newobj",
                                                                                                "text":  "out 1",
                                                                                                "numinlets":  1,
                                                                                                "numoutlets":  0,
                                                                                                "patching_rect":  [
                                                                                                                      20,
                                                                                                                      530,
                                                                                                                      37,
                                                                                                                      22
                                                                                                                  ]
                                                                                            }
                                                                                },
                                                                                {
                                                                                    "box":  {
                                                                                                "id":  "obj-5",
                                                                                                "maxclass":  "newobj",
                                                                                                "text":  "out 2",
                                                                                                "numinlets":  1,
                                                                                                "numoutlets":  0,
                                                                                                "patching_rect":  [
                                                                                                                      580,
                                                                                                                      530,
                                                                                                                      37,
                                                                                                                      22
                                                                                                                  ]
                                                                                            }
                                                                                }
                                                                            ],
                                                                  "lines":  [
                                                                                {
                                                                                    "patchline":  {
                                                                                                      "source":  [
                                                                                                                     "obj-1",
                                                                                                                     0
                                                                                                                 ],
                                                                                                      "destination":  [
                                                                                                                          "obj-3",
                                                                                                                          0
                                                                                                                      ]
                                                                                                  }
                                                                                },
                                                                                {
                                                                                    "patchline":  {
                                                                                                      "source":  [
                                                                                                                     "obj-2",
                                                                                                                     0
                                                                                                                 ],
                                                                                                      "destination":  [
                                                                                                                          "obj-3",
                                                                                                                          1
                                                                                                                      ]
                                                                                                  }
                                                                                },
                                                                                {
                                                                                    "patchline":  {
                                                                                                      "source":  [
                                                                                                                     "obj-3",
                                                                                                                     0
                                                                                                                 ],
                                                                                                      "destination":  [
                                                                                                                          "obj-4",
                                                                                                                          0
                                                                                                                      ]
                                                                                                  }
                                                                                },
                                                                                {
                                                                                    "patchline":  {
                                                                                                      "source":  [
                                                                                                                     "obj-3",
                                                                                                                     1
                                                                                                                 ],
                                                                                                      "destination":  [
                                                                                                                          "obj-5",
                                                                                                                          0
                                                                                                                      ]
                                                                                                  }
                                                                                }
                                                                            ]
                                                              }
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-plugout",
                                                  "maxclass":  "newobj",
                                                  "text":  "plugout~",
                                                  "numinlets":  2,
                                                  "numoutlets":  0,
                                                  "patching_rect":  [
                                                                        30,
                                                                        400,
                                                                        60,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-mode",
                                                  "maxclass":  "live.tab",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Mode",
                                                  "patching_rect":  [
                                                                        30,
                                                                        150,
                                                                        275,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            230,
                                                                            8,
                                                                            275,
                                                                            18
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Mode",
                                                                                                     "parameter_shortname":  "Mode",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  4,
                                                                                                     "parameter_enum":  [
                                                                                                                            "Clean",
                                                                                                                            "OD",
                                                                                                                            "Dist",
                                                                                                                            "Fuzz",
                                                                                                                            "Metal"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  3,
                                                  "outlettype":  [
                                                                     "",
                                                                     "",
                                                                     "float"
                                                                 ],
                                                  "num_lines_patching":  1,
                                                  "num_lines_presentation":  1
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-mode-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend mode",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        30,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-drive",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Drive",
                                                  "patching_rect":  [
                                                                        105,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            8,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Drive",
                                                                                                     "parameter_shortname":  "Drive",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  150,
                                                                                                     "parameter_initial":  [
                                                                                                                               50
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-drive-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend drive",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        105,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-tone",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Tone",
                                                  "patching_rect":  [
                                                                        180,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            58,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Tone",
                                                                                                     "parameter_shortname":  "Tone",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               55
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-tone-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend tone",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        180,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-volume",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Volume",
                                                  "patching_rect":  [
                                                                        255,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            108,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Volume",
                                                                                                     "parameter_shortname":  "Volume",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  "-36",
                                                                                                     "parameter_mmax":  12,
                                                                                                     "parameter_initial":  [
                                                                                                                               "-6"
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-volume-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend volume",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        255,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-drywet",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Mix",
                                                  "patching_rect":  [
                                                                        330,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            158,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Mix",
                                                                                                     "parameter_shortname":  "Mix",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               100
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-drywet-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend drywet",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        330,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-bass",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Bass",
                                                  "patching_rect":  [
                                                                        405,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            230,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Bass",
                                                                                                     "parameter_shortname":  "Bass",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  "-12",
                                                                                                     "parameter_mmax":  12,
                                                                                                     "parameter_initial":  [
                                                                                                                               0
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-bass-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend bass",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        405,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-middle",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Middle",
                                                  "patching_rect":  [
                                                                        480,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            280,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Middle",
                                                                                                     "parameter_shortname":  "Middle",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  "-12",
                                                                                                     "parameter_mmax":  12,
                                                                                                     "parameter_initial":  [
                                                                                                                               0
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-middle-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend middle",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        480,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-treble",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Treble",
                                                  "patching_rect":  [
                                                                        555,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            330,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Treble",
                                                                                                     "parameter_shortname":  "Treble",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  "-12",
                                                                                                     "parameter_mmax":  12,
                                                                                                     "parameter_initial":  [
                                                                                                                               0
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-treble-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend treble",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        555,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-tight",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Tight",
                                                  "patching_rect":  [
                                                                        630,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            400,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Tight",
                                                                                                     "parameter_shortname":  "Tight",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               30
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-tight-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend tight",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        630,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-gatethr",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Gate",
                                                  "patching_rect":  [
                                                                        705,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            450,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Gate",
                                                                                                     "parameter_shortname":  "Gate",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  "-80",
                                                                                                     "parameter_mmax":  "-20",
                                                                                                     "parameter_initial":  [
                                                                                                                               "-80"
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-gatethr-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend gatethr",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        705,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-cabtype",
                                                  "maxclass":  "live.tab",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Cab",
                                                  "patching_rect":  [
                                                                        780,
                                                                        150,
                                                                        160,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            262,
                                                                            114,
                                                                            160,
                                                                            18
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Cab",
                                                                                                     "parameter_shortname":  "Cab",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  3,
                                                                                                     "parameter_enum":  [
                                                                                                                            "Off",
                                                                                                                            "1x12",
                                                                                                                            "2x12",
                                                                                                                            "4x12"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               3
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  3,
                                                  "outlettype":  [
                                                                     "",
                                                                     "",
                                                                     "float"
                                                                 ],
                                                  "num_lines_patching":  1,
                                                  "num_lines_presentation":  1
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-cabtype-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend cabtype",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        780,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-oversamp",
                                                  "maxclass":  "live.menu",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Oversampling",
                                                  "patching_rect":  [
                                                                        855,
                                                                        150,
                                                                        50,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            452,
                                                                            114,
                                                                            50,
                                                                            18
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Oversampling",
                                                                                                     "parameter_shortname":  "Oversampling",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  3,
                                                                                                     "parameter_enum":  [
                                                                                                                            "1x",
                                                                                                                            "2x",
                                                                                                                            "4x",
                                                                                                                            "8x"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               2
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  3,
                                                  "outlettype":  [
                                                                     "",
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-oversamp-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend oversamp",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        855,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compthr",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp Threshold",
                                                  "patching_rect":  [
                                                                        930,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            525,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp Threshold",
                                                                                                     "parameter_shortname":  "Thresh",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  "-40",
                                                                                                     "parameter_mmax":  0,
                                                                                                     "parameter_initial":  [
                                                                                                                               "-10"
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compthr-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend compthr",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        930,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compatk",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp Attack",
                                                  "patching_rect":  [
                                                                        1005,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            575,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp Attack",
                                                                                                     "parameter_shortname":  "Attack",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0.1,
                                                                                                     "parameter_mmax":  30,
                                                                                                     "parameter_initial":  [
                                                                                                                               3
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  2
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compatk-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend compatk",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1005,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-comprel",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp Release",
                                                  "patching_rect":  [
                                                                        1080,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            625,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp Release",
                                                                                                     "parameter_shortname":  "Release",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  50,
                                                                                                     "parameter_mmax":  1200,
                                                                                                     "parameter_initial":  [
                                                                                                                               300
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  2
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-comprel-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend comprel",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1080,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compmake",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp Makeup",
                                                  "patching_rect":  [
                                                                        1155,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            675,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp Makeup",
                                                                                                     "parameter_shortname":  "Makeup",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  20,
                                                                                                     "parameter_initial":  [
                                                                                                                               3
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  4
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compmake-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend compmake",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1155,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compmix",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp Mix",
                                                  "patching_rect":  [
                                                                        1230,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            725,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp Mix",
                                                                                                     "parameter_shortname":  "Mix",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               100
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compmix-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend compmix",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1230,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-comprat",
                                                  "maxclass":  "live.tab",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp Ratio",
                                                  "patching_rect":  [
                                                                        1305,
                                                                        150,
                                                                        150,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            557,
                                                                            114,
                                                                            150,
                                                                            18
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp Ratio",
                                                                                                     "parameter_shortname":  "Comp Ratio",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  2,
                                                                                                     "parameter_enum":  [
                                                                                                                            "2:1",
                                                                                                                            "4:1",
                                                                                                                            "10:1"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  3,
                                                  "outlettype":  [
                                                                     "",
                                                                     "",
                                                                     "float"
                                                                 ],
                                                  "num_lines_patching":  1,
                                                  "num_lines_presentation":  1
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-comprat-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend comprat",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1305,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-chodepth",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Chorus Depth",
                                                  "patching_rect":  [
                                                                        1380,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            795,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Chorus Depth",
                                                                                                     "parameter_shortname":  "Depth",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  200,
                                                                                                     "parameter_initial":  [
                                                                                                                               100
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-chodepth-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend chodepth",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1380,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-chospread",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Chorus Spread",
                                                  "patching_rect":  [
                                                                        1455,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            845,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Chorus Spread",
                                                                                                     "parameter_shortname":  "Spread",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0.5,
                                                                                                     "parameter_mmax":  12,
                                                                                                     "parameter_initial":  [
                                                                                                                               4
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  2
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-chospread-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend chospread",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1455,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-chomix",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Chorus Mix",
                                                  "patching_rect":  [
                                                                        1530,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            895,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Chorus Mix",
                                                                                                     "parameter_shortname":  "Mix",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               0
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-chomix-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend chomix",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1530,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spdecay",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Spring Decay",
                                                  "patching_rect":  [
                                                                        1605,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            965,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Spring Decay",
                                                                                                     "parameter_shortname":  "Decay",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  300,
                                                                                                     "parameter_mmax":  10000,
                                                                                                     "parameter_initial":  [
                                                                                                                               2500
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  2
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spdecay-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend spdecay",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1605,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spsize",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Spring Size",
                                                  "patching_rect":  [
                                                                        1680,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            1015,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Spring Size",
                                                                                                     "parameter_shortname":  "Size",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               30
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spsize-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend spsize",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1680,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-sptone",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Spring Tone",
                                                  "patching_rect":  [
                                                                        1755,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            1065,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Spring Tone",
                                                                                                     "parameter_shortname":  "Tone",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               50
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-sptone-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend sptone",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1755,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spmix",
                                                  "maxclass":  "live.dial",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Spring Mix",
                                                  "patching_rect":  [
                                                                        1830,
                                                                        150,
                                                                        44,
                                                                        48
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            1115,
                                                                            50,
                                                                            44,
                                                                            48
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Spring Mix",
                                                                                                     "parameter_shortname":  "Mix",
                                                                                                     "parameter_type":  0,
                                                                                                     "parameter_mmin":  0,
                                                                                                     "parameter_mmax":  100,
                                                                                                     "parameter_initial":  [
                                                                                                                               0
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  5
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  2,
                                                  "outlettype":  [
                                                                     "",
                                                                     "float"
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spmix-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend spmix",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1830,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-eqon",
                                                  "maxclass":  "live.toggle",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "EQ On",
                                                  "patching_rect":  [
                                                                        1905,
                                                                        150,
                                                                        14,
                                                                        14
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            230,
                                                                            35,
                                                                            14,
                                                                            14
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "EQ On",
                                                                                                     "parameter_shortname":  "EQ On",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  1,
                                                                                                     "parameter_enum":  [
                                                                                                                            "off",
                                                                                                                            "on"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-eqon-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend eqon",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1905,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-shapeon",
                                                  "maxclass":  "live.toggle",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Shape On",
                                                  "patching_rect":  [
                                                                        1980,
                                                                        150,
                                                                        14,
                                                                        14
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            400,
                                                                            35,
                                                                            14,
                                                                            14
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Shape On",
                                                                                                     "parameter_shortname":  "Shape On",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  1,
                                                                                                     "parameter_enum":  [
                                                                                                                            "off",
                                                                                                                            "on"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-shapeon-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend shapeon",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        1980,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compon",
                                                  "maxclass":  "live.toggle",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Comp On",
                                                  "patching_rect":  [
                                                                        2055,
                                                                        150,
                                                                        14,
                                                                        14
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            525,
                                                                            35,
                                                                            14,
                                                                            14
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Comp On",
                                                                                                     "parameter_shortname":  "Comp On",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  1,
                                                                                                     "parameter_enum":  [
                                                                                                                            "off",
                                                                                                                            "on"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-compon-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend compon",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        2055,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-choon",
                                                  "maxclass":  "live.toggle",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Chorus On",
                                                  "patching_rect":  [
                                                                        2130,
                                                                        150,
                                                                        14,
                                                                        14
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            795,
                                                                            35,
                                                                            14,
                                                                            14
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Chorus On",
                                                                                                     "parameter_shortname":  "Chorus On",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  1,
                                                                                                     "parameter_enum":  [
                                                                                                                            "off",
                                                                                                                            "on"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-choon-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend choon",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        2130,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spon",
                                                  "maxclass":  "live.toggle",
                                                  "numinlets":  1,
                                                  "parameter_enable":  1,
                                                  "varname":  "Spring On",
                                                  "patching_rect":  [
                                                                        2205,
                                                                        150,
                                                                        14,
                                                                        14
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            965,
                                                                            35,
                                                                            14,
                                                                            14
                                                                        ],
                                                  "saved_attribute_attributes":  {
                                                                                     "valueof":  {
                                                                                                     "parameter_longname":  "Spring On",
                                                                                                     "parameter_shortname":  "Spring On",
                                                                                                     "parameter_type":  2,
                                                                                                     "parameter_mmax":  1,
                                                                                                     "parameter_enum":  [
                                                                                                                            "off",
                                                                                                                            "on"
                                                                                                                        ],
                                                                                                     "parameter_initial":  [
                                                                                                                               1
                                                                                                                           ],
                                                                                                     "parameter_initial_enable":  1,
                                                                                                     "parameter_unitstyle":  9
                                                                                                 }
                                                                                 },
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-spon-pp",
                                                  "maxclass":  "newobj",
                                                  "text":  "prepend spon",
                                                  "numinlets":  1,
                                                  "numoutlets":  1,
                                                  "outlettype":  [
                                                                     ""
                                                                 ],
                                                  "patching_rect":  [
                                                                        2205,
                                                                        260,
                                                                        70,
                                                                        22
                                                                    ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl1",
                                                  "maxclass":  "live.comment",
                                                  "text":  "DARUMA GUITAR RACK",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  14,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        50,
                                                                        220,
                                                                        22
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            8,
                                                                            6,
                                                                            220,
                                                                            22
                                                                        ],
                                                  "textcolor":  [
                                                                    0.831,
                                                                    0,
                                                                    0,
                                                                    1
                                                                ],
                                                  "fontface":  1
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl2",
                                                  "maxclass":  "live.comment",
                                                  "text":  "AMP",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  9,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        80,
                                                                        60,
                                                                        16
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            8,
                                                                            34,
                                                                            60,
                                                                            16
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl3",
                                                  "maxclass":  "live.comment",
                                                  "text":  "EQ",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  9,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        110,
                                                                        60,
                                                                        16
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            248,
                                                                            34,
                                                                            60,
                                                                            16
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl4",
                                                  "maxclass":  "live.comment",
                                                  "text":  "SHAPE",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  9,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        140,
                                                                        60,
                                                                        16
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            418,
                                                                            34,
                                                                            60,
                                                                            16
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl5",
                                                  "maxclass":  "live.comment",
                                                  "text":  "COMP",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  9,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        170,
                                                                        60,
                                                                        16
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            543,
                                                                            34,
                                                                            60,
                                                                            16
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl6",
                                                  "maxclass":  "live.comment",
                                                  "text":  "CHORUS",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  9,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        200,
                                                                        60,
                                                                        16
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            813,
                                                                            34,
                                                                            60,
                                                                            16
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl7",
                                                  "maxclass":  "live.comment",
                                                  "text":  "SPRING",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  9,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        230,
                                                                        60,
                                                                        16
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            983,
                                                                            34,
                                                                            60,
                                                                            16
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl8",
                                                  "maxclass":  "live.comment",
                                                  "text":  "Ratio",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  10,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        260,
                                                                        32,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            525,
                                                                            114,
                                                                            32,
                                                                            18
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl9",
                                                  "maxclass":  "live.comment",
                                                  "text":  "Cab",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  10,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        290,
                                                                        32,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            230,
                                                                            114,
                                                                            32,
                                                                            18
                                                                        ]
                                              }
                                  },
                                  {
                                      "box":  {
                                                  "id":  "obj-lbl10",
                                                  "maxclass":  "live.comment",
                                                  "text":  "OS",
                                                  "numinlets":  1,
                                                  "numoutlets":  0,
                                                  "fontsize":  10,
                                                  "patching_rect":  [
                                                                        1500,
                                                                        320,
                                                                        22,
                                                                        18
                                                                    ],
                                                  "presentation":  1,
                                                  "presentation_rect":  [
                                                                            430,
                                                                            114,
                                                                            22,
                                                                            18
                                                                        ]
                                              }
                                  }
                              ],
                    "lines":  [
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-plugin",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-plugin",
                                                                       1
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            1
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-gen",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-plugout",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-gen",
                                                                       1
                                                                   ],
                                                        "destination":  [
                                                                            "obj-plugout",
                                                                            1
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-mode",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-mode-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-mode-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-mode",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-drive",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-drive-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-drive-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-drive",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-tone",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-tone-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-tone-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-tone",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-volume",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-volume-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-volume-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-volume",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-drywet",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-drywet-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-drywet-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-drywet",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-bass",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-bass-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-bass-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-bass",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-middle",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-middle-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-middle-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-middle",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-treble",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-treble-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-treble-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-treble",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-tight",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-tight-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-tight-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-tight",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-gatethr",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gatethr-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-gatethr-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gatethr",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-cabtype",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-cabtype-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-cabtype-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-cabtype",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-oversamp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-oversamp-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-oversamp-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-oversamp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compthr",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compthr-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compthr-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compthr",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compatk",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compatk-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compatk-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compatk",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-comprel",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-comprel-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-comprel-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-comprel",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compmake",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compmake-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compmake-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compmake",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compmix",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compmix-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compmix-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compmix",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-comprat",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-comprat-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-comprat-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-comprat",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-chodepth",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-chodepth-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-chodepth-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-chodepth",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-chospread",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-chospread-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-chospread-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-chospread",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-chomix",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-chomix-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-chomix-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-chomix",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spdecay",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spdecay-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spdecay-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spdecay",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spsize",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spsize-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spsize-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spsize",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-sptone",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-sptone-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-sptone-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-sptone",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spmix",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spmix-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spmix-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spmix",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-eqon",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-eqon-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-eqon-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-eqon",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-shapeon",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-shapeon-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-shapeon-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-shapeon",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compon",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compon-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-compon-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-compon",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-choon",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-choon-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-choon-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-choon",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spon",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spon-pp",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-spon-pp",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-gen",
                                                                            0
                                                                        ]
                                                    }
                                  },
                                  {
                                      "patchline":  {
                                                        "source":  [
                                                                       "obj-thisdev",
                                                                       0
                                                                   ],
                                                        "destination":  [
                                                                            "obj-spon",
                                                                            0
                                                                        ]
                                                    }
                                  }
                              ],
                    "dependency_cache":  [

                                         ],
                    "latency":  0,
                    "is_mpe":  0,
                    "external_mpe_tuning_enabled":  0,
                    "minimum_live_version":  "",
                    "minimum_max_version":  "",
                    "platform_compatibility":  0,
                    "autosave":  0,
                    "devicewidth":  1170
                }
}