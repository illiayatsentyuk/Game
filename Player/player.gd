extends CharacterBody2D

enum {
	MOVE,
	ATACK,
	ATACK2,
	ATACK3,
	BLOCK,
	SLIDE
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var hp = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gold = 0
var combo = false
var state = MOVE
var runSpeed = 0.7
var atack_cooldown = false

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATACK:
			atack_state()
		ATACK2:
			atack2_state()
		ATACK3:
			atack3_state()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
			
	if not is_on_floor():
		velocity.y += gravity * delta

	if hp <= 0:
		hp=0
		animPlayer.play('death')
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")
	move_and_slide()

func move_state():
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED * runSpeed
		if velocity.y == 0:
			if runSpeed == 1:
				animPlayer.play("walk")
			else:
				animPlayer.play('Run')
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
	if Input.is_action_pressed("run"):
		runSpeed = 2
	else:
		runSpeed = 1
	if Input.is_action_pressed("Block"):
		if velocity.x == 0:
			state = BLOCK
		else:
			state = SLIDE
	if Input.is_action_just_pressed("Atack") and atack_cooldown == false:
		state = ATACK
func block_state():
	velocity.x = 0
	animPlayer.play('block')
	if Input.is_action_just_released("Block"):
		state = MOVE
func slide_state():
	animPlayer.play("slide")
	await animPlayer.animation_finished
	state = MOVE
func atack_state():
	if Input.is_action_just_pressed("Atack") and combo == true:
		state = ATACK2
	velocity.x = 0
	animPlayer.play('atack')
	await animPlayer.animation_finished
	atack_freeze()
	state = MOVE
func atack2_state():
	if Input.is_action_just_pressed("Atack") and combo == true:
		state = ATACK3
	animPlayer.play("atack2")
	await animPlayer.animation_finished
	state = MOVE
func atack3_state():
	animPlayer.play("atack3")
	await animPlayer.animation_finished
	state = MOVE
func combo_one():
	combo = true
	await animPlayer.animation_finished
	combo = false	
func atack_freeze():
	atack_cooldown = true 
	await get_tree().create_timer(0.5).timeout
	atack_cooldown = false
