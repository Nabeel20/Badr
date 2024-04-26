# Button

[Button component](../../components/button.lua)

### Usage

```lua
function love.load()
    local button = require 'path.to.button.lua'
    myButton = button('Click Me!')
end
```

### `Button(string, {options})`

The second argument is button options :

- `icon` _love2d Image_ : `love.graphics.newImage(path)`
- `variation` _string_ :
  - `primary` is the default
  - `secondary`
  - `destructive`
  - `outline`
  - `ghost`
  - `icon`
- `disabled` _boolean_ : Check this value within `:onClick()` function
