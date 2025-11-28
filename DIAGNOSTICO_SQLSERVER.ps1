# ================================================================================
# DIAGNÓSTICO COMPLETO DE SQL SERVER
# ================================================================================
# Este script verifica:
# 1. Estado del servicio SQL Server (SQLEXPRESS)
# 2. TCP/IP habilitado en SQL Server Configuration Manager
# 3. Puerto 1433 escuchando
# 4. Conectividad desde la aplicación
# 5. Existencia de base de datos y usuario
# ================================================================================

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  DIAGNÓSTICO DE SQL SERVER" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# ================================================================================
# 1. VERIFICAR ESTADO DEL SERVICIO SQL SERVER
# ================================================================================
Write-Host "[1] Verificando estado del servicio SQL Server..." -ForegroundColor Yellow

$serviceNames = @(
    "MSSQL`$SQLEXPRESS",
    "MSSQLSERVER",
    "MSSQL",
    "MSSQLServer"
)

$serviceFound = $false
foreach ($svc in $serviceNames) {
    try {
        $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($service) {
            Write-Host "✓ Servicio encontrado: $svc" -ForegroundColor Green
            Write-Host "  Estado: $($service.Status)" -ForegroundColor Green
            Write-Host "  Display Name: $($service.DisplayName)" -ForegroundColor Green
            
            if ($service.Status -ne "Running") {
                Write-Host "  ⚠ El servicio NO está ejecutándose. Iniciando..." -ForegroundColor Yellow
                Start-Service -Name $svc -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 2
                $service = Get-Service -Name $svc
                Write-Host "  Nuevo estado: $($service.Status)" -ForegroundColor Green
            }
            $serviceFound = $true
            break
        }
    } catch {
        # Continuar con el siguiente nombre
    }
}

if (-not $serviceFound) {
    Write-Host "✗ NO se encontró ningún servicio SQL Server activo" -ForegroundColor Red
    Write-Host "  Posibles soluciones:" -ForegroundColor Yellow
    Write-Host "  - Instalar SQL Server Express" -ForegroundColor Yellow
    Write-Host "  - Verificar en Servicios (services.msc) que esté registrado" -ForegroundColor Yellow
}
Write-Host ""

# ================================================================================
# 2. VERIFICAR TCP/IP HABILITADO (vía registro o archivo de configuración)
# ================================================================================
Write-Host "[2] Verificando TCP/IP en SQL Server..." -ForegroundColor Yellow

# Intenta leer del registro de Windows
$regPath = "HKLM:\SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp"
try {
    $regKey = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
    if ($regKey) {
        if ($regKey.Enabled -eq 1) {
            Write-Host "✓ TCP/IP está HABILITADO en el registro" -ForegroundColor Green
        } else {
            Write-Host "✗ TCP/IP está DESHABILITADO en el registro" -ForegroundColor Red
            Write-Host "  ACCIÓN: Abrir SQL Server Configuration Manager > Protocolos SQLEXPRESS > TCP/IP > Habilitar" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠ No se pudo leer la configuración del registro (SQL Server podría estar en otra ubicación)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ Error al leer registro: $_" -ForegroundColor Yellow
}
Write-Host ""

# ================================================================================
# 3. VERIFICAR PUERTO 1433 ESCUCHANDO
# ================================================================================
Write-Host "[3] Verificando puerto 1433..." -ForegroundColor Yellow

$netstat = netstat -an | Select-String "1433"
if ($netstat) {
    Write-Host "✓ Puerto 1433 está escuchando:" -ForegroundColor Green
    Write-Host $netstat -ForegroundColor Green
} else {
    Write-Host "✗ Puerto 1433 NO está escuchando" -ForegroundColor Red
    Write-Host "  Posibles causas:" -ForegroundColor Yellow
    Write-Host "  - SQL Server no está iniciado" -ForegroundColor Yellow
    Write-Host "  - TCP/IP no está habilitado" -ForegroundColor Yellow
    Write-Host "  - Firewall bloqueando puerto 1433" -ForegroundColor Yellow
}
Write-Host ""

# ================================================================================
# 4. VERIFICAR CONECTIVIDAD TCP AL PUERTO
# ================================================================================
Write-Host "[4] Probando conexión TCP a localhost:1433..." -ForegroundColor Yellow

try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $result = $tcp.BeginConnect("localhost", 1433, $null, $null)
    $result.AsyncWaitHandle.WaitOne(3000) | Out-Null
    
    if ($tcp.Connected) {
        Write-Host "✓ Conexión TCP exitosa a 127.0.0.1:1433" -ForegroundColor Green
    } else {
        Write-Host "✗ No se pudo conectar a localhost:1433 (timeout)" -ForegroundColor Red
        Write-Host "  Verificar: Firewall, servicio SQL Server, TCP/IP habilitado" -ForegroundColor Yellow
    }
} catch {
    Write-Host "✗ Error en conexión TCP: $_" -ForegroundColor Red
} finally {
    $tcp.Close()
}
Write-Host ""

# ================================================================================
# 5. VERIFICAR CONECTIVIDAD CON SQLCMD
# ================================================================================
Write-Host "[5] Probando conexión con sqlcmd (SQL Server Client Tools)..." -ForegroundColor Yellow

if (Get-Command sqlcmd -ErrorAction SilentlyContinue) {
    Write-Host "✓ sqlcmd encontrado. Intentando conectar..." -ForegroundColor Green
    
    try {
        $result = sqlcmd -S "localhost\SQLEXPRESS" -U "Sebastian" -P "Sebastian" -Q "SELECT @@VERSION;" 2>&1
        if ($result -match "Microsoft SQL Server") {
            Write-Host "✓ Conexión con sqlcmd exitosa:" -ForegroundColor Green
            Write-Host $result[0..2] -ForegroundColor Green
        } else {
            Write-Host "✗ sqlcmd no pudo conectar" -ForegroundColor Red
            Write-Host $result -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ Error ejecutando sqlcmd: $_" -ForegroundColor Red
    }
} else {
    Write-Host "⚠ sqlcmd NO está instalado. Se necesita SQL Server Client Tools" -ForegroundColor Yellow
    Write-Host "  ACCIÓN: Instalar SQL Server Tools o usar SSMS" -ForegroundColor Yellow
}
Write-Host ""

# ================================================================================
# 6. VERIFICAR FIREWALL
# ================================================================================
Write-Host "[6] Verificando Firewall de Windows para puerto 1433..." -ForegroundColor Yellow

try {
    $firewallRules = Get-NetFirewallRule -DisplayName "*SQL*" -Direction Inbound -ErrorAction SilentlyContinue | Where-Object { $_.Enabled -eq $true }
    if ($firewallRules) {
        Write-Host "✓ Reglas de firewall SQL Server encontradas:" -ForegroundColor Green
        $firewallRules | ForEach-Object { Write-Host "  - $($_.DisplayName)" -ForegroundColor Green }
    } else {
        Write-Host "⚠ No hay reglas de firewall activas para SQL Server" -ForegroundColor Yellow
        Write-Host "  ACCIÓN: Abrir Firewall > Reglas de entrada > Nueva regla > Puerto 1433" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ Error al verificar firewall: $_" -ForegroundColor Yellow
}
Write-Host ""

# ================================================================================
# 7. VERIFICAR BASE DE DATOS Y USUARIO
# ================================================================================
Write-Host "[7] Buscando base de datos 'sobreruedas'..." -ForegroundColor Yellow

if (Get-Command sqlcmd -ErrorAction SilentlyContinue) {
    try {
        $dbCheck = sqlcmd -S "localhost\SQLEXPRESS" -U "Sebastian" -P "Sebastian" -Q "SELECT name FROM sys.databases WHERE name='sobreruedas';" 2>&1 | Out-String
        if ($dbCheck -match "sobreruedas") {
            Write-Host "✓ Base de datos 'sobreruedas' existe" -ForegroundColor Green
        } else {
            Write-Host "✗ Base de datos 'sobreruedas' NO existe" -ForegroundColor Red
            Write-Host "  ACCIÓN: Crear base de datos antes de ejecutar la aplicación" -ForegroundColor Yellow
            Write-Host "  Script:" -ForegroundColor Yellow
            Write-Host "    sqlcmd -S localhost\SQLEXPRESS -U Sebastian -P Sebastian -Q `"CREATE DATABASE sobreruedas;`"" -ForegroundColor Gray
        }
    } catch {
        Write-Host "⚠ Error verificando base de datos: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠ No se puede verificar BD sin sqlcmd" -ForegroundColor Yellow
}
Write-Host ""

# ================================================================================
# 8. RESUMEN Y RECOMENDACIONES
# ================================================================================
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  RESUMEN Y PRÓXIMOS PASOS" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Si TODO está en verde ✓:" -ForegroundColor Green
Write-Host "  → La aplicación debería conectarse correctamente" -ForegroundColor Green
Write-Host "  → Ejecuta: mvn -DskipTests spring-boot:run" -ForegroundColor Green
Write-Host ""

Write-Host "Si hay rojo ✗ o amarillo ⚠:" -ForegroundColor Yellow
Write-Host "  1. Inicia el servicio SQL Server (Get-Service MSSQL`$SQLEXPRESS | Start-Service)" -ForegroundColor Yellow
Write-Host "  2. Abre SQL Server Configuration Manager" -ForegroundColor Yellow
Write-Host "     - Habilita TCP/IP en Protocolos para SQLEXPRESS" -ForegroundColor Yellow
Write-Host "     - Reinicia la instancia" -ForegroundColor Yellow
Write-Host "  3. Abre Windows Firewall y permite puerto 1433" -ForegroundColor Yellow
Write-Host "  4. Crea la base de datos 'sobreruedas' si no existe" -ForegroundColor Yellow
Write-Host "  5. Vuelve a ejecutar este diagnóstico" -ForegroundColor Yellow
Write-Host ""

Write-Host "Para crear la BD manualmente (en SSMS o sqlcmd):" -ForegroundColor Cyan
Write-Host "  sqlcmd -S localhost\SQLEXPRESS -U Sebastian -P Sebastian -Q `"CREATE DATABASE sobreruedas;`"" -ForegroundColor Gray
Write-Host ""
