tool
extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const IsoGrid = preload("grid.gd")
var grid

func _enter_tree():
    var child = get_child(0)
    if child && child extends TileMap:
        return

    grid = IsoGrid.new()
    grid.set_name("Grid")
    add_child(grid)
    grid.set_owner(self)

    #Avoid the 'YSort 2' default name
    grid.add_children(self, "YSorter")