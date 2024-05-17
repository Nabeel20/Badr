local row = function(children, parent, layout)
    layout = layout or {}
    local padding = {
        horizontal = parent._style.padding[2] + parent._style.padding[4],
        vertical = parent._style.padding[1] + parent._style.padding[3]
    }
    local offset = 0
    for _, child in ipairs(children) do
        if child.position ~= 'absolute' then
            child.x = offset;
            offset = offset + child.width + (layout.gap or 0)

            local alignment = {
                ['start'] = 0,
                ['center'] = math.round((parent.height - padding.vertical - child.height) / 2),
                ['end'] = math.round(parent.height - padding.vertical - child.height)
            }
            child.y = alignment[layout.alignment or 'start'];

            if child.alignSelf == 'end' then
                child.x = math.round(parent.width - child.width - padding.horizontal)
            end
            if child.alignSelf == 'center' then
                child.x = math.round((parent.width - child.width - padding.horizontal) / 2)
            end
        end
    end

    return children
end

return row
