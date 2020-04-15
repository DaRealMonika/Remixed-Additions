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
            image         = 14,
            imageFile     = "items/rings.png",
            name          = "CharmRing_Name",
            info          = "CharmRing_Desc",
            stackable     = false,
            upgradable    = true,
            identified    = true,
            defaultAction = RPD.Actions.equip,
            price         = 89*2.5,
            isArtifact    = true
        }
    end,

    activate = function(self, item, hero)
        local charmfulBuff = RPD.affectBuff(item:getUser(), "Charmful", 10)
        charmfulBuff:setSource(item)
        RPD.glogp("Your now charming.")
        item:setDefaultAction(RPD.Actions.unequip)
    end,

    deactivate = function(self, item, hero)
        RPD.removeBuff(hero,"Charmful")
        RPD.glogn("Your no longer charming.")
        item:setDefaultAction(RPD.Actions.equip)
    end,

    bag = function(self, item)
        return "Keyring"
    end
}
