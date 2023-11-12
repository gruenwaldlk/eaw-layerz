---@class LayerManager
---*NOTE:* Functions prefixed with a double underscore (`__`) are considered private functions of the module. Call at your own risk.
LayerManager = {
    ---@type Configuration
    CONFIG = require("eaw-layerz/configuration"),
    ---@private
    ---@param self LayerManager
    ---@param game_object GameObject
    ---Hides a given `GameObject` reliably by calling `GameObjectWrapper::Hide(bool b)` twice.
    __hide_game_object = function(self, game_object)
        game_object.Hide(true)
        game_object.Hide(true)
    end,
    ---@private
    ---@param self LayerManager
    ---@param game_object GameObject
    ---@param spawns_fighters boolean
    ---Completely disables a given `GameObject`.
    __disable_game_object = function(self, game_object, spawns_fighters)
        local l_spawns_fighters = spawns_fighters or false
        if l_spawns_fighters then game_object.Set_Garrison_Spawn(false) end
        game_object.Make_Invulnerable(true)
        game_object.Set_Selectable(false)
        game_object.Prevent_All_Fire(true)
    end,
    ---@private
    ---@param self LayerManager
    ---@param game_object GameObject
    ---@param spawns_fighters boolean
    ---Completely re-enables a given `GameObject` that waas previously disabled by `LayerManager#__disable_game_object`
    ---@see LayerManager#__disable_game_object
    __enable_game_object = function(self, game_object, spawns_fighters)
        local l_spawns_fighters = spawns_fighters or false
        game_object.Make_Invulnerable(false)
        game_object.Set_Selectable(true)
        game_object.Prevent_All_Fire(false)
        game_object.Prevent_AI_Usage(false)
        if l_spawns_fighters then game_object.Set_Garrison_Spawn(true) end
    end,
    ---@private
    ---@param self LayerManager
    ---@param game_object GameObject
    __randomise_z_axis_coordinate = function(self, game_object)
        local l_position = game_object.Get_Position()
        local l_min, l_max = self:__resolve_layer(game_object)
        if l_min == l_max then return end
        local l_x0, l_x1, l_x2 = l_position.Get_XYZ()
        l_position = Create_Position(l_x0, l_x1, l_x2 + GameRandom(l_min, l_max))
        game_object.Teleport(l_position)
    end,
    ---@private
    ---@param self LayerManager
    ---@param game_object GameObject
    ---@return integer minimum
    ---@return integer maximum
    ---Returns the possible bones.
    __resolve_layer = function(self, game_object)
        for _, l_category_map in pairs(self.CONFIG.CATEGORY_MAP) do
            if game_object.Is_Category(l_category_map.ID) then
                return l_category_map.get_range()
            end
        end
        return self.CONFIG.CATEGORY_MAP.default()
    end,
    ---@param self LayerManager
    ---@param game_object GameObject
    ---@param spawns_fighters boolean
    ---Moves the units to a randomised Z-coordinate based on its category masks and the configurations made.
    ---@see Configuration
    update_unit_layer = function(self, game_object, spawns_fighters)
        if not spawns_fighters then spawns_fighters = false end
        self:__disable_game_object(game_object, spawns_fighters)
        game_object.Cancel_Hyperspace()
        self:__hide_game_object(game_object)
        self:__randomise_z_axis_coordinate(game_object)
        game_object.Cinematic_Hyperspace_In(1)
        self:__enable_game_object(game_object, spawns_fighters)
    end
}

return LayerManager
