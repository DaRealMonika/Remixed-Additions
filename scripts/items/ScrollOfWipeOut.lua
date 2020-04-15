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
            image         = 17,
            imageFile     = "items/scrolls.png",
            name          = "ScrollOfWipeOut_Name",
            info          = "ScrollOfWipeOut_Desc",
            stackable     = true,
            upgradable    = false,
            identified    = true,
            defaultAction = "Scroll_ACRead",
            price         = 0
        }
    end,
    actions = function(self, item, hero)
        return {RPD.Actions.read}
    end,

    execute = function(self, item, hero, action)
        local immuneMobs = {MirrorImage=true,Shopkeeper=true,ImpShopkeeper=true,TempMoney=true,ShadyNPC=true,BishopNPC=true,BlackCat=true,CockerSpanielNPC=true,Yog=true,YogsEye=true,YogsBrain=true,YogsHeart=true,YogsTeeth=true,RottingFist=true,BurningFist=true}
        local resistMobs = {Goo=true,SpiderQueen=true,Lich=true,Tengu=true,IceGuardianCore=true,IceGuardian=true,DM300=true,King=true,ShadowLord=true}
        local healMobs = {BoneDragon=true,GhostWarrior=true,GhostAssassin=true,GhostArcher=true,GhostMage=true}
        if action == RPD.Actions.read then
            local level = RPD.Dungeon.level
            local target
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= item:getUser() and not target:isPet() and not immuneMobs[target:getMobClassName()] then
                            if resistMobs[target:getMobClassName()] and not healMobs[target:getMobClassName()] then
                                target:damage(math.random(1,5), item:getUser())
                                item:getUser():damage(item:getUser():hp()/4, item:getUser())
                            elseif not resistMobs[target:getMobClassName()] and healMobs[target:getMobClassName()] then
                                if target:hp() <= 1 then
                                    target:heal(target:ht()/4, item:getUser())
                                else
                                    target:heal(target:hp()/3, item:getUser())
                                end
                                item:getUser():damage(item:getUser():hp()/2, item:getUser())
                            else
                                target:damage(target:ht(), item:getUser())
                            end
                        end
                    end
                end
            end
            item:detach(item:getUser():getBelongings().backpack)
            item:getUser():spendAndNext(TIME_TO_READ)
        end
    end,

    bag = function(self, item)
        return "ScrollHolder"
    end
}
