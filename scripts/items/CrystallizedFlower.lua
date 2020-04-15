--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"

local cooldown

local function buffs(cell, user, lvl, mul)
    local level = RPD.Dungeon.level
    local hero = RPD.Dungeon.hero
    local target = RPD.Actor:findChar(cell)
    local time
    user:heal(math.random(2,6)*mul, user)
    if target then
        if target ~= hero then
            if target:isPet() then
                target:heal((math.random(2,6)*2)*mul, user)
            else
                target:damage(math.random(1,3)*lvl, user)
                if target:buffLevel("Roots") > 0 then
                    time = math.random(1,2)*lvl
                else
                    time = math.random(1,3)*lvl
                end
                RPD.prolongBuff(target, RPD.Buffs.Roots, time)
            end
        end
    end
    if user:buffLevel("Barkskin") > 0 then
        time = math.random(3,8)*lvl
    else
        time = math.random(13,19)*mul
    end
    RPD.prolongBuff(user, RPD.Buffs.Barkskin, time)
    if target then
        if target ~= hero then
            if target:isPet() then
                RPD.prolongBuff(target, RPD.Buffs.Barkskin, math.random(3,8)*lvl)
            end
        end
    end
end

return item.init{
    desc  = function (self, item)

        return {
            image         = 1,
            imageFile     = "items/special.png",
            name          = "CrystallizedFlower_Name",
            info          = "CrystallizedFlower_Desc",
            stackable     = false,
            upgradable    = true,
            identified    = true,
            defaultAction = RPD.Actions.equip,
            price         = 0,
            isArtifact    = true
        }
    end,

    actions = function(self, item, hero)
        cooldown = self.data.cooldown
        return {RPD.Actions.use}
    end,

    execute = function(self, item, hero, action)
        if action == RPD.Actions.use then
            local level = RPD.Dungeon.level
            local hero = RPD.Dungeon.hero
            local user = item:getUser()
            local userPos = RPD.getXy(user)
            local lvl = item:level()
            local mul = 1
            local Item = user:getBelongings():getItem(item:getClassName())
            if lvl >= 0 then
                lvl = lvl+1
            end
            if lvl > 0 then
                if lvl < 3 and lvl >= 1 then
                    mul = 2
                elseif lvl < 5 and lvl >= 3 then
                    mul = 3
                elseif lvl >= 5 then
                    mul = 4
                end
            elseif lvl < 0 then
                if lvl > -3 and lvl <= -1 then
                    mul = -2
                elseif lvl > -5 and lvl <= -3 then
                    mul = 3
                elseif lvl <= -5 then
                    mul = -4
                end
            else
                mul = 0
            end
            if Item and Item:isEquipped(item:getUser()) then
--[[                if cooldown > 0 then
                    RPD.glogn("Item_OnCooldown", item:name())
                    self.data.cooldown = 0
                else
                    self.data.cooldown = 5
                end]]
                user:spendAndNext(2)
                for x = -5-mul, 5+mul do
                    for y = -5-mul, 5+mul do
                        local pos = level:cell(userPos[1]+x,userPos[2]+y)
                        if level.map[pos] == 2 then
                            if math.random(1,100) <= 5*lvl then
                                level:set(pos-1, 15)
                                RPD.GameScene:updateMap()
                                buffs(pos, user, lvl, mul)
                            end
                        end
                        if level.map[pos] == 1 then
                            if math.random(1,100) <= 3*lvl then
                                level:set(pos-1, 2)
                                RPD.GameScene:updateMap()
                                buffs(pos, user, lvl, mul)
                            end
                        end
                    end
                end
                for i = 0, level:getLength() do
                    local target = RPD.Actor:findChar(i)
                    if target then
                        if level:distance(user:getPos(), target:getPos()) <= 1+mul then
                            if target ~= hero then
                                if not target:isPet() then
                                    local time
                                    target:damage(math.random(1,3)*lvl, user)
                                    if target:buffLevel("Vertigo") > 0 or target:buffLevel("Weakness") > 0 then
                                        time = math.random(1,3)*lvl
                                    else
                                        time = math.random(6,9)*lvl
                                    end
                                    RPD.prolongBuff(target, RPD.Buffs.Vertigo, time)
                                    RPD.prolongBuff(target, RPD.Buffs.Weakness, time)
                                end
                            end
                        end
                    end
                end
            else
                RPD.glogn("Item_NeedsEquip", item:name())
            end
        end
    end,

    activate = function(self, item, hero)
        item:setDefaultAction(RPD.Actions.use)
    end,

    deactivate = function(self, item, hero)
        item:setDefaultAction(RPD.Actions.equip)
    end
}
