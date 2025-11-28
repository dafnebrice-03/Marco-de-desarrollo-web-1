@echo off
REM Script para configurar SQL Server escuchando en puerto 1433
REM DEBE ejecutarse COMO ADMINISTRADOR

cls
echo ====== CONFIGURANDO PUERTO 1433 EN SQL SERVER ======
echo.

echo [1] Deteniendo servicio SQL Server...
net stop MSSQL$SQLEXPRESS /y
timeout /t 3

echo.
echo [2] Modificando registro para puerto 1433...

REM Configurar puerto TCP en el registro
reg add "HKLM\SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d 1433 /f
echo Registro actualizado: TcpPort = 1433

reg add "HKLM\SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp" /v Enabled /t REG_DWORD /d 1 /f
echo Registro actualizado: TCP Enabled = 1

echo.
echo [3] Iniciando servicio SQL Server...
net start MSSQL$SQLEXPRESS
timeout /t 5

echo.
echo [4] Verificando puerto 1433...
netstat -an | findstr "1433"

if errorlevel 1 (
    echo ERROR: Puerto 1433 aun no escucha
    echo Intenta manualmente:
    echo   - Abre SQL Server Configuration Manager
    echo   - Ve a: Protocolos para SQLEXPRESS
    echo   - Haz clic derecho en TCP/IP > Deshabilitar
    echo   - Espera 5 segundos
    echo   - Haz clic derecho en TCP/IP > Habilitar
    echo   - Reinicia SQL Server
) else (
    echo OK: Puerto 1433 escuchando
)

echo.
echo ====== COMPLETADO ======
pause
