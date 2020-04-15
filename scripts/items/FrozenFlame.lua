--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"

local cooldown

return item.init{
    desc  = function (self, item)
--        RPD.new("com.watabou.pixeldungeon.sprites.ItemSprite.Glowing", Glowing(0xD33030))
        return {
            image         = 3,
            imageFile     = "items/materials.png",
            name          = "FrozenFlame_Name",
            info          = "FrozenFlame_Desc",
            stackable     = true,
            upgradable    = false,
            identified    = true,
            price         = 0
        }
    end,

    onThrow = function(self, item, cell)
        if RPD.Dungeon.level.map[cell] ~= RPD.Terrain.WATER_TILES then
            item:dropTo(cell)
        end
    end
}