local column = function(children, parent, layout)
    layout = layout or {}
    local padding = {
        horizontal = parent._style.padding[2] + parent._style.padding[4],
        vertical = parent._style.padding[1] + parent._style.padding[3]
    }
    local offset = 0
    for _, child in ipairs(children) do
        child.y = offset;
        offset = offset + child.height + (layout.gap or 0)

        local alignment = {
            ['start'] = 0,
            ['center'] = math.round((parent.height - padding.horizontal - child.width) / 2),
            ['end'] = math.round(parent.height - padding.horizontal - child.height)
        }
        child.x = alignment[layout.alignment or 'start']

        if child.alignSelf == 'end' then
            child.y = math.round(parent.height - child.height - padding.vertical)
        end
        if child.alignSelf == 'center' then
            child.y = math.round((parent.height - child.height - padding.horizontal) / 2)
        end
    end
end

return column
