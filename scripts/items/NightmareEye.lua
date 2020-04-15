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
        return {
            image         = 0,
            imageFile     = "items/special.png",
            name          = "NightmareEye_Name",
            info          = "NightmareEye_Desc",
            stackable     = false,
            upgradable    = true,
            identified    = true,
            defaultAction = RPD.Actions.equip,
            price         = 0,
            isArtifact    = true
        }
    end,

    actions = function(self, item, hero)
        self.data.cooldown = self.data.cooldown or 0
        cooldown = self.data.cooldown
        return {RPD.Actions.use}
    end,

    execute = function(self, item, hero, action)
        if action == RPD.Actions.use then
            local level = RPD.Dungeon.level
            local hero = RPD.Dungeon.hero
            local user = item:getUser()
            local lvl = item:level()
            local mul = 0
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
            if Item and Item:isEquipped(user) then
--[[                if cooldown > 0 then
                    RPD.glogn("Item_OnCooldown", item:name())
                    self.data.cooldown = 0
                else
                    self.data.cooldown = 5
                end]]
                user:spendAndNext(2)
                for i = 0, level:getLength() do
                    local target = RPD.Actor:findChar(i)
                    if target then
                        if target ~= user then
                            local owner
                            if target ~= hero then
                                if target:getOwner() then
                                    owner = target:getOwner()
                                end
                            end
                            if level:distance(user:getPos(), target:getPos()) <= 4+mul and target ~= user then
                                if target ~= hero and target:getEntityKind() ~= "YogsEye" then
                                    if not target:isPet() then
                                        if target:buffLevel("Nightmare") > 0 then
                                            target:damage(math.random(16,32)*lvl, user)
                                        else
                                            target:damage(math.random(1,3)*lvl, user)
                                        end
                                    end
                                end
                            end
                            if level:distance(user:getPos(), target:getPos()) <= 5+mul and target ~= user then
                                if target ~= hero and target:getEntityKind() ~= "YogsEye" then
                                    if not target:isPet() then
                                        local time
                                        if target:buffLevel("Nightmare") > 0 then
                                            time = math.random(6,13)*mul
                                        else
                                            time = math.random(13,49)*mul
                                        end
                                        RPD.prolongBuff(target, "Nightmare", time)
                                        if target:buffLevel("Nightmare") > 0 then
                                            target:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.UP, 6)
                                        end
                                    end
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
