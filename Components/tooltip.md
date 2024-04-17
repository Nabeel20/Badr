# Tooltip

A popup that displays information related to an element when the element receives keyboard focus or the mouse hovers over it. (radix UI definition). <br>
Using `:onHover(func)` you can pass your drawing logic and add text, shapes or images.

### Usage

```lua
function love.load()
    container_with_tooltip = container({ width = 15, height = 25}):onHover(function(i)
        -- text
        -- i is container props
        love.graphics.print('My tooltip', i.x, i.y)
    end)
end

function love.draw()

end
```

#### Todo

- [ ] add delay
