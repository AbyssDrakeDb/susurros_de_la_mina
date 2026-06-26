# Proyecto: Susurros de la Mina
## Tracking de Progreso

---

## FASE 0: Preparación ✅ COMPLETADA

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 0.1 | Estructura de directorios (26+ carpetas) | ✅ | `assets/`, `scenes/`, `scripts/`, `docs/`, etc. |
| 0.2 | Documentación base | ✅ | README.md, CREDITS.md, arquitectura, GDD, pipeline |
| 0.3 | Autoloads configurados | ✅ | GameState, AudioManager, SaveManager |
| 0.4 | Input Map configurado | ✅ | WASD, sprint, jump, interact, mine, flashlight, inventory |
| 0.5 | project.godot configurado | ✅ | Física Jolt, D3D12, 60 FPS |
| 0.6 | .gitignore + .editorconfig | ✅ | Godot 4 compatible |
| 0.7 | Git workflow | ✅ | main + develop + feature branches |
| 0.8 | Assets 3D: Herramientas | ✅ | `free_low_poly_mining_assets.glb` (purepoly) |
| 0.9 | Assets 3D: Entorno | ✅ | `modular_caves.glb` (ToxaGrom) |
| 0.10 | Assets 3D: Minerales | ✅ | Crystal Pack - 28 cristales (iPoly3D) |
| 0.11 | Assets Texturas | ✅ | Kenney Prototype Textures (13 texturas) |
| 0.12 | Audio: Mining SFX | ✅ | 45 efectos (impactos, picos, metales) |
| 0.13 | Audio: Player SFX | ✅ | 45 efectos (pasos, punch, impacts) |
| 0.14 | Audio: Environment SFX | ✅ | 25 efectos (cave, wood, glass) |
| 0.15 | Audio: UI SFX | ✅ | 105 efectos (clicks, confirmaciones, errores) |
| 0.16 | Audio: Creature SFX | ✅ | 1 efecto (horror ambience) |
| 0.17 | Audio: Music | ✅ | 9 loops ambientales (piano, strings) |
| 0.18 | CREDITS.md actualizado | ✅ | Todas las licencias documentadas |

**Estado: ✅ COMPLETADA - Commits: main + develop sincronizados**

---

## FASE 1: Prototipo Mínimo de Minería (3 meses) 🔲 PENDIENTE

### Mes 1: Movimiento y Exploración

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.1 | Player.tscn - CharacterBody3D | 🔲 | Movimiento FPS con gravedad |
| 1.2 | Sistema de movimiento | 🔲 | WASD + sprint + jump |
| 1.3 | Cámara en primera persona | 🔲 | Mouse look con límites |
| 1.4 | Linterna con batería | 🔲 | Toggle on/off, drain rate |
| 1.5 | Raycast de interacción | 🔲 | Detectar objetos interactivos |
| 1.6 | Entorno base con prototipos | 🔲 | Usar modular_caves.glb |
| 1.7 | Superficie inicial | 🔲 | Zona de spawn + NPC comprador |

### Mes 2: Sistema de Minería y Recursos

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.8 | MineralNode.gd | 🔲 | Vida, tipos, drop al destruir |
| 1.9 | PickaxeTool.gd | 🔲 | Daño, cooldown, animación |
| 1.10 | Sistema de inventario | 🔲 | Slots, capacidad, UI |
| 1.11 | HUD - Barra de vida | 🔲 | HealthBar con tweens |
| 1.12 | HUD - Inventario rápido | 🔲 | Hotbar con items equipados |
| 1.13 | Loop de retorno a superficie | 🔲 | Ascensor/escalera + checkpoint |

### Mes 3: Economía y Loop Completo

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.14 | NPC Comprador | 🔲 | Dialogue + trade system |
| 1.15 | Sistema de comercio | 🔲 | Vender minerales por oro |
| 1.16 | Tienda de mejoras | 🔲 | Comprar mejoras con oro |
| 1.17 | Mejoras iniciales | 🔲 | +Capacidad mochila, +Daño pico |
| 1.18 | Sistema de riesgo | 🔲 | Caídas = daño, perder items |
| 1.19 | Audio integration | 🔲 | Pasos, minería, ambiente, UI |
| 1.20 | Playtesting | 🔲 | Ajustar dificultad y balance |

**Estado: 🔲 PENDIENTE**

---

## FASE 2: Profundidad y Atmósfera (4-5 meses) 🔲 PENDIENTE

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.1 | Generación procedural híbrida | 🔲 | Mixto handcrafted + procedural |
| 2.2 | 3-4 biomas de mina | 🔲 | Superficie,浅層, profundo, crystalline |
| 2.3 | Sistema de mejoras completo | 🔲 | 10+ mejoras unlockables |
| 2.4 | Audio ambiental por bioma | 🔲 | Música + SFX diferentes |
| 2.5 | Iluminación dinámica | 🔲 | Sombras, antorchas, bioluminiscencia |
| 2.6 | Efectos de partículas | 🔲 | Polvo, chispas, cristales |
| 2.7 | Postprocesado básico | 🔲 | Bloom, vignette, color grading |
| 2.8 | **Demo jugable para itch.io** | 🔲 | Build release |

**Estado: 🔲 PENDIENTE**

---

## FASE 3: Despertar del Horror (4-5 meses) 🔲 PENDIENTE

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 3.1 | IA de criatura | 🔲 | 3 estados: Patrol, Chase, Search |
| 3.2 | Detección de ruido | 🔲 | Sistema de audio propagation |
| 3.3 | Detección de luz | 🔲 | La criatura evita/huye de luz |
| 3.4 | Sistema de escondites | 🔲 | Armarios, grietas, oscuridad |
| 3.5 | Mineral desencadenante | 🔲 | Evento que activa horror |
| 3.6 | Mecánicas de evasión | 🔲 | Correr, esconderse, distracciones |
| 3.7 | Narrativa ambiental | 🔲 | Notas, diarios, grabaciones |
| 3.8 | Horror progresivo | 🔲 | Intensidad gradual |

**Estado: 🔲 PENDIENTE**

---

## FASE 4: Pulido y Lanzamiento (4-5 meses) 🔲 PENDIENTE

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 4.1 | Narrativa completa | 🔲 | Cutscenes, final alternativo |
| 4.2 | Audio final | 🔲 | Voice acting, música orquestal |
| 4.3 | Postprocesado visual | 🔲 | Advanced shaders |
| 4.4 | QA y optimización | 🔲 | Profiling, memory, LODs |
| 4.5 | Localización | 🔲 | ES, EN, PT |
| 4.6 | Marketing | 🔲 | Trailer, screenshots, Steam page |
| 4.7 | **Publicación Steam** | 🔲 | Launch |
| 4.8 | **Publicación itch.io** | 🔲 | Publicar demo |

**Estado: 🔲 PENDIENTE**

---

## Resumen de Progreso

| Fase | Estado | Progreso |
|------|--------|----------|
| Fase 0: Preparación | ✅ COMPLETADA | 18/18 (100%) |
| Fase 1: Prototipo Mínimo | 🔲 PENDIENTE | 0/20 (0%) |
| Fase 2: Profundidad | 🔲 PENDIENTE | 0/8 (0%) |
| Fase 3: Horror | 🔲 PENDIENTE | 0/8 (0%) |
| Fase 4: Lanzamiento | 🔲 PENDIENTE | 0/8 (0%) |
| **TOTAL** | 🔲 | **18/62 (29%)** |

---

## Última Actualización
- **Fecha**: 26 de Junio, 2026
- **Fase actual**: Fase 1 - Prototipo Mínimo
- **Siguiente tarea**: 1.1 - Player.tscn
