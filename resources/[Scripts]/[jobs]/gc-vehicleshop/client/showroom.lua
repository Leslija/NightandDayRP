local ClosestVehicle = 1
local inMenu = false
local modelLoaded = true
local fakecar = {model = '', car = nil}

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local bringcoords = {x = -45.77, y = -1082.88, z = 26.73, h = 68.24, r = 1.0}
        local pos = GetEntityCoords(ped, false)
        local dist = GetDistanceBetweenCoords(pos, bringcoords.x, bringcoords.y, bringcoords.z)

        if isLoggedIn then
            if (PlayerJob ~= nil) and PlayerJob.name == "cardealer" then
                if IsPedInAnyVehicle(ped, false) then
                    if dist < 15 then
                        local veh = GetVehiclePedIsIn(ped)
                        DrawMarker(2, bringcoords.x, bringcoords.y, bringcoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.3, 0.1, 255, 0, 0, 155, false, false, false, false, false, false, false)

                        if dist < 2 then
                            DrawText3Ds(bringcoords.x, bringcoords.y, bringcoords.z, '~g~E~w~ - Return the vehicle')
                            if IsControlJustPressed(0, Keys["E"]) then
                                Framework.Functions.DeleteVehicle(veh)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(3)
    end
end)

vehshop = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {}
		},	
	}
}

Citizen.CreateThread(function()
    Citizen.Wait(1500)

    for k, v in pairs(vehicleCategorys) do
        table.insert(vehshop.menu["vehicles"].buttons, {
            menu = k,
            name = v.label,
            description = {}
        })

        vehshop.menu[k] = {
            title = k,
            name = v.label,
            buttons = v.vehicles
        }
    end
end)

function isValidMenu(menu)
    local retval = false
    for k, v in pairs(vehshop.menu["vehicles"].buttons) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0, 0, 0,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0, 0, 0,250) 
	end
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
    local btn = button.name

	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu('super')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Offroad" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		elseif btn == "Vans" then
			OpenMenu('vans')
        elseif btn == "Cycles" then
			OpenMenu('cycles')
		end
	end
end

function OpenMenu(menu)
    vehshop.lastmenu = vehshop.currentmenu
    fakecar = {model = '', car = nil}
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif isValidMenu(vehshop.currentmenu) then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		vehshop.opened = false
		vehshop.menu.from = 1
        vehshop.menu.to = 10
        QB.ShowroomVehicles[ClosestVehicle].inUse = false
        TriggerServerEvent('qb-vehicleshop:server:setShowroomCarInUse', ClosestVehicle, false)
	end)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function MenuVehicleList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Dealer"
    ClearMenu()
    Menu.addButton("View range", "VehicleCategories", nil)
    Menu.addButton("Close Menu", "close", nil) 
end

function VehicleCategories()
    ped = GetPlayerPed(-1);
    MenuTitle = "Veh Cats"
    ClearMenu()
    for k, v in pairs(QB.VehicleMenuCategories) do
        Menu.addButton(QB.VehicleMenuCategories[k].label, "GetCatVehicles", k)
    end
    
    Menu.addButton("Close Menu", "close", nil) 
end

function GetCatVehicles(catergory)
    ped = GetPlayerPed(-1)
    MenuTitle = "Cat Vehs"
    ClearMenu()
    Menu.addButton("Close Menu", "close", nil) 
    for k, v in pairs(shopVehicles[catergory]) do
        Menu.addButton(shopVehicles[catergory][k].name, "SelectVehicle", v, catergory, "€"..shopVehicles[catergory][k]["price"])
    end
end

function SelectVehicle(vehicleData)
    TriggerServerEvent('qb-vehicleshop:server:setShowroomVehicle', vehicleData, ClosestVehicle)
    close()
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for i = 1, #QB.ShowroomVehicles, 1 do
        local oldVehicle = GetClosestVehicle(QB.ShowroomVehicles[i].coords.x, QB.ShowroomVehicles[i].coords.y, QB.ShowroomVehicles[i].coords.z, 3.0, 0, 70)
        if oldVehicle ~= 0 then
            Framework.Functions.DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(QB.ShowroomVehicles[i].chosenVehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, QB.ShowroomVehicles[i].coords.x, QB.ShowroomVehicles[i].coords.y, QB.ShowroomVehicles[i].coords.z, false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, QB.ShowroomVehicles[i].coords.h)
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
    end
end)

function OpenCreator()
	vehshop.currentmenu = "main"
	vehshop.opened = true
    vehshop.selectedbutton = 0
    TriggerServerEvent('qb-vehicleshop:server:setShowroomCarInUse', ClosestVehicle, false)
end

function setClosestShowroomVehicle()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(QB.ShowroomVehicles) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, QB.ShowroomVehicles[id].coords.x, QB.ShowroomVehicles[id].coords.y, QB.ShowroomVehicles[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles[id].coords.x, QB.ShowroomVehicles[id].coords.y, QB.ShowroomVehicles[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles[id].coords.x, QB.ShowroomVehicles[id].coords.y, QB.ShowroomVehicles[id].coords.z, true)
            current = id
        end
    end
    if current ~= ClosestVehicle then
        ClosestVehicle = current
    end
end

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local shopDist = GetDistanceBetweenCoords(pos, QB.VehicleShops[1].x, QB.VehicleShops[1].y, QB.VehicleShops[1].z, false)
        if isLoggedIn then
            if shopDist <= 50 then
                setClosestShowroomVehicle()
            end
        end
        Citizen.Wait(1000)
    end
end)

--[[ local SellStarted = false



Citizen.CreateThread(function()
    Wait(1000)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false
        local SellDistance = GetDistanceBetweenCoords(pos, QB.QuickSell.x, QB.QuickSell.y, QB.QuickSell.z, true)

        if SellDistance < 20 then
            if IsPedInAnyVehicle(ped) then
                local VehicleData = Framework.Shared.VehicleModels[GetEntityModel(GetVehiclePedIsIn(ped))]
                if VehicleData["shop"] == "pdm" then
                    DrawMarker(2, QB.QuickSell.x, QB.QuickSell.y, QB.QuickSell.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 55, 155, 255, 0, 0, 0, 1, 0, 0, 0)
                    inRange = true
                    if SellDistance < 1 then
                        if not SellStarted then
                            DrawText3Ds(QB.QuickSell.x, QB.QuickSell.y, QB.QuickSell.z, '~b~E~w~ - Sell ​​vehicle for ~g~€'..math.ceil(VehicleData["price"] / 100 * 60))
                            if IsControlJustPressed(0, Keys["E"]) then
                                SellStarted = true
                            end
                        else
                            DrawText3Ds(QB.QuickSell.x, QB.QuickSell.y, QB.QuickSell.z, '~b~7~w~ - Confirm / ~b~8~w~ - Cancel')
                            if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustPressed(0, Keys["7"]) then
                                SellStarted = false
                                Framework.Functions.TriggerCallback('qb-vehicleshop:server:SellVehicle', function(SoldVehicle)
                                    if SoldVehicle then
                                        TriggerEvent("qb-phone-new:client:BankNotify", "€"..math.ceil(VehicleData["price"] / 100 * 60).." credited")
                                        local veh = GetVehiclePedIsIn(ped)
                                        Framework.Functions.DeleteVehicle(veh)
                                    else
                                        Framework.Functions.Notify('This is not your vehicle..', 'error')
                                    end
                                end, GetEntityModel(GetVehiclePedIsIn(ped)), GetVehicleNumberPlateText(GetVehiclePedIsIn(ped)))
                            end

                            if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                                SellStarted = false
                            end
                        end
                    else
                        if SellStarted then
                            SellStarted = false
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end) ]]

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z)

        if ClosestVehicle ~= nil then
            if dist < 2.0 then
                if not QB.ShowroomVehicles[ClosestVehicle].inUse then
                    local vehicleHash = GetHashKey(QB.ShowroomVehicles[ClosestVehicle].chosenVehicle)
                    local displayName = Framework.Shared.Vehicles[QB.ShowroomVehicles[ClosestVehicle].chosenVehicle]["name"]
                    local vehPrice = Framework.Shared.Vehicles[QB.ShowroomVehicles[ClosestVehicle].chosenVehicle]["price"]

                    if not QB.ShowroomVehicles[ClosestVehicle].inUse then
                        if not vehshop.opened then
                            if PlayerJob.name == "cardealer" and not buySure then
                                DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.8, '~g~G~w~ - Change vehicle (~g~'..displayName..'~w~)')
                            else
                                DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.8, 'Vehicle Name - ~g~'..displayName..'~w~')
                            end
                            if not buySure then
                                DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.70, '~g~E~w~ - Buy vehicle (~g~€'..vehPrice..'~w~)')
                            elseif buySure then
                                DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.65, 'Are you sure? | ~g~[7]~w~ Yes -/- ~r~[8]~w~ No')
                            end
                        elseif vehshop.opened then
                            if modelLoaded then
                                DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.65, 'Choosing vehicle')
                            else
                                DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.65, 'Vehicle is being picked up..')
                            end
                        end
                    else
                        DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.65, 'Vehicle is in use by a customer...')
                    end
                    if not vehshop.opened then
                        if PlayerJob.name == "cardealer"  then
                            DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 1.9, '~b~/givetest~w~ - Give Test Drive')
                        end
                    end    
                    
                    if not vehshop.opened then
                        if PlayerJob.name == "cardealer" and IsControlJustPressed(0, Keys["G"]) then
                            if vehshop.opened then
                                CloseCreator()
                            else
                                OpenCreator()
                            end
                        end
                    end

                    if vehshop.opened then

                        local ped = GetPlayerPed(-1)
                        local menu = vehshop.menu[vehshop.currentmenu]
                        local y = vehshop.menu.y + 0.12
                        buttoncount = tablelength(menu.buttons)
                        local selected = false

                        for i,button in pairs(menu.buttons) do
                            if i >= vehshop.menu.from and i <= vehshop.menu.to then

                                if i == vehshop.selectedbutton then
                                    selected = true
                                else
                                    selected = false
                                end
                                drawMenuButton(button,vehshop.menu.x,y,selected)
                                if button.price ~= nil then

                                    drawMenuRight("$"..button.price,vehshop.menu.x,y,selected)

                                end
                                y = y + 0.04
                                if isValidMenu(vehshop.currentmenu) then
                                    if selected then
                                        if IsControlJustPressed(1, 18) then
                                            if modelLoaded then
                                                TriggerServerEvent('qb-vehicleshop:server:setShowroomVehicle', button.model, ClosestVehicle)
                                            end
                                        end
                                    end
                                end
                                if selected and ( IsControlJustPressed(1,38) or IsControlJustPressed(1, 18) ) then
                                    ButtonSelected(button)
                                end
                            end
                        end
                    end

                    if vehshop.opened then
                        if IsControlJustPressed(1,202) then
                            Back()
                        end
                        if IsControlJustReleased(1,202) then
                            backlock = false
                        end
                        if IsControlJustPressed(1,188) then
                            if modelLoaded then
                                if vehshop.selectedbutton > 1 then
                                    vehshop.selectedbutton = vehshop.selectedbutton -1
                                    if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
                                        vehshop.menu.from = vehshop.menu.from -1
                                        vehshop.menu.to = vehshop.menu.to - 1
                                    end
                                end
                            end
                        end
                        if IsControlJustPressed(1,187)then
                            if modelLoaded then
                                if vehshop.selectedbutton < buttoncount then
                                    vehshop.selectedbutton = vehshop.selectedbutton +1
                                    if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
                                        vehshop.menu.to = vehshop.menu.to + 1
                                        vehshop.menu.from = vehshop.menu.from + 1
                                    end
                                end
                            end
                        end
                    end

                    if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 then
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                    end

                    if IsControlJustPressed(0, Keys["E"]) then
                        if not vehshop.opened then
                            if not buySure then
                                buySure = true
                            end
                        end
                    end

                    if IsDisabledControlJustPressed(0, Keys["7"]) then
                        if buySure then
                            local class = Framework.Shared.Vehicles[QB.ShowroomVehicles[ClosestVehicle].chosenVehicle]["category"]
                            TriggerServerEvent('qb-vehicleshop:server:buyShowroomVehicle', QB.ShowroomVehicles[ClosestVehicle].chosenVehicle, class)
                            buySure = false
                        end
                    end
                    if IsDisabledControlJustPressed(0, Keys["8"]) then
                        Framework.Functions.Notify('You did not buy the vehicle', 'error', 3500)
                        buySure = false
                    end
                    DisableControlAction(0, Keys["7"], true)
                    DisableControlAction(0, Keys["8"], true)
                elseif QB.ShowroomVehicles[ClosestVehicle].inUse then
                    DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles[ClosestVehicle].coords.y, QB.ShowroomVehicles[ClosestVehicle].coords.z + 0.5, 'Vehicle is in use')
                end
            elseif dist > 2.0 then
                if vehshop.opened then
                    CloseCreator()
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-vehicleshop:client:DoTestrit2')
AddEventHandler('qb-vehicleshop:client:DoTestrit2', function(plate)
    if ClosestVehicle ~= 0 then
        Framework.Functions.SpawnVehicle(QB.ShowroomVehicles[ClosestVehicle].chosenVehicle, function(veh)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            exports['qb-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
            SetVehicleNumberPlateText(veh, plate)
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, QB.VehicleBuyLocations.h)
            exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
            testritveh = veh

            if QB.ShowroomVehicles[ClosestVehicle].chosenVehicle == "urus" then
                SetVehicleExtra(veh, 1, false)
                SetVehicleExtra(veh, 2, true)
            end
        end, QB.VehicleBuyLocations, false)
    end
end)

RegisterNetEvent('qb-vehicleshop:client:setShowroomCarInUse')
AddEventHandler('qb-vehicleshop:client:setShowroomCarInUse', function(showroomVehicle, inUse)
    QB.ShowroomVehicles[showroomVehicle].inUse = inUse
end)

RegisterNetEvent('qb-vehicleshop:client:setShowroomVehicle')
AddEventHandler('qb-vehicleshop:client:setShowroomVehicle', function(showroomVehicle, k)
    if QB.ShowroomVehicles[k].chosenVehicle ~= showroomVehicle then
        Framework.Functions.DeleteVehicle(GetClosestVehicle(QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z, 3.0, 0, 70))
        modelLoaded = false
        Wait(250)
        local model = GetHashKey(showroomVehicle)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(250)
        end
        local veh = CreateVehicle(model, QB.ShowroomVehicles[k].coords.x, QB.ShowroomVehicles[k].coords.y, QB.ShowroomVehicles[k].coords.z, false, false)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(veh)
        SetEntityInvincible(veh,true)
        SetEntityHeading(veh, QB.ShowroomVehicles[k].coords.h)
        SetVehicleDoorsLocked(veh, 3)
        FreezeEntityPosition(veh, true)
        SetVehicleNumberPlateText(veh, k .. "CARSALE")
        modelLoaded = true
        QB.ShowroomVehicles[k].chosenVehicle = showroomVehicle
    end
end)

RegisterNetEvent('qb-vehicleshop:client:buyShowroomVehicle')
AddEventHandler('qb-vehicleshop:client:buyShowroomVehicle', function(vehicle, plate)
    Framework.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['qb-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, QB.DefaultBuySpawn.h)
        SetEntityAsMissionEntity(veh, true, true)
        exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
        SetEntityAsMissionEntity(veh, true, true)
    end, QB.DefaultBuySpawn, false)
end)

RegisterNetEvent('qb-vehicleshop:client:GiveTest')
AddEventHandler('qb-vehicleshop:client:GiveTest', function(plate)
    Framework.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['qb-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, QB.DefaultBuySpawn.h)
        SetEntityAsMissionEntity(veh, true, true)
        exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
        SetEntityAsMissionEntity(veh, true, true)
    end, QB.DefaultBuySpawn, false)
end)