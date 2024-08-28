--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
local badar = {
    x = 0,
    y = 0,
    height = 0,
    width = 0,
    parent = { x = 0, y = 0 },
    id = love.timer.getTime(),
    children = {}
}
badar.__index = badar

function badar:new(t)
    assert(type(t) == "table", 'Badar; passed value must be a table.')
    return setmetatable(t, badar)
end

function badar.__add(self, component)
    if type(component) ~= "table" or component == nil then return end

    -- Input binding
    if component.onClick ~= nil then
        -- signal.click:add(function(button)
        --     if component:isMouseInside() and button == 1 then
        --         component:onClick()
        --     end
        -- end)
    end
    -- child position realative to its parent
    component.parent = self
    if self.column then component.y = self.height end
    if self.row then component.x = self.width end
    self.height = self.height + component.height + (self.gap or 0)
    self.width = self.width + component.width + (self.gap or 0)

    table.insert(self.children, component)
    return self
end

-- Remove child of children and its signals
function badar.__sub(self, component)
    for index, child in ipairs(self.children) do
        if component == child then
            -- unbinding input values
            if type(component.onClick) == "function" then
                -- signal.click:remove(component.onClick)
            end
            table.remove(self.children, index)
            break
        end
    end
    return self
end

-- return the index of child in parent's children list
function badar.__mod(self, id)
    for index, child in ipairs(self.children) do
        if child.id == id then
            return index
        end
    end
end

function badar:isMouseInside()
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= self.x + self.parent.x and mouseX <= self.x + self.parent.x + self.width and
        mouseY >= self.y + self.parent.y and
        mouseY <= self.y + self.parent.y + self.height
end

return setmetatable({ new = badar.new }, {
    __call = function(t, ...)
        return badar:new(...)
    end,
})
