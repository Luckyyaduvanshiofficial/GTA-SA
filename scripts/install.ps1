# GTA San Andreas Mod Pack Installer (PowerShell)
# Windows installation script - Automatically detects GTA SA and applies mods

param(
    [string]$GamePath = "",
    [switch]$SkipBackup = $false,
    [switch]$Help = $false
)

# Script configuration
$ModPackVersion = "2.0"
$RequiredSpace = 3GB
$BackupSuffix = "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# ANSI Colors for better output
$script:HostSupportsColor = $Host.UI.SupportsVirtualTerminal

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    
    if ($script:HostSupportsColor) {
        $colors = @{
            "Red" = "`e[31m"
            "Green" = "`e[32m"
            "Yellow" = "`e[33m"
            "Blue" = "`e[34m"
            "Cyan" = "`e[36m"
            "White" = "`e[37m"
            "Reset" = "`e[0m"
        }
        Write-Host "$($colors[$Color])$Message$($colors['Reset'])"
    } else {
        Write-Host $Message
    }
}

function Show-Help {
    Write-ColorOutput "GTA San Andreas Mod Pack Installer v$ModPackVersion" "Cyan"
    Write-Host ""
    Write-Host "Usage: .\install.ps1 [-GamePath <path>] [-SkipBackup] [-Help]"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -GamePath    : Custom path to GTA San Andreas installation"
    Write-Host "  -SkipBackup  : Skip creating backup of original files"
    Write-Host "  -Help        : Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\install.ps1"
    Write-Host "  .\install.ps1 -GamePath 'C:\Games\GTA San Andreas'"
    Write-Host "  .\install.ps1 -SkipBackup"
}

function Find-GTASanAndreas {
    Write-ColorOutput "🔍 Searching for GTA San Andreas installation..." "Cyan"
    
    # Common installation paths
    $commonPaths = @(
        "${env:ProgramFiles(x86)}\Rockstar Games\GTA San Andreas",
        "${env:ProgramFiles}\Rockstar Games\GTA San Andreas",
        "C:\Program Files (x86)\Rockstar Games\GTA San Andreas",
        "C:\Program Files\Rockstar Games\GTA San Andreas",
        "${env:ProgramFiles(x86)}\Steam\steamapps\common\Grand Theft Auto San Andreas",
        "${env:ProgramFiles}\Steam\steamapps\common\Grand Theft Auto San Andreas",
        "C:\Games\GTA San Andreas",
        "D:\Games\GTA San Andreas",
        "E:\Games\GTA San Andreas"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path "$path\gta_sa.exe") {
            Write-ColorOutput "✓ Found GTA San Andreas at: $path" "Green"
            return $path
        }
    }
    
    # Search in Steam library folders
    $steamConfig = "$env:ProgramFiles(x86)\Steam\steamapps\libraryfolders.vdf"
    if (Test-Path $steamConfig) {
        $content = Get-Content $steamConfig -Raw
        $libraryPaths = [regex]::Matches($content, '"path"\s+"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
        
        foreach ($library in $libraryPaths) {
            $gtaPath = "$library\steamapps\common\Grand Theft Auto San Andreas"
            if (Test-Path "$gtaPath\gta_sa.exe") {
                Write-ColorOutput "✓ Found GTA San Andreas at: $gtaPath" "Green"
                return $gtaPath
            }
        }
    }
    
    return $null
}

function Test-DiskSpace {
    param([string]$Path)
    
    $drive = (Get-Item $Path).PSDrive.Name
    $freeSpace = (Get-PSDrive $drive).Free
    
    if ($freeSpace -lt $RequiredSpace) {
        Write-ColorOutput "⚠ Warning: Low disk space. Required: $($RequiredSpace/1GB)GB, Available: $([math]::Round($freeSpace/1GB, 2))GB" "Yellow"
        return $false
    }
    return $true
}

function Backup-OriginalFiles {
    param([string]$GamePath)
    
    Write-ColorOutput "📦 Creating backup of original files..." "Cyan"
    
    $backupPath = Join-Path $GamePath $BackupSuffix
    
    try {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        
        # Files to backup
        $filesToBackup = @(
            "gta_sa.exe",
            "models\gta3.img",
            "data\vehicles.ide",
            "data\handling.cfg"
        )
        
        foreach ($file in $filesToBackup) {
            $sourcePath = Join-Path $GamePath $file
            if (Test-Path $sourcePath) {
                $destPath = Join-Path $backupPath $file
                $destDir = Split-Path $destPath -Parent
                
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                
                Copy-Item $sourcePath $destPath -Force
                Write-Host "  ✓ Backed up: $file"
            }
        }
        
        Write-ColorOutput "✓ Backup created at: $backupPath" "Green"
        Write-ColorOutput "  To restore, copy files from this folder back to the game directory." "Yellow"
        return $true
        
    } catch {
        Write-ColorOutput "✗ Backup failed: $_" "Red"
        return $false
    }
}

function Install-ModPack {
    param([string]$GamePath)
    
    Write-ColorOutput "📥 Installing mod pack..." "Cyan"
    
    # Check if mod pack exists
    $modPackPath = Join-Path $PSScriptRoot "modpack"
    if (-not (Test-Path $modPackPath)) {
        Write-ColorOutput "✗ Mod pack folder not found at: $modPackPath" "Red"
        Write-ColorOutput "  Please extract the mod pack files first!" "Yellow"
        return $false
    }
    
    try {
        # Copy mod files
        Write-Host "  Copying mod files..."
        
        $modFolders = @("models", "data", "textures", "scripts")
        foreach ($folder in $modFolders) {
            $sourcePath = Join-Path $modPackPath $folder
            if (Test-Path $sourcePath) {
                $destPath = Join-Path $GamePath $folder
                Copy-Item -Path "$sourcePath\*" -Destination $destPath -Recurse -Force
                Write-Host "  ✓ Installed: $folder"
            }
        }
        
        Write-ColorOutput "✓ Mod pack installed successfully!" "Green"
        return $true
        
    } catch {
        Write-ColorOutput "✗ Installation failed: $_" "Red"
        return $false
    }
}

function Verify-Installation {
    param([string]$GamePath)
    
    Write-ColorOutput "🔎 Verifying installation..." "Cyan"
    
    $criticalFiles = @(
        "gta_sa.exe",
        "models\gta3.img"
    )
    
    $allFilesExist = $true
    foreach ($file in $criticalFiles) {
        $filePath = Join-Path $GamePath $file
        if (-not (Test-Path $filePath)) {
            Write-ColorOutput "✗ Missing file: $file" "Red"
            $allFilesExist = $false
        }
    }
    
    if ($allFilesExist) {
        Write-ColorOutput "✓ All critical files present" "Green"
        return $true
    }
    
    return $false
}

function Show-CompletionMessage {
    param([string]$GamePath)
    
    Write-Host ""
    Write-ColorOutput "═══════════════════════════════════════════════════════" "Green"
    Write-ColorOutput "  🎉 Installation Complete!" "Green"
    Write-ColorOutput "═══════════════════════════════════════════════════════" "Green"
    Write-Host ""
    Write-ColorOutput "✓ GTA San Andreas Mod Pack v$ModPackVersion has been installed." "White"
    Write-Host ""
    Write-ColorOutput "Next steps:" "Cyan"
    Write-Host "  1. Launch GTA San Andreas from: $GamePath\gta_sa.exe"
    Write-Host "  2. Adjust graphics settings if needed for your hardware"
    Write-Host "  3. Enjoy the enhanced San Andreas experience!"
    Write-Host ""
    Write-ColorOutput "Troubleshooting:" "Yellow"
    Write-Host "  - If the game crashes, try running as Administrator"
    Write-Host "  - For performance issues, lower graphics settings in-game"
    Write-Host "  - To restore original game, copy files from the backup folder"
    Write-Host ""
    Write-ColorOutput "Need help? Visit: https://gta-san-andreas.in/tutorials" "Cyan"
    Write-Host ""
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

# Show help if requested
if ($Help) {
    Show-Help
    exit 0
}

# Display banner
Clear-Host
Write-ColorOutput "═══════════════════════════════════════════════════════" "Cyan"
Write-ColorOutput "  GTA San Andreas Mod Pack Installer" "Cyan"
Write-ColorOutput "  Version $ModPackVersion" "Cyan"
Write-ColorOutput "═══════════════════════════════════════════════════════" "Cyan"
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-ColorOutput "⚠ Warning: Not running as Administrator" "Yellow"
    Write-ColorOutput "  Some operations may fail. Consider running as Administrator." "Yellow"
    Write-Host ""
}

# Find or validate game path
if ($GamePath -eq "") {
    $GamePath = Find-GTASanAndreas
    
    if ($null -eq $GamePath) {
        Write-ColorOutput "✗ GTA San Andreas not found automatically." "Red"
        Write-Host ""
        Write-ColorOutput "Please specify the game path manually:" "Yellow"
        Write-Host "  .\install.ps1 -GamePath 'C:\Path\To\GTA San Andreas'"
        Write-Host ""
        exit 1
    }
} else {
    if (-not (Test-Path "$GamePath\gta_sa.exe")) {
        Write-ColorOutput "✗ gta_sa.exe not found at: $GamePath" "Red"
        Write-ColorOutput "  Please check the path and try again." "Yellow"
        exit 1
    }
    Write-ColorOutput "✓ Using custom game path: $GamePath" "Green"
}

Write-Host ""

# Check disk space
if (-not (Test-DiskSpace $GamePath)) {
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne "y") {
        Write-ColorOutput "Installation cancelled." "Yellow"
        exit 0
    }
}

Write-Host ""

# Create backup
if (-not $SkipBackup) {
    $backupSuccess = Backup-OriginalFiles $GamePath
    if (-not $backupSuccess) {
        $continue = Read-Host "Backup failed. Continue without backup? (y/N)"
        if ($continue -ne "y") {
            Write-ColorOutput "Installation cancelled." "Yellow"
            exit 0
        }
    }
    Write-Host ""
}

# Install mod pack
$installSuccess = Install-ModPack $GamePath
if (-not $installSuccess) {
    Write-ColorOutput "✗ Installation failed. Please check the errors above." "Red"
    exit 1
}

Write-Host ""

# Verify installation
$verifySuccess = Verify-Installation $GamePath
if (-not $verifySuccess) {
    Write-ColorOutput "⚠ Verification found issues. The game may not work correctly." "Yellow"
}

# Show completion message
Show-CompletionMessage $GamePath

# Pause before exit
Write-Host ""
Read-Host "Press Enter to exit"
