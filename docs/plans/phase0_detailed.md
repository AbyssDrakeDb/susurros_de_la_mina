# Fase 0: Preparación — Plan Detallado (Histórico)

> **Objetivo:** Establecer la base del proyecto: estructura, documentación, assets, configuración de Godot, y workflow de Git.
> **Duración:** 1 día (25 de Junio, 2026)
> **Estado:** ✅ COMPLETADA (18/18 tareas)
> **Commits:** cf0591b → 9321e73

---

## Resumen

La Fase 0 sentó las bases infraestructurales del proyecto "Susurros de la Mina". Se creó la estructura de directorios, se configuró el proyecto en Godot 4.7, se importaron todos los assets (3D, audio, texturas), se estableció el workflow de Git (main + develop), y se documentó el diseño completo del juego.

---

## Tareas Completadas

### 0.1 — Estructura de Directorios

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**26+ carpetas creadas:**
```
assets/
├── 3d/
│   ├── characters/     (6 modelos GLB: Knight, Barbarian, Mage, Ranger, Rogue, Rogue_Hooded)
│   ├── environment/    (modular_caves.glb de ToxaGrom)
│   ├── minerals/       (28 cristales de iPoly3D)
│   └── props/
│       ├── furniture/  (53 modelos GLTF de KayKit)
│       └── mining/     (barrel, crate, table de purepoly)
├── audio/
│   ├── music/
│   │   ├── ambient/    (9 loops WAV)
│   │   └── tension/    (vacío)
│   ├── sfx/
│   │   ├── cave/       (vacío)
│   │   ├── creature/   (1 horror ambience)
│   │   ├── environment/(45 efectos)
│   │   ├── horror/     (vacío)
│   │   ├── mining/     (90 efectos)
│   │   ├── player/     (90 efectos)
│   │   └── ui/         (240 efectos)
│   └── voice/
│       └── whispers/   (vacío)
├── textures/
│   ├── environment/    (vacío)
│   └── prototype/      (13 texturas Kenney)
scenes/
├── autoload/           (vacío)
├── environment/
├── main/
├── minerals/
├── npc/
├── player/
└── ui/
scripts/
├── autoload/
├── environment/
├── horror/             (no existe aún)
├── inventory/          (vacío)
├── minerals/
├── mining/             (vacío)
├── npc/
├── player/
├── tools/
└── ui/
docs/
├── design/
├── plans/
└── technical/
resources/
├── data/               (vacío)
├── items/              (vacío)
└── materials/          (vacío)
```

---

### 0.2 — Documentación Base

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**Archivos creados:**
- `README.md` — Descripción del proyecto, controles, estructura
- `CREDITS.md` — Licencias de todos los assets (CC0, CC-BY)
- `docs/design/game_design.md` — Game Design Document completo (480+ líneas)
- `docs/technical/architecture.md` — Arquitectura técnica (1000+ líneas)
- `docs/design/asset_pipeline.md` — Pipeline de assets
- `docs/design/audio_guide.md` — Guía de audio por bioma/fase
- `docs/design/coding_standards.md` — Estándares de código GDScript

---

### 0.3 — Autoloads Configurados

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 → 276cd17 |
| **Fecha** | 2026-06-25 |

**4 autoloads registrados en project.godot:**

| Autoload | Archivo | Función |
|----------|---------|---------|
| GameState | `scripts/autoload/game_state.gd` | Estado global, inventario, progresión |
| AudioManager | `scripts/autoload/audio_manager.gd` | Pool de 8 SFX players, fade in/out |
| SaveManager | `scripts/autoload/save_manager.gd` | Guardado binario, configuración |
| TransitionManager | `scripts/autoload/transition_manager.gd` | Transiciones surface↔cave |

---

### 0.4 — Input Map Configurado

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**12 acciones de input:**

| Acción | Tecla | Uso |
|--------|-------|-----|
| move_forward | W | Movimiento |
| move_backward | S | Movimiento |
| move_left | A | Movimiento |
| move_right | D | Movimiento |
| jump | Space | Salto |
| sprint | Shift | Sprint |
| interact | E | Interacción NPC/cueva |
| mine | Left Click | Minado |
| toggle_flashlight | F | Linterna |
| open_inventory | Tab | Inventario (reservado) |
| use_battery | R | Usar pila |
| open_shop | Q | Tienda |

---

### 0.5 — project.godot Configurado

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**Configuración:**
- Motor: Godot 4.7
- Renderer: Forward Plus (D3D12)
- Physics: Jolt
- Viewport: 1920×1080
- Stretch mode: canvas_items
- FPS target: 60
- 3 physics layers: Environment(1), Player(2), Minerals(3)

---

### 0.6 — .gitignore + .editorconfig

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | cf0591b |
| **Fecha** | 2026-06-25 |

- `.gitignore` — Excluye `.godot/`, `*.import`, builds, temporales
- `.editorconfig` — Indentación GDScript (tabs), encoding UTF-8

---

### 0.7 — Git Workflow

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | cf0591b |
| **Fecha** | 2026-06-25 |

**Estrategia:**
- `main` — Rama estable, solo merges desde develop
- `develop` — Rama de integración
- `feature/*` — Ramas de características
- Tags: v0.1.0-alpha → v0.3.0-alpha

---

### 0.8 — Assets 3D: Herramientas

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**Asset:** `free_low_poly_mining_assets.glb` (purepoly, CC-BY)
- Contenido: Herramientas de minado (pico, pala, etc.)
- Ubicación: `assets/3d/tools/`
- Texturas: 2 diffuse maps

---

### 0.9 — Assets 3D: Entorno

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**Asset:** `modular_caves.glb` (ToxaGrom, CC-BY)
- Contenido: 13 módulos de cueva modulares
- Ubicación: `assets/3d/environment/`
- Texturas: `modular_caves_0.png` (albedo), `modular_caves_1.png` (normal)

---

### 0.10 — Assets 3D: Minerales

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | e6cbc22 |
| **Fecha** | 2026-06-25 |

**Asset:** Crystal Pack (iPoly3D, CC0)
- Contenido: 28 modelos de cristales variados
- Ubicación: `assets/3d/minerals/`
- Cada cristal con textura PNG individual

---

### 0.11 — Assets Texturas

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | e6cbc22 |
| **Fecha** | 2026-06-25 |

**Asset:** Kenney Prototype Textures (CC0)
- Contenido: 13 texturas de prototipo
- Ubicación: `assets/textures/prototype/`
- Usadas para materiales base de minerales

---

### 0.12 — Audio: Mining SFX

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**90 efectos de audio:**
- impactBell_heavy (5)
- impactMetal_heavy/light/medium (15)
- impactMining (5) — **usados en player.gd**
- impactPlate_heavy/light/medium (15)
- impactTin_medium (5)
- Formato: .ogg

---

### 0.13 — Audio: Player SFX

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**90 efectos de audio:**
- footstep_carpet/concrete/grass/snow/wood (25) — **footstep_concrete usados en player.gd**
- impactPunch/impactSoft (20)
- Formato: .ogg

---

### 0.14 — Audio: Environment SFX

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**45 efectos de audio:**
- impactGlass_heavy/light/medium (15)
- impactGeneric_light (5)
- Cave Room Tone (6+)
- Formato: .ogg/.wav

---

### 0.15 — Audio: UI SFX

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**240 efectos de audio:**
- back, bong, click, close, confirmation, drop, error, glass, glitch
- impactGeneric, impactGlass, maximize, minimize, open, pluck
- question, scratch, scroll, select, switch, tick, toggle
- Formato: .ogg

---

### 0.16 — Audio: Creature SFX

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**1 efecto de audio:**
- `horror_ambience_01.wav` — Reservado para Fase 3

---

### 0.17 — Audio: Music

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | ebf5e92 |
| **Fecha** | 2026-06-25 |

**9 loops ambientales:**
- 5 Ambient Piano Loops (90-128 BPM)
- 4 Ambient String Loops (77 BPM)
- Formato: .wav

---

### 0.18 — CREDITS.md Actualizado

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 276cd17 |
| **Fecha** | 2026-06-25 |

**Licencias documentadas:**
- Crystal Pack (iPoly3D) — CC0
- Modular Caves (ToxaGrom) — CC-BY
- Free Low Poly Mining (purepoly) — CC-BY
- Kenney Prototype Textures — CC0
- KayKit Characters/Props — CC0
- Audio effects — CC0/CC-BY

---

## Archivos Creados en Fase 0

| Archivo | Líneas | Descripción |
|---------|--------|-------------|
| `project.godot` | ~120 | Configuración del proyecto |
| `.gitignore` | ~30 | Exclusiones Git |
| `.editorconfig` | ~15 | Configuración de editor |
| `README.md` | ~100 | Documentación principal |
| `CREDITS.md` | ~80 | Licencias |
| `docs/design/game_design.md` | ~480 | GDD completo |
| `docs/technical/architecture.md` | ~1000 | Arquitectura técnica |
| `docs/design/asset_pipeline.md` | ~100 | Pipeline de assets |
| `docs/design/audio_guide.md` | ~150 | Guía de audio |
| `docs/design/coding_standards.md` | ~80 | Estándares de código |
| `scripts/autoload/game_state.gd` | ~180 | Estado global |
| `scripts/autoload/audio_manager.gd` | ~182 | Gestión de audio |
| `scripts/autoload/save_manager.gd` | ~155 | Guardado |
| `scripts/autoload/main.gd` | ~12 | Entry point |
| **TOTAL** | **~2,684** | |

---

## Assets Importados

| Categoría | Cantidad | Tamaño aprox. |
|-----------|----------|---------------|
| Modelos 3D | 100+ | ~50 MB |
| Texturas | 40+ | ~15 MB |
| Audio SFX | 466 | ~80 MB |
| Audio Music | 9 | ~20 MB |
| **TOTAL** | **615+** | **~165 MB** |

---

## Validación

| Criterio | Resultado |
|----------|-----------|
| Estructura de directorios completa | ✅ 26+ carpetas |
| project.godot funcional | ✅ Abre sin errores |
| Assets importados | ✅ Todos visibles en FileSystem |
| Documentación completa | ✅ 7 archivos .md |
| Git workflow | ✅ main + develop funcionando |
| Autoloads registrados | ✅ 4 autoloads activos |
| Input map configurado | ✅ 12 acciones |

---

## Bugs Encontrados y Corregidos

| Bug | Commit Fix | Descripción |
|-----|------------|-------------|
| Archivos >100MB | 124a4f0 | 3 archivos de audio excedían límite de GitHub, removidos |

---

## Métricas Finales

| Métrica | Valor |
|---------|-------|
| Commits | 5 (cf0591b → 9321e73) |
| Archivos creados | 15 scripts + 10 docs |
| Líneas de código | ~2,684 |
| Assets importados | 615+ archivos |
| Errores encontrados | 1 (audio >100MB) |
| Duración real | 1 día |
