1. **Establecer el directorio fuente y el directorio de destino**:
   - `sourceDir=$(pwd)`: Asigna el directorio actual (donde se ejecuta el script) a la variable `sourceDir`.
   - `targetDir="../fotoExtract"`: Establece el directorio de destino relativo como "../fotoExtract" en relación al directorio actual.

2. **Inicializar contadores**:
   - `totalFiles=0`, `copiedFiles=0`, `noDateFiles=0`: Inicializa los contadores para el número total de archivos, archivos copiados y archivos sin fecha, respectivamente.

3. **Crear el directorio de destino si no existe**:
   - `if [ ! -d "$targetDir" ]; then ... fi`: Verifica si el directorio de destino no existe (`! -d "$targetDir"`) y, en caso afirmativo, crea el directorio utilizando el comando `mkdir`.

4. **Habilitar la búsqueda sin distinción entre mayúsculas y minúsculas**:
   - `shopt -s nocaseglob`: Activa la opción `nocaseglob`, que permite que las búsquedas de archivos sean insensibles a mayúsculas y minúsculas.
   - `shopt -s globstar`: Activa la opción `globstar`, que permite el uso de `**` para coincidir con todos los archivos y subdirectorios.

5. **Declarar un array asociativo**:
   - `declare -A copiedFileNames`: Crea un array asociativo llamado `copiedFileNames` para realizar un seguimiento de los nombres de archivo copiados.

6. **Recorrer tipos de archivo especificados**:
   - Un bucle `for` itera a través de las extensiones de archivo especificadas: `jpeg`, `jpg`, `png`, `gif`, `bmp`, `avi`, `mp4`, `mov`.

7. **Recorrer archivos en el directorio actual y subdirectorios**:
   - Otro bucle `for` itera a través de todos los archivos con la extensión actual en el directorio actual y sus subdirectorios utilizando `**/*."$ext"`.

8. **Contar archivos**:
   - Verifica si el archivo es un archivo regular (`-f "$file"`) y, si es así, incrementa el contador `totalFiles`.

9. **Mostrar el número total de archivos encontrados**.

10. **Recorrer nuevamente tipos de archivo especificados**:
    - Se realiza un bucle similar al paso 6 para iterar sobre las mismas extensiones de archivo.

11. **Procesar archivos individuales**:
    - Verifica si el archivo es un archivo regular.
    - Obtiene el nombre de archivo (`filename`) y su parte sin extensión (`filename_noext`).

12. **Buscar un año en el nombre del archivo**:
    - Un bucle `for` recorre los primeros cuatro caracteres del nombre del archivo (`filename_noext`) en busca de un número de cuatro dígitos que esté en el rango deseado. Si se encuentra, se asigna a la variable `year`.

13. **Buscar un mes en el nombre del archivo**:
    - Si se encontró un año válido, otro bucle `for` recorre los siguientes dos caracteres del nombre del archivo en busca de un número de dos dígitos que represente un mes válido (01-12). Si se encuentra, se asigna a la variable `month`.

14. **Crear directorio de destino y copiar archivos**:
    - Si se encontraron un año y un mes válidos, se crea una ruta de subdirectorio basada en el año y el mes en `targetSubDir`. Si no existe, se crea el directorio.
    - Verifica si el archivo ya se ha copiado para evitar duplicados utilizando el array asociativo `copiedFileNames`.
    - Si no se encontraron un año y un mes válidos, el archivo se copia en el subdirectorio `sinFecha`.

15. **Finalizar el proceso**:
    - Se muestra un mensaje de "Proceso completado".
