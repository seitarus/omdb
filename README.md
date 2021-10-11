# OMDB iOS Swift
Poryecto de ejemplo de cómo usar la API de OMDB.

Este proyecto de ejemplo esta desarrollado con XCode 13.0 y en el lenguaje Swift 5, usando la arquitectura MVVM. 
La APP muestra una pantalla principal en la que se puede realizar una búsqueda por título de película y se consulta a la API de OMDB (https://www.omdbapi.com) Desde el listado de resultados se puede acceder a una pantalla de detalle de cada película. Unit Test for the Api call is also Included in this sample project.

# Qué es MVVM ?

MVVM fue propuesto por John Gossman en 2005. El propósito principal de MVVM es mover el estado de los datos de la Vista al Modelo de Vista.

Según la definición, la Vista consta únicamente de elementos visuales. En la vista, solo hacemos cosas como el diseño, la animación, la inicialización de componentes de la interfaz de usuario, etc. Hay una capa especial entre la vista y el modelo llamada ViewModel. ViewModel es una representación canónica de View. Es decir, ViewModel proporciona un conjunto de interfaces, cada una de las cuales representa un componente de la interfaz de usuario en la vista. Usamos una técnica llamada "enlace" para conectar los componentes de la interfaz de usuario a las interfaces de ViewModel. Entonces, en MVVM, no tocamos la Vista directamente, nos ocupamos de la lógica empresarial en el Modelo de Vista y, por lo tanto, la Vista cambia en consecuencia. Escribimos cosas de presentación como convertir Date a String en ViewModel en lugar de View. Por lo tanto, es posible escribir una prueba más simple para la lógica de presentación sin conocer la implementación de la Vista.

# Screen shots

![solarized dualmode](https://github.com/seitarus/omdb/blob/main/Screen%20shots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20-%202021-10-11%20at%2018.28.00.png)
![solarized dualmode](https://github.com/seitarus/omdb/blob/main/Screen%20shots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20-%202021-10-11%20at%2018.28.05.png)

# Archivos principales

* SearchListViewController.swift     - Dashboard class
* MovieDetailViewController.swift    - Details screen class
* MoviesListViewModel.swift          - View model class
* MovieDetailViewModel.swift         - View model class
* APIService.swift                   - Api Servie class 
