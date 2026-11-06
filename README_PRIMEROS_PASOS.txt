ECOS DE LA OSCURIDAD – PROTOTIPO GODOT 4
=======================================

CAMBIOS DE ESTA VERSION
- Menú: usa la imagen limpia entregada por el usuario, sin botones incrustados.
  Los botones son controles reales de Godot.
- Personaje: se incorporaron recortes aproximados de la lámina de sprites del documento
  y un AnimatedSprite2D con animaciones base idle/walk.
- Interacciones: E investiga pistas, recoge llaves y muestra mensajes en el HUD.
- Linterna: F la enciende y apaga.
- Movimiento: WASD o flechas.
- Se agregaron puntos interactivos a los seis escenarios.

ABRIR
1. Descomprime el ZIP.
2. En Godot 4.x elige Importar.
3. Selecciona project.godot.
4. Abre el proyecto y pulsa F5.

CONTROLES
WASD / flechas: mover.
E: investigar o recoger objetos cercanos.
F: encender/apagar linterna.
ESC: volver al menú.

IMPORTANTE
La lámina de sprites es una referencia compuesta, no un spritesheet transparente exportado.
Los fotogramas se recortaron aproximadamente; para una animación final limpia conviene conseguir
un spritesheet PNG con fondo transparente y celdas uniformes.

Pendiente:
- Colisiones de paredes y puertas por escenario.
- Acertijo funcional de cuatro símbolos.
- Inventario visible y guardado.
- Transiciones por puertas con requisitos.
- Dos finales según pistas encontradas.
