require("state.lua")
require("constants/states.lua")

local function onStateChange(state, k, ov, v)
  print("State changed. New value of " .. k .. "=" .. v)
end

state.subscribe("main", onStateChange)

state.current = states.digging