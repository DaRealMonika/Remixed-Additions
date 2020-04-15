--
-- User: mike
-- Date: 26.05.2018
-- Time: 21:32
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

return item.init{
    desc  = function ()
        return {
            image     = math.random(0,1),
            imageFile = "items/cacti_fruit.png",
            name      = "CactusFruit_Name",
            info      = "CactusFruit_Desc",
            stackable = true,
            defaultAction = "Food_ACEat",
            price         = 10
        }
    end,
    actions = function(self, item, hero)
        return {RPD.Actions.eat}
    end,

    execute = function(self, item, hero, action)
        if action == RPD.Actions.eat then
            if math.random(1,100) <= 25 then
                RPD.Buffs.Buff:affect(hero, RPD.Buffs.Poison, 3*math.random(3,6))
                hero:eat(item,RPD.Buffs.Hunger.HUNGRY,"CactusFruit_BadTaste")
            else
                hero:heal(hero:ht()/3, item)
                hero:eat(item,RPD.Buffs.Hunger.STARVING,"CactusFruit_Taste")
            end
        end
    end
}
