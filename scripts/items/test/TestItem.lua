--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"

local eq = ""
local candle =
{
    kind="Deco",
    object_desc="candle"
}

return item.init{
    desc  = function (self, item)
        RPD.glog("Created item with id:"..tostring(item:getId()))
        return {
            image         = 12,
            imageFile     = "items/food.png",
            name          = "Test item",
            info          = "Item for script tests",
            stackable     = false,
            defaultAction = "action1",
            price         = 0,
            isArtifact    = true,
            data = {
                activationCount = 0
            }
        }
    end,

    actions = function(self, item, hero)

        for k,v in pairs(self) do
            RPD.glog(tostring(k).." -> "..tostring(v))
        end

        if item:isEquipped(hero) then
            eq = "eq_"
        else
            eq = ""
        end
        item:setDefaultAction(eq.."action1")
        return {eq.."action1",
                eq.."action2",
                eq.."action3",
                eq.."action4",
                "inputText",
                "checkText",
                tostring(item:getId()),
                tostring(self.data.activationCount),
                tostring(self)
        }
    end,

    cellSelected = function(self, thisItem, action, cell)
        if action == eq.."action1" then
            RPD.glogp("performing "..action.." on cell "..tostring(cell).."\n")
            RPD.zapEffect(thisItem:getUser():getPos(), cell, "Lightning")
            local book = RPD.createItem("SpellBook", {identified=true})
            RPD.Dungeon.hero:collect(book)
            RPD.Dungeon.hero:collect(RPD.createItem("TomeOfKnowledge", {quantity=10000}))
            RPD.createLevelObject(candle, cell)
            for k,v in pairs(candle) do
                RPD.glogw("\""..tostring(k).."\" = \""..tostring(v).."\"")
            end
            RPD.GameScene:particleEffect("WaterSink", cell);
        end
    end,

    execute = function(self, item, hero, action)
        if action == eq.."action1" then
            item:selectCell(eq.."action1","Please select cell for action 1")
        end

        if action == eq.."action2" then
            self.data.activationCount = self.data.activationCount + 1
            RPD.glogp(tostring(item:getId()).." "..action)
            RPD.affectBuff(hero,"Counter",1):level(10)
        end

        if action == eq.."action3" then
            local packedItem = RPD.packEntity(item)
            RPD.glogh(packedItem)
        end

        if action == eq.."action4" then
            local packedItem = RPD.packEntity(item)
            local restoredItem = RPD.unpackEntity(packedItem)
            local luaDesc = RPD.toLua(restoredItem)
            restoredItem = RPD.fromLua(luaDesc)
            packedItem = RPD.packEntity(restoredItem)
            RPD.glogd(packedItem)
        end

        if action == "inputText" then
            RPD.System.Input:showInputDialog("Text title", "Text subtitle")
        end

        if action == "checkText" then
            local userText = RPD.System.Input:getInputString()
            RPD.glog(userText)
        end
    end,

    activate = function(self, item, hero)
        local Buff = RPD.affectBuff(hero,"TestBuff", 10)
        Buff:level(3)
        Buff:setSource(item)
    end,

    deactivate = function(self, item, hero)
        RPD.removeBuff(hero,"TestBuff")
    end,

    bag = function(self, item)
        return "SeedPouch"
    end
}