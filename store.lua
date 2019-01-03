os.loadAPI("constants/states.lua")
os.loadAPI("extensions/tablex.lua")

function init(fileName)
  local state = {
    __privates = {
      current = states.idle
    },
    __subscriptions = {},
    __file_name = fileName
  }

  local state_meta = {
    __index = function(self, k)
      return rawget(self, "__privates")[k]
    end,
    __newindex = function(self, k, v)
      local privates = rawget(self, "__privates")
      local ov = privates[k]
      if v ~= ov then
        privates[k] = v
        local subscriptions = rawget(self, "__subscriptions")
        for k, f in pairs(subscriptions) do
          f(self, k, ov, v)
        end
      end
    end
  }

  setmetatable(state, state_meta)

  return state
end

function subscribe(store, k, f)
  local subscriptions = rawget(store, "__subscriptions")
  subscriptions[k] = f
end

function unsubscribe(store, k)
  local subscriptions = rawget(store, "__subscriptions")
  subscriptions = tablex.removeKey(subscriptions, k)
end

function loadState(store)
  local fileName = rawget(store, "__file_name")
  if fs.exists(fileName) then
    local file = fs.open(fileName, "r")
    local text = file.readAll()
    file.close()
    local loaded = textutils.unserialise(text)
    for k, v in pairs(loaded) do
      store[k] = v
    end
  end
end

function saveState(store)
  local fileName = rawget(store, "__file_name")
  local file = fs.open(fileName, "w")
  local privates = rawget(store, "__privates")
  file.write(textutils.serialise(privates))
  file.close()
end
