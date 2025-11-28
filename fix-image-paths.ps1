$htmlFiles = Get-ChildItem -Path "src\main\resources\templates" -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Reemplazar /Images/ por /images/
    $content = $content -replace '"/Images/', '"/images/'
    $content = $content -replace "'/Images/", "'/images/"
    
    # Actualizar el archivo solo si se hicieron cambios
    Set-Content -Path $file.FullName -Value $content -NoNewline
}

Write-Host "Se han corregido todas las rutas de imágenes."