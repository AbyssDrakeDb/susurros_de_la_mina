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

## FASE 1: Prototipo Mínimo de Minería (3 meses) 🔄 EN PROGRESO

### Mes 1: Movimiento y Exploración

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.1 | Player.tscn - CharacterBody3D | ✅ | CharacterBody3D con CollisionShape3D |
| 1.2 | Sistema de movimiento | ✅ | WASD + sprint + jump + gravedad |
| 1.3 | Cámara en primera persona | ✅ | Mouse look con límites ±90° |
| 1.4 | Linterna con batería | ✅ | Toggle F, drain 2%/s, intensidad variable |
| 1.5 | Raycast de interacción | ✅ | Detectar objetos con método interact() |
| 1.6 | Entorno base con prototipos | ✅ | CaveRoom.tscn + generate_collisions.gd |
| 1.7 | Superficie inicial | ✅ | Surface.tscn + NPC + CaveEntrance |

### Mes 2: Sistema de Minería y Recursos

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.8 | MineralNode.gd | ✅ | Vida, tipos (copper/iron/silver/gold/crystal), drops |
| 1.9 | PickaxeTool.gd | ✅ | 4 tipos de picos, cooldown, upgrades |
| 1.10 | Sistema de inventario | ✅ | En GameState, capacidad 20 |
| 1.11 | HUD - Barra de vida | ✅ | HealthBar + BatteryBar + mineral counter |
| 1.12 | HUD - Inventario rápido | ✅ | Hotbar.tscn con slots visuales |
| 1.13 | Loop de retorno a superficie | ✅ | CaveEntrance + TransitionManager |

### Mes 3: Economía y Loop Completo

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.14 | NPC Comprador | ✅ | npc.gd + dialogue + trade_panel |
| 1.15 | Sistema de comercio | ✅ | TradePanel + TradeSystem |
| 1.16 | Tienda de mejoras | ✅ | ShopPanel + upgrades |
| 1.17 | Mejoras iniciales | ✅ | +Capacidad mochila, +Daño pico |
| 1.18 | Sistema de riesgo | ✅ | Daño por caída + pérdida de items |
| 1.19 | Audio integration | ✅ | Pasos + minería integrados en player.gd |
| 1.20 | Playtesting | ✅ | Ajustar dificultad y balance |

**Estado: 🔲 PENDIENTE**

---

## FASE 2: Profundidad y Atmósfera (4-5 meses) 🔲 PENDIENTE

### 2.A — Data Layer: Recursos y Configuración

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.A.1 | MineralResource (Custom Resource) | 🔲 | class_name con health, rarity, depth, mesh |
| 2.A.2 | BiomeResource (Custom Resource) | 🔲 | 6 biomas: surface, shallow, crystal, abandoned, deep, cursed |
| 2.A.3 | MineralSpawnEntry (Resource auxiliar) | 🔲 | Peso de spawn por mineral en cada bioma |
| 2.A.4 | RoomTemplate (Custom Resource) | 🔲 | 5 tipos: entrance, mineral, story, challenge, boss |
| 2.A.5 | Crear Room Templates Base | 🔲 | 8 escenas prefabricadas por bioma/tipo |
| 2.A.6 | Actualizar MineralNode para MineralResource | 🔲 | Data-driven stats desde Resource |

### 2.B — Generación Procedural: MineGenerator

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.B.1 | MineGenerator Core (Autoload) | 🔲 | generate_chunk(), get_biome_at_depth() |
| 2.B.2 | BiomeSelector (Lógica por Profundidad) | 🔲 | Mapeo depth→biome, integrar con GameState |
| 2.B.3 | RoomSpawner (Colocación de Salas) | 🔲 | Instanciar templates, conectar con túneles |
| 2.B.4 | MineralSpawner (Población de Minerales) | 🔲 | Spawn por peso de bioma, tipos correctos |
| 2.B.5 | HazardSpawner (Trampas por Bioma) | 🔲 | Chance por bioma, daño escalado |
| 2.B.6 | ChunkManager (Carga/Descarga) | 🔲 | Render distance, limpieza de memoria |
| 2.B.7 | Integrar MineGenerator con CaveEntrance | 🔲 | Flujo Surface→Cave→Profundizar |

### 2.C — Sistema de Biomas: Visuales y Transiciones

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.C.1 | BiomeApplier (Aplicar Visual) | 🔲 | WorldEnvironment, fog, ambient por bioma |
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

**Estado: 🔲 PENDIENTE (0/32 tareas)**

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
| Fase 1: Prototipo Mínimo | ✅ COMPLETADA | 20/20 (100%) |
| Fase 2: Profundidad | 🔲 PENDIENTE | 0/32 (0%) |
| Fase 3: Horror | 🔲 PENDIENTE | 0/8 (0%) |
| Fase 4: Lanzamiento | 🔲 PENDIENTE | 0/8 (0%) |
| **TOTAL** | 🔄 | **38/86 (44%)** |

---

## Última Actualización
- **Fecha**: 27 de Junio, 2026
- **Fase actual**: Fase 2 - Profundidad y Atmósfera (pendiente)
- **Siguiente tarea**: 2.A.1 - MineralResource
- **Plan detallado**: `docs/plans/phase2_detailed.md`
