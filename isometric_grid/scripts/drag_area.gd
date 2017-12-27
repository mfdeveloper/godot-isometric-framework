extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var input_action = "left_click"
export(NodePath) var drag_parent
enum STATUS { DRAGGING, DROP }

var current_status

signal drag(area, delta)

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here            

    # add_input_map()
    drag_parent = drag_parent if drag_parent else get_parent()
        
    set_process_input(true)
    set_process(true)

func _process(delta):
    if current_status == DRAGGING:
        # var callbacks = get_signal_connection_list("drag")
        # print(callbacks)
        if is_connected("drag", drag_parent, "_drag"):
            emit_signal("drag", self, delta)
        else:
            get_parent().set_global_pos(get_global_mouse_pos())
            

func _input(event):
    if event.is_action_pressed(input_action):
        current_status = STATUS.DRAGGING

    if event.is_action_released(input_action):
        current_status = STATUS.DROP

# WORK IN PROGRESS
# TODO: Use the File gdscript class to store the InputMap
# for mouse click into the engine.cfg file
func add_input_map():
    if not InputMap.has_action(input_action):
            
        var mouseEvent = InputEvent()
        mouseEvent.type = InputEvent.MOUSE_BUTTON
        mouseEvent.button_index = BUTTON_LEFT
        var mouseStr = "mbutton("+str(mouseEvent.device)+","+str(mouseEvent.button_index)+")"
        print(mouseEvent.get_meta())
        
        var touchEvent = InputEvent()
        touchEvent.type = InputEvent.SCREEN_TOUCH
        
        InputMap.add_action(input_action)
        InputMap.action_add_event(input_action, mouseEvent)
        InputMap.action_add_event(input_action, touchEvent)
        
        var config = ConfigFile.new()
        var err = config.load("res://engine.cfg")
        # print(err)

        if err == OK:
            config.set_value("input", input_action, [mouseStr])
            # for inputEvent in InputMap.get_action_list(input_action):
                
            #     config.set_value("input", input_action, inputEvent)
            
            config.save("res://engine.cfg")