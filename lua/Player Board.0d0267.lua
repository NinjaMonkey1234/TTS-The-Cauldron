playerBoards = {'117c7f', '9b207a', '978e31', '48120b', '46fc60'}
villainBoard = '95e557'
environmentBoard = '91a9f6'

function getPlayerBoard(params)
  local board = nil
  if params.player > 0 and params.player <= 5 then
    board = getObjectFromGUID(playerBoards[params.player])
  end
  return board
end

function getEnvironmentBoard()
  return getObjectFromGUID(environmentBoard)
end

function getVillainBoard()
  return getObjectFromGUID(villainBoard)
end

function createNavigationButtons(params)
  local skipButton = params.mat.getGUID()
  local position = {-1.25,0.1,-1}

  if skipButton ~= villainBoard then
    params.mat.createButton({
      click_function = 'navigateVillainClick',
      function_owner = self,
      label = 'Villain',
      position = position,
      width = 225,
      height = 25,
      font_size = 25
    })

    position[1] = position[1] + 0.5
  end

  for i, v in pairs(playerBoards) do
    if skipButton ~= v then
      params.mat.createButton({
        click_function = 'navigatePlayer' .. i ..'Click',
        function_owner = self,
        label = 'Player' .. i,
        position = position,
        width = 225,
        height = 25,
        font_size = 25
      })
      position[1] = position[1] + 0.5
    end
  end


  if skipButton ~= environmentBoard then
    params.mat.createButton({
      click_function = 'navigateEnvironmentClick',
      function_owner = self,
      label = 'Environment',
      position = position,
      width = 225,
      height = 25,
      font_size = 25
    })
    position[1] = position[1] + 0.5
  end
end

function navigateVillainClick(sender, player)
  lookAtMat(getVillainBoard(), player, 0)
end
function navigatePlayer1Click(sender, player)
  lookAtMat(getPlayerBoard({player=1}), player, 0)
end
function navigatePlayer2Click(sender, player)
  lookAtMat(getPlayerBoard({player=2}), player, 0)
end
function navigatePlayer3Click(sender, player)
  lookAtMat(getPlayerBoard({player=3}), player, 0)
end
function navigatePlayer4Click(sender, player)
  lookAtMat(getPlayerBoard({player=4}), player, 180)
end
function navigatePlayer5Click(sender, player)
  lookAtMat(getPlayerBoard({player=5}), player, 180)
end
function navigateEnvironmentClick(sender, player)
  lookAtMat(getEnvironmentBoard(), player, 0)
end

function lookAtMat(mat, player, yaw)
  Player[player].lookAt({position = mat.getPosition(), pitch=180, yaw=yaw, distance=20})
end