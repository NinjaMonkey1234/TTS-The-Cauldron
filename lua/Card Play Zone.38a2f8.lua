function onLoad(save_state)
  print(self.getName())
end

zoneItems = {}
-- zoneItems = {
--  {
--    cardGuid = '',
--    counterGuid = '',
--    row = 1,
--    column = 1
--  }
--}
function addCardToZone(params)
    local playBoard = params.playBoard
    local card = params.card
    local row = 1
    local column = 1
    local playZones = getCardPlayZones(playBoard)
    local playBoardPosition = playBoard.getPosition()
    local cardPosition = nil
    local cardDetails = card.getTable('cardDetails')
    local zoneItem = {
      cardGuid = '',
      counterGuid = '',
      row = 0,
      column = 0
    }

    row, column = getNextOpenSlot(playBoard, playZones)

    zoneItem.row = row
    zoneItem.column = column

    cardPosition = {
      x = playBoardPosition.x + playZones.settings.firstCardOffset.x + ((column - 1) * playZones.settings.columnNIncrement),
      y = playBoardPosition.y + 0.2,
      z = playBoardPosition.z + playZones.settings.firstCardOffset.z + ((row - 1) * playZones.settings.rowNIncrement)
    }

    card.setPosition(cardPosition)
    if zoneItems[playBoard.getGUID()] == nil then
      zoneItems[playBoard.getGUID()] = {}
    end

    zoneItem.cardGuid = cardDetails.guid

    if cardDetails.target then
      zoneItem.counterGuid = addCounterToZone(playBoard, playZones, playBoardPosition, cardDetails, row, column)
    end

    table.insert(zoneItems[playBoard.getGUID()], zoneItem)
end

function addCounterToZone(playBoard, playZones, playBoardPosition, cardDetails, row, column)
  local counter = getCounterForPlayBoard(playBoard)
  local counterPosition = nil
  local clonedCounter = nil

  counterPosition = {
    x = playBoardPosition.x + playZones.settings.firstCounterOffset.x + ((column - 1) * playZones.settings.counterColumnNIncrement),
    y = playBoardPosition.y + 0.2,
    z = playBoardPosition.z + playZones.settings.firstCounterOffset.z + ((row - 1) * playZones.settings.counterRowNIncrement)
  }
  clonedCounter = counter.clone({
    position = counterPosition
  })
  clonedCounter.setScale(playZones.settings.healthCounterScale)
  clonedCounter.setValue(cardDetails.health)

  return clonedCounter.getGUID()
end

function removeCardFromZone(params)
    local playBoard = params.playBoard
    local card = params.card
    local cardDetails = card.getTable('cardDetails')
    local index = 0

    if zoneItems[playBoard.getGUID()] ~= nil then
      for _, v in pairs(zoneItems[playBoard.getGUID()]) do
        index = index + 1
        if zoneItems[playBoard.getGUID()].cardGuid == cardDetails.guid then
          break
        end
      end
    end

    if index > 0 then
      if zoneItems[playBoard.getGUID()].counterGuid ~= '' then
        getObjectFromGUID(zoneItems[playBoard.getGUID()].counterGuid).destruct()
      end
      table.remove(zoneItems[playBoard.getGUID()], index)
      -- TODO: Add code to reposition cards
    end
end

function getNextOpenSlot(playBoard, playZones)
  local row = 1
  local column = 1

  if zoneItems[playBoard.getGUID()] ~= nil then
    for _, v in spairs(zoneItems[playBoard.getGUID()], function(t,a,b) return t[b].row < t[a].row end) do
      row = v.row
      break
    end
    for _, v in spairs(zoneItems[playBoard.getGUID()], function(t,a,b) return t[b].column < t[a].column end) do
      column = v.column
      break
    end
    if column == playZones.settings.columns then
      row = row + 1
      column = 1
    else
      column = column + 1
    end
  end
  return row, column
end

function getCardPlayZones(playBoard)
  return playBoard.call('getPlayerMatSettings').cardPlayZones
end

function getCounterForPlayBoard(playBoard)
  return playBoard.call('getCounter')
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1

        if keys[i] then
            return keys[i], t[keys[i]]
          else
            return nil
        end
    end
end