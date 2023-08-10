---------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Helper Functions (Functions that you want to use in your Client code) --------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

--Add your code here

function drawcircle()
	local center = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 15.0, 0.0)

	local r = 10.0

	local Cx = center.x
	local Cy = center.y
	local z = center.z

	X_deg0 = Cx + (r * math.cos(0))
	Y_deg0 = Cy + (r * math.sin(0))

	-- Citizen.InvokeNative(GetHashKey("DRAW_LINE") & 0xFFFFFFFF,GetEntityCoords(PlayerPedId()), center, 255, 0, 0, 255)

	for i = 0, 360, 45 do
		i = math.rad(i)
		local X_deg0 = Cx + (r * math.cos(i))
		local Y_deg0 = Cy + (r * math.sin(i))

		local Vec = vec3(X_deg0, Y_deg0, z)

		-- local _, groundZ, _ = GetGroundZAndNormalFor_3dCoord(camVec.x, camVec.y, camVec.z)

		-- if math.abs(z - groundZ) < minHeightAboveGround then
		-- 	Vec = vec3(Vec)
		-- end

		Citizen.InvokeNative(GetHashKey("DRAW_LINE") & 0xFFFFFFFF, center, Vec, 255, 0, 0, 255)
	end
end