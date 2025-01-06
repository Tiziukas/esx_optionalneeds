local IsAlreadyDrunk = false
local DrunkLevel = -1

local function SetDrunkEffect(level, start)
  local playerPed = PlayerPedId()
  local animSet = {
    [0] = "move_m@drunk@slightlydrunk",
    [1] = "move_m@drunk@moderatedrunk",
    [2] = "move_m@drunk@verydrunk"
  }

  if start then
    DoScreenFadeOut(800)
    Wait(1000)
  end

  if animSet[level] then
    RequestAnimSet(animSet[level])
    while not HasAnimSetLoaded(animSet[level]) do
      Wait(0)
    end
    SetPedMovementClipset(playerPed, animSet[level], true)
  end

  SetTimecycleModifier("spectator5")
  SetPedMotionBlur(playerPed, true)
  SetPedIsDrunk(playerPed, true)

  if start then
    DoScreenFadeIn(800)
  end
end

local function RemoveDrunkEffect()
  local playerPed = PlayerPedId()

  DoScreenFadeOut(800)
  Wait(1000)

  ClearTimecycleModifier()
  ResetScenarioTypesEnabled()
  ResetPedMovementClipset(playerPed, 0)
  SetPedIsDrunk(playerPed, false)
  SetPedMotionBlur(playerPed, false)

  DoScreenFadeIn(800)
end

local function HandleDrunkStatus(status)
  local start = not IsAlreadyDrunk
  local level = (status.val > 500000 and 2) or (status.val > 250000 and 1) or 0

  if status.val > 0 then
    if level ~= DrunkLevel then
      SetDrunkEffect(level, start)
    end
    IsAlreadyDrunk = true
    DrunkLevel = level
  elseif IsAlreadyDrunk then
    RemoveDrunkEffect()
    IsAlreadyDrunk = false
    DrunkLevel = -1
  end
end

AddEventHandler('esx_status:loaded', function(status)
  TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5',
    function(status)
      return status.val > 0
    end,
    function(status)
      status.remove(1500)
    end
  )

  CreateThread(function()
    while true do
      Wait(Config.GetDrunkStatusTick)
      TriggerEvent('esx_status:getStatus', 'drunk', HandleDrunkStatus)
    end
  end)
end)

RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
  local playerPed = PlayerPedId()
  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, true)
  Wait(1000)
  ClearPedTasksImmediately(playerPed)
end)
