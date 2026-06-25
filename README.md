# Susurros de la Mina

**Exploración, minería y supervivencia en primera persona con horror progresivo**

[![Godot 4.7](https://img.shields.io/badge/Godot-4.7-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)

---

## Navegación del Proyecto

| Sección | Descripción |
|---------|-------------|
| [Visión General](#visión-general) | Concepto y objetivos del juego |
| [Guía Rápida](#guía-rápida) | Cómo empezar a desarrollar |
| [Estructura del Proyecto](#estructura-del-proyecto) | Organización de archivos |
| [Fases de Desarrollo](#fases-de-desarrollo) | Roadmap y milestones |
| [Arquitectura Técnica](#arquitectura-técnica) | Sistemas y diseño de código |
| [Pipeline de Assets](#pipeline-de-assets) | Cómo integrar assets |
| [Convenciones de Código](#convenciones-de-código) | Estilo y normas |
| [Assetos Recomendados](#assets-recomendados) | Resources gratuitos |

---

## Visión General

### Concepto

**Susurros de la Mina** es un juego de exploración y minería en primera persona que transiciona progresivamente hacia survival horror. El jugador comienza como un minero solitario buscando fortuna, hasta descubrir que la mina no está tan vacía como parece.

### Pilares de Diseño

1. **Bucle Minero Adictivo** - Excavar, recolectar, mejorar, repetir
2. **Transición de Género** - De sandbox relajante a horror opresivo
3. **Narrativa Ambiental** - Historia contada a través del entorno
4. **Gestión Estratégica** - Luz, ruido, inventario como recursos críticos

### Objetivos del Proyecto

| Objetivo | Métrica de Éxito |
|----------|------------------|
| Loop minero sólido | 30+ minutos sin aburrimiento |
| Atmósfera inquietante | Feedback positivo en usability tests |
| Transición horror | Impacto narrativo medible |
| Publicación | Steam + itch.io con reviews positivas |

---

## Guía Rápida

### Requisitos Previos

- [Godot 4.7](https://godotengine.org/download) o superior
- Git
- Editor de código (VS Code recomendado)

### Instalación del Proyecto

```bash
# Clonar repositorio
git clone https://github.com/AbyssDrakeDb/susurros_de_la_mina.git
cd susurros_de_la_mina

# Abrir en Godot
# Abrir Godot > Import > Seleccionar project.godot
```

### Configuración Inicial

1. Abrir el proyecto en Godot 4.7
2. Ir a **Project > Project Settings > Autoload**
3. Verificar que estén cargados:
   - `GameState` → `res://scripts/autoload/game_state.gd`
   - `AudioManager` → `res://scripts/autoload/audio_manager.gd`
4. Presionar **Play** (F5) para verificar que funciona

### Comandos Útiles

```powershell
# Descargar assets recomendados
.\scripts\download_assets.ps1

# Ejecutar tests (futuro)
# godot --headless --script res://tests/run_tests.gd
```

---

## Estructura del Proyecto

```
susurros_de_la_mina/
├── assets/                          # Recursos del juego
│   ├── 3d/                          # Modelos 3D
│   │   ├── environment/             # Túneles, rocas, suelo
│   │   ├── tools/                   # Picos, linterna, saco
│   │   ├── minerals/                # Gemas, minerales, vetas
│   │   ├── props/                   # Barriles, cajas, raíles
│   │   └── characters/              # NPC, entidades
│   ├── textures/                    # Texturas y materiales
│   │   ├── prototype/               # Texturas de prototipo (Kenney)
│   │   └── environment/             # Texturas de entorno
│   └── audio/                       # Archivos de audio
│       ├── sfx/                     # Efectos de sonido
│       ├── music/                   # Música ambiental
│       └── voice/                   # Voces, susurros
├── scenes/                          # Escenas de Godot
│   ├── main/                        # Escenas principales
│   ├── player/                      # Escenas del jugador
│   ├── environment/                 # Entorno, mina
│   ├── ui/                          # Interfaz de usuario
│   └── autoload/                    # Nodos autoload
├── scripts/                         # Scripts GDScript
│   ├── player/                      # Lógica del jugador
│   ├── mining/                      # Sistema de minería
│   ├── inventory/                   # Inventario y mochila
│   ├── environment/                 # Generación procedural
│   ├── ui/                          # Lógica de UI
│   └── autoload/                    # Scripts globales
├── resources/                       # Recursos de Godot
│   ├── items/                       # Definiciones de items
│   └── data/                        # Datos de juego
├── addons/                          # Plugins de Godot
├── docs/                            # Documentación
│   ├── design/                      # Documentos de diseño
│   └── technical/                   # Documentación técnica
└── scripts/                         # Scripts de sistema
    └── download_assets.ps1          # Descarga de assets
```

---

## Fases de Desarrollo

### Fase 0: Preparación (3-4 semanas) - ACTUAL

| Semana | Tarea | Estado |
|--------|-------|--------|
| 1 | Estructura de carpetas | Completado |
| 1 | Configurar .gitignore | Completado |
| 2 | Crear ramas Git | Pendiente |
| 2 | Configurar autoloads | Pendiente |
| 3 | Documentación técnica | En progreso |
| 4 | Planificación Fase 1 | Pendiente |

### Fase 1: Prototipo de Minería Pura (3 meses)

**Mes 1: Movimiento y entorno base**
- Sistema FPS completo
- Linterna con batería
- Entorno base con assets prototipo
- Superficie con NPC comprador

**Mes 2: Sistema de minería y recursos**
- MineralNode con vida y estados
- Sistema de picos
- Inventario con UI
- Loop de retorno a superficie

**Mes 3: Loop completo y economía**
- Sistema de comercio
- Mejoras iniciales
- Riesgo (caídas, pérdida)
- Playtesting y ajustes

### Fase 2: Profundidad y Atmósfera (4-5 meses)

- Generación procedural híbrida
- 3-4 biomas de mina
- Sistema de mejoras completo
- Audio ambiental por bioma
- **Demo jugable para itch.io**

### Fase 3: Despertar del Horror (4-5 meses)

- IA de criatura (3 estados)
- Detección de ruido/luz
- Sistema de escondites
- Mineral desencadenante
- Mecánicas de evasión

### Fase 4: Pulido y Lanzamiento (4-5 meses)

- Narrativa completa
- Audio final
- Postprocesado visual
- QA y optimización
- Publicación Steam + itch.io

---

## Arquitectura Técnica

Para detalles completos, ver [docs/technical/architecture.md](docs/technical/architecture.md).

### Sistemas Principales

```
┌─────────────────────────────────────────────────────────┐
│                    GAME STATE (Global)                   │
│  • Phase management  • Inventory  • Progression         │
└──────────────┬──────────────────────┬───────────────────┘
               │                      │
    ┌──────────▼──────────┐ ┌────────▼────────────────┐
    │   PLAYER SYSTEM     │ │   MINING SYSTEM         │
    │  • Movement         │ │  • MineralNode          │
    │  • Flashlight       │ │  • Pickaxe              │
    │  • Interaction      │ │  • Resource collection  │
    └──────────┬──────────┘ └────────┬────────────────┘
               │                      │
    ┌──────────▼──────────────────────▼────────────────┐
    │              ENVIRONMENT SYSTEM                   │
    │  • MineGenerator  • Biomes  • Chunk loading      │
    └──────────────────────────────────────────────────┘
```

### Autoloads

| Script | Responsabilidad |
|--------|-----------------|
| `GameState` | Estado global, progresión, inventario |
| `AudioManager` | Gestión de audio centralizada |
| `SaveManager` | Guardado y carga de partidas |

---

## Pipeline de Assets

Para detalles completos, ver [docs/design/asset_pipeline.md](docs/design/asset_pipeline.md).

### Formatos Soportados

| Tipo | Formatos | Notas |
|------|----------|-------|
| Modelos 3D | .glb, .gltf, .obj | Preferir glTF 2.0 |
| Texturas | .png, .jpg | POT (256, 512, 1024) |
| Audio | .ogg, .wav | OGG para loops, WAV para SFX |
| Animaciones | .glb, .anim | Integradas en modelos |

### Fuentes de Assets Recomendadas

| Fuente | Licencia | Tipo | Costo |
|--------|----------|------|-------|
| [Kenney](https://kenney.nl/assets) | CC0 | 3D, Texturas, Audio | Gratis |
| [Poly Pizza](https://poly.pizza) | CC0 | Modelos 3D | Gratis |
| [OpenGameArt](https://opengameart.org) | Varias | 2D, 3D, Audio | Gratis |
| [Sketchfab](https://sketchfab.com) | CC-BY/CC0 | Modelos 3D | Gratis/Pago |
| [Freesound](https://freesound.org) | Varias | Audio | Gratis |

---

## Convenciones de Código

Para detalles completos, ver [docs/technical/coding_standards.md](docs/technical/coding_standards.md).

### Resumen Rápido

```gdscript
# Nombres de clases: PascalCase
class_name MineralNode extends StaticBody3D

# Variables: snake_case
var mineral_type: String = "copper"
var current_health: int = 100

# Funciones: snake_case
func take_damage(amount: int) -> void:
    current_health -= amount
    if current_health <= 0:
        _destroy()

# Señales: snake_case con prefijo del sistema
signal mineral_depleted(node: MineralNode)
signal mineral_hit(node: MineralNode, damage: int)

# Constantes: SCREAMING_SNAKE_CASE
const MAX_HEALTH: int = 100
const MINERAL_TYPES: Array[String] = ["copper", "iron", "gold"]
```

### Estructura de Archivos

- Un script por archivo
- Nombre del archivo = nombre de la clase en snake_case
- Un nodo principal por escena

---

## Assets Recomendados

### Instalados

| Asset | Estado | Ubicación |
|-------|--------|-----------|
| Kenney Prototype Textures | Instalado | `assets/textures/prototype/` |

### Para Descargar

Ver [scripts/download_assets.ps1](scripts/download_assets.ps1) para descarga automática.

| Asset | Fuente | Licencia | Prioridad |
|-------|--------|----------|-----------|
| Free Low Poly Mining Assets | Sketchfab | CC-BY | Alta |
| Modular Caves | Sketchfab | CC-BY | Alta |
| Crystal Pack | Poly Pizza | CC0 | Media |
| Kenney Survival Kit | itch.io | CC0 | Media |
| Mining SFX Pack | OpenGameArt | CC0 | Alta |

---

## Contribuir

### Flujo de Trabajo Git

```
main (estable)
  └── develop (integración)
       └── feature/nombre-feature
       └── bugfix/nombre-bug
```

### Comandos de Git

```bash
# Crear nueva feature
git checkout develop
git checkout -b feature/mining-system

# Actualizar develop
git checkout develop
git pull origin develop

# Merge feature
git checkout develop
git merge feature/mining-system
```

---

## Licencia

Este es un proyecto privado. Todos los derechos reservados.

Los assets de terceros mantienen sus propias licencias (ver créditos en `docs/credits.md`).

---

## Contacto

- **Desarrollador**: AbyssDrake
- **Email**: g.rivera.cid@gmail.com
- **GitHub**: [AbyssDrakeDb](https://github.com/AbyssDrakeDb)

---

*Última actualización: 25 de Junio, 2026*