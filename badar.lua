--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
--* optional signal for input biding
local signal = require 'components.signal'
local badar = {
    x = 0,
    y = 0,
    height = 0,
    width = 0,
    parent = { x = 0, y = 0, visible = true },
    id = tostring(love.timer.getTime()),
    visible = true,
    children = {},
}
badar.__index = badar

function badar:new(t)
    assert(type(t) == "table", 'Badar; passed value must be a table.')
    return setmetatable(t, badar)
end

function badar.__add(self, component)
    if type(component) ~= "table" or component == nil then return end

    component.parent = self
    if self.column then
        component.y = self.height
        self.height = self.height + component.height + (self.gap or 0)
        self.width = math.max(self.width, component.width)
    end
    if self.row then
        component.x = self.width
        self.width = self.width + component.width + (self.gap or 0)
        self.height = math.max(self.height, component.height)
    end

    table.insert(self.children, component)
    return self
end

-- Remove child and its signals
function badar.__sub(self, component)
    if self % component.id then
        if component.onClickHandler then
            signal.click:remove(component.onClickHandler)
        end
        for index, child in ipairs(self.children) do
            if child.id == component.id then
                table.remove(self.children, index)
            end
        end
    end
    return self
end

-- Returns child with specific id
function badar.__mod(self, id)
    assert(type(id) == "string", 'Badar; Provided id must be a string.')
    for _, child in ipairs(self.children) do
        if child.id == id then
            return child
        end
    end
end

function badar:isMouseInside()
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= self.x + self.parent.x and mouseX <= self.x + self.parent.x + self.width and
        mouseY >= self.y + self.parent.y and
        mouseY <= self.y + self.parent.y + self.height
end

function badar:draw()
    if not self.visible then return end;
    if #self.children > 0 then
        for _, child in ipairs(self.children) do
            child:draw()
        end
    end
end

return setmetatable({ new = badar.new, draw = badar.draw }, {
    __call = function(t, ...)
        return badar:new(...)
    end,
})
