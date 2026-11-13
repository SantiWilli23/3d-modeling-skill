$ErrorActionPreference = 'Stop'
$dest = Join-Path $HOME '.claude/skills'
New-Item -ItemType Directory -Force $dest | Out-Null
$target = Join-Path $dest 'modelado-3d'
if (Test-Path $target) { Remove-Item -Recurse -Force $target }
Copy-Item -Recurse (Join-Path $PSScriptRoot 'skills/modelado-3d') $dest
Write-Host "Instalada en $target"
