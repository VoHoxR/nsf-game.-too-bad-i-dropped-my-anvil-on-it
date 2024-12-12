extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var Scale = 1.2

@export var push_force = 140
@export var speed = 150.0
@export var sprint_speed = 250
@export var jump_vel = -300.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_vel

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction := Input.get_axis("walk_left", "walk_right")
	var is_sprinting = false
	if Input.is_action_pressed("sprint") and is_on_floor():
		is_sprinting = true
	else:
		is_sprinting = false
		
		
	if Input.is_action_pressed("crouch") and is_on_floor():
		$CollisionShape2D.scale.y = .5
		$CollisionShape2D.position.y = 30
		$head_col.position.y = 10
	else:
		$CollisionShape2D.scale.y = 1
		$CollisionShape2D.position.y = 20
		$head_col.position.y = -10
		
	if direction:
		velocity.x = direction * speed
	elif direction and is_sprinting == true:
		velocity.x = direction * sprint_speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
