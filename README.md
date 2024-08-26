# Badar 🌕

Badar _(Full moon in Arabic)_ provides a simple and easy way to write UI. <br/>
All you need is your `draw` function and your `input` binding. Badar provides a simple `column` and `row` layouts.

### Usage

```lua
function love.load()
    love.graphics.setBackgroundColor({ 1, 1, 1 })
    local label = require 'components.label'
    local button = require 'components.button'
    menu = require 'components.menu'

    local counter = label('0')
    menu = menu
        + counter
        + label {
            text = 'Doubled: 0',
            id = 'awesome'
        }
        + label 'Badar'
        + label 'Love2d :D'
        + button {
            text = 'Click me!',
            --
            onClick = function(self)
                counter.text = counter.text + 1
                -- get child index by id
                menu.children[menu % 'awesome'].text = 'Doubled: ' .. counter.text * 2
            end
        }
end

function love.draw()
    menu:draw()
end
```

### Functions

- `component = component + child`
- `component = component - child`
- `component % id (string)` return child index
- `:isMouseInside()`

> [!CAUTION]
> Input binding is not included check `__add` and `__sub` functions in `badar.lua`.

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
