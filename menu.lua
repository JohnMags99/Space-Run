
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game", { time=800, effect="fromRight" } )
end

local function gotoHighScores()
	composer.gotoScene( "highscores", { time=800, effect="fromRight" } )
end

local function gotoCredits()
	composer.gotoScene("credits", {time = 800, effect = "fromRight"})
end

local mainMenuTrack


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "background.png", 800, 1400)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect(sceneGroup, "title.png", 450, 480)
	title.x = display.contentCenterX
	title.y = 220

	local playButton = display.newText(sceneGroup, "Run!", display.contentCenterX, 500,native.newFont("justov"), 120)
	playButton:setTextColor(1, 0, 0)

	local highScoresButton = display.newText(sceneGroup, "Leaderboard", display.contentCenterX, 700,native.newFont("justov"), 80)
	highScoresButton:setFillColor(0.75, 0.78, 1)

	local creditsButton = display.newText(sceneGroup, "Credits", display.contentCenterX, 900,native.newFont("justov"), 80)
	creditsButton:setFillColor(0.75, 0.78, 1)

	playButton:addEventListener("tap", gotoGame)
	audio.play(buttonPressSound)
	highScoresButton:addEventListener("tap", gotoHighScores)
	creditsButton:addEventListener("tap", gotoCredits)

	mainMenuTrack = audio.loadStream("dizzySpells.mp3")

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( mainMenuTrack, { channel=1, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		-- Stop music when scene is finished
		audio.stop(1)
	end
end


-- destroy()
function scene:destroy( event )
	audio.dispose(mainMenuTrack)

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
