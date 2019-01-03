function removeKey(t, k)
  local i = 0
  local keys, values = {}, {}
  for k, v in pairs(t) do
    i = i + 1
    keys[i] = k
    values[i] = v
  end

  while i > 0 do
    if keys[i] == k then
      table.remove(keys, i)
      table.remove(values, i)
      break
    end
    i = i - 1
  end

  local a = {}
  for i = 1, #keys do
    a[keys[i]] = values[i]
  end

  return a
end

function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end