# Checkbox

[Checkbox component](../../components/checkbox.lua)

### Usage

```lua
function love.load()
    local _check = checkbox('Checkbox', { value = true })
        :onValueChanged(function(value, txt)
            print(value, txt)
        end)
end
```

### `checkbox(string, options (table))`

Available options:

- `value` _boolean_ : you can pass the initial value of the checkbox.
- `disabled` _boolean_ : disable the checkbox and prevent mouse interaction.
- `color` _table_: colors the box and the text.

## `:onValueChange(fun(value, checkboxText) end)`

Can be used to apply changes very time checkbox status has changed.
