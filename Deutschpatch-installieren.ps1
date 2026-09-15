param([Parameter(Position=0)][string]$GameRoot)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($GameRoot)) { $GameRoot = $PSScriptRoot }
$exe = Join-Path $GameRoot 'TMP3\Binaries\Win64\TMP3-Win64-Shipping.exe'
$bytes = [IO.File]::ReadAllBytes($exe)

function Find-Bytes([byte[]]$Needle) {
    $offsets = [Collections.Generic.List[int]]::new()
    $start = 0
    while ($start -le $bytes.Length - $Needle.Length) {
        $offset = [Array]::IndexOf($bytes, $Needle[0], $start)
        if ($offset -lt 0 -or $offset -gt $bytes.Length - $Needle.Length) { break }
        $matches = $true
        for ($i = 1; $i -lt $Needle.Length; $i++) {
            if ($bytes[$offset + $i] -ne $Needle[$i]) {
                $matches = $false
                break
            }
        }
        if ($matches) {
            $offsets.Add($offset)
            $start = $offset + $Needle.Length
        } else {
            $start = $offset + 1
        }
    }
    return $offsets
}

function Replace-Utf16([string]$OldValue, [string]$NewValue) {
    $source = [Text.Encoding]::Unicode.GetBytes($OldValue)
    $replacement = [Text.Encoding]::Unicode.GetBytes($NewValue)
    if ($replacement.Length -gt $source.Length) { throw 'Replacement is too long.' }
    $sourceOffsets = @(Find-Bytes $source)
    $replacementOffsets = @(Find-Bytes $replacement)
    if ($sourceOffsets.Count -eq 0 -and $replacementOffsets.Count -eq 1) { return }
    if ($sourceOffsets.Count -ne 1) {
        throw "Expected one occurrence of '$OldValue', found $($sourceOffsets.Count)."
    }
    $target = [byte[]]::new($source.Length)
    [Array]::Copy($replacement, $target, $replacement.Length)
    [Array]::Copy($target, 0, $bytes, $sourceOffsets[0], $target.Length)
}

Replace-Utf16 'https://api.jackboxgames.com/arcade' 'https://api.jackboxpatch.de/arcade'
Replace-Utf16 'jackbox.tv' 'jackbox.de'
[IO.File]::WriteAllBytes($exe, $bytes)
