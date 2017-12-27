tool
extends EditorPlugin

# class member variables go here, for example:
# var a = 2
var node_name = "IsometricGrid"

func _enter_tree():
    # Initialization of the plugin goes here
    # Add the new type with a name, a parent type, a script and an icon
    add_custom_type(node_name, "TileMap", preload("grid.gd"), preload("../icons/icon.png"))
    add_custom_type("IsometricRoot", "Node2D", preload("root_node.gd"), preload("../icons/icon.png"))
    add_custom_type("IsometricPlayer", "KinematicBody2D", preload("player.gd"), preload("../icons/player.png"))
    add_custom_type("IsometricObstacle", "Node2D", preload("obstacle.gd"), preload("../icons/obstacle.png"))

func _exit_tree():
    remove_custom_type(node_name)
    remove_custom_type("IsometricRoot")
    remove_custom_type("IsometricPlayer")
    remove_custom_type("IsometricObstacle")
    