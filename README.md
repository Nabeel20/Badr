# Badar 🌕

Badar _(Full moon in Arabic)_ is a simple and fun way to write UI, prioritizing both _**developer experience**_ and _**readability**_.<br/>

### Usage

Copy [badar.lua](badar.lua) to your project for basic functionality _and_ [signal.lua](components/signal.lua) for signals handling. <br/>
🌙 For a **_functional_** example see: [example.lua](components/example.lua)

```lua
function love.load()
    local menu = component { column = true, gap = 10 }
        + label 'Hello, World!'
        + label { text = 'love2d', id = '#2' }
        + button {
            text = 'Click me!',
            onClick = function(self)
                -- get child by id
                (self.parent % '#2').text = 'awesome'
            end
        }
end
```

### Functions

- Creating a `new` component. `column (boolean)` & `row (boolean)` and `gap (number)` are used for basic layout calculations. For inspiration see [components](components).

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

  Adds the child to its parent’s children table and register its signals.

- `component = component - child`

  Removes the child from its parent’s children table, and unregister its signals.

- `component % id (string)`:

  Returns child by id in its parent children list. Useful for modifying children within the same parent.

  ```lua
  (parent % id).value = newValue
  ```

- `:isMouseInside()`

> [!NOTE]
> Badar uses `signal.lua` by default. Feel free to use your own methods (eg. update `__add` and `__sub` in badar.lua).

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
