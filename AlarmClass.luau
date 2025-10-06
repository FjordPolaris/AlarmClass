--@Yorushika_Chan (POLARIS)

local CollectionService = game:GetService("CollectionService")

local Alarm = {}
Alarm.__index = Alarm

type self = {
	-- Attributes
	Object: Model,
	PrimaryPart: BasePart,
	Bulb: BasePart,
	SpinSpeed: number,
	
	TintedLens: {BasePart},
	Constraint: HingeConstraint,
	Light: SpotLight,
	Sound: Sound,
	
	-- Functions
	_GetTintObjects: (self: self) -> {BasePart},
	_AdjustLensTransparency: (self: self, TransparencyValue: number) -> (),
	Deactivate: (self: self) -> (),
	Activate: (self: self) -> (),
}

export type Alarm = self

local instances: {[Model]: Alarm} = {}

--// Utility

function Alarm:_GetTintObjects(): {BasePart}
	local TintObjects: {BasePart} = {}
	
	for _, object in next, self.Object:GetDescendants() do
		if (object:IsA("BasePart") and object.Name == "Tint") then
			table.insert(TintObjects, object)
		end
	end
	
	return TintObjects
end

function Alarm:_AdjustLensTransparency(TransparencyValue: number)
	for _, tinted_glass in next, self.TintedLens do
		tinted_glass.Transparency = TransparencyValue or 0.5 -- Fail-Safe
	end
end

--// Constructor

function Alarm.new(Object: Model, SpinSpeed: number?, SoundId: string | number?): Alarm
	if (instances[Object]) then
		return instances[Object]
	end
	
	local self = setmetatable({}, Alarm)
	
	self.Object = Object
	self.PrimaryPart = Object.PrimaryPart
	self.Bulb = Object:FindFirstChild("Bulb")
	self.SpinSpeed = SpinSpeed or 10
	
	self.Constraint = self.PrimaryPart:FindFirstChild("HingeConstraint")
	self.Light = self.PrimaryPart:FindFirstChild("SpotLight")
	self.Sound = self.PrimaryPart:FindFirstChild("Sound")
	
	self.TintedLens = self:_GetTintObjects()
	
	if SoundId and typeof(SoundId) == "string" then
		self.Sound.SoundId = SoundId
	elseif SoundId and typeof(SoundId) == "number" then
		self.Sound.SoundId = "rbxassetid://" .. SoundId
	else
		warn("SoundId can only be string or number, received " .. typeof(SoundId))
	end
	
	instances[Object] = self
	return self
end

--// Class Methods

function Alarm:Activate()
	self.Constraint.MotorMaxAcceleration = 10
	self.Constraint.AngularVelocity = self.SpinSpeed
	self.Bulb.Material = Enum.Material.Neon
	self.Light.Enabled = true
	self.Sound:Play()
  
  self:_AdjustLensTransparency(0.5)
end

function Alarm:Deactivate()
	self.Constraint.MotorMaxAcceleration = 3
	self.Constraint.AngularVelocity = 0
	self.Bulb.Material = Enum.Material.SmoothPlastic
	self.Light.Enabled = false
	self.Sound:Stop()

  self:_AdjustLensTransparency(0.3)
end

--// Functions

function Alarm.GetAlarms(Object: Model, Tag: string): {Alarm}
  if (not Tag) then warn("No tag given in GetAlarms method") return end
	local Alarms = {}

	for _, alarm in next, Object:GetDescendants() do
		if CollectionService:HasTag(alarm, Tag) then
			local AlarmInstance: Alarm = Alarm.new(alarm)
			table.insert(Alarms, AlarmInstance)
		end
	end

	return Alarms
end

return Alarm
