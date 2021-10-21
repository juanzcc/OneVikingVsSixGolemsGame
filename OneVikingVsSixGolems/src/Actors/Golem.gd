extends "res://src/Actors/Actor.gd"

var dead = false
var movement = Vector2()
var speedEnemy = 100
var moving_left = true
var sideLeft = true
var isAttacking = false

const GRAVITY = 32
const UP = Vector2.UP

onready var l_ray = $l_ray
onready var sprite = $AnimatedSprite

func _physics_process(delta: float) -> void:
	if l_ray.is_colliding(): #caso o golem colida com uma parede ele muda a direção
		moving_left = !moving_left
		l_ray.scale.x = -l_ray.scale.x	
	if l_ray.scale.x == 1: #verificando o lado que o golem esta
		sideLeft = true
	else: if l_ray.scale.x == -1:
		sideLeft = false
	move() #ativando o movimento

func move(): #movimento do golem para os lados
	movement.y += GRAVITY
	movement.x = -speedEnemy if moving_left else speedEnemy
	movement = move_and_slide(movement, UP)
	
func _process(delta: float) -> void: 
	#colocando as sprites do golem
	if dead == false && sideLeft == true && isAttacking == false:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
		$AttackArea/CollisionShape2D.position= Vector2(-24.523, -18.863)
		$VisibleAttack/CollisionShape2D.position= Vector2(-24.523, -18.863)
	else: if dead == false && sideLeft == false && isAttacking == false:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
		$AttackArea/CollisionShape2D.position = Vector2(34.608, -20.863)
		$VisibleAttack/CollisionShape2D.position = Vector2(34.608, -20.863)
	else: if dead == false && sideLeft == true && isAttacking == true:
		$AnimatedSprite.play("attack1")
		$AnimatedSprite.flip_h = true
	else: if dead == false && sideLeft == false && isAttacking == true:
		$AnimatedSprite.play("attack1")
		$AnimatedSprite.flip_h = false
		

func _on_HitDetector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"): #caso entre em contato com a espada do player o golem morre
		dead = true
		$AnimatedSprite.play("dying")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "dying": 
		queue_free() #fazendo o corpo do golem sumir
	if $AnimatedSprite.animation == "attack1":
		isAttacking = false #para parar a animação de ataque


func _on_AttackArea_body_entered(body: Node) -> void:
	if body.is_in_group("player") && isAttacking == true:
		if (body.life > 40): ##atacando o player
			body.life -= 40
		else:
			body.queue_free()
			print("You Died!")
			get_tree().change_scene("res://src/LoserScene.tscn")


func _on_VisibleAttack_body_entered(body: Node) -> void:
	if body.is_in_group("playerAttackArea"): #verificando se o player esta no range do atk
		isAttacking = true #para que possa atacar
