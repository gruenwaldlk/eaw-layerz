---@class Configuration
Configuration = {
    ---@type table<string,function>[]
    ---A map of anonymous objects that define the mapping between the category mask and (a subset of) bones of the `LAYER_DUMMY_TYPE`.
    CATEGORY_MAP = {
        {
            ---@type string
            ID = "Corvette",
            ---@return integer l_min minimum offset
            ---@return integer l_max maximum offset
            ---**TODO:** Update to desired range.
            get_range = function() return 0, 0 end
        },
        {
            -- @type string
            ID = "Frigate",
            ---@return integer l_min minimum offset
            ---@return integer l_max maximum offset
            ---**TODO:** Update to desired range.
            get_range = function() return 0, 0 end

        },
        {
            -- @type string
            ID = "Capital",
            ---@return integer l_min minimum offset
            ---@return integer l_max maximum offset
            ---**TODO:** Update to desired range.
            get_range = function() return 0, 0 end

        },
        ---@return integer l_min minimum offset
        ---@return integer l_max maximum offset
        ---**TODO:** Update to desired range.
        default = function() return 0, 0 end
    }
}

return Configuration
