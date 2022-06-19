-- Glyphs
kGlyphA = "Ⓐ"
kGlyphB = "Ⓑ"
kGlyphPlaydate = "🟨"
kGlyphStart = "⊙"
kGlyphLock = "🔒"
kGlyphCrank = "🎣"
kGlyphDPad = "✛"
kGlyphDPadUp = "⬆️"
kGlyphDPadRight = "➡️"
kGlyphDPadDown = "⬇️"
kGlyphDPadLeft = "⬅️"

-- Fonts
kSystemFont = playdate.graphics.getSystemFont()

-- Display variables
kDisplayWidth = playdate.display.getWidth()
kDisplayHeight = playdate.display.getHeight()

-- Color variables
kBlack = playdate.graphics.kColorBlack
kWhite = playdate.graphics.kColorWhite
kXOR = playdate.graphics.kColorXOR
kClear = playdate.graphics.kColorClear
kNXOR = "NXOR"
kWhiteT = "whiteTransparent"
kBlackT = "blackTransparent"
kInverted = "inverted"
kCopy = "copy"

-- Line variables
kCentered = playdate.graphics.kStrokeCentered
kOutside = playdate.graphics.kStrokeOutside
kInside = playdate.graphics.kStrokeInside

-- Text variables
kLeft = kTextAlignment.left
kCenter = kTextAlignment.center
kRight = kTextAlignment.right

-- Button variables
kButtonA = playdate.kButtonA
kButtonB = playdate.kButtonB
kButtonUp = playdate.kButtonUp
kButtonDown = playdate.kButtonDown
kButtonLeft = playdate.kButtonLeft
kButtonRight = playdate.kButtonRight

-- Dither variables
kDitherN = playdate.graphics.image.kDitherTypeNone
kDitherD = playdate.graphics.image.kDitherTypeDiagonalLine
kDitherV = playdate.graphics.image.kDitherTypeVerticalLine
kDitherH = playdate.graphics.image.kDitherTypeHorizontalLine
kDitherS = playdate.graphics.image.kDitherTypeScreen
kDitherB2 = playdate.graphics.image.kDitherTypeBayer2x2
kDitherB4 = playdate.graphics.image.kDitherTypeBayer4x4
kDitherB8 = playdate.graphics.image.kDitherTypeBayer8x8
--TODO: add the specialty dithers, and rename some of these better

-- Easing variables
kLinear = playdate.easingFunctions.linear
kInQuad = playdate.easingFunctions.inQuad
kOutQuad = playdate.easingFunctions.outQuad
kInOutQuad = playdate.easingFunctions.inOutQuad
kOutInQuad = playdate.easingFunctions.outInQuad
kInCubic = playdate.easingFunctions.inCubic
kOutCubic = playdate.easingFunctions.outCubic
kInOutCubic = playdate.easingFunctions.inOutCubic
kOutInCubic = playdate.easingFunctions.outInCubic
kInQuart = playdate.easingFunctions.inQuart
kOutQuart = playdate.easingFunctions.outQuart
kInOutQuart = playdate.easingFunctions.inOutQuart
kOutInQuart = playdate.easingFunctions.outInQuart
kInQuint = playdate.easingFunctions.inQuint
kOutQuint = playdate.easingFunctions.outQuint
kInOutQuint = playdate.easingFunctions.inOutQuint
kOutInQuint = playdate.easingFunctions.outInQuint
kInSine = playdate.easingFunctions.inSine
kOutSine = playdate.easingFunctions.outSine
kInOutSine = playdate.easingFunctions.inOutSine
kOutInSine = playdate.easingFunctions.outInSine
kInExpo = playdate.easingFunctions.inExpo
kOutExpo = playdate.easingFunctions.outExpo
kInOutExpo = playdate.easingFunctions.inOutExpo
kOutInExpo = playdate.easingFunctions.outInExpo
kInCirc = playdate.easingFunctions.inCirc
kOutCirc = playdate.easingFunctions.outCirc
kInOutCirc = playdate.easingFunctions.inOutCirc
kOutInCirc = playdate.easingFunctions.outInCirc
kInElastic = playdate.easingFunctions.inElastic
kOutElastic = playdate.easingFunctions.outElastic
kInOutElastic = playdate.easingFunctions.inOutElastic
kOutInElastic = playdate.easingFunctions.outInElastic
kInBack = playdate.easingFunctions.inBack
kOutBack = playdate.easingFunctions.outBack
kInOutBack = playdate.easingFunctions.inOutBack
kOutInBack = playdate.easingFunctions.outInBack
kOutBounce = playdate.easingFunctions.outBounce
kInBounce = playdate.easingFunctions.inBounce
kInOutBounce = playdate.easingFunctions.inOutBounce
kOutInBounce = playdate.easingFunctions.outInBounce

-- Screen shake
function _screenShake(length, xTarget, yTarget, randomized)
	local x,y = playdate.display.getOffset()
	local shakeTimer = playdate.frameTimer.new(length)
	
	shakeTimer.updateCallback = function(timer)
		if randomized then
			playdate.display.setOffset(math.random(-xTarget, xTarget), math.random(-yTarget, yTarget))
		else
			playdate.display.setOffset(xTarget, yTarget)
		end
	end

	shakeTimer.timerEndedCallback = function(timer)
		playdate.display.setOffset(x, y)
		return true
	end
end

-- Rounding
function _roundNumber(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Create synth
function _newSynth(attack, decay, sustain, release, volume, sound)
	local synth = playdate.sound.synth.new(sound)
	synth:setADSR(attack, decay, sustain, release)
	synth:setVolume(volume)
	return synth
end

-- Create instrument
function _newInst(poly, voice)
	local instrument = playdate.sound.instrument.new()
	for i=1,poly do
		local synth = voice:copy()
		instrument:addVoice(synth)
	end
	return instrument
end

-- MIDI player
function _midiPlayer(midi, sound)
	local midiTracks = midi:getTrackCount()
	for i=1, midiTracks do
		local track = midi:getTrackAtIndex(i)
		
		if track ~= nil then
			local poly = track:getPolyphony(i)
			local inst = _newInst(poly, sound)
			track:setInstrument(inst)    
		end
	end
end

-- Image color setting
function _setImageColor(color)
	if color == kWhite then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	elseif color == kBlack then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillBlack)
	elseif color == kXOR then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeXOR)
	elseif color == kNXOR then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	elseif color == kWhiteT then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeWhiteTransparent)
	elseif color == kBlackT then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeBlackTransparent)
	elseif color == kCopy then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	elseif color == kInverted then
		return playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeInverted)
	end
end

-- Inverse Lerp (returns a value of 0.0 - 1.0 based on a of b)
function _inverseLerp(min, max, value)
	return (value - min)/(max - min)
end

-- FUTURE IDEAS

-- Move this to a github module or something
-- Something to apply to a static value somewhere and be able to immediately increment/decrement it by some specific interval. like _dynamicValue(5, 0.2) would increment value 5 by +/- 0.2 using some specific keys on keyboard, and then print out the value afterward

-- Print a list of all lua globals
function _printGlobals()
	for n,v in pairs(_G) do
		print(n,v)
	end
end

-- Function to map keys from a table into their own new table
-- TODO, better label "f"
function _mapKeys(table, f)
	local t = {}
	for k,v in pairs(table) do
			t[k] = f(v)
	end
	return t
end

-- Scale an image to specific pixel width/height
function _scaleImage(image, newWidth, newHeight)
	local w, h = image:getSize()
	local resizedImage = image:scaledImage(math.ceil(newWidth / w), math.ceil(newHeight / h))
	return resizedImage
end

-- TODO, make this into a function
class('FillSprite').extends(playdate.graphics.sprite)
function FillSprite:init(width, height, color)
	FillSprite.super.init(self)
	self:setSize(width, height)
	self.draw = function()
		playdate.graphics.setColor(color)
		playdate.graphics.fillRect(0, 0, self.width, self.height)
	end
end
