# eaw-layerz

A full reimplementation of the layer-z script as originally developed by Small_Pox and Kad_Venku.
This script module allows space ships of the same `GameObjectType` to appear at randomised heights.

## Requirements

----

⚠️⚠️⚠️⚠️ **THIS LUA MODULE REQUIRES THE LATEST VERSION OF EMPIRE AT WAR ON STEAM** ⚠️⚠️⚠️⚠️    
This module exclusively works with the latest version of Empire at War on Steam.    
It does **not** work with any other version of Empire at War (Disc, gog.com, Origin).    
There wil be **no support** for these versions.

----

This download includes a pre-packaged LUA-module that has to be dropped into the data folder of your mod.  
the module consists of a library module (`scripts/library/eaw-layerz/layermanager.lua`) and a configuration module (`scripts/library/eaw-layerz/configuration.lua`).

## Installation

Extract the archive and overwrite `scripts/` directory of your mod with the library plugin. This should result in the following directory structure:

```txt
mymod
└───data
    └───scripts
        └───library
            └───eaw-layerz
                    configuration.lua
                    layermanager.lua
```

## Usage

The script uses a unit's category flags to determine its height range, as those usually match the pathfinding layer. Soi an object using the pathfinding layer `Corvette` is usually flagged with the `GameObject` category `Corvette`.

### Step 1: Configuration

The configuration module (`scripts/library/eaw-layerz/configuration.lua`) is the only file you should ever have to adjust for your own mod. Any modification to the module beyond that is not officially supported and performed at your own risk.

#### The `CATEGORY_MAP` List

This list holds a range of anonymous objects describing a `GameObject` category and its associated offset range:

```lua
{
    ID = "GameObjectCategory",
    get_range = function() return 0, 0 end
}
```

The `ID` property holds the name of a `GameObject` category as defined in `data/xml/enum/gameobjectcategorytype.xml`. You may only have **one** entry per `GameObject` category, in other words, the `ID` property has to be unique.

The function `get_range()` returns a tuple of the minimum offset and the maximum offset for that given `GameObject` category.

##### Examples

If you want to offset the `GameObject` category `Corvette` by up to 50 alamo units in positive Z direction you would define the following entry:

```lua
{
    ID = "Corvette",
    get_range = function() return 0, 50 end
}
```

If you want to offset the `GameObject` category `Corvette` by up to 50 alamo units in negative Z direction you would define the following entry:

```lua
{
    ID = "Corvette",
    get_range = function() return -50, 0 end
}
```

If you want to offset the `GameObject` category `Corvette` by up to 50 alamo units in either Z direction you would define the following entry:

```lua
{
    ID = "Corvette",
    get_range = function() return -50, 50 end
}
```
### Step 2: Including the Module in any `GameObjectScript`

Once set up, using the script is straightforward and only requires you to add two lines to an existing object script: the assignment of the layer manager to a variable and a subsequent call to `update_unit_layer()`.

#### Minimal Example

```lua
require("PGStateMachine")

function Definitions()
    ServiceRate = 1
    Define_State("State_Init", State_Init)

    layer_manager = require("eaw-layerz/layermanager")
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Space" then
            ScriptExit()
        end
        layer_manager:update_unit_layer(Object)
    end
end
```

## API Documentation

The `LayerManager` exposes one function with an optional overload.   
**NOTE:** Functions prefixed with a double underscore (`__my_function()`) are considered private functions of the module and may not be called from an external script requiring the `eaw-layerz/layermanager` module.

### `LayerManager.update_unit_layer(self: LayerManager, game_object: GameObject)`

The default invocation. It randomizes a unit's z-offset from its defined `Layer_Z_Adjust` by agiven range.

### `LayerManager.update_unit_layer(self: LayerManager, game_object: GameObject, spawns_fighters: boolean)`

Overload. You may set `spawns_fighters` to `true` if a unit has the `SPAWN_SQUADRON` space behaviour to prevent fighters spawning during the hyerspace phase. Calling the function with `spawns_fighters` set to `false` is equivalent to calling the function without the parameter.

## Known Issues

2023-11-12: None

## Changelog

### 2023-11-12 - v1.0.1
* [#1] Fixes an issue where the AI would ignore pop cap limits with the module enabled.

### 2021-01-17 - v1.0.0
* Intial release.
