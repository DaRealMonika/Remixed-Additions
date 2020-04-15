--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local mob = require"scripts/lib/mob"

local wallTiles = {[0]=false,[1]=true,[2]=true,[3]=true,[4]=false,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=false,[11]=true,[12]=false,[13]=false,[14]=true,[15]=true,[16]=false,[17]=true,[18]=true,[19]=true,[20]=true,[21]=true,[22]=true,[23]=true,[24]=true,[25]=false,[26]=false,[27]=true,[28]=true,[29]=true,[30]=true,[31]=true,[32]=true,[33]=true,[34]=true,[35]=false,[36]=false,[37]=true,[38]=true,[39]=true,[40]=true,[41]=false,[42]=true,[43]=false,[44]=false,[45]=false,[46]=false,[47]=true,[48]=true,[49]=true,[50]=true,[51]=true,[52]=true,[53]=true,[54]=true,[55]=true,[56]=true,[57]=true,[58]=true,[59]=true,[60]=true,[61]=true,[62]=true,[63]=true}

return mob.init({
    interact = function(self, chr)
        local ownPos = self:getPos()
        local newPos = chr:getPos()
        local level = RPD.Dungeon.level
--[[        local item = chr:getBelongings():getItem("RingOfStoneWalking")
        if item and item:isEquipped(chr) then
            if not wallTiles[level.map[ownPos] then
                self:move(newPos)
                self:getSprite():move(ownPos, newPos)
                chr:move(ownPos)
                chr:getSprite():move(newPos, ownPos)
            end
        else]]
            if wallTiles[level.map[ownPos]] then
                self:move(newPos)
                self:getSprite():move(ownPos, newPos)
                chr:move(ownPos)
                chr:getSprite():move(newPos, ownPos)
            end
--        end
    end
})