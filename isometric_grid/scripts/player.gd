# Compared to the grid example (final/06), only a few lines changed
# The Grid (TileMap) node supports isometric projection out of the box, 
# but we still have to calculate isometric motion by ourselves.
# The player has a cartesian_to_isometric method that converts the coordinates,
# explained in details in the Intro to Isometric Worlds tutorial (https://youtu.be/KvSjJ-kdGio)
tool
extends KinematicBody2D

const IsoGrid = preload("grid.gd")
const SPRITE_TEXTURE = preload("../sprites/Player.png")

export var max_speed = 1200

var direction = Vector2()
var speed = 0
var motion = Vector2()

var target_pos = Vector2()
var target_direction = Vector2()
var is_moving = false

var type
var grid

var sprite

func _enter_tree():
	var children = get_children()
	children.size()

	if children.size() == 0:
		var target_visualizer = Node2D.new()
		add_child(target_visualizer)
		target_visualizer.set_name("TargetVisualizer")
		target_visualizer.set_script(preload("player_visualizer.gd"))
		target_visualizer.set_owner(self)

		sprite = Sprite.new()
		sprite.set_texture(SPRITE_TEXTURE)
		add_child(sprite)
		sprite.set_owner(self)

func _ready():
	# The Player is now a child of the YSort node, so we have to go 1 more step up the node tree
	grid = get_parent().get_parent()
	if grid && grid extends IsoGrid:
		type = grid.PLAYER
	set_fixed_process(true)


func _fixed_process(delta):
	direction = Vector2()
	speed = 0
	var pos = get_pos()

	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1

	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1

	if not is_moving and direction != Vector2():
		target_direction = direction.normalized()
		if grid.is_cell_vacant(pos, direction):
			if not grid.move_outside_tiles:
				if grid.cell_has_tile(pos, direction):
					update_pos(pos, direction)
			else:
				update_pos(pos, direction)
	elif is_moving:
		speed = max_speed
		# We have to convert the player's motion to the isometric system.
		# The target_direction is normalized a few lines above so the player moves at the same speed in all directions.
		motion = grid.cartesian_to_isometric(speed * target_direction * delta)

		var distance_to_target = pos.distance_to(target_pos)
		var ui_distance = motion.length()

		# In the previous example, the player could land on floating positions
		# We force him to stop exactly on the target by setting the position instead of using the move method
		# As the grid handles the "collisions", we can use the two functions interchangeably:
		# move(motion) <=> set_pos(get_pos() + motion)
		if ui_distance > distance_to_target:
			set_pos(target_pos)
			is_moving = false
		else:
			move(motion)

func update_pos(pos, direction):
	target_pos = grid.update_child_pos(pos, direction, grid.Player)
	is_moving = true
