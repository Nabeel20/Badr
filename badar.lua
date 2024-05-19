--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
local badar = function(obj)
    obj = obj or {}
    local self = {
        id = 'default',
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        _style = {
            color = { 1, 1, 1 },
            hoverColor = nil,
            padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
            corner = 0,
            opacity = 1,
            scale = 1,
            visible = true,
            borderWidth = 0,
            borderColor = { 0, 0, 0 }
        },
        children = {},
        globalPosition = { x = 0, y = 0 },
        passMouseEvent = true,
        layout = {},
    }
    for key, value in pairs(obj) do
        self[key] = value
    end

    --
    self.drawSelf       = function()
        local width = self.width
        local height = self.height
        local drawRectangle = function(mode)
            love.graphics.rectangle(
                mode,
                math.round(-width / 2),
                math.round(-height / 2),
                math.round(width),
                math.round(height),
                self._style.corner,
                self._style.corner
            )
        end
        love.graphics.push()
        love.graphics.translate(math.round(self.x + width / 2), math.round(self.y + height / 2))
        love.graphics.scale(self._style.scale, self._style.scale)
        drawRectangle('fill')

        -- drawing border
        if self._style.borderWidth > 0 then
            love.graphics.setColor(self._style.borderColor)
            love.graphics.setLineWidth(self._style.borderWidth)
            drawRectangle('line')
            love.graphics.setLineWidth(1)
        end
        love.graphics.pop()
    end
    self.draw           = function()
        if not self._style.visible then
            return function()
                return self
            end
        end

        local color = self._style.color
        if self.hovered and self._style.hoverColor then
            color = self._style.hoverColor
        end
        if color ~= nil then
            love.graphics.setColor({
                color[1],
                color[2],
                color[3],
                self._style.opacity
            })
        end
        self:drawSelf()

        return function()
            love.graphics.push()
            love.graphics.translate(
                math.round(self.x + self._style.padding[4]),
                math.round(self.y + self._style.padding[1]))
            local sW, sH = love.graphics.getWidth(), love.graphics.getHeight()
            self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(sW, sH)
            self.globalPosition.x = math.round(sW - self.globalPosition.x) - self._style.padding[4]
            self.globalPosition.y = math.round(sH - self.globalPosition.y) - self._style.padding[1]
            for _, child in ipairs(self.children) do
                child:draw()()
            end
            love.graphics.pop()

            return self
        end
    end
    self.render         = function()
        self.update()
        self.draw()()
    end

    --
    self.style          = function(style)
        for key, value in pairs(style) do
            self._style[key] = value
        end
        self.width  = self.width + self._style.padding[2] + self._style.padding[4]
        self.height = self.height + self._style.padding[1] + self._style.padding[3]
        return self
    end
    self.content        = function(func)
        assert(type(self.children) == 'table', 'Badar; content function must return a table with children.')
        self.children = func(self)
        -- register all definition to use later
        self.snapshot = func
        for _, child in ipairs(self.children) do
            table.spread(self.children, child)
        end
        return self
    end

    --
    self.update         = function()
        if type(self.onUpdateFunction) == "function" then
            self:onUpdateFunction()
        end
        for _, child in ipairs(self.children) do
            child.update()
        end
        return self
    end
    self.onUpdate       = function(func)
        self.onUpdateFunction = func
        return self
    end

    --
    self.mousereleased  = function()
        if not self.passMouseEvent then return end;
        if self.pressed and type(self.onMouseRealease_function) == "function" then
            self:onMouseRealease_function()
            self.pressed = false
        end

        self.pressed = false
        for _, child in ipairs(self.children) do
            child.mousereleased()
        end
    end
    self.onMouseRelease = function(func)
        self.onMouseRealease_function = func;
        return self;
    end

    -- utilities
    self.modify         = function(func)
        func(self);
        return self;
    end
    self.find           = function(target)
        if self.id == target then
            return self
        end

        for _, child in ipairs(self.children or {}) do
            local result = child.find(target)
            if result ~= nil then
                return result
            end
        end

        return nil
    end
    self.addChild       = function(child)
        table.insert(self.children, child)
        return self;
    end
    self.removeChild    = function(c)
        for index, child in ipairs(self.children) do
            if child == c then
                table.remove(self.children, index)
                break
            end
        end
    end
    self.isMouseInside  = function()
        local getRect = function()
            return {
                self.globalPosition.x,
                self.globalPosition.y,
                math.round(self.globalPosition.x + self.width),
                math.round(self.globalPosition.y + self.height)
            }
        end
        local px, py = love.mouse.getX(), love.mouse.getY()
        local rect = getRect()

        local x, y, width, height = rect[1], rect[2], rect[3], rect[4]
        return px >= x and px <= width and py >= y and py <= height
    end

    --
    self.mousemoved     = function()
        if not self.passMouseEvent then return end;
        if self.isMouseInside() then
            self.hovered = true
            if type(self.onEnter) == "function" then
                self.onEnter(self)
            end
            self.mouseEntered = true
        else
            self.hovered = false
            if self.mouseEntered then
                if type(self.onExit) == "function" then
                    self.onExit(self)
                end
                self.mouseEntered = false
            end
        end
        for _, child in ipairs(self.children) do
            child.mousemoved()
        end
    end
    self.onHover        = function(hoverLogic)
        for key, value in pairs(hoverLogic) do
            self[key] = value
        end
        return self;
    end

    --
    self.onClick        = function(func)
        self.onClickFun = func
        return self
    end
    self.onRightClick   = function(func)
        self.onRClickFun = func
        return self
    end
    self.mousepressed   = function(mouseButton)
        if not self.passMouseEvent then return end;
        if self.isMouseInside() then
            if mouseButton == 1 and self.onClickFun then
                self:onClickFun()
                self.pressed = true
            elseif mouseButton == 2 and self.onRclickFunc then
                self:onRclickFunc()
                self.pressed = true
            end
        end

        for _, child in ipairs(self.children) do
            child.mousepressed(mouseButton)
        end
    end

    --
    self.resize         = function(w, h)
        self.width = w
        self.height = h
        if self.snapshot then
            self.content(self.snapshot)
        end
    end

    return self
end

function math.round(num) return math.floor(num + .5) end

function table.spread(t1, t2)
    for key, value in pairs(t2) do
        t1[key] = value
    end
    return t1
end

return badar
