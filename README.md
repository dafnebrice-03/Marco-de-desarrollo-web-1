Aplicación de Reservas con Spring Boot 3.5.7 y SQL Server

Stack: Spring Boot 3.5.7, Java 21, SQL Server 2019+, Thymeleaf, Spring Security

PARA EJECUTAR LA APP

1. Verificar SQL Server está corriendo
   - Abre services.msc
   - Busca "SQL Server (SQLEXPRESS)"
   - Si no está en "Running", click derecho → Start

2. Ejecutar la aplicación
   mvn spring-boot:run
   
   O con verificación previa:
   .\EJECUTAR_CON_VERIFICACION.ps1

3. Accede a http://localhost:8080

CONFIGURACIÓN SQL SERVER

Servidor: DESKTOP-9TFAVTI
Puerto: 1433
Base de datos: sobreruedas
Usuario: sa
Contraseña: 123

La BD se crea automáticamente si no existe.

ESTRUCTURA

src/main/java/com/sobreruedas/app/
├── controller/    - Controladores (UsuarioController, ReservaController, etc)
├── model/         - Entidades JPA (Usuario, Reserva, Paquete)
├── service/       - Lógica de negocio
├── repository/    - Acceso a datos
├── config/        - Configuración de seguridad
└── dto/           - Objetos de transferencia

src/main/resources/
├── application.properties      - Config principal SQL Server
├── templates/                  - Templates Thymeleaf
└── static/                     - CSS, JS, imágenes

FUNCIONALIDADES

- Registro de usuarios
- Login con sesiones
- Reserva de paquetes turísticos
- Formulario de contacto
- Seguridad con Spring Security
- Base de datos SQL Server

TROUBLESHOOTING

Si la app no arranca:

1. ¿SQL Server está corriendo?
   Get-Service | Where-Object {$_.Name -like "*SQL*"}
   
2. ¿Puedo conectar a BD?
   sqlcmd -S DESKTOP-P99LE3N\SQLEXPRESS -U Sebastian -P Sebastian

3. ¿Puerto 1433 escucha?
   netstat -an | findstr 1433

4. ¿Tengo Maven instalado?
   mvn -version

Si sigue sin funcionar, verifica application.properties tiene credenciales correctas.
