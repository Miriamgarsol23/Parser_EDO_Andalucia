# Analizador Léxico de Datos Epidemiológicos de Andalucía (EDO) 🦠📊

> Práctica de la asignatura **Modelos de Computación**.
> **Universidad de Granada (UGR)** - Doble Grado en Ingeniería Informática y Matemáticas.

Este proyecto implementa un escáner léxico avanzado utilizando **Flex** y **C++** para automatizar la extracción, filtrado y estructuración de datos sobre **Enfermedades de Declaración Obligatoria (EDO)** desde el portal oficial de la Junta de Andalucía.

## 🚀 Funcionalidades

* **Adquisición Dinámica:** Integra `curl` para descargar automáticamente los datos más recientes desde el servidor de la Junta (`STPivot.jsp`) si no se detecta un fichero local.
* **Parsing de Datos Crudos:** Analiza el formato de exportación XML/Pivot (basado en atributos `caption` y `val`) en lugar de HTML visual.
* **Filtro "Nuclear":** Implementa lógica semántica en C++ para discriminar entre datos epidemiológicos reales y metadatos/ruido (cabeceras, totales, etc.).
* **Autómata Implícito:** Reconstruye la estructura tabular (12 columnas: Hombres/Mujeres por edad) a partir de un flujo lineal de tokens.
* **Interfaz CLI:** Menú interactivo en terminal para consultar estadísticas detalladas por enfermedad.

## 🛠️ Tecnologías Utilizadas

* **Flex (Fast Lexical Analyzer Generator):** Para la tokenización y definición de reglas léxicas.
* **C++ (STL):** Para la lógica de negocio, estructuras de datos (`std::vector`) y gestión de flujos.
* **cURL:** Para la peticiones HTTP al servidor de datos.
* **Make:** Para la automatización de la compilación.

## 📋 Requisitos

Para ejecutar este proyecto necesitas un entorno Linux/Unix con:
* `g++`
* `flex`
* `make`
* `curl`

En Ubuntu/Debian puedes instalarlo con:
```bash
sudo apt-get install flex g++ make curl
⚙️ Instalación y Ejecución
Sigue estos pasos para poner en marcha el analizador:

1. Clonar el repositorio
Descarga el código fuente a tu máquina local (asegúrate de usar tu usuario real):

Bash

git clone [https://github.com/TU_USUARIO/EDO-Andalucia-Parser.git](https://github.com/TU_USUARIO/EDO-Andalucia-Parser.git)
cd EDO-Andalucia-Parser
2. Compilar
Ejecuta el comando make en la raíz del proyecto. Esto invocará a flex para generar el código intermedio y a g++ para crear el ejecutable final ANALIZADOR.

Bash

make
3. Ejecutar
Inicia el programa. Si es la primera vez, te preguntará si deseas descargar los datos oficiales.

Bash

make run
# O alternativamente: ./ANALIZADOR
4. Limpiar (Opcional)
Para borrar los ejecutables generados y eliminar el fichero de datos data.html (útil para forzar una nueva descarga):

Bash

make clean
📂 Estructura del Proyecto
El repositorio está organizado de la siguiente manera:

analizador.l: Archivo principal. Contiene las definiciones regulares de Flex, las reglas de tokenización y la lógica de negocio en C++ (incluyendo el main).

Makefile: Script de configuración para automatizar la compilación y limpieza del proyecto.

docs/: Directorio que contiene la documentación y la memoria detallada de la práctica.

.gitignore: Configuración para excluir binarios y archivos temporales del control de versiones.

✒️ Autores
Trabajo realizado por:

Miriam García Sollo

Juana María Rascón Contreras

Este proyecto ha sido desarrollado con fines puramente académicos para la asignatura de Modelos de Computación.
