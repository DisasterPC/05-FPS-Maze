extends KinematicBody

onready var camera = $Pivot/Camera
onready var Decal = load("res://Player/Decal.tscn")
onready var health = 100
onready var raycast = $Pivot/RayCast

var speed = 5
var speedy = 0
var gravity = -8.0
var direction = Vector3()
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var velocity = Vector2.ZERO
var jump_power = 20


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pivot/Camera.current = true

func _physics_process(_delta):
	velocity = get_input()*speed
	velocity.y += gravity
	if velocity != Vector3.ZERO:
		velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_pressed("shoot"):
		shoot()

	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_power * -gravity
			velocity = move_and_slide(velocity)
			
func _input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func get_input():
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func shoot():
	if not $Pivot/Flash.visible:
		$Pivot/Flash.show()
		$Pivot/Flash/Timer.start()
		if $Pivot/RayCast.is_colliding():
			var shot = raycast.get_collider()
			if shot.is_in_group("enemy"):
				print("hit")
				if shot.has_method("damaged"):
					shot.damaged(10)
			else:
				var t = $Pivot/RayCast.get_collider()
				var p = $Pivot/RayCast.get_collision_point()
				var n = $Pivot/RayCast.get_collision_normal()
				var decal = Decal.instance()
				t.add_child(decal)
				decal.global_transform.origin = p
				decal.look_at(p + n, Vector3.UP)
			$Pivot/Blaster/GunSFX.play()

	
func _on_Timer_timeout():
	$Pivot/Flash.hide()

func damaged(dmg):
	health -= dmg
	print(health)
	if health < 0 or health == 0:
		die()

func die():
	var node = get_node_or_null("res://Game/GameOverScreen")
	if not node == null:
		node.show()
		get_tree().paused = true
	else:
		print("You're not supposed to see this, if you do something went wrong. Please report this.")
