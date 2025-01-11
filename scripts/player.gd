extends CharacterBody2D

var debug_draw_enabled = false
var collision_debug_drawer: Node2D = null

func _ready():
	# Initialize the debug drawer once and toggle its visibility
	collision_debug_drawer = CollisionDebugDrawer.new()
	collision_debug_drawer.visible = false
	add_child(collision_debug_drawer)

func _physics_process(_delta: float) -> void:
	var movement_speed = 100.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * movement_speed * 5
	move_and_slide()

	if velocity.length() > 0.0:
		get_node("HappyBoo").play_walk_animation()

	if Input.is_action_just_pressed("debug_toggle"):
		debug_show_collision_box(not debug_draw_enabled)

	if Input.is_action_just_pressed("exit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		print_debug("Closing the application")
		get_tree().quit()

func debug_show_collision_box(_flag: bool) -> void:
	debug_draw_enabled = _flag
	if collision_debug_drawer:
		collision_debug_drawer.visible = debug_draw_enabled

class CollisionDebugDrawer:
	extends Node2D

	func _ready():
		# Align the drawer's position with the parent node
		position = Vector2.ZERO

	func _draw():
		var collision_shape = get_parent().get_node("CollisionShape2D")

		if collision_shape and collision_shape.shape:
			var shape = collision_shape.shape
			if shape is RectangleShape2D:
				var rect_size = shape.size
				draw_rect(Rect2(collision_shape.position - rect_size * 0.5, rect_size), Color(1, 0, 0 , 0.3), false)
			elif shape is CircleShape2D:
				draw_circle(collision_shape.position, shape.radius, Color(0, 1, 0, 0.3))

	func _process(_delta):
		pass
