--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
badar = Object:extend()


function badar:new(obj)
    obj = obj or {}
    self.id = obj.id or 'default id'
    self.x = obj.x or 0
    self.y = obj.y or 0
    self.width = obj.width or 0
    self.height = obj.height or 0
    self.minWidth = obj.minWidth or 0
    self.minHeight = obj.minHeight or 0

    self._style = {
        color = { 1, 1, 1 },
        padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
        hoverEnabled = false,
        corner = 0,
        opacity = 1, -- set to zero to hide border
        filled = false,
        scale = 1,
        visible = true,
        borderWidth = 1,
    }
    self.gap = 0;
    self.hideBorder = obj.hideBorder or false;
    if self.hideBorder then
        self._style.opacity = 0
    end
    self.hovered = false
    self.globalPosition = { x = 0, y = 0 }

    self.clickFunc = obj.onClick or function() end;
    self.hover = obj.hover or {
        onEnter = function(s) end,
        onExit = function(s) end
    }
    self.mouseReleaseFunc = function() end;
    self.updateLogic = function() end;
    self.drawFunc = function()
        local drawMode = (self.hovered and self._style.hoverEnabled) and 'fill' or 'line'
        if (self._style.filled) then drawMode = 'fill' end
        love.graphics.rectangle(
            drawMode,
            self.x,
            self.y,
            self.width,
            self.height,
            self._style.corner,
            self._style.corner
        )
    end
    self.children = obj.children or {}
    self.data = obj.data or nil
    self.pressed = false
    return self
end

function badar:draw()
    if not self._style.visible then
        return function()
            return self
        end
    end

    love.graphics.push()
    love.graphics.scale(self._style.scale)
    love.graphics.setColor({
        self._style.color[1],
        self._style.color[2],
        self._style.color[3],
        self._style.opacity
    })
    love.graphics.setLineWidth(self._style.borderWidth)
    self.drawFunc()
    love.graphics.pop()

    return function()
        love.graphics.push()
        love.graphics.translate(math.floor(self.x + self._style.padding[4]), math.floor(self.y + self._style.padding[1]))
        local sW, sH = love.graphics.getWidth(), love.graphics.getHeight()
        self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(sW, sH)
        self.globalPosition.x = sW - self.globalPosition.x
        self.globalPosition.y = sH - self.globalPosition.y

        for _, child in ipairs(self.children) do
            child:draw()()
        end

        love.graphics.pop()
        return self
    end
end

function badar:content(content)
    self.children = content;
    self.width = self:calculateLayout().computedWidth
    self.height = self:calculateLayout().computedHeight
    return self;
end

function badar:onHover(hoverLogic)
    for key, value in pairs(hoverLogic) do
        self.hover[key] = value
    end
    return self
end

function badar:onClick(func, mouseButton)
    self.clickFunc = func
    self.mouseButton = mouseButton or 1
    self._style.hoverEnabled = true
    self.pressed = true
    return self
end

function badar:getRect()
    return {
        self.globalPosition.x - self._style.padding[4],
        self.globalPosition.y - self._style.padding[1],
        (self.globalPosition.x + self.width - self._style.padding[2]) * self._style.scale,
        (self.globalPosition.y + self.height - self._style.padding[3]) * self._style.scale
    }
end

function badar:render()
    return self:draw()()
end

function badar:modify(func)
    func(self)
    return self
end

function badar:isMouseInside()
    local px, py = love.mouse.getX(), love.mouse.getY()
    local rect = self:getRect()

    local x, y, width, height = rect[1], rect[2], rect[3], rect[4]
    return px >= x and px <= width and py >= y and py <= height
end

function badar:mousepressed(button)
    if self:isMouseInside() and button == self.mouseButton then
        self:clickFunc()
    end
    for _, child in ipairs(self.children) do
        child:mousepressed(button)
    end
end

function badar:layout(obj)
    self.direction = obj.direction or nil
    self.gap       = obj.gap or 0;
    self.alignment = obj.alignment or nil;
    self.justify   = obj.justify or nil;
    self.centered  = obj.centered or false;
    local offset   = 0;
    local layout   = self:calculateLayout()
    local widest   = layout.widest + layout.padding.horizontal
    local highest  = layout.highest + layout.padding.vertical
    self.width     = layout.computedWidth;
    self.height    = layout.computedHeight;


    if #self.children == 0 then return self end
    local function center(child)
        if #self.children > 1 then
            print('ERROR: Badar. centered container must have only one child.')
        end
        child.x = (self.width - child.width - layout.padding.horizontal) / 2
        child.y = (self.height - child.height - layout.padding.vertical) / 2
    end

    local function row(child)
        child.x = offset;
        offset = offset + child.width + self.gap
        -- alignment
        if child.height ~= highest then
            if self.alignment == 'center' then
                child.y = (highest - child.height - layout.padding.vertical) / 2
            end
            if self.alignment == 'end' then
                child.y = highest - child.height - layout.padding.vertical
            end
        end
    end

    local function column(child)
        child.y = offset;
        offset = offset + child.height + self.gap
        --alignment
        if child.width ~= widest then
            if self.alignment == 'center' then
                child.x = (widest - child.width - layout.padding.horizontal) / 2
            end
            if self.alignment == 'end' then
                child.x = widest - child.width - layout.padding.horizontal
            end
        end
    end



    for _, child in ipairs(self.children) do
        if self.centered then center(child) end
        if self.direction == 'row' then row(child) end
        if self.direction == 'column' then column(child) end
        if child.justify == 'end' then
            if self.direction == 'row' then
                child.x = self.width - child.width - layout.padding.horizontal;
            end
            if self.direction == 'column' then
                child.y = self.height - child.height - layout.padding.vertical;
            end
        end
        if child.justify == 'center' then
            child.x = (self.width - child.width) / 2 - layout.padding.horizontal
            child.y = (self.height - child.height) / 2 - layout.padding.vertical
        end
    end

    if self.direction == 'row' then
        self.height = math.max(highest, self.minHeight)
    end
    if self.direction == 'column' then
        self.width = math.max(widest, self.minWidth)
    end
    return self
end

function badar:calculateLayout()
    local totalWidth, totalHeight, widest, highest = 0, 0, 0, 0
    for _, child in ipairs(self.children) do
        totalWidth = totalWidth + child.width;
        totalHeight = totalHeight + child.height
        highest = math.max(child.height, highest)
        widest = math.max(child.width, widest)
    end

    local hPadding = self._style.padding[4] + self._style.padding[2]
    local vPadding = self._style.padding[1] + self._style.padding[3]
    local gap = self.gap * (#self.children - 1)


    local contentWidth = (totalWidth + hPadding + gap) * self._style.scale;
    local contentHeight = (totalHeight + vPadding + gap) * self._style.scale

    local minimumWidth = math.max(contentWidth, self.minWidth)
    local minimumHeight = math.max(contentHeight, self.minHeight)


    return {
        highest = highest,
        widest = widest,
        padding = {
            horizontal = hPadding,
            vertical = vPadding
        },
        gap = gap,
        contentWidth = contentWidth,
        contentHeight = contentHeight,
        computedWidth = math.max(minimumWidth, self.width),
        computedHeight = math.max(minimumHeight, self.height)
    }
end

function badar:style(style)
    for key, value in pairs(style) do
        self._style[key] = value
    end
    return self
end

function badar:find(target)
    if self == nil then
        return nil
    end

    if self.id == target then
        return self
    end

    for i, child in ipairs(self.children or {}) do
        local result = child:find(target)
        if result ~= nil then
            return result
        end
    end

    return nil
end

function badar:mousemoved()
    if self:isMouseInside() then
        self.hovered = true
        self.hover.onEnter(self)
        self.mouseEntered = true
    else
        self.hovered = false
        if self.mouseEntered then
            self.hover.onExit(self)
            self.mouseEntered = false
        end
    end
    for _, child in ipairs(self.children) do
        child:mousemoved()
    end
end

function badar:mousereleased()
    if self.pressed then
        self:mouseReleaseFunc()
    end
    for _, child in ipairs(self.children) do
        child:mousereleased()
    end
end

function badar:onMouseRelease(func)
    self.mouseReleaseFunc = func
    return self
end

function badar:onUpdate(func)
    self.updateLogic = func
    return self
end

function badar:update()
    self:updateLogic()
    for _, child in ipairs(self.children) do
        child:update()
    end
end

return badar
