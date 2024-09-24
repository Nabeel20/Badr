local template = {}
template.__index = template
function template.new()
    return setmetatable({}, template)
end

function template:add(item)
    table.insert(self, item)
end

function template:remove(item)
    for index, value in ipairs(self) do
        if value == item then
            table.remove(self, index)
        end
    end
end

function template:emit(...)
    for _, item in ipairs(self) do
        item(...)
    end
end

local signal = {
    click = template:new(),
    keyPress = template:new(),
}

return signal
