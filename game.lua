local composer = require( "composer" )
local scene = composer.newScene()

local function exitToMenu()
	composer.gotoScene("menu", {time = 800, effect = "fromLeft"})
end
local function goToMenu()
	composer.gotoScene("menu", { time=800, effect="crossFade" } )
end

local physics = require( "physics" )
physics.start()
physics.setGravity(0,0)

--Initialize variables
local score = 0
local died = false

local spacemonkeyTable = {}

local spaceman
local gameLoopTimer
local scoreText

local backGroup
local mainGroup
local uiGroup
local startY = 200

local mainGameTrack

local function updateText()
	scoreText.text = "Score: " .. score
end

local function  createSpacemonkey()
	local newSpacemonkey = display.newImageRect( mainGroup, "spacemonkey-1.png", 100, 97)
	table.insert( spacemonkeyTable, newSpacemonkey )
	physics.addBody( newSpacemonkey, "dynamic", { radius=40, bounce=0 } )
	newSpacemonkey.myName = "spacemonkey"

	local whereFrom = 1
	if (whereFrom == 1) then
		--Coming from the top
		newSpacemonkey.x = math.random(120,640)
		newSpacemonkey.y = -60
		newSpacemonkey:setLinearVelocity(0,startY)
		if(score%1500==0) then
			startY=startY+50
		end
	end

end local function dragSpaceman( event )
	local ship = event.target
	local phase = event.phase
	if("began" == phase) then
		display.currentStage:setFocus(spaceman)
		spaceman.touchOffsetX = event.x - spaceman.x

		elseif("moved" == phase) then
		spaceman.x = event.x - ship.touchOffsetX

		elseif("ended" == phase or "cancelled" == phase ) then
		display.currentStage:setFocus(nil)
	end
	return true
end

local function gameLoop()
	createSpacemonkey()
	for i = #spacemonkeyTable, 1, -1 do
		local thisSpacemonkey = spacemonkeyTable[i]

		if (thisSpacemonkey.x < -100 or
			thisSpacemonkey.x > display.contentWidth + 100 or
			thisSpacemonkey.y < -100 or
			thisSpacemonkey.y > display.contentHeight + 100 )
			then
			display.remove( thisSpacemonkey )
			table.remove( spacemonkeyTable, i )
		end
	end
	function scoreInc()

		if(died == false) then
			score = score + 100
			updateText()
		end

	end
	timer.performWithDelay(2000,scoreInc)

end

local function endGame()
	composer.setVariable("finalScore", score)
	composer.gotoScene( "highscores", {time=800,effect="crossFade" } )
end


local function onCollision(event)
	if ( event.phase == "began") then

		local obj1 = event.object1
		local obj2 = event.object2
		if((obj1.myName == "spaceman" and obj2.myName == "spacemonkey") or
				(obj1.myName == "spacemonkey" and obj2.myName == "spaceman")) then
			if (died == false) then
				died = true
				if (died == true) then
					display.remove( spaceman )
					local imagedied = display.newImageRect(uiGroup, "you died.png", 550, 450)
					imagedied.x = 400
					imagedied.y = display.contentCenterY
					timer.performWithDelay( 4000, endGame )

				end
			end
		end
	end
end



-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the spaceman and the spacemonkeys etc
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

	-- Load the background
	local background = display.newImageRect( backGroup, "background.png", 850, 1000 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	spaceman = display.newImageRect( mainGroup, "spaceman(1).png", 100, 85 )
	spaceman.x = display.contentCenterX
	spaceman.y = display.contentHeight - 100
	physics.addBody( spaceman, { radius=50, isSensor=true } )
	spaceman.myName = "spaceman"

	-- Display score
	scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 45,native.newFont("justov"), 45)
	spaceman:addEventListener( "touch", dragSpaceman )

	local leaveGameButton = display.newText(sceneGroup, "X", display.contentCenterX+250, 35,native.newFont("justov"), 55)
	leaveGameButton:setFillColor(1, 0, 0)
	leaveGameButton:addEventListener("tap", exitToMenu)

	mainGameTrack = audio.loadStream("endlessSun.mp3")
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

		--Play Music when game scene appears
		audio.play(mainGameTrack, {channel=1, loops=-1})
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		composer.removeScene( "game" )

				--Stop track when the scene is finished
		audio.stop(1)
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

	audio.dispose(mainGameTrack)

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene