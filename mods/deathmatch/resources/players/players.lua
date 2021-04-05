local spawnX, spawnY, spawnZ = 0, 0, 5
function joinHandler()
	spawnPlayer(source, spawnX, spawnY, spawnZ)
	fadeCamera(source, true)
	setCameraTarget(source, source)
	outputChatBox("Welcome to My Server "..getPlayerName(source), source)
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)