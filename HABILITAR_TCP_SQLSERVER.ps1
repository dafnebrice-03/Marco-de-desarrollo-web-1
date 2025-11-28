Write-Host "====== HABILITANDO TCP/IP EN SQL SERVER ======" -ForegroundColor Cyan
Write-Host ""

# Verificar si ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "ERROR: Este script debe ejecutarse COMO ADMINISTRADOR" -ForegroundColor Red
    Write-Host ""
    Write-Host "Pasos:" -ForegroundColor Yellow
    Write-Host "1. Abre PowerShell COMO ADMINISTRADOR" -ForegroundColor Yellow
    Write-Host "2. Ejecuta: powershell -NoProfile -ExecutionPolicy Bypass -File `".\HABILITAR_TCP_SQLSERVER.ps1`"" -ForegroundColor Yellow
    exit 1
}

Write-Host "OK - Ejecutando con permisos de administrador" -ForegroundColor Green
Write-Host ""

# Paso 1: Detener el servicio SQL Server
Write-Host "[1] Deteniendo servicio SQL Server..." -ForegroundColor Yellow
Stop-Service -Name "MSSQL`$SQLEXPRESS" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "OK - Servicio detenido" -ForegroundColor Green
Write-Host ""

# Paso 2: Habilitar TCP/IP en el registro
Write-Host "[2] Habilitando TCP/IP en registro..." -ForegroundColor Yellow

$regPath = "HKLM:\SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp"
$regValue = "Enabled"

# Verificar si la ruta existe
if (Test-Path $regPath) {
    # Establecer Enabled = 1
    Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -ErrorAction SilentlyContinue
    Write-Host "OK - TCP/IP habilitado en registro" -ForegroundColor Green
    
    # Verificar
    $enabled = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($enabled.Enabled -eq 1) {
        Write-Host "VERIFICADO: TCP/IP está habilitado (Enabled = 1)" -ForegroundColor Green
    }
} else {
    Write-Host "ERROR: No se encontró la ruta en el registro" -ForegroundColor Red
    Write-Host "Ruta esperada: $regPath" -ForegroundColor Red
}
Write-Host ""

# Paso 3: Iniciar el servicio SQL Server
Write-Host "[3] Reiniciando servicio SQL Server..." -ForegroundColor Yellow
Start-Service -Name "MSSQL`$SQLEXPRESS" -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5
Write-Host "OK - Servicio reiniciado" -ForegroundColor Green
Write-Host ""

# Paso 4: Verificar puerto
Write-Host "[4] Verificando puerto 1433..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
$port = netstat -an | Select-String "1433"
if ($port) {
    Write-Host "OK - Puerto 1433 escuchando" -ForegroundColor Green
    Write-Host $port -ForegroundColor Green
} else {
    Write-Host "ADVERTENCIA - Puerto 1433 aún no escucha. Espera 10 segundos e intenta de nuevo." -ForegroundColor Yellow
}
Write-Host ""

# Paso 5: Crear base de datos
Write-Host "[5] Creando base de datos 'sobreruedas'..." -ForegroundColor Yellow
$dbExists = sqlcmd -S "localhost\SQLEXPRESS" -U "Sebastian" -P "Sebastian" -Q "SELECT name FROM sys.databases WHERE name='sobreruedas';" 2>&1 | Select-String "sobreruedas"

if ($dbExists) {
    Write-Host "OK - Base de datos 'sobreruedas' ya existe" -ForegroundColor Green
} else {
    Write-Host "Creando base de datos..." -ForegroundColor Yellow
    sqlcmd -S "localhost\SQLEXPRESS" -U "Sebastian" -P "Sebastian" -Q "CREATE DATABASE sobreruedas;" 2>&1 | Out-Null
    Write-Host "OK - Base de datos 'sobreruedas' creada" -ForegroundColor Green
}
Write-Host ""

# Resumen final
Write-Host "====== COMPLETADO ======" -ForegroundColor Cyan
Write-Host "Ahora puedes ejecutar la aplicación:" -ForegroundColor Green
Write-Host "  mvn -DskipTests spring-boot:run" -ForegroundColor Gray
Write-Host ""
