@echo off
REM Reiniciar SQL Server SQLEXPRESS
REM Este script debe ejecutarse COMO ADMINISTRADOR

cd C:\Users\USER\OneDrive\Desktop\app_spring-main

cls
echo ====== REINICIANDO SQL SERVER ======
echo.

echo [1] Deteniendo servicio...
net stop MSSQL$SQLEXPRESS /y
timeout /t 3

echo.
echo [2] Iniciando servicio...
net start MSSQL$SQLEXPRESS
timeout /t 5

echo.
echo [3] Verificando puerto 1433...
netstat -an | findstr "1433"

echo.
echo [4] Buscando base de datos 'sobreruedas'...
sqlcmd -S localhost\SQLEXPRESS -U Sebastian -P Sebastian -Q "SELECT name FROM sys.databases WHERE name='sobreruedas';"

if errorlevel 1 (
    echo.
    echo Base de datos no existe. Creando...
    sqlcmd -S localhost\SQLEXPRESS -U Sebastian -P Sebastian -Q "CREATE DATABASE sobreruedas;"
    echo Base de datos creada.
) else (
    echo Base de datos ya existe.
)

echo.
echo ====== COMPLETADO ======
echo Ejecuta: mvn -DskipTests spring-boot:run
pause
