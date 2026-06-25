# Download Assets Script - Susurros de la Mina
# Este script descarga assets gratuitos recomendados para el proyecto

param(
    [string]$OutputDir = ".\assets",
    [switch]$Force
)

# Colores para output
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Reset = "`e[0m"

Write-Host "${Green}=== Descargador de Assets - Susurros de la Mina ===${Reset}"
Write-Host ""

# Crear directorio temporal
$TempDir = "$env:TEMP\godot_assets"
if (-not (Test-Path $TempDir)) {
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
}

# Función para descargar archivo
function Download-Asset {
    param(
        [string]$Url,
        [string]$OutputPath,
        [string]$Description
    )
    
    Write-Host "${Yellow}Descargando: $Description${Reset}"
    
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutputPath)
        Write-Host "${Green}  ✓ Descargado: $OutputPath${Reset}"
        return $true
    }
    catch {
        Write-Host "${Red}  ✗ Error descargando $Description${Reset}"
        Write-Host "${Red}    $($_.Exception.Message)${Reset}"
        return $false
    }
}

# Función para extraer ZIP
function Extract-ZipFile {
    param(
        [string]$ZipPath,
        [string]$DestinationPath
    )
    
    Write-Host "${Yellow}Extrayendo: $ZipPath${Reset}"
    
    try {
        Expand-Archive -Path $ZipPath -DestinationPath $DestinationPath -Force
        Write-Host "${Green}  ✓ Extraído a: $DestinationPath${Reset}"
        return $true
    }
    catch {
        Write-Host "${Red}  ✗ Error extrayendo: $($_.Exception.Message)${Reset}"
        return $false
    }
}

# ═══════════════════════════════════════════════════════════════
# ASSETS A DESCARGAR
# ═══════════════════════════════════════════════════════════════

$assets = @(
    # Kenney Prototype Textures (CC0)
    @{
        Name = "Kenney Prototype Textures"
        Url = "https://github.com/Calinou/kenney-prototype-textures/archive/master.zip"
        ZipFile = "$TempDir\kenney_textures.zip"
        ExtractTo = "$TempDir\kenney_textures"
        Destination = "$OutputDir\textures\prototype"
        License = "CC0"
        Type = "textures"
    }
)

# ═══════════════════════════════════════════════════════════════
# PROCESO PRINCIPAL
# ═══════════════════════════════════════════════════════════════

Write-Host "${Green}Assets a descargar: $($assets.Count)${Reset}"
Write-Host ""

$downloaded = 0
$failed = 0

foreach ($asset in $assets) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "${Green}Procesando: $($asset.Name)${Reset}"
    Write-Host "Licencia: $($asset.License)"
    Write-Host ""
    
    # Verificar si ya existe
    if ((Test-Path $asset.Destination) -and -not $Force) {
        Write-Host "${Yellow}  ⚠ Ya existe: $($asset.Destination)${Reset}"
        Write-Host "${Yellow}    Usa -Force para re-descargar${Reset}"
        Write-Host ""
        continue
    }
    
    # Descargar
    $success = Download-Asset -Url $asset.Url -OutputPath $asset.ZipFile -Description $asset.Name
    
    if ($success) {
        # Extraer
        $extracted = Extract-ZipFile -ZipPath $asset.ZipFile -DestinationPath $asset.ExtractTo
        
        if ($extracted) {
            # Copiar a destino final
            Write-Host "${Yellow}Copiando a destino...${Reset}"
            
            # Crear directorio destino si no existe
            if (-not (Test-Path $asset.Destination)) {
                New-Item -ItemType Directory -Path $asset.Destination -Force | Out-Null
            }
            
            # Buscar archivos relevantes y copiar
            $files = Get-ChildItem -Path $asset.ExtractTo -Recurse -File | 
                     Where-Object { $_.Extension -match '\.(png|jpg|ogg|wav|glb|gltf)$' }
            
            foreach ($file in $files) {
                $destFile = Join-Path $asset.Destination $file.Name
                if (-not (Test-Path $destFile) -or $Force) {
                    Copy-Item $file.FullName -Destination $destFile -Force
                    Write-Host "  Copiado: $($file.Name)"
                }
            }
            
            $downloaded++
        }
        else {
            $failed++
        }
    }
    else {
        $failed++
    }
    
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════
# RESUMEN
# ═══════════════════════════════════════════════════════════════

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "${Green}Resumen:${Reset}"
Write-Host "  Descargados: $downloaded"
Write-Host "  Fallidos: $failed"
Write-Host ""

if ($failed -eq 0) {
    Write-Host "${Green}¡Todos los assets descargados exitosamente!${Reset}"
}
else {
    Write-Host "${Yellow}Algunos assets no se pudieron descargar.${Reset}"
    Write-Host "${Yellow}Puedes descargarlos manualmente desde:${Reset}"
    Write-Host "  - https://kenney.nl/assets"
    Write-Host "  - https://poly.pizza"
    Write-Host "  - https://opengameart.org"
}

# ═══════════════════════════════════════════════════════════════
# ASSETS MANUALES (requieren descarga manual)
# ═══════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "${Yellow}Assets que requieren descarga manual:${Reset}"
Write-Host ""
Write-Host "1. Free Low Poly Mining Assets"
Write-Host "   URL: https://sketchfab.com/3d-models/free-low-poly-mining-assets-fb8c435dc8644a1ea4555f59a17313fc"
Write-Host "   Licencia: CC-BY"
Write-Host "   Destino: $OutputDir\3d\tools\ y $OutputDir\3d\minerals\"
Write-Host ""
Write-Host "2. Modular Caves"
Write-Host "   URL: https://sketchfab.com/3d-models/modular-caves-66d33b65d4fc471db78a7e4da2232623"
Write-Host "   Licencia: CC-BY"
Write-Host "   Destino: $OutputDir\3d\environment\"
Write-Host ""
Write-Host "3. Crystal Pack"
Write-Host "   URL: https://poly.pizza/bundles/Crystal Pack"
Write-Host "   Licencia: CC0"
Write-Host "   Destino: $OutputDir\3d\minerals\"
Write-Host ""
Write-Host "4. Kenney Audio"
Write-Host "   URL: https://kenney.nl/assets?q=audio"
Write-Host "   Licencia: CC0"
Write-Host "   Destino: $OutputDir\audio\sfx\"
Write-Host ""

# Limpiar archivos temporales
Write-Host "${Yellow}Limpiando archivos temporales...${Reset}"
if (Test-Path $TempDir) {
    Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "${Green}¡Proceso completado!${Reset}"