
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local creditsTrack

local function gotoMenu()
	composer.gotoScene("menu", {time = 800, effect = "fromLeft"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local background = display.newImageRect(sceneGroup, "background.png", 800, 1400)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	xPosHeading = display.contentCenterX-210
	musicCredits = display.newText(sceneGroup, "Music by: ",xPosHeading+40, 300,native.newFont("justov"), 45)
	musicName = display.newText(sceneGroup, "August Hansen", xPosHeading+340, 300,native.newFont("justov"), 45)
	creationCredits = display.newText(sceneGroup, "Created by: ",xPosHeading+55, 450,native.newFont("justov"), 45)
	michaelNames = display.newText(sceneGroup,"Michael Danaher",xPosHeading+340,450,native.newFont("justov"), 45)
	johnNames = display.newText(sceneGroup,"John Maguire",xPosHeading+340,550,native.newFont("justov"), 45)
	millieNames = display.newText(sceneGroup,"Emily Kearney",xPosHeading+340,650,native.newFont("justov"), 45)
	athulNames = display.newText(sceneGroup,"Athul Shabu",xPosHeading+340,750,native.newFont("justov"), 45)
	damianNames = display.newText(sceneGroup,"Damian Larkin",xPosHeading+340,850,native.newFont("justov"), 45)

	local title = display.newImageRect(sceneGroup, "credits.png", 350, 300)
	title.x = display.contentCenterX
	title.y = 190

	local leaveCreditsButton =  display.newText(sceneGroup, "Menu", display.contentCenterX+220, 35,native.newFont("justov"), 55)
	leaveCreditsButton:setFillColor(0.75, 0.78, 1)
	leaveCreditsButton:addEventListener("tap", gotoMenu)

	-- Load in the track for use
	creditsTrack  = audio.loadStream("underStars.mp3")

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		-- Play track when scene is on screen
		audio.play( creditsTrack, { channel=1, loops=-1 } )

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

		audio.stop(1)

	end
end


-- destroy()
function scene:destroy( event )
	audio.dispose(creditsTrack)

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
