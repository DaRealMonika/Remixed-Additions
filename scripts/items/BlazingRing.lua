--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

return item.init{
    desc  = function (self, item)

        return {
            image         = 15,
            imageFile     = "items/rings.png",
            name          = "BlazingRing_Name",
            info          = "BlazingRing_Desc",
            stackable     = false,
            upgradable    = false,
            identified    = true,
            defaultAction = RPD.Actions.equip,
            price         = 89*5,
            isArtifact    = true
        }
    end,

    activate = function(self, item, hero)
        RPD.affectBuff(hero, "BlazingFiery", 10)
        RPD.permanentBuff(hero, RPD.Buffs.Light)
        RPD.glogp("Your now blazing with fiery.")
        item:setDefaultAction(RPD.Actions.unequip)
    end,

    deactivate = function(self, item, hero)
        RPD.removeBuff(hero,"BlazingFiery")
        RPD.removeBuff(hero,RPD.Buffs.Light)
        RPD.glogn("Your no longer blazing.")
        item:setDefaultAction(RPD.Actions.equip)
    end,

    bag = function(self, item)
        return "Keyring"
    end
}
