--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

local dmg
local upgrades = 4
local uses = 0

return item.init{
    desc  = function (self, item)

        return {
            image         = 8,
            imageFile     = "items/ranged.png",
            name          = "MagicGun_Name",
            info          = "MagicGun_Desc",
            stackable     = false,
            upgradable    = false,
            identified    = true,
            defaultAction = "magicgun_action1",
            price         = 0
        }
    end,
    actions = function(self, item, hero)
        return {"magicgun_action1","magicgun_action2","magicgun_action3","Just Kill","All out Kill"}
    end,

    cellSelected = function(self, item, action, cell)
        if action == "magicgun_action1" then
            local mob = RPD.Actor:findChar(cell)

            if mob ~= nil then
                if mob ~= item:getUser() then
                    if mob:getOwnerId() == item:getUser():getId() and mob:hp() <= 0 then
                        mob:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                        RPD.playSound("snd_curse.mp3")
                    elseif mob:getOwnerId() == item:getUser():getId() then
                        RPD.playSound("snd_curse.mp3")
                    end
                    RPD.zapEffect(item:getUser():getPos(), cell, "Lightning")
                    mob:damage(dmg, item:getUser())
                    if uses >= upgrades then
                        item:level(item:level()+1)
                        upgrades = upgrades+math.random(4, 6)
                        uses = uses/2
                        RPD.glogp(RPD.textById("item_upgraded"):format(item:name()))
                    else
                        uses = uses+1
                    end
                end
            end
        end

        if action == "Just Kill" then
            local mob = RPD.Actor:findChar(cell)

            if mob ~= nil then
                if mob ~= item:getUser() then
                    if mob:getOwnerId()== item:getUser():getId() then
                        mob:getSprite():emitter():burst(RPD.Sfx.ShadowParticle.CURSE, 6)
                        RPD.playSound("snd_curse.mp3")
                    end
                    RPD.zapEffect(item:getUser():getPos(), cell, "Lightning")
                    mob:destroy()
                    mob:getSprite():killAndErase()
                end
            end
        end
    end,

    execute = function(self, item, hero, action)
        if action == "magicgun_action1" then
            item:selectCell("magicgun_action1","magicgun_shoot")
            if item:level() == 0 then
                dmg = math.random(1, 5)
            else
                dmg = math.random(3, 8)*item:level()
            end
        end

        if action == "magicgun_action2" then
            local level = RPD.Dungeon.level
            local target
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= item:getUser() and not target:isPet() and target:getEntityKind() ~= "Shopkeeper" and target:getEntityKind() ~= "ImpShopkeeper" then
                            RPD.zapEffect(item:getUser():getPos(), target:getPos(), "Lightning")
                            target:damage(target:hp(), item:getUser())
                        end
                    end
                end
            end
        end

        if action == "magicgun_action3" then
            local level = RPD.Dungeon.level
            local target
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= item:getUser() then
                            RPD.zapEffect(item:getUser():getPos(), target:getPos(), "Lightning")
                            target:damage(target:hp(), item:getUser())
                        end
                    end
                end
            end
        end

        if action == "Just Kill" then
            item:selectCell(action,"magicgun_shoot")
        end

        if action == "All out Kill" then
            local level = RPD.Dungeon.level
            local target
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= item:getUser() then
                            RPD.zapEffect(item:getUser():getPos(), target:getPos(), "Lightning")
                            target:destroy()
                            target:getSprite():killAndErase()
                        end
                    end
                end
            end
        end
    end,
}