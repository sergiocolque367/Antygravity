# Administración Básica de Linux y Docker

Este repositorio contiene la resolución paso a paso de varias tareas comunes de administración en sistemas Linux (específicamente Ubuntu), incluyendo gestión de usuarios, manejo de permisos, búsqueda de archivos, y la instalación completa de Docker.

## Tareas Realizadas

### 1. Creación de un nuevo grupo de usuarios
Creamos un grupo llamado `esbirros`.
```bash
sudo groupadd esbirros
```
**Explicación:** `groupadd` registra el nuevo grupo en el archivo del sistema `/etc/group`.

### 2. Creación del usuario `sergio` con UID específico
Creamos el usuario `sergio` forzando el UID 3196, creando su directorio personal y asignando la consola bash.
```bash
sudo useradd -u 3196 -m -s /bin/bash sergio
```
**Explicación:**
- `-u 3196`: Asigna exactamente el Identificador de Usuario (UID) 3196.
- `-m`: Crea físicamente la carpeta personal en `/home/sergio`.
- `-s /bin/bash`: Asigna `bash` como la terminal por defecto.

### 3. Creación del usuario `paolo` con configuración personalizada
Creamos al usuario `paolo` con UID 4003, pero su carpeta personal estará en `/ezbirros/` en lugar del `/home/` habitual. Además, forzamos que su grupo principal se llame igual que el usuario.
```bash
sudo useradd -u 4003 -d /ezbirros/ -m -U -s /bin/bash paolo
```
**Explicación:**
- `-d /ezbirros/`: Define una ruta no estándar para el *home directory*.
- `-U`: Crea un grupo con el mismo nombre (`paolo`) y lo asigna como grupo principal.

### 4. Búsqueda de archivos por propietario
Buscamos en todo el sistema (`/`) los archivos que le pertenecen a `paolo` y guardamos los resultados en un archivo.
```bash
sudo find / -user paolo > paolo_user 2>/dev/null
```
**Explicación:**
- `find /`: Inicia la búsqueda desde la raíz del sistema.
- `-user paolo`: Filtra los resultados para mostrar solo archivos cuyo dueño es paolo.
- `>`: Redirige la salida estándar hacia el archivo `paolo_user`.
- `2>/dev/null`: Envía los errores (ej. "Permiso denegado" al intentar leer carpetas del sistema) a un agujero negro, manteniendo la salida limpia.

### 5. Filtrado de logs del sistema
Buscamos la palabra "err" de forma insensible a mayúsculas dentro de `/var/log/` y guardamos los resultados en `/root/var.log`.
```bash
sudo bash -c 'grep -rIi "err" /var/log/ > /root/var.log'
```
**Explicación:**
- `grep`: Comando de búsqueda de texto.
- `-rIi`: Búsqueda recursiva (`r`), ignorando archivos binarios (`I`), y sin distinguir mayúsculas/minúsculas (`i`).
- `sudo bash -c '...'`: Envuelve toda la instrucción en una sesión de administrador. Esto es estrictamente necesario porque redirigir (`>`) hacia `/root/` fallaría si solo usamos `sudo` al principio, ya que el redireccionamiento lo ejecuta el usuario original (que no tiene privilegios).

### 6. Instalación oficial de Docker
Realizamos la instalación de Docker usando los repositorios oficiales para asegurar la versión más reciente.

**Paso A: Actualizar e instalar dependencias**
```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
```

**Paso B: Agregar la llave G¡PG oficial de Docker**
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

**Paso C: Agregar el repositorio e instalar Docker**
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

**Paso D: Habilitar y verificar el servicio**
```bash
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run hello-world
```

**Paso E: Post-instalación (Buena Práctica)**
Agregamos al usuario actual al grupo de administradores de Docker para no tener que usar `sudo` en el futuro.
```bash
sudo usermod -aG docker $USER
```
*(Nota: Requiere cerrar sesión y volver a entrar para que los cambios surtan efecto).*

## Script de Automatización
En este repositorio también se incluye el script `setup_tareas.sh` que automatiza todos los pasos anteriores de forma secuencial y desatendida.