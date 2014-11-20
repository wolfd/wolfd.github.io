--City Gen: (whatever) Version
--By: WolfX
--Code used for wealth map is by D3, (thanks!)
System_Message_Network_Send_2_All(-1, "Loaded City Generator")


function pushCityBlock(coordinatesArray)
	for i = 1, 4 do
		table.insert(cityBlockStack, coordinatesArray[i])
	end
end

function popCityBlock()
	--System_Message_Network_Send_2_All(Map_ID, "&c"..table.getn(cityBlockStack))
	popArray = nil
	popArray = {}
	if table.getn(cityBlockStack) >= 4 then
		for i = 1, 4 do
			popArray[i] = cityBlockStack[#cityBlockStack-4+i]
		end

		for i = 1, 4 do
			table.remove(cityBlockStack, #cityBlockStack-4+i)
		end
	end

	return popArray
end
function generateStairs(stairWidth, floorSize, buildingBlockHeight)

	local stairs = {}
	for ix = 0, floorSize do
		stairs[ix] = {}
		for iy = 0, floorSize+1 do
			stairs[ix][iy] = {}
			for iz = 0, buildingBlockHeight-1 do
				stairs[ix][iy][iz] = 0
				if iz%floorSize == 0 then
				stairs[ix][0][iz-1] = 1
				end
			end
		end
	end

	for ix = 0, floorSize do
		for iz = 0, buildingBlockHeight-1 do
			stairs[ix][((iz+1)%floorSize)+1][iz] = 1
		end
	end

return stairs
end

function generateBuildingWall(buildingWidth, buildingBlockHeight, windowWidth, windowHeight, floorSize)


	--wall array
	buildingWall = {}

	for ix = 0, buildingWidth do
		buildingWall[ix] = {}
		for iy = 0, buildingBlockHeight do
			buildingWall[ix][iy] = baseColor
		end
	end

	--Y wall array
	--[[local buildingWallY = {buildingWidthY, buildingBlockHeight}
	for ix = 0, buildingWidthY do
		for iy = 0, buildingBlockHeight do
			buildingWallY[ix][iy] = baseColor
		end
	end]]

	--windows

	for ix = 0, buildingWidth do

		if ix%windowWidth == 0 then
			--do nothing
			else
			for iy = 0, buildingBlockHeight do
				buildingWall[ix][iy] = windowColor
			end
		end
	end

	--floors
	for iy = 0, buildingBlockHeight do

		if iy%floorSize == 0 then
			for ix = 0, buildingWidth do
				buildingWall[ix][iy] = baseColor
			end
		end
		buildingWall[buildingWidth][iy] = decorativeColor
		buildingWall[0][iy] = decorativeColor
	end

	--top
	for ix = 0, buildingWidth do
		buildingWall[ix][buildingBlockHeight] = decorativeColor
	end

	--reflect
	for ix = 0, buildingWidth do
		if ix <=(buildingWidth/2) then
			for iy = 0, buildingBlockHeight do
				buildingWall[ix][iy] = buildingWall[(buildingWidth) - ix][iy]
			end
		end
	end
	return buildingWall
	end

function generateBuilding(buildingWidthX, buildingWidthY, buildingBlockHeight, windowWidth, windowHeight, floorSize, doorDirection)

	--generate building array
	local building = {}
	for ix = 0, buildingWidthX do
		building[ix] = {}
		for iy = 0, buildingWidthY do
			building[ix][iy] = {}
			for iz = 0, buildingBlockHeight do
				building[ix][iy][iz] = 0
				--building[ix][iy][iz] = 0
			end
		end
	end


	local buildingWallX = generateBuildingWall(buildingWidthX, buildingBlockHeight, windowWidth, windowHeight, floorSize)

	local buildingWallY = generateBuildingWall(buildingWidthY, buildingBlockHeight, windowWidth, windowHeight, floorSize)

	--fill building array with floors
	for ix = 0, buildingWidthX do
		for iy = 0, buildingWidthY do
			for iz = 0, buildingBlockHeight do
				if iz%floorSize == 0 then
				building[ix][iy][iz] = 1
				end
			end
		end
	end


	--rooms to go here


	local stairWidth = math.min(6, buildingWidthY)
	local stairs = generateStairs(stairWidth, floorSize, buildingBlockHeight)

	for ix = 0, floorSize do
		for iy = 0, floorSize do
			for iz = 0, buildingBlockHeight-2 do
				building[ix+math.floor((buildingWidthX/2)-(floorSize/2))][iy+math.floor((buildingWidthY/2)-(floorSize/2))][iz+1] = stairs[ix][iy][iz]
			end
		end
	end


	--fill building array with 4 walls
	for ix = 0, buildingWidthX do
		for iy = 0, buildingWidthY do
			for iz = 0, buildingBlockHeight do
				building[0][iy][iz] = buildingWallY[iy][iz]
				building[buildingWidthX][iy][iz] = buildingWallY[iy][iz]
				building[ix][0][iz] = buildingWallX[ix][iz]
				building[ix][buildingWidthY][iz] = buildingWallX[ix][iz]
			end
		end
	end

	--make entrance
	for iEntrance = 1, 4 do
		if doorDirection[iEntrance] == true then
			local doorOpenDirection = iEntrance
			if doorOpenDirection == 1 or doorOpenDirection == 3 then
				buildingWidth = buildingWidthX
			else
				buildingWidth = buildingWidthY
			end
			local i
			local doorWidth = math.random(2,buildingWidth/4)
			for ix = 0, buildingWidthX do
				for iy = 0, buildingWidthY do
					for iz = 0, math.min(floorSize, 3) do
						--x or y iteration
						if doorOpenDirection == 1 or doorOpenDirection == 3 then
							i = ix
						else
							i = iy
						end
						--door border
						if i >= (buildingWidth/2)-(doorWidth/2)-1 and i <= (buildingWidth/2)+(doorWidth/2)+1 then
							if doorOpenDirection == 1 then
								building[ix][buildingWidthY][iz] = baseColor
							end
							if doorOpenDirection == 2 then
								building[buildingWidthX][iy][iz] = baseColor
							end
							if doorOpenDirection == 3 then
								building[ix][0][iz] = baseColor
							end
							if doorOpenDirection == 4 then
								building[0][iy][iz] = baseColor
							end
						end
						--door step
						if i >= (buildingWidth/2)-(doorWidth/2) and i <= (buildingWidth/2)+(doorWidth/2) then

							if doorOpenDirection == 1 then
								building[ix][buildingWidthY][iz] = 0
								building[ix][buildingWidthY][0] = 44
							end
							if doorOpenDirection == 2 then
								building[buildingWidthX][iy][iz] = 0
								building[buildingWidthX][iy][0] = 44
							end
							if doorOpenDirection == 3 then
								building[ix][0][iz] = 0
								building[ix][0][0] = 44
							end
							if doorOpenDirection == 4 then
								building[0][iy][iz] = 0
								building[0][iy][0] = 44
							end
						end
					end
				end
			end
		end
	end

return building
end

function Mapfill_city(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)


	local Time_Start = os.clock()



	--standard flatgrass
	for ix = 0, Map_Size_X-1 do
		for iy = 0, Map_Size_Y-1 do
			for iz = 0, Map_Size_Z/2-1 do
				if iz == Map_Size_Z/2-1 then
					Map_Block_Change_Fast(-1, Map_ID, ix, iy, iz, 49, 0, 0, 0, 0)
					--potholes are stupid
					--[[if math.random(1,100)==50 then
					Map_Block_Change_Fast_Fast(-1, Map_ID, ix, iy, iz, 0, 0, 0, 0, 0)
					end]]
				else
					Map_Block_Change_Fast(-1, Map_ID, ix, iy, iz, 3, 0, 0, 0, 0)
				end
			end
		end
	end

	local Map_Size_Scaled_Z = Map_Size_Z/2
	local Size = 2
	-- Höhen: (Maximale Höhe des Materials)
	local Height_Poor = Map_Size_Scaled_Z * 0.3
	local Height_Mid = Map_Size_Scaled_Z * 0.5
	local Height_Wealthy = Map_Size_Scaled_Z * 0.65
	local Height_Skyscraper = Map_Size_Scaled_Z * 0.8

	--begin code by d3
	if Map_Size_X <= 512 and Map_Size_Y <= 512 then
	Iterations = 8
	end
	if Map_Size_X <= 256 and Map_Size_Y <= 256 then
	Iterations = 7
	end
	if Map_Size_X <= 128 and Map_Size_Y <= 128 then
	Iterations = 6
	end
	if Map_Size_X <= 64 and Map_Size_Y <= 64 then
	Iterations = 5
	end
	if Map_Size_X <= 32 and Map_Size_Y <= 32 then
	Iterations = 4
	end
	if Map_Size_X <= 16 and Map_Size_Y <= 16 then
	Iterations = 3
	end

	local wealthMap = {}
	for i = 0, 600 do
		wealthMap[i] = {}
	end

	for ix = 0, Size do
		for iy = 0, Size do
			wealthMap[ix][iy] = math.random(Map_Size_Scaled_Z*0.9)
			if wealthMap[ix][iy] < Height_Poor then
				wealthMap[ix][iy] = (wealthMap[ix][iy] + Height_Poor*15) / 16
			end
			if wealthMap[ix][iy] > Height_Poor and wealthMap[ix][iy] < Height_Mid then
				wealthMap[ix][iy] = (wealthMap[ix][iy] + Height_Poor*80) / 81
			end
		end
	end

	for i = 1, Iterations do
		if i >= Iterations-1 then
			RND_Factor = 0
		else
			RND_Factor = 0.010*(Iterations-i)
		end

		for ix = Size, 0, -1 do
			for iy = Size, 0, -1 do
				wealthMap[ix*2][iy*2] = wealthMap[ix][iy]
			end
		end
		for ix = 0, Size-1 do
			for iy = 0, Size-1 do
				if wealthMap[ix*2][iy*2] <= Height_Poor then
					RND_Factor_2 = RND_Factor * 0.5
				elseif wealthMap[ix*2][iy*2] <= Height_Mid then
					RND_Factor_2 = RND_Factor * 0.3
				else
					RND_Factor_2 = RND_Factor
				end
				wealthMap[ix*2][iy*2+1] = (wealthMap[ix*2][iy*2] + wealthMap[ix*2][iy*2+2]) / 2 + ((math.random(255)-128)*RND_Factor_2)
				wealthMap[ix*2+2][iy*2+1] = (wealthMap[ix*2+2][iy*2] + wealthMap[ix*2+2][iy*2+2]) / 2 + ((math.random(255)-128)*RND_Factor_2)

				wealthMap[ix*2+1][iy*2] = (wealthMap[ix*2][iy*2] + wealthMap[ix*2+2][iy*2]) / 2 + ((math.random(255)-128)*RND_Factor_2)
				wealthMap[ix*2+1][iy*2+2] = (wealthMap[ix*2][iy*2+2] + wealthMap[ix*2+2][iy*2+2]) / 2 + ((math.random(255)-128)*RND_Factor_2)

				wealthMap[ix*2+1][iy*2+1] = (wealthMap[ix*2][iy*2] + wealthMap[ix*2+2][iy*2] + wealthMap[ix*2][iy*2+2] + wealthMap[ix*2+2][iy*2+2]) / 4 + ((math.random(255)-128)*RND_Factor_2)
			end
		end
		Size = Size * 2
	end
	--make heightmap with water
	--[[for ix = 0, Map_Size_X do
		for iy = 0, Map_Size_Z do
			Map_Block_Change_Fast(-1, Map_ID, ix, iy, (Map_Size_Z/2)+wealthMap[ix][iy], 9, 0, 0, 0, 0) --44 = sidewalk
		end
	end]]

	--end code by D3 (Thanks!)
	local defaultBlockSizeX = math.random(32,72)
	local defaultBlockSizeY = math.random(32,72)

	local sidewalkSize = 2
	local roadSize = 9 + (sidewalkSize * 2)

	--[[local defaultBlockSizeX = 80
	local defaultBlockSizeY = 271]]

	local blocksX = Map_Size_X/(defaultBlockSizeX + roadSize)
	local blocksY = Map_Size_Y/(defaultBlockSizeY + roadSize)

	buildingsCreated = 0

	for iBlocksX = 1, blocksX do
		for iBlocksY = 1, blocksY do

			local sidewalkStartX = (iBlocksX*defaultBlockSizeX) - defaultBlockSizeX + (roadSize*iBlocksX) - sidewalkSize
			local sidewalkStartY = (iBlocksY*defaultBlockSizeY) - defaultBlockSizeY + (roadSize*iBlocksY) - sidewalkSize
			local sidewalkEndX = (iBlocksX*defaultBlockSizeX) + (roadSize*iBlocksX) - 3 + sidewalkSize
			local sidewalkEndY = (iBlocksY*defaultBlockSizeY) + (roadSize*iBlocksY) - 3 + sidewalkSize

			local cityBlockStartX = (iBlocksX*defaultBlockSizeX)-defaultBlockSizeX
			local cityBlockStartY = (iBlocksY*defaultBlockSizeY)-defaultBlockSizeY
			local cityBlockEndX = (iBlocksX*defaultBlockSizeX)
			local cityBlockEndY = (iBlocksY*defaultBlockSizeY)

			for ix = sidewalkStartX, sidewalkEndX do
				for iy = sidewalkStartY, sidewalkEndY do
					Map_Block_Change_Fast(-1, Map_ID, ix, iy, (Map_Size_Z/2), 44, 0, 0, 0, 0) --44 = sidewalk
				end
			end

			--lamps
			local lampDistance = 25
			for ix = sidewalkStartX, sidewalkEndX do
				if ix%lampDistance == 0 and ix >= sidewalkStartX+2 and ix <= sidewalkEndX-2 then
					for iz = 0, 6 do
						Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkStartY, (Map_Size_Z/2)+iz, 43, 0, 0, 0, 0)
					end
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkStartY-1, (Map_Size_Z/2)+5, 23, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkStartY-1, (Map_Size_Z/2)+6, 44, 0, 0, 0, 0)
				end
			end

			for ix = sidewalkStartX, sidewalkEndX do
				if ix%lampDistance == 0 and ix >= sidewalkStartX+2 and ix <= sidewalkEndX-2 then
					for iz = 0, 6 do
						Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkEndY, (Map_Size_Z/2)+iz, 43, 0, 0, 0, 0)
					end
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkEndY+1, (Map_Size_Z/2)+5, 23, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkEndY+1, (Map_Size_Z/2)+6, 44, 0, 0, 0, 0)
				end
			end

			for iy = sidewalkStartY, sidewalkEndY do
				if iy%lampDistance == 0 and iy >= sidewalkStartY+2 and iy <= sidewalkEndY-2 then
					for iz = 0, 6 do
						Map_Block_Change_Fast(-1, Map_ID, sidewalkStartX, iy,  (Map_Size_Z/2)+iz, 43, 0, 0, 0, 0)
					end
					Map_Block_Change_Fast(-1, Map_ID, sidewalkStartX-1, iy, (Map_Size_Z/2)+5, 23, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, sidewalkStartX-1, iy, (Map_Size_Z/2)+6, 44, 0, 0, 0, 0)
				end
			end

			for iy = sidewalkStartY, sidewalkEndY do
				if iy%lampDistance == 0 and iy >= sidewalkStartY+2 and iy <= sidewalkEndY-2 then
					for iz = 0, 6 do
						Map_Block_Change_Fast(-1, Map_ID, sidewalkEndX, iy,  (Map_Size_Z/2)+iz, 43, 0, 0, 0, 0)
					end
					Map_Block_Change_Fast(-1, Map_ID, sidewalkEndX+1, iy, (Map_Size_Z/2)+5, 23, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, sidewalkEndX+1, iy, (Map_Size_Z/2)+6, 44, 0, 0, 0, 0)
				end
			end
			--end lamps


			--hydrants
			local hydrantDistance = 57
			for ix = sidewalkStartX, sidewalkEndX do
				if ix%hydrantDistance == 0 and ix >= sidewalkStartX+2 and ix <= sidewalkEndX-2 and ix%lampDistance ~= 0 then
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkStartY, (Map_Size_Z/2), 21, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkStartY, (Map_Size_Z/2)+1, 44, 0, 0, 0, 0)
				end
			end

			for ix = sidewalkStartX, sidewalkEndX do
				if ix%hydrantDistance == 0 and ix >= sidewalkStartX+2 and ix <= sidewalkEndX-2 and ix%lampDistance ~= 0 then
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkEndY, (Map_Size_Z/2), 21, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, ix, sidewalkEndY, (Map_Size_Z/2)+1, 44, 0, 0, 0, 0)
				end
			end

			for iy = sidewalkStartY, sidewalkEndY do
				if iy%hydrantDistance == 0 and iy >= sidewalkStartY+2 and iy <= sidewalkEndY-2 and iy%lampDistance ~= 0 then
					Map_Block_Change_Fast(-1, Map_ID, sidewalkStartX, iy, (Map_Size_Z/2), 21, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, sidewalkStartX, iy, (Map_Size_Z/2)+1, 44, 0, 0, 0, 0)
				end
			end

			for iy = sidewalkStartY, sidewalkEndY do
				if iy%hydrantDistance == 0 and iy >= sidewalkStartY+2 and iy <= sidewalkEndY-2 and iy%lampDistance ~= 0 then
					Map_Block_Change_Fast(-1, Map_ID, sidewalkEndX, iy, (Map_Size_Z/2), 21, 0, 0, 0, 0)
					Map_Block_Change_Fast(-1, Map_ID, sidewalkEndX, iy, (Map_Size_Z/2)+1, 44, 0, 0, 0, 0)
				end
			end
			--end hydrants

			--steet lines
			local streetLineLength = 3 -- minus 1
			for ix = sidewalkStartX, sidewalkEndX do
				for iy = sidewalkStartY, sidewalkEndY do
					if ix%streetLineLength ~= 1 and iy == sidewalkEndY then
						Map_Block_Change_Fast(-1, Map_ID, ix, iy + math.floor(roadSize/2), (Map_Size_Z/2)-1, 36, 0, 0, 0, 0)
					end
					if iy%streetLineLength ~= 1 and ix == sidewalkEndX then
						Map_Block_Change_Fast(-1, Map_ID, ix + math.floor(roadSize/2), iy, (Map_Size_Z/2)-1, 36, 0, 0, 0, 0)
					end
				end
			end
			--street lines end

			--clear block stack
			cityBlockStack = nil
			cityBlockStack = {}

			minBuildingSize = 16
			minSplitSize = (minBuildingSize * 2)
			firstSplitBool = true
			--loop here
			while true do

				if firstSplitBool == true then
					divisionBlockStartX = (iBlocksX*defaultBlockSizeX)-defaultBlockSizeX
					divisionBlockStartY = (iBlocksY*defaultBlockSizeY)-defaultBlockSizeY
					divisionBlockEndX = (iBlocksX*defaultBlockSizeX)
					divisionBlockEndY = (iBlocksY*defaultBlockSizeY)
					firstSplitBool = false
				else
					poparray = nil
					popArray = popCityBlock()
					if table.getn(popArray) == 4 then
						divisionBlockStartX, divisionBlockStartY, divisionBlockEndX, divisionBlockEndY = popArray[1], popArray[2], popArray[3], popArray[4]
					else
						break
					end
				end

				dStartX = math.min(divisionBlockStartX, divisionBlockEndX)
				dStartY = math.min(divisionBlockStartY, divisionBlockEndY)
				dEndX = math.max(divisionBlockStartX, divisionBlockEndX)
				dEndY = math.max(divisionBlockStartY, divisionBlockEndY)
				dSizeX = dEndX - dStartX
				dSizeY = dEndY - dStartY

				--division of blocks

				local cutXBool = false
				local cutYBool = false
				local doCutBlock = math.random(1,10)
				if dSizeX  >= minSplitSize and dSizeX > dSizeY and doCutBlock > 5 then
					--System_Message_Network_Send_2_All(Map_ID, "cutX")
					--split block x
					if dStartX + minBuildingSize <= dEndX - minBuildingSize then
						cutX = math.random(dStartX + minBuildingSize, dEndX - minBuildingSize)
						cutXBool = true
					end
				elseif dSizeY  >= minSplitSize and dSizeY > dSizeX and doCutBlock > 5 then
					--System_Message_Network_Send_2_All(Map_ID, "cutY")
					--split block y
					if dStartY + minBuildingSize <= dEndY - minBuildingSize then
						cutY = math.random(dStartY + minBuildingSize, dEndY - minBuildingSize)
						cutYBool = true
					end
				else
					if math.random(0,10) > 5 then
						--System_Message_Network_Send_2_All(Map_ID, "cutX")
						--split block x
						if dStartX + minBuildingSize <= dEndX - minBuildingSize then
							cutX = math.random(dStartX + minBuildingSize, dEndX - minBuildingSize)
							cutXBool = true
						end
					else
						--System_Message_Network_Send_2_All(Map_ID, "cutY")
						--split block y
						if dStartY + minBuildingSize <= dEndY - minBuildingSize then
							cutY = math.random(dStartY + minBuildingSize, dEndY - minBuildingSize)
							cutYBool = true
						end
					end
				end

				--decide what to push to stack
				if cutXBool == true and cutYBool == false then
					pushCityBlock({dStartX, dStartY, cutX, dEndY})
					pushCityBlock({cutX, dStartY, dEndX, dEndY})
				end

				if cutXBool == false and cutYBool == true then
					pushCityBlock({dStartX, dStartY, dEndX, cutY})
					pushCityBlock({dStartX, cutY, dEndX, dEndY})
				end

				if cutXBool == false and cutYBool == false then
					--check to see if building has any points touching street, only build if so
					if dStartX == (iBlocksX*defaultBlockSizeX)-defaultBlockSizeX or dEndX == (iBlocksX*defaultBlockSizeX) or dStartY == (iBlocksY*defaultBlockSizeY)-defaultBlockSizeY or dEndY == (iBlocksY*defaultBlockSizeY) then
						--draw building here
						--colors
						--building styles
						local wealthVal = wealthMap[math.min(dStartX,Map_Size_X)][math.min(dStartY,Map_Size_Y)]

						floorSize = 4
						local maxFloors = (Map_Size_Z/2)/floorSize - floorSize

						if wealthVal < Height_Poor then
							--abandoned/poor
							if math.random()>.7 then
								baseColorArray = nil
								baseColorArray = {1}
								windowWidth = math.random(2,3)
								windowHeight = 0 --possibly later
								windowColor = 0
								buildingFloors = math.floor(wealthVal/floorSize)
							else
								baseColorArray = nil
								baseColorArray = {1}
								windowWidth = math.random(2,3)
								windowHeight = 0 --possibly later
								windowColor = 20
								buildingFloors = math.floor(wealthVal/floorSize)
							end

						elseif wealthVal >= Height_Poor and wealthVal < Height_Mid then
							--mid
							baseColorArray = nil
							baseColorArray = {1, 35, 36, 43}
							windowWidth = math.random(2,4)
							windowHeight = 0 --possibly later
							windowColor = 20 --glass
							buildingFloors = math.floor(wealthVal/floorSize)

						elseif wealthVal >= Height_Mid and wealthVal < Height_Wealthy then
							--wealthy
							baseColorArray = nil
							baseColorArray = {1, 34, 35, 36, 42, 43}
							windowWidth = math.random(2,8)
							windowHeight = 0 --possibly later
							windowColor = 20 --glass
							buildingFloors = math.floor(wealthVal/floorSize)

						elseif wealthVal >= Height_Wealthy and wealthVal < Height_Skyscraper then
							--skyscraper
							baseColorArray = nil
							baseColorArray = {34, 35, 36, 42, 43}
							windowWidth = math.random(4,16)
							windowHeight = 0 --possibly later
							windowColor = 20
							buildingFloors = math.floor(wealthVal/floorSize)

						elseif wealthVal >= Height_Skyscraper then
							--skyscraper
							baseColorArray = nil
							baseColorArray = {34, 42}
							windowWidth = math.random(4,16)
							windowHeight = 0 --possibly later
							windowColor = 20
							buildingFloors = maxFloors

						end

						baseColor = baseColorArray[math.random(1,#baseColorArray)]
						decorativeColor = baseColorArray[math.random(1,#baseColorArray)]
						--windowColor = 20 --glass



						--local buildingFloors = math.random(3,maxFloors)


						--System_Message_Network_Send_2_All(Map_ID, wealth)

						local buildingBlockHeight = (buildingFloors * floorSize) + 1
						local alleySize = 3 --minus 1
						local buildingWidthX = (dEndX-dStartX) - alleySize
						local buildingWidthY = (dEndY-dStartY) - alleySize

						local doorDirection = nil
						local doorDirection = {}

						if dStartX == cityBlockStartX then
							doorDirection[4] = true -- GOOD
						else
							doorDirection[4] = false
						end
						if dStartY == cityBlockStartY then
							doorDirection[3] = true
						else
							doorDirection[3] = false
						end
						if dEndX == cityBlockEndX then
							doorDirection[2] = true
						else
							doorDirection[2] = false
						end
						if dEndY == cityBlockEndY then
							doorDirection[1] = true
						else
							doorDirection[1] = false
						end


						building = generateBuilding(buildingWidthX, buildingWidthY, buildingBlockHeight, windowWidth, windowHeight, floorSize, doorDirection)
						buildingsCreated = buildingsCreated + 1

						--System_Message_Network_Send_2_All(Map_ID, "building: "..buildingsCreated.."  dStartX: "..dStartX.."  dEndX: "..dEndX.."  dStartY: "..dStartY.."  dEndY: "..dEndY)

						for ix = 0, buildingWidthX do
							for iy = 0, buildingWidthY do
								for iz = 0, buildingBlockHeight do
									Map_Block_Change_Fast(-1, Map_ID, ix + dStartX + (roadSize*iBlocksX), iy + dStartY + (roadSize*iBlocksY), iz + (Map_Size_Z/2), building[ix][iy][iz], 0, 0, 0, 0)
								end
							end
						end
					end
				end



			end --block loop

		end
	end

	System_Message_Network_Send_2_All(Map_ID, "&cCity generated in "..string.sub(tostring(os.clock()-Time_Start), 1, 4).."s.")
	System_Message_Network_Send_2_All(Map_ID, "&cCreated "..buildingsCreated.." buildings")
	System_Message_Network_Send_2_All(Map_ID, "&cCityGen made by WolfX.")


end

--for testing in SciTE
--Mapfill_city(Map_ID, 128, 128, 128)
