# Script para ver en TIEMPO REAL qué está pasando con la conexión

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "DIAGNÓSTICO EN TIEMPO REAL - SQL SERVER" -ForegroundColor Cyan  
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Variables
$server = "DESKTOP-P99LE3N"
$instance = "SQLEXPRESS"
$db = "sobreruedas"
$user = "Sebastian"
$pass = "Sebastian"
$port = 1433

Write-Host "📊 INFORMACIÓN DEL SERVIDOR" -ForegroundColor Yellow
Write-Host "   Servidor: $server\$instance" -ForegroundColor White
Write-Host "   Puerto: $port" -ForegroundColor White
Write-Host "   Base de datos: $db" -ForegroundColor White
Write-Host "   Usuario: $user" -ForegroundColor White
Write-Host ""

# 1. Verificar SQL Server
Write-Host "1️⃣  VERIFICANDO SQL SERVER" -ForegroundColor Yellow
Write-Host "   Buscando proceso sqlservr.exe..." -ForegroundColor Gray

$sqlProcesses = Get-Process | Where-Object { $_.ProcessName -like "*sqlservr*" }

if ($sqlProcesses) {
    Write-Host "   ✅ SQL Server está CORRIENDO" -ForegroundColor Green
    Write-Host "      Procesos encontrados:" -ForegroundColor White
    foreach ($proc in $sqlProcesses) {
        Write-Host "      - $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor White
    }
} else {
    Write-Host "   ❌ SQL Server NO está corriendo" -ForegroundColor Red
    Write-Host "   Solución:" -ForegroundColor Yellow
    Write-Host "      1. Abre: services.msc" -ForegroundColor White
    Write-Host "      2. Busca: SQL Server (SQLEXPRESS)" -ForegroundColor White
    Write-Host "      3. Click derecho → Reiniciar" -ForegroundColor White
    exit 1
}

Write-Host ""

# 2. Verificar puerto
Write-Host "2️⃣  VERIFICANDO PUERTO 1433" -ForegroundColor Yellow
Write-Host "   Verificando si el puerto está listening..." -ForegroundColor Gray

$portListening = (netstat -an | Select-String "$port.*LISTENING")

if ($portListening) {
    Write-Host "   ✅ Puerto 1433 está LISTENING" -ForegroundColor Green
    Write-Host "      $portListening" -ForegroundColor White
} else {
    Write-Host "   ⚠️  Puerto 1433 no está listening" -ForegroundColor Yellow
    Write-Host "   Esto significa SQL Server puede no haber iniciado correctamente" -ForegroundColor Yellow
}

Write-Host ""

# 3. Prueba de conectividad TCP
Write-Host "3️⃣  PRUEBA DE CONECTIVIDAD TCP" -ForegroundColor Yellow
Write-Host "   Intentando conectar a $server`:$port..." -ForegroundColor Gray

try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.ConnectAsync($server, $port).Wait(5000)
    
    if ($tcpClient.Connected) {
        Write-Host "   ✅ Conexión TCP EXITOSA a puerto $port" -ForegroundColor Green
        $tcpClient.Close()
    } else {
        Write-Host "   ❌ No se pudo conectar al puerto $port" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Error de conectividad TCP: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 4. Verificar configuración SQL Server
Write-Host "4️⃣  VERIFICANDO CONFIGURACIÓN SQL SERVER" -ForegroundColor Yellow
Write-Host "   Leyendo versión de SQL Server..." -ForegroundColor Gray

$connectionString = "Server=$server\$instance;Integrated Security=true;Connection Timeout=5;"

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT @@VERSION as Version"
    $result = $command.ExecuteScalar()
    
    Write-Host "   ✅ SQL Server version:" -ForegroundColor Green
    Write-Host "      $result" -ForegroundColor White
    
    $connection.Close()
} catch {
    Write-Host "   ⚠️  No se pudo leer versión (puede ser permiso)" -ForegroundColor Yellow
}

Write-Host ""

# 5. Prueba de conexión con credenciales
Write-Host "5️⃣  PRUEBA DE CONEXIÓN CON CREDENCIALES" -ForegroundColor Yellow
Write-Host "   Usuario: $user" -ForegroundColor Gray
Write-Host "   Probando conexión..." -ForegroundColor Gray

$connectionString = "Server=$server\$instance;Database=master;User Id=$user;Password=$pass;TrustServerCertificate=True;Encrypt=False;Connection Timeout=5;"

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    
    Write-Host "   ✅ CONEXIÓN EXITOSA con usuario '$user'" -ForegroundColor Green
    
    # Verificar bases de datos disponibles
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT name FROM sys.databases WHERE database_id > 4 ORDER BY name"
    $reader = $command.ExecuteReader()
    
    Write-Host "   📚 Bases de datos disponibles:" -ForegroundColor White
    $found = $false
    while ($reader.Read()) {
        $dbName = $reader["name"]
        if ($dbName -eq $db) {
            Write-Host "      ✅ $dbName (TARGET)" -ForegroundColor Green
            $found = $true
        } else {
            Write-Host "      - $dbName" -ForegroundColor White
        }
    }
    
    if (-not $found) {
        Write-Host "      ⚠️  Base de datos '$db' NO ENCONTRADA" -ForegroundColor Yellow
        Write-Host "      (Será creada automáticamente por JPA)" -ForegroundColor Yellow
    }
    
    $reader.Close()
    $connection.Close()
} catch {
    Write-Host "   ❌ ERROR EN CONEXIÓN:" -ForegroundColor Red
    Write-Host "      $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Posibles causas:" -ForegroundColor Yellow
    Write-Host "      - Credenciales incorrectas" -ForegroundColor White
    Write-Host "      - Usuario no existe" -ForegroundColor White
    Write-Host "      - SQL Server requiere autenticación de Windows" -ForegroundColor White
}

Write-Host ""

# Resumen final
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "✅ DIAGNÓSTICO COMPLETADO" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Ahora puedes ejecutar:" -ForegroundColor Yellow
Write-Host "   mvn spring-boot:run" -ForegroundColor Cyan
Write-Host ""
Write-Host "La aplicación estará disponible en:" -ForegroundColor Yellow
Write-Host "   http://localhost:8080" -ForegroundColor Cyan
Write-Host ""

Read-Host "Presiona ENTER para salir"
