# Slider

[Slider component](../../components/slider.lua)

### Usage

```lua
function love.load()
    local button = require 'path.to.slider.lua'
    mySlider = slider({ defaultValue = 10, step = 10, width = 100 })
        :onValueChange(function(o)
            print(o)
        end)
end
```

### `slider(options)`

- `id` _string_ : identify your slider with unique id, use with `:find(id)`.
- `defaultValue` _number_ : starting value. Default is `0`.
- `step` _number_ : The stepping interval. Default is `1`.
- `width` _number_: Component's width and `max` value.
- `trackColor` _table_

### `:onValueChange(fn)`

Emitted every time slider value has changed.
