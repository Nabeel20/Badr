## Callback functions

Theses functions can be used to pass events to container to handle it. Add what you need, only render is mandatory.

### `:render()`

This function calls the `draw` function for the container and all of its children.
Should be called within `love.draw` function.

### `:mousepressed(button (num))`

Passes the mouse event to container to handle it. Should be used within `love.mousepressed()` function.

### `:mousemoved()`

Passes mouse movement events to container, it is used for 'hover' checking and hover related logic. Should be called within `love.mousemoved()` function.

### `:mousereleased()`
