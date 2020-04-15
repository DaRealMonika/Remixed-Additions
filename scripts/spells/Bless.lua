--
-- User: mike
-- Date: 03.06.2018
-- Time: 22:51
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local spell = require "scripts/lib/spell"

return spell.init{
    desc  = function ()
        return {
            image         = 0,
            imageFile     = "spellsIcons/common.png",
            name          = "Bless_Name",
            info          = "Bless_Info",
            magicAffinity = "Common",
            targetingType = "self",
            spellCost     = 3,
            level         = 2,
            castTime      = 2
        }
    end,
    cast = function(self, spell, chr)
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        for i = 0, level:getLength() do
            local target = RPD.Actor:findChar(i)
            local owner = target
            if target then
                if target ~= hero then
                    if target:getOwner() then
                        owner = target:getOwner()
                    end
                end
                if level.fieldOfView[target:getPos()] then
                    if target == chr or owner == chr then
                        RPD.prolongBuff(target, RPD.Buffs.Blessed, 50)
                        target:getSprite():emitter():start(RPD.Sfx.ShadowParticle.UP, 0.05, 10);
                    end
                end
            end
        end
        return true
    end
}