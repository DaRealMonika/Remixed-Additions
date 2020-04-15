--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"
local swords = require "scripts/lib/swords"

local swordLevel = 2
local swordDesc = "TestMeleeWeapon_Desc"

local baseDesc = swords.makeSword(swordLevel,swordDesc)

baseDesc.desc = function (self, item)
    return {
        image         = 0,
        imageFile     = "items/swords.png",
        name          = "Test Melee Weapon",
        info          = swordDesc,
        upgradable    = true,
        price         = 0,
        defaultAction = RPD.Actions.equip,
        equipable     = "WEAPON"
    }
end

baseDesc.getVisualName = function()
    return "ShortSword"
end

baseDesc.attackProc = function(self, item, attacker, defender, damage)
    if defender:buffLevel("Nightmare") > 0 then
        RPD.prolongBuff(defender, "Nightmare", defender:hp()/math.random(2,3))
    else
        RPD.affectBuff(defender, "Nightmare", defender:hp()/math.random(1,3))
    end
    return damage
end

return item.init(baseDesc)