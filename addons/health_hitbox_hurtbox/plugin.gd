@tool
extends EditorPlugin

const addon_path = "res://addons/health_hitbox_hurtbox/%s"

var hit_box_2d_added: bool
var hit_scan_2d_added: bool
var hurt_box_2d_added: bool
var basic_hit_box_2d_added: bool
var basic_hit_scan_2d_added: bool
var basic_hurt_box_2d_added: bool

var hit_box_3d_added: bool
var hit_scan_3d_added: bool
var hurt_box_3d_added: bool
var basic_hit_box_3d_added: bool
var basic_hit_scan_3d_added: bool
var basic_hurt_box_3d_added: bool

func _enter_tree() -> void:
	add_custom_type("Health", "Node",
		preload("health/health.gd"),
		preload("health/health.svg"))
	
	# ==================
	# Load 2D components
	# ==================
	if FileAccess.file_exists(addon_path % "2d/hit_box_2d/hit_box_2d.gd"):
		hit_box_2d_added = true
		add_custom_type("HitBox2D", "Area2D",
			load(addon_path % "2d/hit_box_2d/hit_box_2d.gd"),
			load(addon_path % "2d/hit_box_2d/hit_box_2d.svg"))
	
	if FileAccess.file_exists(addon_path % "2d/hit_scan_2d/hit_scan_2d.gd"):
		hit_scan_2d_added = true
		add_custom_type("HitScan2D", "RayCast2D",
			load(addon_path % "2d/hit_scan_2d/hit_scan_2d.gd"),
			load(addon_path % "2d/hit_scan_2d/hit_scan_2d.svg"))
	
	if FileAccess.file_exists(addon_path % "2d/hurt_box_2d/hurt_box_2d.gd"):
		hurt_box_2d_added = true
		add_custom_type("HurtBox2D", "Area2D",
			load(addon_path % "2d/hurt_box_2d/hurt_box_2d.gd"),
			load(addon_path % "2d/hurt_box_2d/hurt_box_2d.svg"))
	
	if FileAccess.file_exists(addon_path % "2d/hit_box_2d/basic_hit_box_2d.gd"):
		basic_hit_box_2d_added = true
		add_custom_type("BasicHitBox2D", "HitBox2D",
			load(addon_path % "2d/hit_box_2d/basic_hit_box_2d.gd"),
			load(addon_path % "2d/hit_box_2d/hit_box_2d.svg"))
	
	if FileAccess.file_exists(addon_path % "2d/hit_scan_2d/basic_hit_scan_2d.gd"):
		basic_hit_scan_2d_added = true
		add_custom_type("BasicHitScan2D", "HitScan2D",
			load(addon_path % "2d/hit_scan_2d/basic_hit_scan_2d.gd"),
			load(addon_path % "2d/hit_scan_2d/hit_scan_2d.svg"))
	
	if FileAccess.file_exists(addon_path % "2d/hurt_box_2d/basic_hurt_box_2d.gd"):
		basic_hurt_box_2d_added = true
		add_custom_type("BasicHurtBox2D", "HurtBox2D",
			load(addon_path % "2d/hurt_box_2d/basic_hurt_box_2d.gd"),
			load(addon_path % "2d/hurt_box_2d/hurt_box_2d.svg"))

	# ==================
	# Load 3D components
	# ==================
	if FileAccess.file_exists(addon_path % "3d/hit_box_3d/hit_box_3d.gd"):
		hit_box_3d_added = true
		add_custom_type("HitBox3D", "Area3D",
			load(addon_path % "3d/hit_box_3d/hit_box_3d.gd"),
			load(addon_path % "3d/hit_box_3d/hit_box_3d.svg"))

	if FileAccess.file_exists(addon_path % "3d/hit_scan_3d/hit_scan_3d.gd"):
		hit_scan_3d_added = true
		add_custom_type("HitScan3D", "RayCast3D",
			load(addon_path % "3d/hit_scan_3d/hit_scan_3d.gd"),
			load(addon_path % "3d/hit_scan_3d/hit_scan_3d.svg"))

	if FileAccess.file_exists(addon_path % "3d/hurt_box_3d/hurt_box_3d.gd"):
		hurt_box_3d_added = true
		add_custom_type("HurtBox3D", "Area3D",
			load(addon_path % "3d/hurt_box_3d/hurt_box_3d.gd"),
			load(addon_path % "3d/hurt_box_3d/hurt_box_3d.svg"))

	if FileAccess.file_exists(addon_path % "3d/hit_box_3d/basic_hit_box_3d.gd"):
		basic_hit_box_3d_added = true
		add_custom_type("BasicHitBox3D", "HitBox3D",
			load(addon_path % "3d/hit_box_3d/basic_hit_box_3d.gd"),
			load(addon_path % "3d/hit_box_3d/hit_box_3d.svg"))

	if FileAccess.file_exists(addon_path % "3d/hit_scan_3d/basic_hit_scan_3d.gd"):
		basic_hit_scan_3d_added = true
		add_custom_type("BasicHitScan3D", "HitScan3D",
			load(addon_path % "3d/hit_scan_3d/basic_hit_scan_3d.gd"),
			load(addon_path % "3d/hit_scan_3d/hit_scan_3d.svg"))

	if FileAccess.file_exists(addon_path % "3d/hurt_box_3d/basic_hurt_box_3d.gd"):
		basic_hurt_box_3d_added = true
		add_custom_type("BasicHurtBox3D", "HurtBox3D",
			load(addon_path % "3d/hurt_box_3d/basic_hurt_box_3d.gd"),
			load(addon_path % "3d/hurt_box_3d/hurt_box_3d.svg"))


func _exit_tree() -> void:
	remove_custom_type("Health")
	
	# ====================
	# Remove 2D components
	# ====================
	if hit_box_2d_added:
		remove_custom_type("HitBox2D")
	if hit_scan_2d_added:
		remove_custom_type("HitScan2D")
	if hurt_box_2d_added:
		remove_custom_type("HurtBox2D")
	if basic_hit_box_2d_added:
		remove_custom_type("BasicHitBox2D")
	if basic_hit_scan_2d_added:
		remove_custom_type("BasicHitScan2D")
	if basic_hurt_box_2d_added:
		remove_custom_type("BasicHurtBox2D")
	
	# ====================
	# Remove 3D components
	# ====================
	if hit_box_3d_added:
		remove_custom_type("HitBox3D")
	if hit_scan_3d_added:
		remove_custom_type("HitScan3D")
	if hurt_box_3d_added:
		remove_custom_type("HurtBox3D")
	if basic_hit_box_3d_added:
		remove_custom_type("BasicHitBox3D")
	if basic_hit_scan_3d_added:
		remove_custom_type("BasicHitScan3D")
	if basic_hurt_box_3d_added:
		remove_custom_type("BasicHurtBox3D")
