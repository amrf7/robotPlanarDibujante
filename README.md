# Robot Planar Dibujante
Esta apliación que nos permite a partir de una imagen, ya sea por webcam o un archivo (.jpg, .jpeg), obtener las coordenadas cartesianas que le permitirán dibujar la imagen a un robot planar de 3 grados de libertad.

# Motivación
Este proyecto fue creado como un challenge para la evaluación final de la materia de Robótica (LMT4051-2). 

# Requerimientos
Para usar esta aplicación se necesitan los siguientes toolbox:
-  Robotic's Toolbox de Peter Corke
- Image Acquisition Toolbox Support Package for OS Generic Video Interface
- Image Acquisition Toolbox Supoort Package for DCAM Hardware
- Image Processing Toolbox
- Image Acquisition Toolbox
- MATLAB Support Package for USB Webcams

# Descripción de la interfaz
La interfaz generada en MATLAB se compone de los siguientes elementos:
- **Vista previa:** en esta figura podremos observar la imagen de la cámara, la captura de la misma o la imagen seleccionada. Así mismo, nos permite observar la imagen filtrada tras actualizar el filtro.
- **Selección de imagen:** Contiene las distintas opciones para la selección de imagen.
    * _Iniciar Cámara_ activa la cámara por default del sistema y transmite la imagen en vista previa.
    * _Capturar Imagen_ nos permite tomar una foto con la webcam.
    * _Seleccionar Imagen_ abre el explorador de archivos y nos permite seleccionar una imagen en los formatos *.jpg, o *.jpeg.
    * _Limpiar_ permite limpiar la figura de vista previa.
- **Procesamiento de imagen:** Contiene el control para la detección de bordes. 
    * Para la detección de bordes se utilizó un filtro Canny, el cual requiere de un pre-procesamiento con un filtro gaussiano. El slider _Sigma_ le permite al usuario modificar la magnitud del filtro gaussiano, lo que permite aumentar o disminuir la cantidad de bordes detectados.
    * _Actualizar filtro de pantalla_ nos permite previsualizar la imagen procesada de acuerdo al _Sigma_ seleccionado.
    * _Aceptar cambios_ nos permite guardar la configuración y es necesario presionarla antes de realizar cualquier animación. 
- **Animación:** Contiene las dos animaciones del robot disponibles.
    * _Animation_ik_ nos permite observar la animación del robot en una figura 2D de MATLAB. Esta animación utiliza elementos _SE2_ del toolbox de Peter Corke. 
    * _Animation_ik_TB_ nos permite observar la animación del robot generada por un objeto _Robot_ del toolbox de Peter Corke. Mientras el robot se encuentre dibujando, sólo es posible tener una vista superior; al finalizar el dibujo es posible rotar la figura para observar el robot en 3D. 

<div align="center">
<img src="./resources/gui.png" alt="GUI" width = 75%>
<p align="center"><em> Captura de pantalla de la interfaz </em></p>
</div>

# Funcionamiento
Pueden encontrarse videos del funcionamiento de esta aplicación para distintos casos en el siguiente [link](https://youtu.be/5BYJgvd3Z4k).

# Autoría
Este proyecto fue creado por el Equipo 1, IDs: 158885, 159928, 160228, 160519.