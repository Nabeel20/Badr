# Tooltip

A popup that displays information related to an element when the element receives keyboard focus or the mouse hovers over it. (radix UI definition). <br>
Use `:onHover()` to show your tooltip component.

### Usage

```lua
local buttonStyle = {
    padding = { 8, 12, 8, 12 },
    hoverEnabled = true,
    opacity = 1,
    color = {1,0,0},
    corner = 4
}
function love.load()
    local container = require 'path.to.badar.lua'
    local text = require 'path.to.text.lua'

    container_with_tooltip = container()
        :style(buttonStyle)
        :content({
            text('Hover me!'),
        })
        :onHover({
            onEnter = function(i)
                local _tooltip = i:find('tooltip')
                if not _tooltip then
                    i.children[#i.children + 1] = text('Hover', { id = 'tooltip' })
                else
                    _tooltip.x = math.floor(love.mouse.getX() - i.globalPosition.x + 15)
                    _tooltip.y = math.floor(love.mouse.getY() - i.globalPosition.y + 15)
                end
            end,
            onExit = function(i)
                for k, v in ipairs(i.children) do
                    if v.id == 'tooltip' then
                        table.remove(i.children, k)
                        break
                    end
                end
            end
        })
end

function love.draw()
    container_with_tooltip:render()
end

function love.mousemoved(x, y, dx, dy)
    container_with_tooltip:mousemoved()
end
```

#### Todo

- [ ] add delay
