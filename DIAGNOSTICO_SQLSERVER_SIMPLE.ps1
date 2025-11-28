Write-Host "====== DIAGNOSTICO DE SQL SERVER ======" -ForegroundColor Cyan
Write-Host ""

# 1. Estado del servicio
Write-Host "[1] Estado del servicio SQL Server:" -ForegroundColor Yellow
$svc = Get-Service -Name "MSSQL`$SQLEXPRESS" -ErrorAction SilentlyContinue
if ($svc) {
    if ($svc.Status -eq "Running") {
        Write-Host "OK - Servicio EJECUTANDOSE" -ForegroundColor Green
    } else {
        Write-Host "ERROR - Servicio DETENIDO. Iniciando..." -ForegroundColor Red
        Start-Service -Name "MSSQL`$SQLEXPRESS" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "Intenta de nuevo en 5 segundos..." -ForegroundColor Yellow
    }
} else {
    Write-Host "ERROR - Servicio NO ENCONTRADO" -ForegroundColor Red
}
Write-Host ""

# 2. Puerto escuchando
Write-Host "[2] Verificando puerto 1433:" -ForegroundColor Yellow
$port = netstat -an | Select-String "1433"
if ($port) {
    Write-Host "OK - Puerto 1433 escuchando" -ForegroundColor Green
    Write-Host $port -ForegroundColor Green
} else {
    Write-Host "ERROR - Puerto 1433 NO escuchando" -ForegroundColor Red
}
Write-Host ""

# 3. Conectividad TCP
Write-Host "[3] Prueba conexion TCP a localhost:1433:" -ForegroundColor Yellow
$tcp = New-Object System.Net.Sockets.TcpClient
$result = $tcp.BeginConnect("localhost", 1433, $null, $null)
$result.AsyncWaitHandle.WaitOne(2000) | Out-Null
if ($tcp.Connected) {
    Write-Host "OK - Conexion TCP exitosa" -ForegroundColor Green
} else {
    Write-Host "ERROR - No se conecta a puerto 1433" -ForegroundColor Red
}
$tcp.Close()
Write-Host ""

# 4. sqlcmd disponible
Write-Host "[4] Buscando sqlcmd:" -ForegroundColor Yellow
if (Get-Command sqlcmd -ErrorAction SilentlyContinue) {
    Write-Host "OK - sqlcmd esta disponible" -ForegroundColor Green
} else {
    Write-Host "ERROR - sqlcmd NO encontrado (necesitas SQL Server Client Tools)" -ForegroundColor Red
}
Write-Host ""

# 5. Resumen
Write-Host "====== PROXIMOS PASOS ======" -ForegroundColor Cyan
Write-Host "1. Si todo esta en VERDE: mvn -DskipTests spring-boot:run" -ForegroundColor Green
Write-Host "2. Si hay ROJO, ejecuta en cmd COMO ADMINISTRADOR:" -ForegroundColor Yellow
Write-Host "   net start MSSQL`$SQLEXPRESS" -ForegroundColor Gray
Write-Host "3. Abre SQL Server Configuration Manager:" -ForegroundColor Yellow
Write-Host "   - Habilita TCP/IP para SQLEXPRESS" -ForegroundColor Gray
Write-Host "   - Reinicia SQL Server" -ForegroundColor Gray
Write-Host "4. Abre Windows Firewall y permite puerto 1433 (entrada)" -ForegroundColor Yellow
Write-Host "5. En SSMS o sqlcmd, crea la BD: CREATE DATABASE sobreruedas;" -ForegroundColor Yellow
Write-Host ""
