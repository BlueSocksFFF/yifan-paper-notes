# Sync Paper Notes from Obsidian to Quartz
# Run this script to update your website content

$ObsidianBase = "D:\张一帆\AI-Knowledge-Base"
$QuartzContent = "C:\Users\12425\Documents\Projects\yifan-paper-notes\content"

Write-Host "🔄 Syncing paper notes to Quartz..." -ForegroundColor Cyan

# Clear existing content (except .gitkeep)
Get-ChildItem -Path $QuartzContent -Force | Where-Object { $_.Name -ne ".gitkeep" } | Remove-Item -Recurse -Force

# Create folder structure
$folders = @(
    "01-AI4Science",
    "01-AI4Science/Papers",
    "01-AI4Science/Summaries",
    "02-Agent",
    "02-Agent/Papers",
    "02-Agent/Memory-Mechanisms",
    "03-Memory-in-AI",
    "03-Memory-in-AI/Papers",
    "03-Memory-in-AI/Biological-Inspired"
)

foreach ($folder in $folders) {
    $targetPath = Join-Path $QuartzContent $folder
    if (!(Test-Path $targetPath)) {
        New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
    }
}

# Copy paper folders
$paperFolders = @(
    "01-AI4Science/Papers",
    "01-AI4Science/Summaries",
    "02-Agent/Papers",
    "02-Agent/Memory-Mechanisms",
    "03-Memory-in-AI/Papers",
    "03-Memory-in-AI/Biological-Inspired"
)

foreach ($folder in $paperFolders) {
    $sourcePath = Join-Path $ObsidianBase $folder
    $targetPath = Join-Path $QuartzContent $folder
    
    if (Test-Path $sourcePath) {
        Write-Host "  📄 Copying: $folder" -ForegroundColor Gray
        Get-ChildItem -Path $sourcePath -Filter "*.md" | Copy-Item -Destination $targetPath -Force
    }
}

# Copy MOC files (Map of Content - these are like index pages)
$mocFiles = @(
    "00-Meta/AI4Science-MOC.md",
    "00-Meta/Agent-MOC.md",
    "00-Meta/Memory-MOC.md"
)

foreach ($moc in $mocFiles) {
    $sourcePath = Join-Path $ObsidianBase $moc
    $targetPath = Join-Path $QuartzContent $moc
    
    if (Test-Path $sourcePath) {
        $targetDir = Split-Path $targetPath -Parent
        if (!(Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        Write-Host "  📑 Copying MOC: $moc" -ForegroundColor Gray
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
    }
}

Write-Host "✅ Sync complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run: npx quartz build --serve" -ForegroundColor White
Write-Host "  2. Open: http://localhost:8080" -ForegroundColor White
