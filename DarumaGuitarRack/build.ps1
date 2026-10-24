# Builds DarumaGuitarRack.amxd (+ .maxpat) from DarumaGuitarRack.genexpr
# Usage: powershell -ExecutionPolicy Bypass -File build.ps1
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$deviceName = 'DarumaGuitarRack'
$code = [IO.File]::ReadAllText((Join-Path $here 'DarumaGuitarRack.genexpr')) -replace "`r`n", "`n"

$appversion = [ordered]@{ major = 8; minor = 5; revision = 5; architecture = 'x64'; modernui = 1 }
$titleColor = @(0.831, 0.0, 0.0, 1.0)   # Ferrari Rosso Corsa #D40000

$boxes = New-Object System.Collections.ArrayList
$lines = New-Object System.Collections.ArrayList
function Add-Box($box) { [void]$boxes.Add([ordered]@{ box = $box }) }
function Add-Line($src, $out, $dst, $in) {
    [void]$lines.Add([ordered]@{ patchline = [ordered]@{ source = @($src, $out); destination = @($dst, $in) } })
}

# ---------- gen~ with embedded codebox ----------
$gen = [ordered]@{
    fileversion = 1; appversion = $appversion; classnamespace = 'dsp.gen'
    rect = @(100, 100, 700, 600); bglocked = 0; openinpresentation = 0
    default_fontsize = 12.0; default_fontface = 0; default_fontname = 'Arial'; gridonopen = 1; gridsize = @(15, 15)
    boxes = @(
        [ordered]@{ box = [ordered]@{ id = 'obj-1'; maxclass = 'newobj'; text = 'in 1'; numinlets = 0; numoutlets = 1; outlettype = @(''); patching_rect = @(20, 20, 30, 22) } },
        [ordered]@{ box = [ordered]@{ id = 'obj-2'; maxclass = 'newobj'; text = 'in 2'; numinlets = 0; numoutlets = 1; outlettype = @(''); patching_rect = @(400, 20, 30, 22) } },
        [ordered]@{ box = [ordered]@{ id = 'obj-3'; maxclass = 'codebox'; code = $code; fontface = 0; fontname = '<Monospaced>'; fontsize = 12.0
                numinlets = 2; numoutlets = 2; outlettype = @('', ''); patching_rect = @(20, 60, 600, 450) } },
        [ordered]@{ box = [ordered]@{ id = 'obj-4'; maxclass = 'newobj'; text = 'out 1'; numinlets = 1; numoutlets = 0; patching_rect = @(20, 530, 37, 22) } },
        [ordered]@{ box = [ordered]@{ id = 'obj-5'; maxclass = 'newobj'; text = 'out 2'; numinlets = 1; numoutlets = 0; patching_rect = @(580, 530, 37, 22) } }
    )
    lines = @(
        [ordered]@{ patchline = [ordered]@{ source = @('obj-1', 0); destination = @('obj-3', 0) } },
        [ordered]@{ patchline = [ordered]@{ source = @('obj-2', 0); destination = @('obj-3', 1) } },
        [ordered]@{ patchline = [ordered]@{ source = @('obj-3', 0); destination = @('obj-4', 0) } },
        [ordered]@{ patchline = [ordered]@{ source = @('obj-3', 1); destination = @('obj-5', 0) } }
    )
}

Add-Box ([ordered]@{ id = 'obj-plugin'; maxclass = 'newobj'; text = 'plugin~'; numinlets = 2; numoutlets = 2; outlettype = @('signal', 'signal'); patching_rect = @(30, 20, 60, 22) })
Add-Box ([ordered]@{ id = 'obj-thisdev'; maxclass = 'newobj'; text = 'live.thisdevice'; numinlets = 1; numoutlets = 3; outlettype = @('bang', 'int', 'int'); patching_rect = @(200, 20, 90, 22) })
Add-Box ([ordered]@{ id = 'obj-gen'; maxclass = 'newobj'; text = 'gen~'; numinlets = 2; numoutlets = 2; outlettype = @('signal', 'signal'); patching_rect = @(30, 330, 900, 22); patcher = $gen })
Add-Box ([ordered]@{ id = 'obj-plugout'; maxclass = 'newobj'; text = 'plugout~'; numinlets = 2; numoutlets = 0; patching_rect = @(30, 400, 60, 22) })
Add-Line 'obj-plugin' 0 'obj-gen' 0
Add-Line 'obj-plugin' 1 'obj-gen' 1
Add-Line 'obj-gen' 0 'obj-plugout' 0
Add-Line 'obj-gen' 1 'obj-plugout' 1

# ---------- controls ----------
$script:k = 0
function Add-Control($maxclass, $name, $genParam, $valueof, $prect) {
    $id = "obj-$genParam"
    $px = 30 + $script:k * 75
    $script:k++
    $box = [ordered]@{
        id = $id; maxclass = $maxclass; numinlets = 1; parameter_enable = 1; varname = $name
        patching_rect = @($px, 150, $prect[2], $prect[3]); presentation = 1; presentation_rect = $prect
        saved_attribute_attributes = [ordered]@{ valueof = $valueof }
    }
    if ($maxclass -eq 'live.dial') { $box.numoutlets = 2; $box.outlettype = @('', 'float') }
    elseif ($maxclass -eq 'live.tab') { $box.numoutlets = 3; $box.outlettype = @('', '', 'float'); $box.num_lines_patching = 1; $box.num_lines_presentation = 1 }
    elseif ($maxclass -eq 'live.toggle') { $box.numoutlets = 1; $box.outlettype = @('') }
    else { $box.numoutlets = 3; $box.outlettype = @('', '', 'float') }
    Add-Box $box
    Add-Box ([ordered]@{ id = "$id-pp"; maxclass = 'newobj'; text = "prepend $genParam"; numinlets = 1; numoutlets = 1; outlettype = @(''); patching_rect = @($px, 260, 70, 22) })
    Add-Line $id 0 "$id-pp" 0
    Add-Line "$id-pp" 0 'obj-gen' 0
    Add-Line 'obj-thisdev' 0 $id 0
}
function Dial($name, $short, $genParam, $min, $max, $init, $unit, $x, $y) {
    $v = [ordered]@{ parameter_longname = $name; parameter_shortname = $short; parameter_type = 0
        parameter_mmin = $min; parameter_mmax = $max; parameter_initial = @($init); parameter_initial_enable = 1; parameter_unitstyle = $unit }
    Add-Control 'live.dial' $name $genParam $v @($x, $y, 44, 48)
}
function EnumCtl($maxclass, $name, $genParam, $items, $init, $rect) {
    $v = [ordered]@{ parameter_longname = $name; parameter_shortname = $name; parameter_type = 2
        parameter_mmax = $items.Count - 1; parameter_enum = $items; parameter_initial = @($init); parameter_initial_enable = 1; parameter_unitstyle = 9 }
    Add-Control $maxclass $name $genParam $v $rect
}
function Label($text, $rect, $size, $color) {
    $script:nl++
    $id = "obj-lbl$($script:nl)"
    $ly = 20 + 30 * $script:nl
    $b = [ordered]@{ id = $id; maxclass = 'live.comment'; text = $text; numinlets = 1; numoutlets = 0; fontsize = $size
        patching_rect = @(1500, $ly, $rect[2], $rect[3]); presentation = 1; presentation_rect = $rect }
    if ($color) { $b.textcolor = $color; $b.fontface = 1 }
    Add-Box $b
}

# unitstyle: 1 float, 4 dB, 5 %
EnumCtl 'live.tab' 'Mode' 'mode' @('Clean', 'OD', 'Dist', 'Fuzz', 'Metal') 1 @(230, 8, 275, 18)
Dial 'Drive'  'Drive'  'drive'   0 150 50  5 8   50
Dial 'Tone'   'Tone'   'tone'    0 100 55  5 58  50
Dial 'Volume' 'Volume' 'volume' -36 12 -6  4 108 50
Dial 'Mix'    'Mix'    'drywet'  0 100 100 5 158 50
Dial 'Bass'   'Bass'   'bass'   -12 12 0   4 230 50
Dial 'Middle' 'Middle' 'middle' -12 12 0   4 280 50
Dial 'Treble' 'Treble' 'treble' -12 12 0   4 330 50
Dial 'Tight'  'Tight'  'tight'   0 100 30  5 400 50
Dial 'Gate'   'Gate'   'gatethr' -80 -20 -80 4 450 50
EnumCtl 'live.tab' 'Cab' 'cabtype' @('Off', '1x12', '2x12', '4x12') 3 @(262, 114, 160, 18)
EnumCtl 'live.menu' 'Oversampling' 'oversamp' @('1x', '2x', '4x', '8x') 2 @(452, 114, 50, 18)
Dial 'Comp Threshold' 'Thresh'  'compthr'  -40 0 -10   4 525 50
Dial 'Comp Attack'    'Attack'  'compatk'  0.1 30 3    2 575 50
Dial 'Comp Release'   'Release' 'comprel'  50 1200 300 2 625 50
Dial 'Comp Makeup'    'Makeup'  'compmake' 0 20 3      4 675 50
Dial 'Comp Mix'       'Mix'     'compmix'  0 100 100   5 725 50
EnumCtl 'live.tab' 'Comp Ratio' 'comprat' @('2:1', '4:1', '10:1') 1 @(557, 114, 150, 18)
Dial 'Chorus Depth'  'Depth'  'chodepth'  0 200 100 5 795 50
Dial 'Chorus Spread' 'Spread' 'chospread' 0.5 12 4 2 845 50
Dial 'Chorus Mix'    'Mix'    'chomix'    0 100 0  5 895 50
Dial 'Spring Decay'  'Decay'  'spdecay'   300 10000 2500 2 965 50
Dial 'Spring Size'   'Size'   'spsize'    0 100 30 5 1015 50
Dial 'Spring Tone'   'Tone'   'sptone'    0 100 50 5 1065 50
Dial 'Spring Mix'    'Mix'    'spmix'     0 100 0  5 1115 50

# section on/off toggles (AMP has none: always on)
EnumCtl 'live.toggle' 'EQ On'     'eqon'    @('off', 'on') 1 @(230, 35, 14, 14)
EnumCtl 'live.toggle' 'Shape On'  'shapeon' @('off', 'on') 1 @(400, 35, 14, 14)
EnumCtl 'live.toggle' 'Comp On'   'compon'  @('off', 'on') 1 @(525, 35, 14, 14)
EnumCtl 'live.toggle' 'Chorus On' 'choon'   @('off', 'on') 1 @(795, 35, 14, 14)
EnumCtl 'live.toggle' 'Spring On' 'spon'    @('off', 'on') 1 @(965, 35, 14, 14)

Label 'DARUMA GUITAR RACK' @(8, 6, 220, 22) 14 $titleColor
Label 'AMP' @(8, 34, 60, 16) 9 $null
Label 'EQ' @(248, 34, 60, 16) 9 $null
Label 'SHAPE' @(418, 34, 60, 16) 9 $null
Label 'COMP' @(543, 34, 60, 16) 9 $null
Label 'CHORUS' @(813, 34, 60, 16) 9 $null
Label 'SPRING' @(983, 34, 60, 16) 9 $null
Label 'Ratio' @(525, 114, 32, 18) 10 $null
Label 'Cab' @(230, 114, 32, 18) 10 $null
Label 'OS' @(430, 114, 22, 18) 10 $null

$patch = [ordered]@{ patcher = [ordered]@{
    fileversion = 1; appversion = $appversion; classnamespace = 'box'
    rect = @(80, 80, 1100, 520); openrect = @(0, 0, 0, 169); bglocked = 0; openinpresentation = 1
    default_fontsize = 10.0; default_fontface = 0; default_fontname = 'Arial Bold'; gridonopen = 1; gridsize = @(8, 8)
    boxes = $boxes; lines = $lines
    dependency_cache = @(); latency = 0; is_mpe = 0; external_mpe_tuning_enabled = 0; minimum_live_version = ''; minimum_max_version = ''
    platform_compatibility = 0; autosave = 0; devicewidth = 1170.0
} }

$json = $patch | ConvertTo-Json -Depth 100
# PS 5.1 escapes these needlessly; restore them for readability
$bs = [string][char]92
foreach ($c in @(60, 62, 39, 38)) { $json = $json.Replace($bs + 'u00' + ('{0:x2}' -f $c), [string][char]$c) }

$utf8 = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText((Join-Path $here "$deviceName.maxpat"), $json, $utf8)

# .amxd = 'ampf' header + device type ('aaaa' = audio effect) + meta + ptch chunk with the JSON patcher
[byte[]]$payload = $utf8.GetBytes($json + "`n" + [char]0)
$ascii = [Text.Encoding]::ASCII
$ms = New-Object IO.MemoryStream
$bw = New-Object IO.BinaryWriter($ms)
$bw.Write($ascii.GetBytes('ampf')); $bw.Write([int32]4); $bw.Write($ascii.GetBytes('aaaa'))
$bw.Write($ascii.GetBytes('meta')); $bw.Write([int32]4); $bw.Write([int32]7)
$bw.Write($ascii.GetBytes('ptch')); $bw.Write([int32]$payload.Length); $bw.Write($payload)
$bw.Flush()
[IO.File]::WriteAllBytes((Join-Path $here "$deviceName.amxd"), $ms.ToArray())
Write-Output "Built $deviceName.amxd ($($ms.Length) bytes)"
