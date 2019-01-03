require("constants/states.lua")
require("extensions/table.lua")

local DEFAULT_FILE_NAME = "state.dat"

local state = {
  __privates = {
    current = states.idle
  },
  __subscriptions = {},
  subscribe = function(k, f)
    __subscriptions[k] = f
  end,
  unsubscribe = function(k)
    __subscriptions = table.removeKey(__subscriptions, k)
  end,
  __on_change = function(self, k, ov, v)
    for k, f in pairs(__subscriptions) do
      f(self, k, ov, v)
    end
  end
}

local state_meta = {
  __index = function(self, k)
    return rawget(self, "__privates")[k]
  end,
  __newIndex = function(self, k, v)
    local privates = rawget(self, "__privates")
    local ov = privates[k]
    privates[k] = v
    rawget(self, "__on_change")(self, k, ov, v)
  end
}

function state.loadState(fileName)
  fileName = fileName or DEFAULT_FILE_NAME
  if fs.exists(fileName) then
    local file = fs.open(filename)
    local text = file.readAll()
    file.close()
    local loaded = textutils.unserialise(text)
    for k, v in pairs(loaded) do
      self[k] = v
    end
  end
end

function state.saveState(fileName)
  fileName = fileName or DEFAULT_FILE_NAME
  local file = fs.open(filename, w)
  fs.write(textutils.serialise(__privates))
  file.close()
end

setmetatable(state, state_meta)

return state
