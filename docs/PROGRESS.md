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

## FASE 1: Prototipo Mínimo de Minería (2 días) ✅ COMPLETADA

### Sub-Fase 1.1: Movimiento y Exploración (26 Jun)

| # | Tarea | Estado | Commit | Notas |
|---|-------|--------|--------|-------|
| 1.1 | Player.tscn - CharacterBody3D | ✅ | 7aa1a32 | CharacterBody3D + CollisionShape3D |
| 1.2 | Sistema de movimiento | ✅ | 7aa1a32 → 888fcf1 | WASD + sprint + jump + gravity + frenado |
| 1.3 | Cámara en primera persona | ✅ | 7aa1a32 | Mouse look ±90°, sensitivity 0.003 |
| 1.4 | Linterna con batería | ✅ | 7aa1a32 | Toggle F, drain 2%/s, intensidad variable |
| 1.5 | Raycast de interacción | ✅ | 7aa1a32 | 15° down, 2.5m, detecta take_damage() |
| 1.6 | Entorno base con prototipos | ✅ | adaa122 | CaveRoom + generate_collisions.gd |
| 1.7 | Superficie inicial | ✅ | adaa122 | Surface.tscn + NPC + CaveEntrance |

### Sub-Fase 1.2: Sistema de Minería y Recursos (26 Jun)

| # | Tarea | Estado | Commit | Notas |
|---|-------|--------|--------|-------|
| 1.8 | MineralNode.gd | ✅ | 7aa1a32 → 3f0947f | 5 tipos, materials únicos, health bar 3D |
| 1.9 | PickaxeTool.gd | ✅ | 7aa1a32 | 4 tipos, cooldown, upgrades |
| 1.10 | Sistema de inventario | ✅ | 7aa1a32 | Dictionary, capacity 20, signals |
| 1.11 | HUD - Barra de vida | ✅ | 7aa1a32 | HealthBar + BatteryBar + mineral counter |
| 1.12 | HUD - Inventario rápido | ✅ | 7aa1a32 → 48f90b6 | 6 slots, battery display, signal fix |
| 1.13 | Loop de retorno a superficie | ✅ | 7aa1a32 | CaveEntrance + TransitionManager |

### Sub-Fase 1.3: Economía y Loop Completo (26-27 Jun)

| # | Tarea | Estado | Commit | Notas |
|---|-------|--------|--------|-------|
| 1.14 | NPC Comprador | ✅ | c755f40 | Knight.glb, dialogue, trade panel |
| 1.15 | Sistema de comercio | ✅ | c755f40 | TradePanel + TradeSystem (5 minerales) |
| 1.16 | Tienda de mejoras | ✅ | c755f40 → cf30e8d | 4 upgrades + battery cells |
| 1.17 | Mejoras iniciales | ✅ | c755f40 | +Capacidad, +Daño, +Batería, +Velocidad |
| 1.18 | Sistema de riesgo | ✅ | 96209dc | Fall damage + hazards + death penalty |
| 1.19 | Audio integration | ✅ | c755f40 | 5 mining + 5 footstep sounds |
| 1.20 | Playtesting | ✅ | 33292aa → cf30e8d | 11 categorías, 14 bugs corregidos |

**Estado: ✅ COMPLETADA - v0.3.0-alpha - 16 commits (7aa1a32 → cf30e8d)**

### Bugs Corregidos en Fase 1

| # | Bug | Severidad | Commit Fix |
|---|-----|-----------|------------|
| 1 | Escenas .tscn incompatible Godot 4.7 | Alta | bcbcc5c |
| 2 | Movimiento dirección incorrecta | Alta | 3a831be |
| 3 | Mouse no se libera | Media | 888fcf1 |
| 4 | Materiales compartidos entre minerales | Alta | 3f0947f |
| 5 | Raycast no detecta minerales | Alta | 3f0947f |
| 6 | MineralNode sin health bar visible | Media | a346af4 |
| 7 | Hotbar no muestra inventario | Alta | 48f90b6 |
| 8 | NPC mesh no aparece | Alta | 33292aa |
| 9 | CanvasLayer NPC sin input | Alta | 33292aa |
| 10 | ShopPanel crash theme_override | Alta | cf30e8d |
| 11 | Game over no triggerea | Alta | cf30e8d |
| 12 | Botón reiniciar no funciona | Alta | cf30e8d |
| 13 | ESC durante game over despausa | Media | cf30e8d |
| 14 | Sin feedback al usar pilas | Media | cf30e8d |

---

## FASE 2: Profundidad y Atmósfera (4-5 meses) ✅ EN PROGRESO (11/32 tareas · +9 bugs corregidos)

### 2.A — Data Layer: Recursos y Configuración

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.A.1 | MineralResource (Custom Resource) | 🔲 | class_name con health, rarity, depth, mesh |
| 2.A.2 | BiomeResource (Custom Resource) | ✅ | 6 biomas: surface, shallow, crystal, abandoned, deep, cursed |
| 2.A.3 | MineralSpawnEntry (Resource auxiliar) | ✅ | Peso de spawn por mineral en cada bioma |
| 2.A.4 | RoomTemplate (Custom Resource) | ✅ | 5 tipos: entrance, mineral, story, challenge, boss |
| 2.A.5 | Crear Room Templates Base | 🔲 | 8 escenas prefabricadas por bioma/tipo |
| 2.A.6 | Actualizar MineralNode para MineralResource | 🔲 | Data-driven stats desde Resource |

### 2.B — Generación Procedural: MineGenerator

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.B.1 | MineGenerator Core (Autoload) | ✅ | generate_chunk(), get_biome_at_depth(), generate_path() |
| 2.B.2 | BiomeSelector (Lógica por Profundidad) | ✅ | Mapeo depth→biome, integrado con GameState |
| 2.B.3 | RoomSpawner (Colocación de Salas) | ✅ | Instanciar templates, conectar con túneles |
| 2.B.4 | MineralSpawner (Población de Minerales) | ✅ | Spawn por peso de bioma, tipos correctos |
| 2.B.5 | HazardSpawner (Trampas por Bioma) | ✅ | Chance por bioma, daño escalado |
| 2.B.6 | ChunkManager (Carga/Descarga) | ✅ | Render distance, limpieza de memoria con validación |
| 2.B.7 | Integrar MineGenerator con CaveEntrance | ✅ | Flujo Surface→Cave→Profundizar con conexión GameState |

### 2.C — Sistema de Biomas: Visuales y Transiciones

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.C.1 | BiomeApplier (Aplicar Visual) | ✅ | cave_scene_setup aplica ambient_color, fog, density al WorldEnvironment |
| 2.C.2 | BiomeTransitionDetector | 🔲 | Fade in/out entre biomas, sin parpadeos |
| 2.C.3 | Crear Materiales por Bioma | 🔲 | 5 materiales base, colores y roughness |
| 2.C.4 | BiomeDecorations (Props) | 🔲 | Decoración por bioma con assets existentes |
| 2.C.5 | DepthTracker (Profundidad Jugador) | 🔲 | Actualizar GameState.current_depth en Y |

### 2.D — Sistema de Horror: Fases y Atmósfera

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.D.1 | HorrorPhaseManager | 🔲 | Fases por depth: NONE→LATENT→STALKING→HUNTING |
| 2.D.2 | HorrorEventSystem (Efectos Visuales) | 🔲 | Whisper, shadow, footsteps, breathing, jumpscare |
| 2.D.3 | HorrorAtmosphere (Ambiente Visual) | 🔲 | Niebla, oscuridad, música por fase |
| 2.D.4 | Evento Mineral Maldito | 🔲 | Primera descubierta depth 10, flashbacks |

### 2.E — Iluminación Dinámica

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.E.1 | LightingManager (Autoload) | 🔲 | Setup por bioma, point lights, torches |
| 2.E.2 | TorchSystem (Antorchas) | 🔲 | Parpadeo, humo, luz naranja |
| 2.E.3 | CrystalGlow (Bioluminiscencia) | 🔲 | Pulso sinusoidal en cristales |

### 2.F — Partículas y Postprocesado

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.F.1 | ParticleEffects | 🔲 | Polvo, chispas, cristales, humo, aura |
| 2.F.2 | PostProcessing | 🔲 | Bloom, vignette, color grading por bioma |

### 2.G — Audio Ambiental por Bioma

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.G.1 | BiomeAudioManager | 🔲 | Crossfade música, SFX ambiental por bioma |
| 2.G.2 | Asignar Pistas de Audio | 🔲 | Organizar audio existente por bioma |

### 2.H — Integración y Demo

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.H.1 | Integrar Sistema Completo | 🔲 | Reemplazar cueva estática, flujo completo |
| 2.H.2 | Balance y Tuning | 🔲 | Ajustar valores post-testing |
| 2.H.3 | Build para itch.io | 🔲 | Windows + Web, subir demo |

**Estado: ✅ EN PROGRESO (11/32 tareas)**

---

### 2.X — Bugs Corregidos en Generación Procedural (29 Jun 2026 — Sesión 2)

| # | Problema | Archivo | Fix |
|---|----------|---------|-----|
| 1 | `global_position` en nodos fuera del árbol | `room_spawner.gd` | Cambiar a `position` |
| 2 | `look_at()` antes de `add_child()` | `room_spawner.gd` | Reordenar: add_child → look_at |
| 3 | Chunks no añadidos al árbol | `mine_generator.gd` | Parámetro `parent` en generate_chunk() |
| 4 | Referencias stale tras cambio escena | `chunk_manager.gd` | `_is_container_valid()` |
| 5 | `global_transform` en nodos no en árbol | `generate_collisions.gd` | Doble await + is_inside_tree |
| 6 | Nodo "Chunks" huérfano en re-entrada | `cave_scene_setup.gd` | has_node check antes de crear |
| 7 | Contenido artesanal superpuesto | `cave_scene_setup.gd` | Añadir "CaveRoom" a limpieza |
| 8 | Túneles BoxShape3D injugables | `room_spawner.gd` | SurfaceTool con malla tubo irregular |
| 9 | Piezas de cueva NO conectadas (gap visible) | `modular_cave_generator.gd`, `mine_generator.gd` | Piezas tienen escala 0.5 en .tscn pero PIECE_DATA usaba tamaño sin escalar → half_size 2x → posiciones duplicadas. Fix: añadir `scale: 0.5` a PIECE_DATA (salvo mine_01=1.0), calcular half_size como `size * scale * 0.5`, aplicar `body.scale` y resetear `visual.transform = IDENTITY` en `_instance_piece()` |
| 9 | Colisión BoxShape3D atrapa jugador | `mine_generator.gd` | ConcavePolygonShape3D trimesh |
| 10 | Piezas superpuestas entre chunks | `mine_generator.gd` | `_chunk_end` tracking |
| 11 | Piezas dispersas por AABB | `modular_cave_generator.gd` | connection_offset auto-detect |
| 12 | Conexión en eje incorrecto | `modular_cave_generator.gd` | connection_axis configurable |
| 13 | Offsets aleatorios rompen alineación | `modular_cave_generator.gd` | Eliminar offsets aleatorios |
| 14 | Campo de visión reducido | `player.tscn` | Camera3D.far 500→5000 |
| 15 | Sistema modular no integrado | `mine_generator.gd` | Integrar ModularCaveGenerator |
| 16 | Colisión trimesh costosa | `mine_generator.gd` | Cache _collision_cache por piece_id |
| 17 | Sin restricciones consecutivas | `modular_cave_generator.gd` | _apply_consecutive_rules() |
| 18 | Sin LOD | `mine_generator.gd` + `piece_lod.gd` | PieceLOD por distancia |
| 19 | Pantalla de carga fija 5s | `cave_scene_setup.gd` | Condicional + dinámica en test_mode |
| 20 | Sin integración visual biomas | `cave_scene_setup.gd` | _apply_biome_visuals() en setup |
| 21 | const PIECE_DATA no modificable en runtime | `modular_cave_generator.gd` | Reemplazar PIECE_DATA con _offset_cache |
| 22 | Auto-detect de offsets retornaba 0 (ningún bin vacío) | `modular_cave_generator.gd` | Eliminar auto_detect; usar half_size = size/2 |
| 23 | Jugador spawnea DENTRO del mesh de la primera pieza | `cave_scene_setup.gd` + `mine_generator.gd` | start_offset = half_first + 50; instance_path() con offset |
| 24 | ConcavePolygonShape3D no detecta colisión desde el interior | `mine_generator.gd` | safety floor (BoxShape3D bajo el jugador) |
| 25 | generate_path() llamado 2 veces daba paths distintos | `cave_scene_setup.gd` + `mine_generator.gd` | instance_path() público + generar path 1 vez |
| 26 | connection_axis inconsistente ("X" vs "Z") | `modular_cave_generator.gd` + `cave_scene_setup.gd` | Unificar default a "X" en todos los módulos |
| 27 | surface_get_arrays() retorna Array no Dictionary | `modular_cave_generator.gd` | Tipo PackedVector3Array[] + acceso con [] |
| 28 | _scene tipado como Node recibía PackedScene | `cave_connection_analyzer.gd` | Cambiar tipo a PackedScene |

---

## FASE 3: Despertar del Horror (4-5 meses) 🔲 PENDIENTE

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 3.A.1 | CreatureAI (5 estados) | 🔲 | IDLE, PATROL, CHASE, SEARCH, RETREAT |
| 3.A.2 | Detección de ruido | 🔲 | Pasos, minado, correr →吸引 criatura |
| 3.A.3 | Detección de luz | 🔲 | Criatura evita zonas iluminadas |
| 3.B.1 | Sistema de escondites | 🔲 | Armarios, grietas, zonas oscuras |
| 3.B.2 | Sistema de distracciones | 🔲 | Piedra, bomba de luz, ruidoso |
| 3.C.1 | Notas/diarios | 🔲 | 20+ notas, audio recordings |
| 3.C.2 | Horror progresivo | 🔲 | Eventos ambientales por fase |
| 3.D.1 | Balance de criatura | 🔲 | Velocidad, detección, dificultad |

**Estado: 🔲 PENDIENTE (0/8 tareas)**
**Plan detallado:** `docs/plans/phase3_detailed.md`

---

## FASE 4: Pulido y Lanzamiento (4-5 meses) 🔲 PENDIENTE

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 4.A.1 | Narrativa completa + cutscenes | 🔲 | Opening, story beats, endings |
| 4.A.2 | Contenido final (notas, props) | 🔲 | 20+ notas, 10+ grabaciones, props |
| 4.B.1 | Audio final | 🔲 | Voice acting, música orquestal |
| 4.B.2 | Postprocesado avanzado | 🔲 | Bloom, vignette, color grading |
| 4.C.1 | QA y optimización | 🔲 | 30+ FPS, profiling, LODs |
| 4.D.1 | Localización (i18n) | 🔲 | ES, EN, PT-BR |
| 4.E.1 | Marketing | 🔲 | Trailer, screenshots, Steam page |
| 4.E.2 | Publicación | 🔲 | Steam + itch.io |

**Estado: 🔲 PENDIENTE (0/8 tareas)**
**Plan detallado:** `docs/plans/phase4_detailed.md`

---

## Resumen de Progreso

| Fase | Estado | Progreso | Plan Detallado |
|------|--------|----------|----------------|
| Fase 0: Preparación | ✅ COMPLETADA | 18/18 (100%) | `phase0_detailed.md` |
| Fase 1: Prototipo Mínimo | ✅ COMPLETADA | 20/20 (100%) | `phase1_detailed.md` |
| Fase 2: Profundidad | ✅ EN PROGRESO | 11/32 (34%) | `phase2_detailed.md` |
| Fase 3: Horror | 🔲 PENDIENTE | 0/8 (0%) | `phase3_detailed.md` |
| Fase 4: Lanzamiento | 🔲 PENDIENTE | 0/8 (0%) | `phase4_detailed.md` |
| **TOTAL** | ✅ | **49/86 (57%)** | |

---

## Última Actualización
- **Fecha**: 29 de Junio, 2026
- **Fase actual**: Fase 2 - Profundidad y Atmósfera (en progreso)
- **Siguiente tarea**: 2.A.1 - MineralResource / 2.A.5 - Room Templates
- **Planes detallados**: `docs/plans/phase{0-4}_detailed.md`, `docs/godot-prompter/plans/problemas-generacion-cuevas.md`
- **Tag actual**: v0.3.0-alpha (Fase 1 completa)
