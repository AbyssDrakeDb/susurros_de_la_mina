# Fase 4: Pulido y Lanzamiento — Plan Detallado

> **Objetivo:** Narrativa completa, audio final, optimización, localización, marketing, y publicación.
> **Duración estimada:** 4-5 meses
> **Estado:** 🔲 PENDIENTE (0/8 tareas)
> **Dependencias:** Fase 3 completa (criatura, narrativa, horror)

---

## Resumen

La Fase 4 lleva el juego de "prototipo funcional" a "producto pulido". Incluye la narrativa completa con cutscenes, audio profesional (voice acting, música orquestal), postprocesado avanzado, QA y optimización, localización a 3 idiomas, marketing (trailer, Steam page), y finalmente la publicación en Steam e itch.io.

---

## Sub-Fases

| Sub-Fase | Nombre | Tareas | Dependencias |
|----------|--------|--------|--------------|
| **4.A** | Narrativa y Contenido | 2 | Fase 3 completa |
| **4.B** | Audio y Visual Final | 2 | 4.A |
| **4.C** | QA y Optimización | 1 | Todo implementado |
| **4.D** | Localización | 1 | Textos finalizados |
| **4.E** | Marketing y Publicación | 2 | Build estable |

---

## 4.A — Narrativa y Contenido

> **Objetivo:** Historia completa con cutscenes, final alternativo, y contenido final.

### Tarea 4.A.1 — Narrativa Completa y Cutscenes
**Skill:** `godot-prompter:dialogue-system`

**Contenido a crear:**
- **Opening cutscene:** Intro narrativa del jugador llegando a la mina
- **Story beats:** 10+ eventos narrativos distribuidos por profundidad
- **Cursed mineral event:** Cinemática del despertar de la criatura
- **Final normal:** Escapar de la mina
- **Final secreto:** Destruir el mineral maldito
- **Credits roll:** Reconocimientos

**Archivos:**
- `scripts/cutscenes/cutscene_manager.gd`
- `scripts/cutscenes/cutscene_trigger.gd`
- `scenes/cutscenes/opening.tscn`
- `scenes/cutscenes/ending_normal.tscn`
- `scenes/cutscenes/ending_secret.tscn`

**Validación:** Cutscenes se reproducen, transiciones suaves, sin bugs

---

### Tarea 4.A.2 — Contenido Final (Notas, Grabaciones, Props)
**Skill:** `godot-prompter:scene-organization`

**Contenido a crear:**
- **20+ notas/diarios** distribuidos por bioma
- **10+ grabaciones de audio** (voice acting)
- **Props narrativos:** Restos de campamento, herramientas abandonadas, marcas en paredes
- **Environmental storytelling:** Sangre en paredes, objetos movidos, huellas

**Archivos:**
- `scenes/horror/note_*.tscn` (20+)
- `assets/audio/voice/recordings/*.ogg` (10+)
- `scenes/decorations/narrative_*.tscn` (15+)

**Validación:** Historia es coherente, notas ubicadas lógicamente

---

## 4.B — Audio y Visual Final

> **Objetudio:** Audio profesional y visual pulido para release.

### Tarea 4.B.1 — Audio Final
**Skill:** `godot-prompter:audio-system`

**Contenido a crear:**
- **Voice acting:** Narrador + personajes (grabaciones profesionales o AI)
- **Música orquestal:** 3-4 tracks temáticos (surface, cave, horror, ending)
- **SFX final:** Reemplazar prototipos con versiones finales
- **Mix final:** Ecualización, compresión, masterización

**Archivos:**
- `assets/audio/voice/narration/*.ogg`
- `assets/audio/music/final/*.ogg`
- `assets/audio/sfx/final/*.ogg`

**Validación:** Audio suena profesional, sin clipping, niveles correctos

---

### Tarea 4.B.2 — Postprocesado Visual Avanzado
**Skill:** `godot-prompter:shader-basics`

**Efectos a implementar:**
- **Bloom** ajustado por bioma
- **Vignette** dinámico (más intenso en horror)
- **Color grading** por bioma y fase de horror
- **Screen shake** para impactos y jump scares
- **Chromatic aberration** sutil en horror
- **Film grain** para efecto cinematográfico

**Archivos:**
- `resources/compositor/biome_*.tres`
- `resources/compositor/horror_*.tres`
- `scripts/ui/advanced_post_processing.gd`

**Validación:** Visual es polido, efectos no impactan FPS significativamente

---

## 4.C — QA y Optimización

> **Objetivo:** Juego estable, 30+ FPS, sin bugs críticos.

### Tarea 4.C.1 — QA y Optimización
**Skill:** `godot-prompter:godot-optimization`

**Checklist de QA:**

| Área | Verificar |
|------|-----------|
| **Performance** | 30+ FPS en hardware mínimo, profiling |
| **Memoria** | Sin memory leaks, cleanup de nodos |
| **Collision** | Sin stuck, sin fall-through |
| **Saving** | Save/load funciona correctamente |
| **All paths** | Todos los caminos accesibles |
| **All items** | Todos los items funcionan |
| **All upgrades** | Todas las mejoras aplican correctamente |
| **Audio** | Sin cortes, sin loops infinitos |
| **UI** | Responsive en diferentes resoluciones |
| **Edge cases** | Morir durante cutscene, inventario lleno, etc. |

**Optimizaciones:**
- **LOD** para meshes lejanas
- **Occlusion culling** para cuevas
- **Object pooling** para partículas
- **Texture streaming** para assets grandes
- **Profiling** con Godot debugger

**Archivos:** Múltiples scripts optimizados
**Validación:** QA checklist completo, profiling sin bottlenecks

---

## 4.D — Localización

> **Objetivo:** Soporte para Español, Inglés, Portugués.

### Tarea 4.D.1 — Localización (i18n/l10n)
**Skill:** `godot-prompter:localization`

**Idiomas soportados:**
- **Español (es)** — Idioma primario
- **Inglés (en)** — Inglés americano
- **Portugués (pt-br)** — Portugués brasileño

**Implementación:**
- Usar `TranslationServer` de Godot
- Archivos PO/CSV para cada idioma
- Localizar: UI, notas, diálogos, cutscenes
- Soporte para RTL si se necesita (no aplica)

**Archivos:**
- `resources/localization/es.po`
- `resources/localization/en.po`
- `resources/localization/pt_BR.po`
- `scripts/ui/locale_manager.gd`

**Validación:** Cambio de idioma funciona, textos no se cortan

---

## 4.E — Marketing y Publicación

> **Objetivo:** Llegar al público y publicar.

### Tarea 4.E.1 — Marketing
**Skill:** `godot-prompter:export-pipeline`

**Contenido de marketing:**
- **Trailer:** 60-90 segundos, gameplay + horror
- **Screenshots:** 10+ capturas de calidad
- **Steam page:** Descripción, requisitos, tags
- **itch.io page:** Demo gratuita
- **Social media:** Twitter/Reddit/Discord presence

**Archivos:**
- `marketing/trailer/` — Edición de trailer
- `marketing/screenshots/` — Capturas curadas
- `docs/steam_page.md` — Contenido para Steam

**Validación:** Trailer profesional, Steam page completa

---

### Tarea 4.E.2 — Publicación
**Skill:** `godot-prompter:export-pipeline`

**Plataformas:**
- **Steam** — Build final Windows + Mac + Linux
- **itch.io** — Demo gratuita (primeras 2 horas)

**Configuración de export:**
- Windows: .exe con icono personalizado
- Mac: .dmg con code signing
- Linux: .x86_64
- Web: HTML5 para itch.io (si aplica)

**Archivos:** Configuración de export en project.godot
**Validación:** Builds funcionan en todas las plataformas, sin crashes

---

## Archivos a Crear en Fase 4

| Archivo | Líneas estimadas | Descripción |
|---------|-------------------|-------------|
| `scripts/cutscenes/cutscene_manager.gd` | ~200 | Gestión de cutscenes |
| `scripts/cutscenes/cutscene_trigger.gd` | ~60 | Triggers de cutscenes |
| `scenes/cutscenes/*.tscn` | ~500 | 3+ escenas de cutscene |
| `scenes/horror/note_*.tscn` | ~800 | 20+ notas distribuidas |
| `scenes/decorations/narrative_*.tscn` | ~400 | 15+ props narrativos |
| `resources/localization/*.po` | ~2,000 | 3 idiomas |
| `scripts/ui/locale_manager.gd` | ~80 | Gestión de idioma |
| `scripts/ui/advanced_post_processing.gd` | ~100 | Postprocesado avanzado |
| `resources/compositor/*.tres` | ~100 | Configuraciones de compositor |
| **TOTAL** | **~4,240** | |

---

## Orden de Ejecución Recomendado

```
Semana 1-4:  4.A.1 (Cutscenes) + 4.A.2 (Contenido narrativo)
Semana 5-8:  4.B.1 (Audio final) + 4.B.2 (Postprocesado)
Semana 9-12: 4.C.1 (QA completo)
Semana 13-14: 4.D.1 (Localización)
Semana 15-16: 4.E.1 (Marketing)
Semana 17-18: 4.E.2 (Publicación)
```

---

## Validación por Sub-Fase

| Sub-Fase | Criterio de Aceptación |
|----------|----------------------|
| 4.A | Historia completa, cutscenes funcionan, sin bugs narrativos |
| 4.B | Audio profesional, visual polido, efectos correctos |
| 4.C | 30+ FPS, sin memory leaks, QA checklist completo |
| 4.D | 3 idiomas funcionando, textos correctos |
| 4.E | Builds publicables, Steam page completa, trailer profesional |

---

## Criterio de Lanzamiento

Antes de publicar, verificar:

- [ ] Todos los bugs críticos corregidos
- [ ] 30+ FPS en hardware mínimo especificado
- [ ] Save/load funciona correctamente
- [ ] Todas las cutscenes reproducibles
- [ ] Localización completa en 3 idiomas
- [ ] Audio final mixado y masterizado
- [ ] Steam page con descripción, screenshots, y requisitos
- [ ] Trailer de 60-90 segundos
- [ ] QA externo completado (3+ testers)
- [ ] Build testeada en Windows, Mac, Linux
