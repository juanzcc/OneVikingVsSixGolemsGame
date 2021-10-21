extends Actor

onready var _animated_sprite = $AnimatedSprite #para utilizar as sprites do personagem
var life = 100 #quantidade de vida inicial do personagem
var _cont = 0.0 #utilizado para saber se o personagem esta virado para esquerda ou para direita
var isAttacking = false #para saber se o personagem esta atacando
var dead = false #para saber se o personagem esta morto

export var knockback = 7000
export var knockup = 500

func _ready() -> void:
	#para esconder a porcentagem da barra
	$LifeBar.percent_visible = false

func _physics_process(delta: float) -> void: 
	$LifeBar.value = life #para atualizar a vida atual do personagem
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: =  get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2: 
	return Vector2( 
		#se mover para direita a variavel vai receber 1 se mover para a esquerda -1
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("jump") and is_on_floor() else 1.0
	) 

func _process(delta):
	#ifs de splites do personagem
	if Input.get_action_strength("jump") && _cont == 1.0 && isAttacking == false:
		_animated_sprite.play("jump")
		_animated_sprite.flip_h = true
	else: if Input.get_action_strength("jump") && isAttacking == false:
		_animated_sprite.play("jump")
		_animated_sprite.flip_h = false
	else: if Input.get_action_strength("move_right") && isAttacking == false:
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = false
		_animated_sprite.offset = Vector2(0, 0)
		_cont = 0.0
	else: if Input.get_action_strength("move_left") && isAttacking == false:
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = true
		_animated_sprite.offset = Vector2(-40.0, 0)
		_cont = 1.0
	else:
		if isAttacking == false:
			_animated_sprite.play("idle")
			_animated_sprite.flip_h = false
			_animated_sprite.offset = Vector2(0, 0) 
			_cont = 0.0
	if Input.get_action_strength("attack") && _cont == 1.0: #ifs de splite de atk do personagem
		_animated_sprite.play("attack1")
		_animated_sprite.flip_h = true
		_animated_sprite.offset = Vector2(-40, 0)
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
		$AttackArea/CollisionShape2D.position = Vector2(-37.169, -21.369)
	else: if Input.get_action_strength("attack"):
		_animated_sprite.play("attack1")
		_animated_sprite.flip_h = false
		_animated_sprite.offset = Vector2(0, 0)
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
		$AttackArea/CollisionShape2D.position = Vector2(45.19, -21.369)

func _on_AnimatedSprite_animation_finished() -> void:
	if _animated_sprite.animation == "attack1":
		$AttackArea/CollisionShape2D.disabled = true
		isAttacking = false

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	return out
