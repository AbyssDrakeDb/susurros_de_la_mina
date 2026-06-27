# Fase 1: Prototipo Mínimo de Minería — Plan Detallado (Histórico)

> **Objetivo:** Crear un loop de gameplay funcional: moverse → explorar → minar → vender → mejorar → repetir.
> **Duración:** 1-2 días (26-27 de Junio, 2026)
> **Estado:** ✅ COMPLETADA (20/20 tareas)
> **Commits:** 7aa1a32 → cf30e8d (16 commits)
> **Tags:** v0.1.0-alpha → v0.3.0-alpha

---

## Resumen

La Fase 1 implementó el prototipo mínimo jugable completo. El jugador puede moverse en primera persona, explorar una cueva, minar 5 tipos de minerales con una picota visible, recargar la linterna con pilas, vender minerales al NPC por oro, comprar mejoras en la tienda, y enfrentar peligros (trampas de pinchos, daño por caída). El sistema incluye HUD completo, hotbar, pausa, game over con reinicio, y audio integrado.

---

## Sub-Fases

| Sub-Fase | Nombre | Tareas | Período |
|----------|--------|--------|---------|
| **1.1** | Movimiento y Exploración | 7 | 26 Jun |
| **1.2** | Sistema de Minería y Recursos | 6 | 26 Jun |
| **1.3** | Economía y Loop Completo | 7 | 26-27 Jun |

---

## 1.1 — Movimiento y Exploración (Tareas 1.1-1.7)

### Tarea 1.1 — Player.tscn: CharacterBody3D

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:player-controller` |
| **Archivos** | `scenes/player/player.tscn`, `scripts/player/player.gd` |

**Implementación:**
- CharacterBody3D con CollisionShape3D (capsule)
- Head (Node3D) → Camera3D + Flashlight (SpotLight3D) + InteractionRay (RayCast3D)
- Flashlight: Toggle F, drain 2%/s, intensidad variable según batería
- Raycast: Ángulo 15° hacia abajo, rango 2.5m, detecta objetos con `take_damage()`

---

### Tarea 1.2 — Sistema de Movimiento

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 → 3a831be → 888fcf1 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:player-controller` |
| **Archivos** | `scripts/player/player.gd` |

**Implementación:**
- WASD + sprint (8.0) + jump (5.0) + gravity (20.0)
- Acceleration (12.0) / Deceleration (20.0) — frenado fuerte sin deslizamiento
- Mouse look: sensitivity 0.003, clamped ±90° vertical
- Head bob: walk (8.0 speed, 0.03 amount), sprint (10.0, 0.05)

**Bugs corregidos:**
- 3a831be: Corregir movimiento del jugador (dirección incorrecta)
- 888fcf1: Movimiento suave y mouse libre (problema con input)

---

### Tarea 1.3 — Cámara en Primera Persona

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:camera-system` |
| **Archivos** | `scripts/player/player.gd` |

**Implementación:**
- Camera3D como hijo de Head (Node3D)
- Rotación X limitada a ±PI/2
- Sensibilidad configurable via export

---

### Tarea 1.4 — Linterna con Batería

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:player-controller` |
| **Archivos** | `scripts/player/player.gd` |

**Implementación:**
- SpotLight3D con toggle (F)
- Batería: 100% base, drain 2%/s
- Intensidad: lerp 0.3-1.0 según nivel de batería
- Cuando batería = 0: linterna se apaga automáticamente
- Pilas: tecla R para recargar (sistema añadido en 1.3)

---

### Tarea 1.5 — Raycast de Interacción

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:player-controller` |
| **Archivos** | `scripts/player/player.gd` |

**Implementación:**
- RayCast3D inclinado 15° hacia abajo
- Rango: 2.5m
- Detecta colliders con método `take_damage()`
- Muestra indicador "[ CLICK ]" cuando apunta a mineral minable

---

### Tarea 1.6 — Entorno Base con Prototipos

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | adaa122 → bcbcc5c |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:3d-essentials` |
| **Archivos** | `scenes/environment/cave_room.tscn`, `scripts/environment/generate_collisions.gd` |

**Implementación:**
- CaveRoom.tscn con `modular_caves.glb` (ToxaGrom)
- `generate_collisions.gd`: Recolección recursiva de MeshInstance3D, generación de trimesh CollisionShape3D en runtime

**Bug corregido:**
- bcbcc5c: Corregir formato de escenas .tscn para Godot 4.7

---

### Tarea 1.7 — Superficie Inicial

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | adaa122 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:scene-organization` |
| **Archivos** | `scenes/environment/surface.tscn` |

**Implementación:**
- Piso con textura prototipo
- DirectionalLight3D
- NPC (Knight.glb) con sistema de diálogo
- CaveEntrance (Area3D) para entrar a la cueva

---

## 1.2 — Sistema de Minería y Recursos (Tareas 1.8-1.13)

### Tarea 1.8 — MineralNode.gd

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 → a346af4 → 3f0947f |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:resource-pattern` |
| **Archivos** | `scripts/minerals/mineral_node.gd`, `scenes/minerals/mineral_node.tscn` |

**Implementación:**
- StaticBody3D con BoxShape3D
- 5 tipos: copper (100HP), iron (150HP), silver (175HP), gold (200HP), crystal (300HP)
- Colores únicos por tipo (verde, gris, plateado, dorado, azul)
- Materials como copias únicas por instancia en `_ready()`
- BillboardMode=3 (Y-Billboard) en health bar BG/Fill
- BillboardMode=1 en Label3D
- Hit flash: emisión burst + bar shake
- Destrucción: tween de escala a 0
- Señal `mined` → `GameState.add_mineral()`
- Battery drop: 15% chance al minar

**Bugs corregidos:**
- a346af4: Rango de minado reducido a 1.5m, barra de vida visible
- 3f0947f: Materiales únicos por mineral (evitar资源共享), raycast inclinado

---

### Tarea 1.9 — PickaxeTool.gd

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:component-system` |
| **Archivos** | `scripts/tools/pickaxe_tool.gd` |

**Implementación:**
- 4 tipos de picos:
  - Basic: 25dmg, 0.5cd, 1.0noise
  - Reinforced: 40dmg, 0.4cd, 1.2noise
  - Silent: 25dmg, 0.5cd, 0.5noise
  - Drill: 60dmg, 0.3cd, 2.0noise
- Cooldown timer entre golpes
- Sistema de upgrades

---

### Tarea 1.10 — Sistema de Inventario

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:inventory-system` |
| **Archivos** | `scripts/autoload/game_state.gd` |

**Implementación:**
- Dictionary-based: `{"copper": 15, "iron": 3}`
- Capacidad: 20 items (upgradeable)
- Métodos: `add_mineral()`, `remove_mineral()`, `get_mineral_count()`
- Señales: `inventory_changed`, `mineral_changed`
- Contador `inventory_used` actualizado automáticamente

---

### Tarea 1.11 — HUD: Barra de Vida

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:hud-system` |
| **Archivos** | `scenes/ui/hud.tscn`, `scripts/ui/hud.gd` |

**Implementación:**
- CanvasLayer con MarginContainer/VBoxContainer
- HealthBar (ProgressBar) — conectada a `GameState.health_changed`
- BatteryBar (ProgressBar) — actualizada desde player.gd
- MineralCounter (Label) — "Minerals: X / Y"
- GoldCounter (Label) — "Gold: X | Pilas: Y"
- DepthLabel (Label) — "Depth: Xm"

---

### Tarea 1.12 — HUD: Inventario Rápido (Hotbar)

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 → 48f90b6 |
| **Fecha** | 2026-06-26-27 |
| **Skill** | `godot-prompter:hud-system` |
| **Archivos** | `scenes/ui/hotbar.tscn`, `scripts/ui/hotbar.gd` |

**Implementación:**
- 6 slots horizontales con HBoxContainer
- Cada slot: ColorRect (color del mineral) + Label (nombre) + CountLabel (cantidad)
- StyleBoxFlat con bordes redondeados
- Slot de baterías: "P:N" en último slot
- Señal `inventory_changed` reconectada con `await process_frame x2`

**Bug corregido:**
- 48f90b6: Hotbar no muestra items del inventario (señal no conectada correctamente)

---

### Tarea 1.13 — Loop de Retorno a Superficie

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 7aa1a32 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:scene-organization` |
| **Archivos** | `scripts/environment/cave_entrance.gd`, `scripts/autoload/transition_manager.gd` |

**Implementación:**
- CaveEntrance: Area3D con Label3D "Presiona E para entrar"
- Al interactuar: `TransitionManager.go_to_scene("cave")`
- CaveExit: Area3D que lleva de vuelta a surface
- TransitionManager: `go_to_scene()` con `await process_frame x2`

---

## 1.3 — Economía y Loop Completo (Tareas 1.14-1.20)

### Tarea 1.14 — NPC Comprador

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | c755f40 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:dialogue-system` |
| **Archivos** | `scripts/npc/npc.gd`, `scenes/npc/npc.tscn` |

**Implementación:**
- StaticBody3D con Knight.glb (carga procedural)
- InteractionArea (Area3D) 4×3×4
- Dialogue cycling con Label3D
- InteractHint: "Presiona E para hablar"
- Al interactuar: abre TradePanel, pausa jugador (`is_paused=true`)
- CanvasLayer(layer=20) para paneles dinámicos

---

### Tarea 1.15 — Sistema de Comercio

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | c755f40 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:inventory-system` |
| **Archivos** | `scripts/npc/trade_system.gd`, `scripts/ui/trade_panel.gd`, `scenes/ui/trade_panel.tscn` |

**Implementación:**
- TradeSystem: Sell minerals → gold
  - Copper: 10g, Iron: 25g, Silver: 50g, Gold: 100g, Crystal: 200g
- TradePanel: UI con lista de minerales, precios, botones de venta
- Señales: `trade_completed`, `trade_failed`

---

### Tarea 1.16 — Tienda de Mejoras

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | c755f40 → cf30e8d |
| **Fecha** | 2026-06-26-27 |
| **Skill** | `godot-prompter:godot-ui` |
| **Archivos** | `scripts/ui/shop_panel.gd`, `scenes/ui/shop_panel.tscn` |

**Implementación:**
- 4 mejoras + 1 consumible:
  - Mochila Mayor: +10 capacidad (100g)
  - Pico Reforzado: +10 daño (150g)
  - Batería Mejorada: +50% duración (80g)
  - Botas de Velocidad: +20% velocidad (120g)
  - Celda de Batería: recarga linterna (30g)
- Compra con verificación de oro
- `add_theme_font_size_override()` en vez de `theme_override_font_sizes`

**Bug corregido:**
- cf30e8d: ShopPanel crash por `theme_override_font_sizes` inexistente en Label nuevo

---

### Tarea 1.17 — Mejoras Iniciales

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | c755f40 → 96209dc |
| **Fecha** | 2026-06-26-27 |
| **Skill** | `godot-prompter:resource-pattern` |
| **Archivos** | `scripts/autoload/game_state.gd` |

**Implementación:**
- `unlocked_upgrades: Array[String]`
- `has_upgrade()`, `unlock_upgrade()`
- `get_damage_bonus()`, `get_speed_multiplier()`, `get_battery_multiplier()`
- Aplicación en tiempo real (velocidad, daño, batería)

---

### Tarea 1.18 — Sistema de Riesgo

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 96209dc → cf30e8d |
| **Fecha** | 2026-06-27 |
| **Skill** | `godot-prompter:physics-system` |
| **Archivos** | `scripts/environment/hazard.gd`, `scripts/player/player.gd` |

**Implementación:**
- **Daño por caída:** Threshold 5.0 unidades, 10 damage por unidad adicional
- **Trampas:** Hazard.gd (Area3D), daño periódico configurable
  - 3 SpikeTraps en cueva: damage 15/20/25, interval 1.0/0.8/0.6s
- **Pérdida aleatoria:** Al morir, pierde 1-3 tipos de mineral aleatorios
- **Game Over:** Overlay con CanvasLayer(100), stats, botón "Reiniciar"

**Bugs corregidos:**
- cf30e8d: Game over screen usaba `get_total_minerals()` (no existía) → calculado desde inventory dict
- cf30e8d: Botón reiniciar no funcionaba por `get_tree().paused = true` bloqueando input → removido pausa de árbol

---

### Tarea 1.19 — Audio Integration

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | c755f40 |
| **Fecha** | 2026-06-26 |
| **Skill** | `godot-prompter:audio-system` |
| **Archivos** | `scripts/player/player.gd` |

**Implementación:**
- 5 mining sounds: `impactMining_000-004.ogg` — randomized pitch
- 5 footstep sounds: `footstep_concrete_000-004.ogg` — interval walk 0.45s, sprint 0.35s
- AudioManager.play_sfx_varied() para variación

---

### Tarea 1.20 — Playtesting

| Campo | Detalle |
|-------|---------|
| **Estado** | ✅ |
| **Commit** | 33292aa → 115ca6a → 48f90b6 → 96209dc → cf30e8d |
| **Fecha** | 2026-06-26-27 |
| **Skill** | `godot-prompter:godot-debugging` |
| **Archivos** | Múltiples |

**Tests validados por usuario:**

| Test | Categoría | Resultado |
|------|-----------|-----------|
| A1-A14 | Player movement | ✅ Funciona |
| B1-B5 | Linterna | ✅ Funciona |
| C1-C9 | Minería (CRÍTICO) | ✅ Funciona |
| D1-D7 | Transiciones | ✅ Funciona |
| E1-E7 | NPC + Comercio | ✅ Funciona |
| F1-F6 | Tienda | ✅ Funciona |
| G1-G5 | Hotbar | ✅ Funciona |
| H1-H4 | Riesgo | ✅ Funciona |
| I1-I4 | Audio | ✅ Funciona (mejorable) |
| J1-J4 | GameState | ✅ Funciona |
| K1-K4 | Escena principal | ✅ Funciona |

---

## Historial de Commits

| Commit | Fecha | Tipo | Descripción |
|--------|-------|------|-------------|
| 7aa1a32 | 2026-06-26 | feat | Fase 1.1-1.3 - Player, MineralNode, Pickaxe, HUD |
| 4ad2b6e | 2026-06-26 | docs | actualizar progreso - Fase 1 al 50% |
| bcbcc5c | 2026-06-26 | fix | corregir formato de escenas .tscn para Godot 4.7 |
| adaa122 | 2026-06-26 | feat | agregar piso, iluminación y minerales con materiales |
| 3a831be | 2026-06-26 | fix | corregir movimiento del jugador |
| 888fcf1 | 2026-06-26 | fix | movimiento suave y mouse libre |
| 54b81b7 | 2026-06-26 | fix | pausa con Escape, minado funcional, plataformas |
| 249ecbb | 2026-06-26 | feat | picota visible, indicador de minado |
| a346af4 | 2026-06-26 | feat | rango de minado reducido, barra de vida en minerales |
| 3f0947f | 2026-06-26 | fix | materiales únicos, raycast inclinado, colores |
| c755f40 | 2026-06-26 | feat | Fase 1 completa - Prototipo de minería (100%) |
| 33292aa | 2026-06-26 | fix | 6 bugs críticos corregidos |
| 115ca6a | 2026-06-27 | fix | 4 bugs de interacción y UI |
| 48f90b6 | 2026-06-27 | fix | Hotbar no muestra items |
| 96209dc | 2026-06-27 | feat | Baterías, tienda mejoras, mapa cueva, hazards |
| cf30e8d | 2026-06-27 | fix | Game over, ShopPanel crash, feedback pilas |

---

## Bugs Encontrados y Corregidos

| # | Bug | Severidad | Commit Fix | Solución |
|---|-----|-----------|------------|----------|
| 1 | Escenas .tscn incompatible con Godot 4.7 | Alta | bcbcc5c | Reformatar cabeceras |
| 2 | Movimiento del jugador con dirección incorrecta | Alta | 3a831be | Corregir cálculo de dirección |
| 3 | Mouse no se libera correctamente | Media | 888fcf1 | Ajustar input handling |
| 4 | Materiales compartidos entre minerales | Alta | 3f0947f | Copiar material por instancia |
| 5 | Raycast no detecta minerales | Alta | 3f0947f | Inclinar 15° hacia abajo |
| 6 | MineralNode sin barra de vida visible | Media | a346af4 | BillboardMode correcto |
| 7 | Hotbar no muestra inventario | Alta | 48f90b6 | Reconectar señal con await |
| 8 | NPC mesh no aparece | Alta | 33292aa | Carga procedural de Knight.glb |
| 9 | CanvasLayer NPC no recibe input | Alta | 33292aa | Crear dinámicamente |
| 10 | ShopPanel crash theme_override_font_sizes | Alta | cf30e8d | Usar add_theme_font_size_override() |
| 11 | Game over no triggerea | Alta | cf30e8d | Agregar listener phase_changed |
| 12 | Botón reiniciar no funciona | Alta | cf30e8d | No pausar árbol de escena |
| 13 | ESC durante game over despausa | Media | cf30e8d | Bloquear en GAME_OVER |
| 14 | Sin feedback al usar pilas | Media | cf30e8d | Notificación Label3D con tween |

**Total bugs: 14** (8 críticos, 6 medios)

---

## Archivos Creados en Fase 1

| Archivo | Líneas | Descripción |
|---------|--------|-------------|
| `scripts/player/player.gd` | 366 | Controlador FPS completo |
| `scripts/minerals/mineral_node.gd` | 170 | Sistema de minerales |
| `scripts/npc/npc.gd` | 192 | NPC con diálogo y comercio |
| `scripts/npc/trade_system.gd` | 45 | Lógica de comercio |
| `scripts/tools/pickaxe_tool.gd` | 99 | 4 tipos de picos |
| `scripts/ui/hud.gd` | 50 | Interfaz de usuario |
| `scripts/ui/hotbar.gd` | 116 | Barra de inventario rápido |
| `scripts/ui/trade_panel.gd` | 92 | Panel de comercio |
| `scripts/ui/shop_panel.gd` | 186 | Panel de tienda |
| `scripts/environment/hazard.gd` | 44 | Trampas con daño |
| `scripts/environment/cave_entrance.gd` | 36 | Transición a cueva |
| `scripts/environment/generate_collisions.gd` | 42 | Colisiones trimesh |
| `scripts/autoload/transition_manager.gd` | 51 | Gestión de transiciones |
| `scenes/player/player.tscn` | 63 | Escena del jugador |
| `scenes/minerals/mineral_node.tscn` | 64 | Escena de mineral |
| `scenes/npc/npc.tscn` | 44 | Escena del NPC |
| `scenes/ui/hud.tscn` | 66 | Escena HUD |
| `scenes/ui/hotbar.tscn` | 32 | Escena hotbar |
| `scenes/ui/trade_panel.tscn` | 56 | Escena trade |
| `scenes/ui/shop_panel.tscn` | 56 | Escena shop |
| `scenes/environment/surface.tscn` | 70 | Escena superficie |
| `scenes/main/main.tscn` | 220+ | Escena cueva principal |
| **TOTAL** | **~2,090** | |

---

## Validación Final

| Criterio | Resultado |
|----------|-----------|
| Player se mueve sin deslizamiento | ✅ |
| Linterna funciona con batería | ✅ |
| Minado funcional con 5 tipos | ✅ |
| Health bar visible en minerales | ✅ |
| NPC comercia correctamente | ✅ |
| Tienda de mejoras funciona | ✅ |
| Hotbar muestra inventario | ✅ |
| Transiciones surface↔cave | ✅ |
| Game over con reinicio | ✅ |
| Audio de pasos y minado | ✅ |
| Daño por caída funciona | ✅ |
| Trampas hacen daño | ✅ |
| Pilas se usan con R | ✅ |
| 30+ FPS estable | ✅ |

---

## Métricas Finales

| Métrica | Valor |
|---------|-------|
| Commits | 16 |
| Archivos GDScript | 12 |
| Archivos .tscn | 10 |
| Líneas de código | ~2,090 |
| Bugs encontrados | 14 |
| Bugs corregidos | 14 (100%) |
| Tests manuales validados | 11 categorías (68+ tests) |
| Duración real | 2 días |
| Tags | v0.1.0 → v0.3.0-alpha |
