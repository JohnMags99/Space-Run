
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local leaderboardTrack

-- Initialize variables
local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )


local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	end
end


local function saveScores()

	for i = #scoresTable, 11, -1 do
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
		io.close( file )
	end
end


local function gotoMenu()
	composer.gotoScene( "menu", { time=800, effect="fromLeft" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
    loadScores()

    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )

    -- Save the scores
    saveScores()

    local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local highScoresHeader = display.newImageRect( sceneGroup, "leaderboard.png",300,300)
	highScoresHeader.x = display.contentCenterX
	highScoresHeader.y =180

    for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 150 + ( i * 65 )

            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-160, yPos+160,native.newFont("justov"), 60)
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX+80, yPos+160,native.newFont("justov"), 60)
            thisScore.anchorX = 0
        end
    end

    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX+220, 35,native.newFont("justov"), 55)
    menuButton:setFillColor( 0.75, 0.78, 1 )
    menuButton:addEventListener( "tap", gotoMenu )

	-- Load in the track for use
	leaderboardTrack = audio.loadStream("underStars.mp3")
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
		audio.play( leaderboardTrack, { channel=1, loops=-1 } )

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
		composer.removeScene( "highscores" )

		audio.stop(1)
	end
end


-- destroy()
function scene:destroy( event )
	audio.dispose(leaderboardTrack)

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
