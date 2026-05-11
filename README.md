# Gawęda

A top-down 2D RPG built with [LÖVE2D](https://love2d.org/) as a home-schooling high-school project by a teenage girl from Poland.

**All art** — characters, tilesets, UI elements, and effects — is created by her.
**Most of the code** is written by her dad.
Code comments and this README were assisted by AI.

---

## Story

TBD

## Features

- **Four playable characters** — switch between them on the fly with a satisfying spark-burst effect
- **Tile-based world** — maps built in [Tiled](https://www.mapeditor.org/) with per-tile collision boxes
- **Dialog system** — NPC conversations with an animated sliding dialog box
- **Retro pixel art rendering** — game world rendered at a low resolution and scaled up 4× for a crisp pixel look
- **Smooth camera** — follows the player and stays clamped within map boundaries

## Controls

| Key | Action |
|-----|--------|
| W / A / S / D | Move up / left / down / right |
| 1 – 4 | Switch to character 1–4 |

## Running the Game

1. Install [LÖVE2D](https://love2d.org/) (version 11.x or later).
2. Clone this repository.
3. Run the game from the project root:

```bash
love .
```

On Windows you can also drag the project folder onto `love.exe`.

## Project Structure

```
gaweda/
├── assets/
│   ├── fonts/          # LuckiestGuy (title), PixelifySans (UI)
│   ├── images/
│   │   ├── effects/    # Animated puff sprites
│   │   ├── gui/        # Dialog box frame
│   │   ├── particles/  # Spark texture for character-switch effect
│   │   └── sprites/    # Per-character walk & idle animations
│   └── maps/           # Tiled map files (exported to Lua)
├── src/
│   ├── core/
│   │   └── statemachine.lua   # Manages game states (menu / game / dialog)
│   ├── entities/
│   │   ├── camera.lua         # Follows the player, clamped to map bounds
│   │   ├── character.lua      # Character data and animation state
│   │   ├── map.lua            # Tiled map loader and tile renderer
│   │   ├── particles.lua      # Spark burst effect on character switch
│   │   ├── player.lua         # Movement, collision, character switching
│   │   └── sprite.lua         # Sprite sheet loader and frame advance
│   └── states/
│       ├── dialog.lua         # Dialog overlay with unfold animation
│       ├── game.lua           # Main gameplay loop
│       └── menu.lua           # Title screen
├── conf.lua                   # LÖVE2D engine configuration
└── main.lua                   # Entry point (load / update / draw)
```

## Credits

| Role | Who |
|------|-----|
| Game design & all artwork | HP |
| Programming | Dad |
| Code comments & README | AI (Claude) |

---

*Work in progress*
