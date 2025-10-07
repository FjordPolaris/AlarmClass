# AlarmClass
An open source OOP spinning alarm class in Roblox for anyone to use

## API
- `?` = Optional parameter
- `|` = Union type
- `->` = Function's return type
- `-> {Something}` = Returns a table of Seomthing

**Class Functions**
- `.new(Object: Model, SpinSpeed: number?, SoundId: string | number?) -> Alarm`
- `.GetAlarms(Object: Model, Tag: string?) -> {Alarm}`

**Class Methods**
- `:Deactivate`
- `:Activate`

## Model Hierarchy
AlarmObject:
- SpinningPart (PrimaryPart)
  - HingeConstraint
  - SpotLight
  - Sound
- Bulb (neon part)
- Tint (can have multiple)

## Usage
```luau
local AlarmClass = require(path_to_AlarmClass)

--// Import type
type Alarm = AlarmClass.Alarm

--// Create object
local myAlarm: Alarm = AlarmClass.new(path_to_alarm_model)
```

## Contacts
- Discrd: autumn_fj
- Server: https://discord.gg/6GqJvn7Wa2
