# Badar 🌕

Badar _(Full moon in Arabic)_ is a simple and fun way to write UI, prioritizing both _**developer experience**_ and _**readability**_.<br/>

### Usage

Copy [badar.lua](badar.lua) to your project for basic functionality and [signal.lua](components/signal.lua) for basic input handling. <br/>
For a functional example see: [example.lua](components/example.lua)

```lua
function love.load()
    -- ...
    local counter = label('0')
    menu = menu
        + counter
        + label { text = 'Doubled: 0', id = 'awesome' }
        + label 'Hello, World!'
        + button {
            text = 'Click me!',
            onClick = function(self)
                counter.text = counter.text + 1
                -- get child by id
                (self.parent % 'awesome').text = 'Doubled: ' .. counter.text * 2
            end
        }
end

function love.draw()
    menu:draw()
end
```

### Functions

- Creating a `new` component. Default props are (`x`,`y`,`width`,`height`, `parent`, `id`, `column`, `row`, `gap`). For inspiration see [components](components).

  ```lua
  local component = require 'badar'
  local button = component({
    x = 10,
    y = 10,
    --
    myCustomProp = true,   -- define your props
    --
    column = true,         -- basic column / row layout (optional)
    gap = 10,
    draw = function(self) love.graphics.print('Button', self.x, self.y) end, -- don't forget to call
    onClick = function(self) self.x = self.x + 10 end,
  })
  ```

- `component = component + child`

  Adds the child to its parent’s children table and manages its input and position.

- `component = component - child`

  Removes the child from its parent’s children table, and removes its input binding.

- `component % id (string)`:

  Returns child by id in its parent children list. Useful for modifying children within the same parent.

  ```lua
  (parent % id).value = newValue
  ```

- `:isMouseInside()`

> [!NOTE]
> Badar uses `signal.lua` for input-binding by default. Feel free to use your own methods (eg. update `__add` and `__sub` in `badar.lua`).

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
