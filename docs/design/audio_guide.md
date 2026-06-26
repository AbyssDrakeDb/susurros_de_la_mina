# Guía de Audio - Susurros de la Mina

**Última actualización**: 25 de Junio, 2026

---

## Audio Recomendado para Descarga Manual

La mayoría de这些requieren crear cuenta gratuita para descargar.

---

### 1. Cave Atmospheres (Signature Sounds) - RECOMENDADO

- **URL**: https://signaturesounds.org/store/p/cave-atmospheres
- **Licencia**: CC0 (Dominio Público)
- **Tamaño**: ~230MB
- **Contenido**:
  - Dark ambient cave drones
  - Air movements and subtle rumbles
  - Natural reverb tails
  - Underground ambience
- **Uso**: Ambiente principal de la mina
- **Formato**: WAV
- **Prioridad**: ALTA

### 2. Loops of Ambience (Signature Sounds)

- **URL**: https://signaturesounds.org/store/p/loops-of-ambience
- **Licencia**: CC0 (Dominio Público)
- **Tamaño**: ~227MB
- **Contenido**:
  - 90 ambient loops
  - Evolving textures
  - Seamless looping
- **Uso**: Música ambiental, drones de tensión
- **Formato**: WAV
- **Prioridad**: ALTA

### 3. Cave Ambience Loop (Freesound)

- **URL**: https://freesound.org/people/hushless/sounds/770379/
- **Licencia**: CC0 (Dominio Público)
- **Autor**: hushless
- **Duración**: 1:16
- **Descripción**: Loop ambiental de cueva oscura, diseñado para videojuegos
- **Uso**: Loop de ambiente de mina
- **Formato**: WAV
- **Prioridad**: ALTA

### 4. Kenney Audio Packs

- **URL**: https://kenney.nl/assets?q=audio
- **Licencia**: CC0 (Dominio Público)
- **Packs relevantes**:
  - Impact Sounds (golpes de pico)
  - Interface Sounds (UI)
  - Transition Sounds (transiciones)
- **Uso**: SFX generales
- **Prioridad**: MEDIA

### 5. Horror Ambience (Freesound - klankbeeld)

- **URL**: https://freesound.org/people/klankbeeld/sounds/128905/
- **Licencia**: CC-BY 4.0 (requiere atribución)
- **Autor**: klankbeeld
- **Uso**: Ambiente de horror
- **Prioridad**: MEDIA

### 6. Scott Buckley Music

- **URL**: https://www.scottbuckley.com.au/library/genre/ambient
- **Licencia**: CC-BY 4.0 (requiere atribución)
- **Contenido**: Música ambiental oscura
- **Uso**: Música de fondo, tenso
- **Prioridad**: MEDIA

### 7. Sonniss GDC Audio Bundle

- **URL**: https://sonniss.com/gameaudiogdc
- **Licencia**: Royalty-Free (sin atribución)
- **Contenido**: Miles de SFX profesionales
- **Uso**: SFX de calidad profesional
- **Prioridad**: ALTA (cuando esté disponible la edición 2026)

---

## SFX Específicos Necesarios

### Minería
| SFX | Fuente Recomendada | Notas |
|-----|-------------------|-------|
| Golpe de pico en roca | Freesound / Kenney | 3-4 variaciones |
| Roca rompiéndose | Cave Atmospheres | Efecto de destrucción |
| Mineral recolectado | Kenney Impact | Sonido satisfactorio |
| Golpe en metal | Freesound | Para minerales metálicos |

### Ambiente
| SFX | Fuente Recomendada | Notas |
|-----|-------------------|-------|
| Agua goteando | Cave Atmospheres | Loop continuo |
| Viento en túnel | Loops of Ambience | Variaciones por profundidad |
| Ecos lejanos | Cave Atmospheres | Reverb natural |
| Susurros | Freesound (horror) | Para fase de horror |

### Jugador
| SFX | Fuente Recomendada | Notas |
|-----|-------------------|-------|
| Pasos en roca | OpenGameArt CC0 | 4 variaciones |
| Pasos en metal | OpenGameArt CC0 | Raíles, vagonetas |
| Respiración | Generar con Audacity | Estrés, calma |
| Latidos | Generar con Audacity | Baja salud |

### Interfaz
| SFX | Fuente Recomendada | Notas |
|-----|-------------------|-------|
| Click de botón | Kenney UI | Genérico |
| Abrir inventario | Kenney UI | Succión |
| Completar venta | Kenney UI | Monedas |
| Alerta batería | Kenney Transition | Tensión |

### Horror
| SFX | Fuente Recomendada | Notas |
|-----|-------------------|-------|
| Criatura acechando | Freesound horror | Sutil, lejano |
| Grito de criatura | Freesound horror | Para cazando |
| Distorsión de realidad | Loops of Ambience | Para transiciones |
| Pasos de criatura | Generar propio | Lentos, pesados |

---

## Herramientas para Crear Audio Propio

### Audacity (Gratis)
- **URL**: https://audacityteam.org
- **Uso**: Editar y crear SFX
- **Técnicas**:
  - Reverb para ecos de cueva
  - Pitch shifting para voces de criatura
  - Layering para sonidos complejos
  - Noise generation para ambiente

### Bfxr (Gratis, Online)
- **URL**: https://www.bfxr.net
- **Uso**: Generar SFX retro/pixel art
- **Técnicas**:
  - Randomize para nuevos sonidos
  - Exportar como WAV

### SFXR (Gratis)
- **URL**: https://sfxr.me
- **Uso**: Generador de SFX procedural

---

## Proceso de Integración

1. **Descargar** archivos de las fuentes recomendadas
2. **Convertir** a formato OGG (música) o WAV (SFX cortos)
3. **Organizar** en carpetas:
   - `assets/audio/sfx/mining/` - Sonidos de minería
   - `assets/audio/sfx/player/` - Sonidos del jugador
   - `assets/audio/sfx/environment/` - Sonidos ambientales
   - `assets/audio/sfx/ui/` - Sonidos de interfaz
   - `assets/audio/sfx/creature/` - Sonidos de criatura
   - `assets/audio/music/ambient/` - Música ambiental
   - `assets/audio/music/tension/` - Música de tensión
4. **Importar** en Godot (arrastrar archivos)
5. **Configurar** AudioStreamPlayer en escenas
6. **Documentar** en CREDITS.md

---

## Notas de Licencia

| Licencia | Uso Comercial | Atribución | Ejemplo |
|----------|---------------|------------|---------|
| CC0 | ✅ | ❌ | Kenney, Signature Sounds |
| CC-BY | ✅ | ✅ | klankbeeld, Scott Buckley |
| Royalty-Free | ✅ | ❌ | Sonniss GDC |

**Regla**: Preferir CC0 siempre que sea posible. Para CC-BY, incluir crédito en CREDITS.md.

---

*Este documento se actualizará a medida que se descarguen e integren los assets de audio.*
