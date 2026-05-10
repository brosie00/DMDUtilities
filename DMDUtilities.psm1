# Dot-source public functions
$public = Join-Path $PSScriptRoot "Public"

Get-ChildItem -Path $public -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

$Global:MyTable = Import-Csv -Path "$psscriptRoot\Data\Users.csv" -Header SEID, EMail

$Global:MyHashTable = @{}

foreach ($r in $MyTable) {
    $MyHashTable[$r.SEID] = $($r.EMail).tolower()
    $MyHashTable[$r.EMail] = $($r.SEID).tolower()
}


