--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--
local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"
local shields = require "scripts/lib/shields"

local shieldLevel = 5
local shieldDesc  = "RoyalShield_desc"

local baseDesc = shields.makeShield(shieldLevel,shieldDesc)

baseDesc.desc = function (self, item)
    return {
        image         = 3,
        imageFile     = "items/shields.png",
        name          = "RoyalShield_name",
        info          = shieldDesc,
        price         = 160 * shieldLevel,
        defaultAction = RPD.Actions.equip,
        equipable     = "left_hand",
        upgradable    = true
    }
end

baseDesc.activate = function (self, item, hero)
    if item:slotName() == "LEFT_HAND" then
        local shieldBuff = RPD.affectBuff(hero, "ShieldLeft", shields.rechargeTime(shieldLevel, hero:effectiveSTR()))
        shieldBuff:level(shieldLevel)
        shieldBuff:setSource(item)
        item:setDefaultAction(RPD.Actions.unequip)
    end
end

baseDesc.deactivate = function (self, item, hero)
    if item:slotName() == "LEFT_HAND" then
        RPD.removeBuff(hero, "ShieldLeft")
        item:setDefaultAction(RPD.Actions.equip)
    end
end

return item.init(baseDesc)
