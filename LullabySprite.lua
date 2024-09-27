-- LullabySprite: A Wrapper for Psych Engine's Lua Sprites.

local LullabySprite = {};

-- Initialization function.
--- @param tag The sprites identifier.
--- @param path The path to the LullabySprite graphic.
--- @param x The sprites x coordinate position.
--- @param y The sprites y coordinate position.
--- @param animated Whether the sprite is animated or not.
--- @param spriteType The type of animated sprite this `LullabySprite` is.
--- @return The instance of this `LullabySprite`.
function LullabySprite:new(tag, path, x, y, animated, spriteType)
	if(not animated) then
		makeLuaSprite(tag, path, x or 0, y or 0);
	else
		makeAnimatedLuaSprite(tag, path, x or 0, y or 0, spriteType or 'sparrow');
	end

	self.tag = tag;

	self.animation = {
		addByPrefix = function(name, prefix, fps, loop)
			addAnimationByPrefix(tag, name, prefix, fps, loop or false);
		end,
		addByIndices = function(name, prefix, indices, fps, loop)
			addAnimationByIndices(tag, name, prefix, indices, fps, loop or false);
		end,
		addAnim = function(name, frames, fps, loop)
			addAnimation(tag, name, frames, fps, loop or false);
		end,
		offsetAnim = function(name, x, y)
			addOffset(tag, name, x, y);
		end,
		play = function(name, forced)
			playAnim(tag, name, forced or false);
		end
	};

	return self;
end

-- Adds the sprite to the game.
--- @param infront Whether the sprite should be layered in front of the characters or not.
function LullabySprite:add(infront)
	addLuaSprite(self.tag, infront or false);
end

-- Inserts the sprite at a specified position.
--- @param pos Where to insert this `LullabySprite` at. 
function LullabySprite:insert(pos)
	setObjectOrder(self.tag, pos);
end

-- Removes this `LullabySprite` from the game.
--- @param destroy Whether to destroy the sprite instead of just removing it.
function LullabySprite:remove(destroy)
	removeLuaSprite(self.tag, destroy or true);
end

-- Gets the position index of this `LullabySprite`.
--- @return The current position index of the sprite.
function LullabySprite:getIndex()
	return getObjectOrder(self.tag);
end

-- Gets the midpoint of this `LullabySprite`.
--- @return The midpoint of the sprite.
function LullabySprite:getMidpoint()
	return {x = getMidpointX(self.tag), y = getMidpointY(self.tag)};
end

-- Gets the graphic midpoint of this `LullabySprite`.
--- @return The graphic midpoint of the sprite.
function LullabySprite:getGraphicMidpoint()
	return {x = getGraphicMidpointX(self.tag), y = getGraphicMidpointY(self.tag)};
end

-- Gets the screen position of this `LullabySprite`.
--- @return The current screen position of the sprite.
function LullabySprite:getScreenPosition()
	return {x = getScreenPositionX(self.tag), y = getScreenPositionY(self.tag)};
end

-- Makes a graphic for this `LullabySprite`.
--- @param width The width of the graphic.
--- @param height The height of the graphic.
--- @param color The color of the graphic.
function LullabySprite:makeGraphic(width, height, color)
	makeGraphic(self.tag, width or 0, height or 0, color);
end

-- Loads a graphic for this `LullabySprite`.
--- @param path The path to the sprite graphic.
--- @param width The width at which the graphic should be sliced at (for animation)
--- @param height The height at which the graphic should be sliced at (for animation)
function LullabySprite:loadGraphic(path, width, height)
	loadGraphic(self.tag, path, width or 0, height or 0);
end

-- Loads frames for this `LullabySprite`.
--- @param path The path to the graphic
--- @param type The type of frames that should be loaded (defaults to "sparrow")
function LullabySprite:loadFrames(path, spriteType)
	loadFrames(self.tag, path, spriteType or 'sparrow');
end

-- Sets the camera that the sprite should be drawn on.
--- @param cam The camera you want the sprite to be drawn on.
function LullabySprite:setCamera(cam)
	local playstateCamNames = {'camgame', 'game', 'camhud', 'hud', 'camother', 'other'};
	if(tableContains(playstateCamNames, cam:lower())) then
		setObjectCamera(self.tag, cam);
	else
		--[[
			Custom camera support
			This assumes the name of the cam you put in the arg is the same as what you set it as
			in setVar/game.variables.set
			If this is not the case, you should probably fix it to accomodate for this.
		]]
		runHaxeCode([[
			var sprite: FlxSprite = getVar(']] .. self.tag .. [[');
			var camera: FlxCamera = getVar(']] .. cam .. [[');
			if(camera != null) sprite.camera = camera;
		]]);
	end
end

-- Sets the position of this `LullabySprite`.
--- @param x The x position.
--- @param y The y position.
function LullabySprite:setPosition(x, y)
	setProperty(self.tag .. '.x', x);
	setProperty(self.tag .. '.y', y);
end

-- Tweens this `LullabySprite`.
--- @param name The identifier for the tween.
--- @param fields The fields of the sprite you want to tween.
--- @param duration The duration of the tween.
--- @param usePBR Whether the duration should account for playbackRate.
--- @param options Tween Options (ex: startDelay, onComplete, etc.).
function LullabySprite:tween(name, fields, duration, usePBR, options)
	startTween(name, self.tag, fields, duration / (usePBR and playbackRate or 1), options or {});
end

-- Scales this `LullabySprite`.
--- @param x The scale for x axis.
--- @param y The scale for the y axis.
--- @param updateHB Whether the hitbox should be updated.
function LullabySprite:scale(x, y, updateHB)
	scaleObject(self.tag, x, y, updateHB or true);
end

-- Updates the hitbox of this `LullabySprite`
function LullabySprite:updateHitbox()
	updateHitbox(self.tag);
end

-- Centers this `LullabySprite` on a specified axis.
--- @param axis The axis the sprite should be centered on.
function LullabySprite:screenCenter(axis)
	screenCenter(self.tag, axis or 'xy');
end

-- Sets he scroll factor on this `LullabySprite`.
--- @param x The scroll factor for the x axis.
--- @param y The scroll factor for the y axis.
function LullabySprite:setScrollFactor(x, y)
	setScrollFactor(self.tag, x or 1, y or 1);
end

-- Sets a field value for this `LullabySprite`.
--- @param field The field you want to set.
--- @param value The value you want to assign to the field.
function LullabySprite:set(field, value)
	setProperty(self.tag .. '.' .. field, value);
end

-- Gets a field value for this `LullabySprite`.
--- @param field The field you want to get.
--- @return The specified field.
function LullabySprite:get(field)
	return getProperty(self.tag .. '.' .. field);
end

function tableContains(t, f)
	if(type(t) ~= 'table') then return false; end
	for i, v in pairs(t) do
		if(v == f) then
			return true;
		end
	end
	return false;
end

return LullabySprite;