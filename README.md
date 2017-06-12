# Ludotecapp
Aplicación para la gestión de la ludoteca en jornadas y eventos de juegos de mesa.
Tradicionalmente este proceso se ha realizado de forma manual, pero conforme ha ido creciendo el número de asistentes (1.700 jugadores en la última edición) se ha detectado la necesidad de automatizar los procesos para agilizar la gestión de la misma.

## Funcionalidades
Para tratar que se entienda mejor el proceso, trataremos de definir las principales funcionalidades, quedando algunas de ellas pendientes de un mayor nivel de detalle.

Puede acceder al desarrollo de la idea de proyecto a través del siguiente enlace:

https://gist.github.com/targess/3f340914bd503e0322025850965a489f

## Puesta en marcha
Para instalar Ludotecapp debe realizar los siguientes pasos:

Clonar el repositorio:
```
git clone git@github.com:targess/ludotecapp.git
```

Realizar bundle install:
```
% bundle
```

Realizar el reseteo de la DB con una carga de datos inicial:
```
% rails db:reset BOARDGAMES=usuario_bgg
```

Si deseas realizar la carga inicial a partir de un usuario concreto de la BGG:
```
% rails db:reset BOARDGAMES=usuario_bgg
```

## Acceso
Tras la puesta en marcha, podrás acceder como administrador con los datos:

```
usuario:    admin@demo.demo
contraseña: 123456
``
