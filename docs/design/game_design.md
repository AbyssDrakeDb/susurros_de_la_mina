# Game Design Document - Susurros de la Mina

**Versión**: 1.0  
**Última actualización**: 25 de Junio, 2026  
**Género**: Exploración, Minería, Supervivencia → Survival Horror  
**Plataforma**: PC (Windows, Linux, macOS)  
**Motor**: Godot 4.7

---

## Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Concepto del Juego](#concepto-del-juego)
3. [Pilares de Diseño](#pilares-de-diseño)
4. [Mecánicas Principales](#mecánicas-principales)
5. [Bucle de Juego](#bucle-de-juego)
6. [Sistemas de Juego](#sistemas-de-juego)
7. [Contenido](#contenido)
8. [Progresión](#progresión)
9. [Narrativa](#narrativa)
10. [Dirección Artística](#dirección-artística)
11. [Dirección de Audio](#dirección-de-audio)
12. [Métricas de Éxito](#métricas-de-éxito)

---

## Visión General

### Elevator Pitch

> "Un juego de minería relajante que se convierte en tu pesadilla."

### Objetivo del Jugador

El jugador asume el rol de un minero solitario que desciende a una mina en busca de fortuna. A medida que explora más profundo, descubre que la mina oculta un secreto antiguo y una presencia que no quiere ser molestada.

### Audiencia Objetivo

| Aspecto | Descripción |
|---------|-------------|
| Edad | 16-35 años |
| Género | Todos |
| Preferencias | Minecraft, Stardew Valley, Amnesia, Outlast |
| Sesión promedio | 30-60 minutos |
| Plataforma principal | PC (Steam) |

---

## Concepto del Juego

### Nombre

**Susurros de la Mina** (Whispers of the Mine)

### Género

- **Primario**: Exploración y Minería (First-Person)
- **Secundario**: Survival Horror (Progressive)
- **Tags**: Mining, Exploration, Horror, Atmospheric, Indie

### Tono y Atmósfera

| Fase | Tono | Emoción Objetivo |
|------|------|------------------|
| Inicio | Solitario, esperanzador | Calma, curiosidad |
| Minería | Relajante, adictivo | Satisfacción, progresión |
| Transición | Inquietante, misterioso | Tensión creciente |
| Horror | Opresivo, aterrador | Miedo, desesperación |

### Gancho Comercial

1. **Bucle minero adictivo** - "Una más veta y listo"
2. **Transición inesperada** - "¿Qué está pasando?"
3. **Historia ambiental** - "¿Qué le pasó a los demás mineros?"
4. **Horror psicológico** - "¿Eso fue real o imaginé?"

---

## Pilares de Diseño

### 1. Minería Satisfactoria

> "Cada golpe debe sentirse recompensado"

- Feedback visual y sonoro claro
- Progresión visible (mejores herramientas, más minerales)
- Riesgo/recompensa equilibrado
- Variedad de minerales y biomas

### 2. Transición Orgánica

> "El horror debe crecer, no aparecer"

- Señales sutiles al principio
- El jugador controla cuándo avanza
- Cambio gradual de mecánicas
- Narrativa que justifica el cambio

### 3. Supervivencia Estratégica

> "Recursos escasos, decisiones difíciles"

- Batería limitada
- Ruido atrae peligro
- Inventario reducido
- Zonas seguras vs. zonas de riesgo

### 4. Narrativa Ambiental

> "La mina cuenta su historia"

- Diarios y notas
- Restos de otros mineros
- Estructuras abandonadas
- La criatura como parte de la historia

---

## Mecánicas Principales

### Sistema de Minería

#### Concepto

El jugador excava vetas de minerales en paredes usando picos. Cada mineral tiene vida, tipo, rareza y valor.

#### Mecánicas

```yaml
Tipos de Mineral:
  - Cobre: Común, bajo valor, fácil de minar
  - Hierro: Común, valor medio
  - Plata: Poco común, buen valor
  - Oro: Raro, alto valor
  - Gemas: Muy raras, alto valor
  - Mineral Maldito: Especial, desencadena horror

Herramientas:
  Básica:
    - Pico básico: Daño 25, ruido bajo
    - Pico reforzado: Daño 40, ruido medio
    - Taladro manual: Daño 60, ruido alto
  
  Mejoras:
    - Picos silenciosos: -50% ruido
    - Picos resistentes: +100% durabilidad
    - Picos mágicos: +25% minerales raros

Feedback:
  Visual:
    - Animación de golpe
    - Partículas al romperse
    - Flash de color por tipo
  
  Sonoro:
    - Sonido por tipo de mineral
    - Eco según profundidad
    - Variación de pitch
```

#### Flujo de Minería

```
1. Encontrar veta de mineral
2. Equipar pico
3. Apuntar a la veta
4. Presionar botón de minar
5. Animación de golpe
6. Daño aplicado
7. Partículas y sonido
8. Repetir hasta romper
9. Recoger minerales
10. Añadir al inventario
```

### Sistema de Linterna

#### Concepto

La linterna es la única fuente de luz del jugador. Usa batería que se agota y atrae a la criatura.

#### Mecánicas

```yaml
Batería:
  Inicial: 100%
  Drenaje: 2% por segundo
  Recarga: Pilas encontradas/compradas
  
Estados:
  Encendida:
    - Ilumina área
    - Consume batería
    - Atrae criatura (bajo)
  
  Apagada:
    - Oscuridad casi total
    - No consume batería
    - Seguridad relativa
  
  Titilante:
    - Batería < 20%
    - Efecto visual
    - Alerta al jugador

Modos:
  Normal:cono de luz, 100% intensidad
  Ahorro:cono amplio, 50% intensidad
  SOS:parpadeo rápido, atrae/despista
```

### Sistema de Inventario

#### Concepto

Mochila limitada que fuerza decisiones sobre qué llevar y qué dejar.

#### Mecánicas

```yaml
Capacidad:
  Inicial: 20 slots
  Mejoras: +5, +10, +15 slots
  
Tipos de Item:
  Minerales:
    - Stackable (hasta 99)
    - Ocupan 1 slot por tipo
  
  Herramientas:
    - No stackable
    - Ocupan 1 slot cada una
  
  Consumibles:
    - Stackable (hasta 10)
    - Pilas, vendas, etc.
  
  Quest Items:
    - No stackable
    - Ocupan 1 slot cada uno

Decisiones:
  - ¿Llevo más minerales o herramientas?
  - ¿Cuántas pilas necesito?
  - ¿Dejo espacio para tesoros raros?
```

### Sistema de Movimiento

#### Concepto

Movimiento en primera persona fluido y responsivo.

#### Controles

```yaml
Movimiento:
  WASD: Mover
  Shift: Correr (consume energía)
  Espacio: Saltar
  
Cámara:
  Ratón: Rotar cámara
  Sensibilidad: Ajustable
  
Interacción:
  E: Interactuar
  Click Izq: Minar/Usar herramienta
  F: Encender/Apagar linterna
  
UI:
  Tab: Inventario
  Escape: Pausa
  M: Mapa (futuro)
```

### Sistema de Superficie

#### Concepto

Área segura donde el jugador puede vender, comprar y descansar.

#### Elementos

```yaml
Zona Segura:
  - Campamento minero
  - Tienda del viejo minero
  - Mesa de mejoras
  - Cabaña para guardar
  
NPCs:
  Viejo Minero:
    - Compra minerales
    - Vende mejoras
    - Da pistas narrativas
    - Tienda rotativa

Acciones:
  - Vender minerales
  - Comprar mejoras
  - Comprar suministros
  - Descansar (recuperar energía)
  - Avanzar historia
```

---

## Bucle de Juego

### Ciclo Principal

```
                    ┌─────────────────┐
                    │    SUPERFICIE   │
                    │  • Vender       │
                    │  • Comprar      │
                    │  • Mejorar      │
                    │  • Descansar    │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  DESCENSO       │
                    │  • Explorar     │
                    │  • Minar        │
                    │  • Sobrevivir   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
      ┌──────────┐   ┌──────────┐   ┌──────────┐
      │ MINERAL  │   │ PELIGRO  │   │ DESCUBR. │
      │ Común    │   │ Caída    │   │ Nota     │
      │ Raro     │   │ Criatura │   │ Diario   │
      │ Maldito  │   │ Oscuro   │   │ Sala     │
      └──────────┘   └──────────┘   └──────────┘
              │              │              │
              └──────────────┼──────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   RETORNO       │
                    │  • Superficie   │
                    │  • O muerte     │
                    └─────────────────┘
```

### Métricas del Bucle

| Métrica | Objetivo |
|---------|----------|
| Tiempo por run | 15-30 minutos |
| Minerales por run | 5-15 |
| Muertes promedio | 1 cada 3 runs |
| Progresión | 1 upgrade cada 2-3 runs |

---

## Sistemas de Juego

### Sistema de Economía

#### Monedas

- **Oro**: Moneda principal, se obtiene vendiendo minerales

#### Precios Base

| Mineral | Precio Compra | Precio Venta |
|---------|---------------|--------------|
| Cobre | 5 | 10 |
| Hierro | 10 | 20 |
| Plata | 25 | 50 |
| Oro | 50 | 100 |
| Gema | 100 | 200 |
| Maldito | ? | ? |

#### Costos de Mejora

| Mejora | Costo | Efecto |
|--------|-------|--------|
| Mochila +5 | 200 | +5 slots |
| Linterna mejorada | 300 | -50% drenaje |
| Pico reforzado | 500 | +50% daño |
| Botas silenciosas | 400 | -30% ruido |

### Sistema de Dificultad

#### Factores de Dificultad

```yaml
Profundidad:
  - Más oscuridad
  - Menos minerales comunes
  - Más minerales raros
  - Mayor riesgo

Herramientas:
  - Mejores herramientas = más eficiencia
  - Pero más ruido

Inventario:
  - Capacidad limitada
  - Fuerza decisiones

Batería:
  - Recursos escasos
  - Timing importante

Criatura:
  - Más agresiva en profundidad
  - Reacciona a ruido y luz
```

#### Curva de Dificultad

```
Dificultad
    ▲
    │         ╭─────── Horror activo
    │        ╱
    │       ╱
    │      ╱
    │     ╱  Transición
    │    ╱
    │   ╱
    │  ╱  Zona segura
    │ ╱
    │╱
    └──────────────────────────► Profundidad
    0    2    4    6    8    10
```

---

## Contenido

### Biomas

| Bioma | Profundidad | Características | Minerales |
|-------|-------------|-----------------|-----------|
| Superficie | 0 | Campamento, seguro | Ninguno |
| Somero | 1-3 | Fácil, tutorial | Cobre, Hierro |
| Cristalino | 4-5 | Cristales brillantes | Plata, Cristales |
| Abandonado | 6-7 | Estructuras rotas | Oro, Herramientas |
| Profundo | 8-9 | Oscuro, peligroso | Gemas, Raros |
| Maldito | 10 | Horror activo | Mineral Maldito |

### Salas Prefabricadas

```yaml
Tipos de Sala:
  Entrada:
    - Túnel de entrada
    - Primera|mina
    - Tutorial implícito
  
  Mineral:
    - Cámara de minerales
    - Vetas expuestas
    - Riesgo/recompensa
  
  Historia:
    - Diario de otro minero
    - Restos de campamento
    - Estructura abandonada
  
  Desafío:
    - Plataformas
    - Puzles ambientales
    - Trampas
  
  Jefe:
    - Sala del mineral maldito
    - Evento narrativo
    - Cambio de fase
```

### Items

#### Herramientas

| Herramienta | Daño | Ruido | Durabilidad | Costo |
|-------------|------|-------|-------------|-------|
| Pico básico | 25 | 1 | 100 | Inicio |
| Pico reforzado | 40 | 2 | 150 | 500 |
| Taladro manual | 60 | 3 | 80 | 800 |
| Pico silencioso | 30 | 0.5 | 120 | 600 |

#### Consumibles

| Item | Efecto | Duración | Costo |
|------|--------|----------|-------|
| Pila | +50% batería | Instant | 50 |
| Venda | +25 salud | 3s | 30 |
| Barra de energía | +50 energía | Instant | 40 |

---

## Progresión

### Fases del Juego

#### Fase 1: El Comienzo (0-2 horas)

```yaml
Objetivo: Aprender mecánicas básicas
Contenido:
  - Tutorial en superficie
  - Primera mina (fácil)
  - Encontrar copper
  - Volver a vender
  - Comprar primera mejora

Desbloqueos:
  - Pico básico
  - Linterna
  - Inventario básico
```

#### Fase 2: Profundización (2-5 horas)

```yaml
Objetivo: Explorar más, mejores recursos
Contenido:
  - Biomas nuevos
  - Minerales raros
  - Primeras señales de horror
  - Historia ambiental

Desbloqueos:
  - Pico reforzado
  - Mochila mejorada
  - Linterna mejorada
```

#### Fase 3: El Descubrimiento (5-8 horas)

```yaml
Objetivo: Encontrar el mineral maldito
Contenido:
  - Sala del mineral maldito
  - Evento narrativo
  - Activación de la criatura
  - Cambio de género

Desbloqueos:
  - Nuevas mecánicas de horror
  - Herramientas de supervivencia
```

#### Fase 4: El Horror (8-12 horas)

```yaml
Objetivo: Sobrevivir y escapar
Contenido:
  - Criatura activa
  - Mecánicas de evasión
  - Objetivos de historia
  - Finales

Desbloqueos:
  - Picos mágicos
  - Habilidades de supervivencia
  - Múltiples finales
```

### Tabla de Desbloqueos

| Hora | Desbloqueo | Impacto |
|------|------------|---------|
| 0:00 | Pico básico | Inicio |
| 0:30 | Primera venta | Economía |
| 1:00 | Primera mejora | Progresión |
| 2:00 | Bioma cristalino | Exploración |
| 4:00 | Señales de horror | Tensión |
| 6:00 | Mineral maldito | Giro |
| 8:00 | Criatura activa | Horror |
| 10:00 | Objetivos finales | Narrativa |
| 12:00 | Final | Cierre |

---

## Narrativa

### Historia Resumen

**Acto 1: Esperanza**
Un minero solitario llega a una mina abandonada en busca de fortuna. Todo parece normal al principio.

**Acto 2: Duda**
A medida que desciende, comienza a escuchar susurros y ver sombras. ¿Es su imaginación?

**Acto 3: Miedo**
Descubre un mineral extraño que despierta una presencia ancestral. La mina ya no está vacía.

**Acto 4: Desesperación**
La criatura lo persigue. Debe encontrar una manera de escapar o sellarla para siempre.

### Personajes

| Personaje | Rol | Descripción |
|-----------|-----|-------------|
| Jugador | Protagonista | Minero solitario, nombre no revelado |
| Viejo Minero | NPC | Comerciante, conoce la historia |
| La Criatura | Antagonista | Entidad subterránea, reacciona a ruido/luz |
| Mineros Pasado | Lore | Diarios, notas, restos |

### Estructura Narrativa

```yaml
Explícita:
  - Diarios encontrados
  - Notas del viejo minero
  - Eventos de cutscene
  
Ambiental:
  - Entorno cuenta historia
  - Estructuras abandonadas
  - Restos de campamentos
  
Implícita:
  - La criatura tiene motivaciones
  - La mina tiene un pasado
  - El jugador deduce la verdad
```

### Diarios (Ejemplos)

**Diario 1 - Primer día**
> "Llegué a la mina hoy. El viejo minero me advirtió sobre las profundidades, pero necesito el dinero. Las primeras vetas de cobre están cerca de la superficie."

**Diario 5 - Señales**
> "Escucho cosas. Susurros lejanos. Pasos que no son los míos. El viejo me dijo que no descendiera más allá del nivel 5."

**Diario 10 - El Mineral**
> "Encontré algo. Un mineral que brilla con luz propia. No sé qué es, pero siento que me observa."

**Diario 15 - La Criatura**
> "Dios mío. Vi algo. Una sombra. Se movía cuando apagué la linterna. No estoy solo aquí abajo."

---

## Dirección Artística

### Estilo Visual

- **Low-poly oscuro** con iluminación dinámica
- **Paleta fría**: Azules, grises, verdes apagados
- **Toques cálidos**: Linterna, minerales, fuego

### Paleta de Colores

```yaml
Base:
  - Negro profundo: #0a0a0a
  - Gris oscuro: #1a1a2e
  - Azul oscuro: #16213e
  - Gris medio: #4a4a4a

Minerales:
  - Cobre: #cd7f32
  - Hierro: #808080
  - Plata: #c0c0c0
  - Oro: #ffd700
  - Cristal: #4fc3f7
  - Maldito: #9c27b0

Iluminación:
  - Linterna: #fff3e0
  - Antorcha: #ff6f00
  - Cristales: #80deea
  - Maldito: #7b1fa2
```

### Efectos Visuales

```yaml
Ambiente:
  - Niebla volumétrica
  - Partículas de polvo
  - Luz dinámica
  - Sombras suaves

Minería:
  - Partículas al golpear
  - Flash de colores
  - Destrucción de modelo
  - Gotas de sudor (futuro)

Horror:
  - Distorsión de lente
  - Oscurecimiento de bordes
  - Parpadeo de luz
  - Visión borrosa
```

---

## Dirección de Audio

### Música

| Situación | Estilo | BPM | Instrumentos |
|-----------|--------|-----|--------------|
| Superficie | Ambiental calmada | 60-80 | Guitarra, piano |
| Minando | Rítmica relajante | 90-110 | Percusión suave |
| Explorando | Misteriosa | 70-90 | Sintetizadores |
| Horror | Tenso, disonante | Variable | Cuerdas, percusión |
| Muerte | Dramática | Variable | Orquesta completa |

### Efectos de Sonido

```yaml
Minería:
  - Golpe de pico (por mineral)
  - Roca rompiéndose
  - Mineral cayendo
  - Eco en túnel

Ambiente:
  - Gotas de agua
  - Viento en túneles
  - Susurros lejanos
  - Pasos extraños

Jugador:
  - Pasos (por superficie)
  - Respiración
  - Latidos (baja salud)
  - Hambre/energía

Interfaz:
  - Click de botón
  - Abrir inventario
  - Completar transacción
  - Alerta de batería
```

### Audio Espacial

```yaml
Reverberación:
  - Superficie: Seco
  - Túnel pequeño: Eco corto
  - Cámara grande: Eco largo
  - Cueva: Reverberación máxima

Atenuación:
  - Distancia lineal
  - Bloqueado por paredes
  - Reduce con profundidad
```

---

## Métricas de Éxito

### Métricas Cuantitativas

| Métrica | Objetivo | Método de Medición |
|---------|----------|---------------------|
| Retención D1 | >40% | Analytics |
| Retención D7 | >20% | Analytics |
| Tiempo promedio sesión | >30 min | Analytics |
| Tasa de finalización | >30% | Checkpoints |
| Reviews positivas | >80% | Steam reviews |

### Métricas Cualitativas

| Métrica | Objetivo | Método de Medición |
|---------|----------|---------------------|
| "Adictivo" en reviews | Mencionado | Análisis de reviews |
| "Atmosférico" en reviews | Mencionado | Análisis de reviews |
| "Buena transición" | Mencionado | Análisis de reviews |
| Sin crashes | 0 | Reports de bugs |

### Playtesting

```yaml
Fase 1:
  - Test con 5 amigos
  - Validar loop minero
  - Ajustar dificultad
  
Fase 2:
  - Test con 10 personas
  - Validar atmósfera
  - Medir retención
  
Fase 3:
  - Beta pública en itch.io
  - Recoger feedback
  - Ajustar balance
  
Lanzamiento:
  - QA profesional
  - Performance testing
  - Certificación Steam
```

---

## Documentos Relacionados

- [Asset Pipeline](asset_pipeline.md) - Cómo integrar assets
- [Architecture](../technical/architecture.md) - Diseño técnico
- [Coding Standards](../technical/coding_standards.md) - Convenciones