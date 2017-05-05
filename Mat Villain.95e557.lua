function onLoad()
  imports_playerBoard = Global.call('importPlayerBoard')
  imports_playerBoard.call('createNavigationButtons', {mat = self})
end

imports_playerBoard = nil

matSettings = {
  scriptZoneGuid = '3bf1a7',
  deckOffset = {x=-6.63, z=-4.9}
}

function getMatSettings()
  return matSettings
end