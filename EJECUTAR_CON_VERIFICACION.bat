@echo off
REM Script para verificar conexión a SQL Server antes de ejecutar Spring Boot
REM Soluciona el problema de HikariPool que se queda esperando

echo.
echo ============================================
echo VERIFICACION DE CONEXION A SQL SERVER
echo ============================================
echo.

REM Obtener variables
set SERVER=DESKTOP-P99LE3N
set INSTANCE=SQLEXPRESS
set DB=sobreruedas
set USER=Sebastian
set PASS=Sebastian

echo Servidor: %SERVER%\%INSTANCE%
echo Base de Datos: %DB%
echo Usuario: %USER%
echo.

REM 1. Verificar que SQL Server está corriendo
echo [1/3] Verificando que SQL Server está corriendo...
tasklist | findstr /I "sqlservr.exe" >nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ SQL Server está corriendo
) else (
    echo ❌ SQL Server NO está corriendo
    echo.
    echo Por favor inicia SQL Server:
    echo   - Abre: services.msc
    echo   - Busca: SQL Server (SQLEXPRESS)
    echo   - Click derecho → Start
    echo.
    pause
    exit /b 1
)

echo.

REM 2. Intentar conectar a SQL Server con sqlcmd
echo [2/3] Intentando conectar a SQL Server...
sqlcmd -S %SERVER%\%INSTANCE% -U %USER% -P %PASS% -d %DB% -Q "SELECT 1" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Conexion a SQL Server EXITOSA
) else (
    echo ❌ No se pudo conectar a SQL Server
    echo.
    echo Posibles causas:
    echo   1. SQL Server no está corriendo (verifica en services.msc)
    echo   2. Credenciales incorrectas (Usuario: %USER%, Pass: %PASS%)
    echo   3. Base de datos '%DB%' no existe
    echo   4. Servidor no existe o no es accesible
    echo.
    pause
    exit /b 1
)

echo.

REM 3. Verificar que la BD existe
echo [3/3] Verificando base de datos '%DB%'...
sqlcmd -S %SERVER%\%INSTANCE% -U %USER% -P %PASS% -Q "USE %DB%; SELECT COUNT(*) as 'Tablas' FROM INFORMATION_SCHEMA.TABLES;" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Base de datos '%DB%' existe y es accesible
) else (
    echo ⚠️  Advertencia: No se pudo acceder a la BD (será creada automáticamente por JPA)
)

echo.
echo ============================================
echo ✅ TODO VERIFICADO - Puedes ejecutar la app
echo ============================================
echo.
echo Ejecutando: mvn spring-boot:run
echo.

cd /d C:\Users\USER\OneDrive\Desktop\app_spring-main
call mvn spring-boot:run

pause
