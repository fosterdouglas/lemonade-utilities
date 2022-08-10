-- -- -- -- PLAYDATE CONSTANTS -- -- -- -- 

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
kWhiteTransparent = "whiteTransparent"
kBlackTransparent = "blackTransparent"
kInverted = "inverted"
kCopy = "copy"
kWhiteFill = "fillWhite"
kBlackFill = "fillBlack"

-- Line variables
kStrokeCenter = playdate.graphics.kStrokeCentered
kStrokeOutside = playdate.graphics.kStrokeOutside
kStrokeInside = playdate.graphics.kStrokeInside

-- Text variables
kTextLeft = kTextAlignment.left
kTextCenter = kTextAlignment.center
kTextRight = kTextAlignment.right

-- Button variables
kButtonA = playdate.kButtonA
kButtonB = playdate.kButtonB
kButtonUp = playdate.kButtonUp
kButtonDown = playdate.kButtonDown
kButtonLeft = playdate.kButtonLeft
kButtonRight = playdate.kButtonRight

-- Dither variables
kDitherNone = playdate.graphics.image.kDitherTypeNone
kDitherDiagonal = playdate.graphics.image.kDitherTypeDiagonalLine
kDitherVertoca; = playdate.graphics.image.kDitherTypeVerticalLine
kDitherHorizontal = playdate.graphics.image.kDitherTypeHorizontalLine
kDitherScreen = playdate.graphics.image.kDitherTypeScreen
kDitherB2 = playdate.graphics.image.kDitherTypeBayer2x2
kDitherB4 = playdate.graphics.image.kDitherTypeBayer4x4
kDitherB8 = playdate.graphics.image.kDitherTypeBayer8x8
kDitherFloyd = playdate.graphics.image.kDitherTypeFloydSteinberg
kDitherBurkes = playdate.graphics.image.kDitherTypeBurkes
kDitherAtkinson = playdate.graphics.image.kDitherTypeAtkinson

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

-- -- -- -- PLAYDATE FUNCTIONS -- -- -- -- 

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

-- Scale an image to specific pixel width/height
function _imageScale(image, newWidth, newHeight)
	local w, h = image:getSize()
	local resizedImage = image:scaledImage(math.ceil(newWidth / w), math.ceil(newHeight / h))
	return resizedImage
end

-- -- -- -- GENERAL LUA FUNCTIONS -- -- -- -- 

-- Rounding
function _roundNumber(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Inverse Lerp (returns a value of 0.0 - 1.0 based on a of b)
function _inverseLerp(min, max, value)
	return (value - min)/(max - min)
end

-- Sort table of numbers numerically
function _tableSortNumeric(table)
	table.sort(table, function(a,b) return #a<#b end)
end

function _tableShuffle(table)
	local new = {}
	
	for i, v in ipairs(table) do
		local pos = math.random(1, #shuffledPositions+1)
		table.insert(new, pos, v)
	end
	
	return new
end

-- Print a list of all lua globals
function _printGlobals()
	for n,v in pairs(_G) do
		print(n,v)
	end
end

-- Function to map keys from a table into their own new table
function _mapKeys(table, func)
	local t = {}
	for k,v in pairs(table) do
			t[k] = func(v)
	end
	return t
end

