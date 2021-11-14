extends KinematicBody

enum {
	IDLE,
	ALERT,
}

var state = IDLE

onready var raycast = $forward
onready var eyes = $Eyes
onready var shoottimer = $ShootTimer
onready var Decal = load("res://Player/Decal.tscn")

var health = 100
var target
var speed = 5
var gravity = -8.0
var direction = Vector3()
var velocity = Vector2.ZERO
var jump_power = 20
var view_player = false
var rng = 0
var space_state
# Called when the node enters the scene tree for the first time.
func _ready():
	space_state = get_world().direct_space_state
	randomize()
	rng = rand_range(-15.0, 15.0)

func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		shoottimer.start()

func _on_SightRange_body_exited(body):
	state = IDLE
	shoottimer.stop()

func _physics_process(_delta):
	velocity = Vector3(0,0,0)*speed
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity
	if velocity != Vector3.ZERO:
		velocity = move_and_slide(velocity, Vector3.UP)
	match state:
		IDLE:
			velocity.x += rng
			velocity.z += rng
		ALERT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * speed))
			var goalx = target.global_transform.origin.x
			var goalz = target.global_transform.origin.z
			velocity.x += goalx
			velocity.z += goalz
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ShootTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			shoot()

func shoot():
	if not $Pivot/Flash.visible:
		$Pivot/Flash.show()
		$Pivot/Blaster/GunSFX.play()
		$Pivot/Flash/Timer.start()
		if $Pivot/RayCast.is_colliding():
			var shot = raycast.get_collider()
			if shot.is_in_group("Player"):
				print("hit")
				if shot.has_method("damaged"):
					shot.damaged(100)
			else:
				var t = $Pivot/RayCast.get_collider()
				var p = $Pivot/RayCast.get_collision_point()
				var n = $Pivot/RayCast.get_collision_normal()
				var decal = Decal.instance()
				t.add_child(decal)
				decal.global_transform.origin = p
				decal.look_at(p + n, Vector3.UP)


func _on_Timer_timeout():
	$Pivot/Flash.hide()


func _on_MovementTimer_timeout():
	randomize()
	rng = rand_range(-10,10)
