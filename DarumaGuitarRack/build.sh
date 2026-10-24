#!/usr/bin/env bash
# Builds DarumaGuitarRack.amxd (+ .maxpat) from DarumaGuitarRack.genexpr
# Same output as build.ps1, for macOS/Linux (bash or zsh). Keep the two in sync.
# Usage: ./build.sh   (or: bash build.sh / zsh build.sh)
set -eu
here=$(cd "$(dirname "$0")" && pwd)
device_name=DarumaGuitarRack

# gen~ code as a JSON string: drop CR, escape \ " and tabs, join lines with \n
tab=$(printf '\t')
code=$(tr -d '\r' < "$here/$device_name.genexpr" \
    | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e "s/$tab/\\\\t/g" \
    | awk '{ printf "%s\\n", $0 }')

appversion='{"major":8,"minor":5,"revision":5,"architecture":"x64","modernui":1}'
title_color='[0.831,0.0,0.0,1.0]'   # Ferrari Rosso Corsa #D40000

nl='
'
boxes=''
lines=''
add_box() { boxes="${boxes:+$boxes,$nl}{\"box\":{$1}}"; }
add_line() { lines="${lines:+$lines,$nl}{\"patchline\":{\"source\":[\"$1\",$2],\"destination\":[\"$3\",$4]}}"; }
# JSON array of strings from the arguments
jstrs() { out=''; for s in "$@"; do out="${out:+$out,}\"$s\""; done; printf '[%s]' "$out"; }

# ---------- gen~ with embedded codebox ----------
gen="{\"fileversion\":1,\"appversion\":$appversion,\"classnamespace\":\"dsp.gen\",
\"rect\":[100,100,700,600],\"bglocked\":0,\"openinpresentation\":0,
\"default_fontsize\":12.0,\"default_fontface\":0,\"default_fontname\":\"Arial\",\"gridonopen\":1,\"gridsize\":[15,15],
\"boxes\":[
{\"box\":{\"id\":\"obj-1\",\"maxclass\":\"newobj\",\"text\":\"in 1\",\"numinlets\":0,\"numoutlets\":1,\"outlettype\":[\"\"],\"patching_rect\":[20,20,30,22]}},
{\"box\":{\"id\":\"obj-2\",\"maxclass\":\"newobj\",\"text\":\"in 2\",\"numinlets\":0,\"numoutlets\":1,\"outlettype\":[\"\"],\"patching_rect\":[400,20,30,22]}},
{\"box\":{\"id\":\"obj-3\",\"maxclass\":\"codebox\",\"code\":\"$code\",\"fontface\":0,\"fontname\":\"<Monospaced>\",\"fontsize\":12.0,
\"numinlets\":2,\"numoutlets\":2,\"outlettype\":[\"\",\"\"],\"patching_rect\":[20,60,600,450]}},
{\"box\":{\"id\":\"obj-4\",\"maxclass\":\"newobj\",\"text\":\"out 1\",\"numinlets\":1,\"numoutlets\":0,\"patching_rect\":[20,530,37,22]}},
{\"box\":{\"id\":\"obj-5\",\"maxclass\":\"newobj\",\"text\":\"out 2\",\"numinlets\":1,\"numoutlets\":0,\"patching_rect\":[580,530,37,22]}}
],
\"lines\":[
{\"patchline\":{\"source\":[\"obj-1\",0],\"destination\":[\"obj-3\",0]}},
{\"patchline\":{\"source\":[\"obj-2\",0],\"destination\":[\"obj-3\",1]}},
{\"patchline\":{\"source\":[\"obj-3\",0],\"destination\":[\"obj-4\",0]}},
{\"patchline\":{\"source\":[\"obj-3\",1],\"destination\":[\"obj-5\",0]}}
]}"

add_box '"id":"obj-plugin","maxclass":"newobj","text":"plugin~","numinlets":2,"numoutlets":2,"outlettype":["signal","signal"],"patching_rect":[30,20,60,22]'
add_box '"id":"obj-thisdev","maxclass":"newobj","text":"live.thisdevice","numinlets":1,"numoutlets":3,"outlettype":["bang","int","int"],"patching_rect":[200,20,90,22]'
add_box "\"id\":\"obj-gen\",\"maxclass\":\"newobj\",\"text\":\"gen~\",\"numinlets\":2,\"numoutlets\":2,\"outlettype\":[\"signal\",\"signal\"],\"patching_rect\":[30,330,900,22],\"patcher\":$gen"
add_box '"id":"obj-plugout","maxclass":"newobj","text":"plugout~","numinlets":2,"numoutlets":0,"patching_rect":[30,400,60,22]'
add_line obj-plugin 0 obj-gen 0
add_line obj-plugin 1 obj-gen 1
add_line obj-gen 0 obj-plugout 0
add_line obj-gen 1 obj-plugout 1

# ---------- controls ----------
k=0
# add_control maxclass name genParam valueof x y w h
add_control() {
    id="obj-$3"
    px=$((30 + k * 75))
    k=$((k + 1))
    case $1 in
        live.dial) outs='"numoutlets":2,"outlettype":["","float"]' ;;
        live.tab) outs='"numoutlets":3,"outlettype":["","","float"],"num_lines_patching":1,"num_lines_presentation":1' ;;
        live.toggle) outs='"numoutlets":1,"outlettype":[""]' ;;
        *) outs='"numoutlets":3,"outlettype":["","","float"]' ;;
    esac
    add_box "\"id\":\"$id\",\"maxclass\":\"$1\",\"numinlets\":1,\"parameter_enable\":1,\"varname\":\"$2\",\"patching_rect\":[$px,150,$7,$8],\"presentation\":1,\"presentation_rect\":[$5,$6,$7,$8],\"saved_attribute_attributes\":{\"valueof\":$4},$outs"
    add_box "\"id\":\"$id-pp\",\"maxclass\":\"newobj\",\"text\":\"prepend $3\",\"numinlets\":1,\"numoutlets\":1,\"outlettype\":[\"\"],\"patching_rect\":[$px,260,70,22]"
    add_line "$id" 0 "$id-pp" 0
    add_line "$id-pp" 0 obj-gen 0
    add_line obj-thisdev 0 "$id" 0
}
# dial name short genParam min max init unit x y
dial() {
    v="{\"parameter_longname\":\"$1\",\"parameter_shortname\":\"$2\",\"parameter_type\":0,\"parameter_mmin\":$4,\"parameter_mmax\":$5,\"parameter_initial\":[$6],\"parameter_initial_enable\":1,\"parameter_unitstyle\":$7}"
    add_control live.dial "$1" "$3" "$v" "$8" "$9" 44 48
}
# enum_ctl maxclass name genParam init x y w h item...
enum_ctl() {
    ec_class=$1; ec_name=$2; ec_param=$3; ec_init=$4; ec_x=$5; ec_y=$6; ec_w=$7; ec_h=$8
    shift 8
    v="{\"parameter_longname\":\"$ec_name\",\"parameter_shortname\":\"$ec_name\",\"parameter_type\":2,\"parameter_mmax\":$(($# - 1)),\"parameter_enum\":$(jstrs "$@"),\"parameter_initial\":[$ec_init],\"parameter_initial_enable\":1,\"parameter_unitstyle\":9}"
    add_control "$ec_class" "$ec_name" "$ec_param" "$v" "$ec_x" "$ec_y" "$ec_w" "$ec_h"
}
n_lbl=0
# label text x y w h size [color]
label() {
    n_lbl=$((n_lbl + 1))
    b="\"id\":\"obj-lbl$n_lbl\",\"maxclass\":\"live.comment\",\"text\":\"$1\",\"numinlets\":1,\"numoutlets\":0,\"fontsize\":$6,\"patching_rect\":[1500,$((20 + 30 * n_lbl)),$4,$5],\"presentation\":1,\"presentation_rect\":[$2,$3,$4,$5]"
    if [ $# -ge 7 ]; then b="$b,\"textcolor\":$7,\"fontface\":1"; fi
    add_box "$b"
}

# unitstyle: 1 float, 2 ms, 4 dB, 5 %
enum_ctl live.tab Mode mode 1 230 8 275 18 Clean OD Dist Fuzz Metal
dial Drive  Drive  drive   0 150 50  5 8   50
dial Tone   Tone   tone    0 100 55  5 58  50
dial Volume Volume volume -36 12 -6  4 108 50
dial Mix    Mix    drywet  0 100 100 5 158 50
dial Bass   Bass   bass   -12 12 0   4 230 50
dial Middle Middle middle -12 12 0   4 280 50
dial Treble Treble treble -12 12 0   4 330 50
dial Tight  Tight  tight   0 100 30  5 400 50
dial Gate   Gate   gatethr -80 -20 -80 4 450 50
enum_ctl live.tab Cab cabtype 3 262 114 160 18 Off 1x12 2x12 4x12
enum_ctl live.menu Oversampling oversamp 2 452 114 50 18 1x 2x 4x 8x
dial 'Comp Threshold' Thresh  compthr  -40 0 -10   4 525 50
dial 'Comp Attack'    Attack  compatk  0.1 30 3    2 575 50
dial 'Comp Release'   Release comprel  50 1200 300 2 625 50
dial 'Comp Makeup'    Makeup  compmake 0 20 3      4 675 50
dial 'Comp Mix'       Mix     compmix  0 100 100   5 725 50
enum_ctl live.tab 'Comp Ratio' comprat 1 557 114 150 18 2:1 4:1 10:1
dial 'Chorus Depth'  Depth  chodepth  0 200 100 5 795 50
dial 'Chorus Spread' Spread chospread 0.5 12 4 2 845 50
dial 'Chorus Mix'    Mix    chomix    0 100 0  5 895 50
dial 'Spring Decay'  Decay  spdecay   300 10000 2500 2 965 50
dial 'Spring Size'   Size   spsize    0 100 30 5 1015 50
dial 'Spring Tone'   Tone   sptone    0 100 50 5 1065 50
dial 'Spring Mix'    Mix    spmix     0 100 0  5 1115 50

# section on/off toggles (AMP has none: always on)
enum_ctl live.toggle 'EQ On'     eqon    1 230 35 14 14 off on
enum_ctl live.toggle 'Shape On'  shapeon 1 400 35 14 14 off on
enum_ctl live.toggle 'Comp On'   compon  1 525 35 14 14 off on
enum_ctl live.toggle 'Chorus On' choon   1 795 35 14 14 off on
enum_ctl live.toggle 'Spring On' spon    1 965 35 14 14 off on

label 'DARUMA GUITAR RACK' 8 6 220 22 14 "$title_color"
label AMP 8 34 60 16 9
label EQ 248 34 60 16 9
label SHAPE 418 34 60 16 9
label COMP 543 34 60 16 9
label CHORUS 813 34 60 16 9
label SPRING 983 34 60 16 9
label Ratio 525 114 32 18 10
label Cab 230 114 32 18 10
label OS 430 114 22 18 10

json="{\"patcher\":{\"fileversion\":1,\"appversion\":$appversion,\"classnamespace\":\"box\",
\"rect\":[80,80,1100,520],\"openrect\":[0,0,0,169],\"bglocked\":0,\"openinpresentation\":1,
\"default_fontsize\":10.0,\"default_fontface\":0,\"default_fontname\":\"Arial Bold\",\"gridonopen\":1,\"gridsize\":[8,8],
\"boxes\":[
$boxes
],
\"lines\":[
$lines
],
\"dependency_cache\":[],\"latency\":0,\"is_mpe\":0,\"external_mpe_tuning_enabled\":0,\"minimum_live_version\":\"\",\"minimum_max_version\":\"\",
\"platform_compatibility\":0,\"autosave\":0,\"devicewidth\":1170.0}}"

maxpat="$here/$device_name.maxpat"
amxd="$here/$device_name.amxd"
printf '%s' "$json" > "$maxpat"

# little-endian int32
le32() {
    printf "\\$(printf '%03o' $(($1 & 255)))\\$(printf '%03o' $((($1 >> 8) & 255)))\\$(printf '%03o' $((($1 >> 16) & 255)))\\$(printf '%03o' $((($1 >> 24) & 255)))"
}

# .amxd = 'ampf' header + device type ('aaaa' = audio effect) + meta + ptch chunk with the JSON patcher
payload_len=$(($(wc -c < "$maxpat") + 2))   # JSON + "\n" + NUL
{
    printf 'ampf'; le32 4; printf 'aaaa'
    printf 'meta'; le32 4; le32 7
    printf 'ptch'; le32 "$payload_len"; cat "$maxpat"; printf '\n\000'
} > "$amxd"
echo "Built $device_name.amxd ($(($(wc -c < "$amxd"))) bytes)"
