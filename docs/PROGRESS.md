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
| Fase 2: Profundidad | 🔲 PENDIENTE | 0/32 (0%) | `phase2_detailed.md` |
| Fase 3: Horror | 🔲 PENDIENTE | 0/8 (0%) | `phase3_detailed.md` |
| Fase 4: Lanzamiento | 🔲 PENDIENTE | 0/8 (0%) | `phase4_detailed.md` |
| **TOTAL** | ✅ | **38/86 (44%)** | |

---

## Última Actualización
- **Fecha**: 27 de Junio, 2026
- **Fase actual**: Fase 2 - Profundidad y Atmósfera (pendiente)
- **Siguiente tarea**: 2.A.1 - MineralResource
- **Planes detallados**: `docs/plans/phase{0-4}_detailed.md`
- **Tag actual**: v0.3.0-alpha (Fase 1 completa)
