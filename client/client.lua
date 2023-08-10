---------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Client File (This is code that is run on the players side) -------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

local loadedBlips = {}

local StationInteract
local StationInteractPrompt = GetRandomIntInRange(0, 0xffffff)

---------------- NUI Example ----------------
--[[RegisterCommand('testNUI', function(source, args, rawCommand)
    -- NUI SendNUIMessage lets you talk from Lua to HTML/JS
    SendNUIMessage({
        type = 'open',
        message = _U('HelloWorld')
    })
    SetNuiFocus(true, true) -- Sets the focus of the player view to NUI
end)]]

-- NUI Callback lets you talk from HTML/JS to Lua
--[[RegisterNUICallback('close', function(args, cb)
    SetNuiFocus(false, false) -- Sets the focus of the player view away from NUI
    cb('ok')
end)]]

---------------- Server Call Examples ----------------
-- "boilerplate:giveMeat" is the name of the RegisterServerEvent in server.lua
--[[RegisterCommand("giveMeat", function(args, rawCommand) --  COMMAND
    TriggerServerEvent('boilerplate:giveMeat')	
end)]]

---------------- Notification Examples ----------------
-- TriggerEvent('erb-notify:Toast', 'alert', 'Delivery Job', "You need $" ..payment .. " to start the mission!", 7000)



RegisterCommand("clientnotify", function(args, rawCommand) --  COMMAND
    TriggerEvent('vorp:NotifyLeft', "first text", "second text", "generic_textures", "tick", 4000)
    Wait(4000)
    TriggerEvent('vorp:Tip', "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:NotifyTop', "your text", "TOWN_ARMADILLO", 4000)
    Wait(4000)
    TriggerEvent('vorp:TipRight', "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:TipBottom', "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:ShowTopNotification', "your text", "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:ShowAdvancedRightNotification', "your text", "generic_textures", "tick", "COLOR_PURE_WHITE", 4000)
    Wait(4000)
    TriggerEvent('vorp:ShowBasicTopNotification', "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:ShowSimpleCenterText', "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:ShowBottomRight', "your text", 4000)
    Wait(4000)
    TriggerEvent('vorp:deadplayerNotifY', "tittle", "Ledger_Sounds", "INFO_HIDE", 4000)
    Wait(4000)
    TriggerEvent('vorp:updatemissioNotify', "tittleid", "tittle", "message", 4000)
    Wait(4000)
    TriggerEvent('vorp:warningNotify', "tittle", "message", "Ledger_Sounds", "INFO_HIDE", 4000)
end)


PRINT MESSAGE IN MIDDLE OF SCREEN
function PrintInMiddleOfScreen(text) 
    SetTextScale(1.5, 1.5)
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
end

---------------- This example is directly from ----------------
-- start your here  code reference from the Readme.md file to help you

function createObject(model, position, rotate)
    local objectHash = GetHashKey(model)

    if not Citizen.InvokeNative(0x1283B8B89DD5D1B6, objectHash) then -- HasModelLoaded
        Citizen.InvokeNative(0xFA28FE3A6246FC30, objectHash) -- RequestModel
    end

    while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, objectHash) do -- HasModelLoaded
        Wait(1)
    end

    local entityHandle = Citizen.InvokeNative(0x509D5878EB39E842, objectHash, position.x, position.y, position.z, true, true, true) -- CreateObject

    Citizen.InvokeNative(0x58A850EAEE20FAA3, entityHandle) -- PlaceObjectOnGroundProperly
    Citizen.InvokeNative(0xDC19C288082E586E, entityHandle, true, false) -- SetEntityAsMissionEntity
    ActivatePhysics(entityHandle)
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, entityHandle, true) -- FreezeEntityPosition
    Citizen.InvokeNative(0x7DFB49BCDB73089A, entityHandle, true) -- SetPickupLight
    Citizen.InvokeNative(0xF66F820909453B8C, entityHandle, true, true) -- SetEntityCollision

    SetModelAsNoLongerNeeded(objectHash)

    return entityHandle
end

function AddBlips() 
    Citizen.CreateThread(function()
        for k, v in pairs(Config.deliveryStations) do
			local blipId = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords.x, v.coords.y, v.coords.z)

			SetBlipSprite(blipId, v.sprite, 1);
			
			if v.color then
				Citizen.InvokeNative(0x662D364ABF16DE2F, blipId, GetHashKey(v.color));
			else 
				Citizen.InvokeNative(0x662D364ABF16DE2F, blipId, GetHashKey(BLIP_COLORS.WHITE));
			end
			
			local varString = CreateVarString(10, 'LITERAL_STRING', v.name);
			Citizen.InvokeNative(0x9CB1A1623062F402, blipId, varString)
			
			table.insert(loadedBlips, blipId)
		end
    
    end)
end

function SetupStationInteractPrompt()
    local str = _U("StationInteract")
    StationInteract = PromptRegisterBegin()
    PromptSetControlAction(StationInteract, Config.InteractionKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(StationInteract, str)
    PromptSetEnabled(StationInteract, 1)
    PromptSetVisible(StationInteract, 1)
    PromptSetStandardMode(StationInteract, 1)
    PromptSetGroup(StationInteract, StationInteractPrompt)
    -- If you want to hold the key use with this
    -- PromptSetHoldMode(WashPrompt, 1000)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, StationInteract, true)
    PromptRegisterEnd(StationInteract)
end

function CreatePrompts()
    SetupStationInteractPrompt()
end

AddEventHandler(
	"onResourceStart",
	function(resourceName)
		if resourceName == GetCurrentResourceName() then
			AddBlips()
		end
	end
)

AddEventHandler(
	"onResourceStop",
	function(resourceName)
		if resourceName == GetCurrentResourceName() then
			for _, blip in pairs(loadedBlips) do
				RemoveBlip(blip)
			end
		end
	end
)

Citizen.CreateThread(function()
    CreatePrompts()
    local player = PlayerPedId()

    local sleep = true
    while true do
        Citizen.Wait(2)
        local pCoords = GetEntityCoords(player)
        for k, v in pairs(Config.deliveryStations) do
            local distance = #(pCoords - v.coords)
            if distance <= v.minDistanceToInteract then
                sleep = false
                local label = CreateVarString(10, 'LITERAL_STRING', v.name)
                PromptSetActiveGroupThisFrame(StationInteractPrompt, label)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, StationInteract) then
                   print('ACCESS')
                end

                -- For holding key use this
                -- if PromptHasHoldModeCompleted(StationInteract) then
                --     -- Your code
                -- end
            end
            
        end
        
        if sleep then       
            Citizen.Wait(1000)            
        end
    end
end)

-------------- Thread used for adding / removing chat suggestions ----------------
CreateThread(function()
	while true do
		Wait(Config.CheckPermissionTime)
		TriggerServerEvent('erb-boilerplate:server:addChatSuggestions')
	end
end)