os.loadAPI("store.lua")
os.loadAPI("constants/states.lua")

local mainStore = store.init("state.dat")

local onStateChange = function(state, k, ov, v)
  print("State changed. New value of " .. k .. "=" .. v)
end

store.subscribe(mainStore, "main", onStateChange)

mainStore.test = "hey"

store.saveState(mainStore)
print("Store saved")

mainStore.current = states.digging

print("Restoring state")
store.loadState(mainStore)
