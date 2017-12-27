tool
extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const SPRITE_TEXTURE = preload("../sprites/Obstacle.png")

func _enter_tree():
    var child = get_child(0)
    if child && child extends Sprite:
        return

    var sprite = Sprite.new()
    sprite.set_texture(SPRITE_TEXTURE)
    add_child(sprite)

    sprite.set_owner(self)
