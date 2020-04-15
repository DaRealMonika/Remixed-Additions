--
-- User: mike
-- Date: 23.11.2017
-- Time: 21:04
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init({
    stats = function(self)
        self:immunities():add(RPD.Blobs.ToxicGas)
        self:immunities():add(RPD.Blobs.ParalyticGas)
        self:immunities():add(RPD.Blobs.ConfusionGas)
    end
})