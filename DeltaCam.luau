--!nonstrict
--[[


 █████  ███████  ██████ ██   ██  ██████  ██████  ██████  
██   ██ ██      ██      ██   ██ ██    ██ ██   ██ ██   ██ 
███████ ███████ ██      ███████ ██    ██ ██████  ██████  
██   ██      ██ ██      ██   ██ ██    ██ ██   ██ ██      
██   ██ ███████  ██████ ██   ██  ██████  ██   ██ ██      

                                    
 
████████ ███████  ██████ ██   ██ ███    ██  ██████  ██       ██████   ██████  ██ ███████ ███████ 
   ██    ██      ██      ██   ██ ████   ██ ██    ██ ██      ██    ██ ██       ██ ██      ██      
   ██    █████   ██      ███████ ██ ██  ██ ██    ██ ██      ██    ██ ██   ███ ██ █████   ███████ 
   ██    ██      ██      ██   ██ ██  ██ ██ ██    ██ ██      ██    ██ ██    ██ ██ ██           ██ 
   ██    ███████  ██████ ██   ██ ██   ████  ██████  ███████  ██████   ██████  ██ ███████ ███████ 
                                                                                 

Ashcorp tecnologies - "Spaggetti code since 2022"


█████████████████████████████
█							█
█	HOW TO USE AND INFO 	█
█							█
█████████████████████████████


this is basically a script that when the player presses
the key C it toggles 1st person cam. It also does
the illusion of vehicle suspension via camera position 
thingamajigs. Used for trains, expect
bugs and incopences when used with other vehicles


Put this in Starter player scripts as a localscript
Profit! 


feel free to modify - give credit if u do plsss
inspired by british railway's 1st person cam system!

V 1.0

- Ashley (@CatzHTU) - 2026 COPYRIGHT MODIFICATION ALLOWED - MUST CREDIT -- ASHCORP TECHNOLOGIES
]]
--[[
 
█████████████████████████████
█							█
█	  CONFIGURATIONS 		█
█							█
█████████████████████████████

]]

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInput     = game:GetService("UserInputService")
local ContextAction = game:GetService("ContextActionService")

local player    = Players.LocalPlayer
local cam       = workspace.CurrentCamera
local SPRING_K  = 20      -- suspension stiffness
local DAMP_K    = 5       -- suspension damping
local suspensionMultiplier = 2 -- Multiply all suspension effects.

-- states
local active               = false 
local baseFOV              = 70
local zoomStep             = 2 		-- how much the fov changes when the player scrools for 1 delta (one mouse scroll snapping thingy. Thats where the name comes from, yes)
local minFOV, maxFOV       = 30, 90	-- 
local springPos, springVel = 0, 0 	-- spring positions and spring velocities
local swayPos, swayVel     = 0, 0   -- lateral movement
local cameraRootPart 	   = "hum" 	-- alternate between "hum" (humanoid) and "root" (root part). The latter makes the entire player's char invisible for convinience. can also be set to a CFrame / Vector. Defaults to "hum" 

--[[
 
█████████████████████████████
█							█
█	  END OF CONFIGS 		█
█							█
█████████████████████████████

]]


local renderConn           = nil -- this thing is holding up the entire suspension together. pls no touchy T_T

local function onSit(seat, humanoid)
	active = false
	cam.CameraType = Enum.CameraType.Custom
	cam.FieldOfView = baseFOV

	ContextAction:BindAction("ToggleFP", function(_, state)
		if state == Enum.UserInputState.Begin then
			active = not active
			if active then
				cam.CameraType = Enum.CameraType.Attach
				player.CameraMode = Enum.CameraMode.LockFirstPerson
				if cameraRootPart == "hum" then
					cam.CameraSubject = humanoid
				elseif cameraRootPart == "root" then 
					cam.CameraSubject = humanoid.RootPart
				elseif type(cameraRootPart) == "string" or cameraRootPart == nil then 
					warn(`:: DELTA CAM :: Warning! {cameraRootPart} is not valid! Set within params (defaulted to humanoid)`)
					cam.CameraSubject = humanoid
				else
					if type(cameraRootPart) == "vector" then
						local camPart = Instance.new("Part", workspace)
						camPart.Position = cameraRootPart
						camPart.Transparency = 1 -- feel free to change! 
						cam.CameraSubject = camPart
					elseif type(cameraRootPart) == "userdata" then -- i have no idea why its called user data
						local s,f = pcall(function()
							local camp = Instance.new("Part", workspace)
							camp.CFrame = cameraRootPart
							camp.Transparency = 1
							cam.CameraSubject = camp
						end)

						if not s then warn(f) cam.CameraSubject = humanoid wait(":: DELTA CAM :: Cannot process CFrame for some ungodly reason") end
					else
						warn(`:: DELTA CAM :: Warning! {cameraRootPart} is not valid! Set within params (defaulted to humanoid)`)
						cam.CameraSubject = humanoid
					end
				end
			else
				cam.CameraType = Enum.CameraType.Custom
				player.CameraMode = Enum.CameraMode.Classic
				cam.CameraSubject = humanoid
			end
		end
	end, false, Enum.KeyCode.C)


	UserInput.InputChanged:Connect(function(inp)
		if active and inp.UserInputType == Enum.UserInputType.MouseWheel then
			local delta = inp.Position.Z > 0 and -zoomStep or zoomStep
			cam.FieldOfView = math.clamp(cam.FieldOfView + delta, minFOV, maxFOV)
		end
	end)


	if renderConn then
		renderConn:Disconnect()
	end

	local lastVel = seat.Velocity
	springPos, springVel = 0, 0
	swayPos, swayVel = 0, 0

	renderConn = RunService.RenderStepped:Connect(function(dt)
		if active then
			local velocity = seat.Velocity
			local cf = seat.CFrame
			local forward = cf.LookVector
			local right = cf.RightVector
			local deltaV = velocity - lastVel
			lastVel = velocity

			local longAccel = forward:Dot(deltaV) / dt
			local latAccel = right:Dot(deltaV) / dt

			local threshold = 0.5

			local springTarget = math.abs(longAccel) > threshold and -longAccel * 0.002 * suspensionMultiplier or 0
			local swayTarget   = math.abs(latAccel) > threshold and  latAccel * 0.002 * suspensionMultiplier or 0

			springVel += (springTarget - springPos) * SPRING_K * dt
			springVel *= math.exp(-DAMP_K * dt)
			springPos += springVel * dt

			swayVel += (swayTarget - swayPos) * SPRING_K * dt
			swayVel *= math.exp(-DAMP_K * dt)
			swayPos += swayVel * dt

			local tilt = CFrame.Angles(-springPos * 0.002 * suspensionMultiplier, 0, -swayPos * 0.002 * suspensionMultiplier)
			local lookCFrame = cam.CFrame - cam.CFrame.Position
			cam.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, springPos, 0) + cf.RightVector * swayPos) * tilt * lookCFrame
		end
	end)
end


player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").Seated:Connect(function(isSit, activeSeat)
		if isSit and activeSeat:IsA("VehicleSeat") or activeSeat:IsA("Seat") then
			onSit(activeSeat, char:WaitForChild("Humanoid"))
		end
	end)
end)
