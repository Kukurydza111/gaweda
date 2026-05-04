local map = {}

-- this function loads a tiled exported lua and png files into a level structure
function map.load(filename)
    -- load Tiled project exported to lua 
    local level = require(filename)
    -- load associated tilesets, images, and quads from exported Tiled files
    level.quads = {}
    level.collisionboxes = {}
    for k, v in pairs(level.tilesets) do
        local t = require("assets/maps/" .. v.name)
        t.loveimage = love.graphics.newImage("assets/maps/" .. t.name .. ".png")
        map.loadTileQuads(t, level.quads, v.firstgid)
        map.loadTileCollisionBoxes(t, level.collisionboxes, v.firstgid)
        level.tilesets[k].tileset = t
    end

    return level
end

-- helper function to load individual tiles from a png
function map.loadTileQuads(tileset, quads, firstgid)
    local x = tileset.margin
    local y = tileset.margin
    local c = 1
    local qi = firstgid

    -- create quads in a for loop, as many quads as tilecount
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

        -- go to next column
        c = c + 1
        -- check if we need to go to next row
        if c > tileset.columns then
            c = 1
            x = tileset.margin
            y = y + tileset.tileheight + tileset.spacing
        else
            x = x + tileset.tilewidth + tileset.spacing
        end
    end
end

-- helper function to load collision boxes from Tiled tileset
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
                    width = object.width,
                    height = object.height
                }
                table.insert(collisionboxes[firstgid + tile.id], collisionbox)
            end
        end
    end
end

-- this function renders the base layer of the map
function map.drawLayer(level, layer, offsetX, offsetY, fineOffsetX, fineOffsetY, renderWidth, renderHeight)
    local l = level.layers[layer]
    if l.type ~= "tilelayer" then return end

    local tilesX = math.min(math.floor((renderWidth - 1) / level.tilewidth) + 1, l.width)
    local tilesY = math.min(math.floor((renderHeight - 1) / level.tileheight) + 1, l.height)

    for y = 0, tilesY - 1  do
        for x = 0, tilesX - 1 do
            local tile = l.data[1 + ((y + offsetY) * l.width + (x + offsetX))]
            if tile > 0 then
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
