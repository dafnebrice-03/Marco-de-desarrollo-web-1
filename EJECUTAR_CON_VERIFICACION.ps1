# Script PowerShell para verificar conexión a SQL Server antes de ejecutar Spring Boot

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "VERIFICACION DE CONEXION A SQL SERVER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$server = "DESKTOP-P99LE3N"
$instance = "SQLEXPRESS"
$db = "sobreruedas"
$user = "Sebastian"
$pass = "Sebastian"

Write-Host "Servidor: $server\$instance" -ForegroundColor White
Write-Host "Base de Datos: $db" -ForegroundColor White
Write-Host "Usuario: $user" -ForegroundColor White
Write-Host ""

# 1. Verificar que SQL Server está corriendo
Write-Host "[1/4] Verificando que SQL Server está corriendo..." -ForegroundColor Yellow

$sqlProcess = Get-Process | Where-Object { $_.ProcessName -like "*sqlservr*" }

if ($sqlProcess) {
    Write-Host "✅ SQL Server está corriendo" -ForegroundColor Green
} else {
    Write-Host "❌ SQL Server NO está corriendo" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor inicia SQL Server:" -ForegroundColor Yellow
    Write-Host "  - Abre: services.msc" -ForegroundColor White
    Write-Host "  - Busca: SQL Server (SQLEXPRESS)" -ForegroundColor White
    Write-Host "  - Click derecho → Start" -ForegroundColor White
    Write-Host ""
    Read-Host "Presiona ENTER para continuar"
    exit 1
}

Write-Host ""

# 2. Intentar conectar a SQL Server
Write-Host "[2/4] Intentando conectar a SQL Server..." -ForegroundColor Yellow

$connectionString = "Server=$server\$instance;Database=$db;User Id=$user;Password=$pass;TrustServerCertificate=True;Encrypt=False;"

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    $connection.Close()
    Write-Host "✅ Conexión a SQL Server EXITOSA" -ForegroundColor Green
} catch {
    Write-Host "❌ No se pudo conectar a SQL Server" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "  1. SQL Server no está corriendo (verifica en services.msc)" -ForegroundColor White
    Write-Host "  2. Credenciales incorrectas (Usuario: $user, Pass: $pass)" -ForegroundColor White
    Write-Host "  3. Base de datos '$db' no existe" -ForegroundColor White
    Write-Host "  4. Servidor no existe o no es accesible" -ForegroundColor White
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Read-Host "Presiona ENTER para continuar"
    exit 1
}

Write-Host ""

# 3. Verificar que la BD existe y tiene tablas
Write-Host "[3/4] Verificando base de datos '$db'..." -ForegroundColor Yellow

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT COUNT(*) as TableCount FROM INFORMATION_SCHEMA.TABLES"
    $result = $command.ExecuteScalar()
    $connection.Close()
    Write-Host "✅ Base de datos '$db' existe con $result tabla(s)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Advertencia: No se pudo acceder a la BD (será creada automáticamente por JPA)" -ForegroundColor Yellow
}

Write-Host ""

# 4. Info final
Write-Host "[4/4] Preparando para ejecutar la aplicación..." -ForegroundColor Yellow

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "✅ TODO VERIFICADO - Iniciando aplicación" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "La aplicación se inicia en: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""

# Ejecutar Maven
Set-Location "C:\Users\USER\OneDrive\Desktop\app_spring-main"
& mvn spring-boot:run

Read-Host "Presiona ENTER para salir"
