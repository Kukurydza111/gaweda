local map = {}

-- Loads a Tiled map (exported to Lua) and prepares it for rendering.
-- `filename` is the require-style path to the .lua map file exported from Tiled.
-- Each tileset referenced by the map is also loaded: its PNG is turned into a Love2D image,
-- its tiles are sliced into quads, and any per-tile collision boxes are extracted.
-- Returns the fully populated `level` table ready for map.drawLayer().
function map.load(filename)
    local level = require(filename)
    level.quads = {}           -- flat table: gid -> { quad, image }
    level.collisionboxes = {}  -- flat table: gid -> list of { offsetX, offsetY, width, height }

    for k, v in pairs(level.tilesets) do
        -- Each tileset entry in the map has a `name` and a `firstgid`.
        -- `firstgid` is the global tile ID where this tileset's tiles begin,
        -- ensuring tile IDs are unique across multiple tilesets in one map.
        local t = require("assets/maps/" .. v.name)
        t.loveimage = love.graphics.newImage("assets/maps/" .. t.name .. ".png")
        map.loadTileQuads(t, level.quads, v.firstgid)
        map.loadTileCollisionBoxes(t, level.collisionboxes, v.firstgid)
        level.tilesets[k].tileset = t
    end

    return level
end

-- Slices the tileset PNG into individual Love2D quads, one per tile.
-- Quads are stored in `quads` indexed by global tile ID (firstgid + local index),
-- so tile data from the map layer can look up the right quad directly.
-- The tileset image is laid out as a grid; we step through it column by column,
-- then row by row, respecting `margin` (border around the whole image) and
-- `spacing` (gap between individual tiles).
function map.loadTileQuads(tileset, quads, firstgid)
    local x = tileset.margin   -- current pixel X in the tileset image
    local y = tileset.margin   -- current pixel Y in the tileset image
    local c = 1                -- current column (1-based)
    local qi = firstgid        -- global tile ID for the tile being processed

    for i = 1, tileset.tilecount do
        local quad = love.graphics.newQuad(
            x, y,
            tileset.tilewidth, tileset.tileheight,
            tileset.imagewidth, tileset.imageheight
        )
        quads[qi] = {}
        quads[qi].quad = quad
        quads[qi].image = tileset.loveimage
        qi = qi + 1

        c = c + 1
        if c > tileset.columns then
            -- end of row: wrap to the next row
            c = 1
            x = tileset.margin
            y = y + tileset.tileheight + tileset.spacing
        else
            -- advance to the next column
            x = x + tileset.tilewidth + tileset.spacing
        end
    end
end

-- Reads per-tile collision boxes exported from Tiled's tile object groups.
-- In Tiled you can draw rectangles on individual tiles to mark solid areas;
-- this function turns those rectangles into { offsetX, offsetY, width, height }
-- entries stored in `collisionboxes` under the tile's global ID.
-- Tiles with no object group get an empty list, so collision checks can always
-- index into `collisionboxes` without a nil guard.
function map.loadTileCollisionBoxes(tileset, collisionboxes, firstgid)
    for i, tile in ipairs(tileset.tiles) do
        if not collisionboxes[firstgid + tile.id] then
            collisionboxes[firstgid + tile.id] = {}
        end
        if tile.objectgroup then
            for j, object in ipairs(tile.objectGroup.objects) do
                local collisionbox = {
                    offsetX = object.x,
                    offsetY = object.y,
                    width   = object.width,
                    height  = object.height
                }
                table.insert(collisionboxes[firstgid + tile.id], collisionbox)
            end
        end
    end
end

-- Draws a single tile layer of the map to the screen.
-- Only the tiles that fit within the viewport are drawn (culling).
--
-- Parameters:
--   level         - the level table returned by map.load()
--   layer         - 1-based index into level.layers
--   offsetX/Y     - tile-grid scroll offset (which tile column/row is at the top-left corner)
--   fineOffsetX/Y - sub-tile pixel offset for smooth scrolling (currently unused)
--   renderWidth/H - pixel dimensions of the visible area; used to calculate how many tiles fit
function map.drawLayer(level, layer, offsetX, offsetY, fineOffsetX, fineOffsetY, renderWidth, renderHeight)
    local l = level.layers[layer]
    if l.type ~= "tilelayer" then return end

    -- How many tiles fit horizontally/vertically in the viewport.
    -- Clamped to the layer dimensions so we never read outside the data array.
    local tilesX = math.min(math.floor((renderWidth  - 1) / level.tilewidth)  + 1, l.width)
    local tilesY = math.min(math.floor((renderHeight - 1) / level.tileheight) + 1, l.height)

    for y = 0, tilesY - 1 do
        for x = 0, tilesX - 1 do
            -- Tiled stores layer data as a flat, 1-based array in row-major order.
            -- We offset by (offsetX, offsetY) to implement scrolling.
            local tile = l.data[1 + ((y + offsetY) * l.width + (x + offsetX))]
            if tile > 0 then  -- 0 means empty cell; skip it
                love.graphics.draw(
                    level.quads[tile].image,
                    level.quads[tile].quad,
                    x * level.tilewidth,
                    y * level.tileheight
                )
            end
        end
    end
end


return map
