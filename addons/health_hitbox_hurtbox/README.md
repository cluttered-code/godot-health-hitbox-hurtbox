# Godot <img src="https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/health/health.svg" width="24" height="24"/>  Health, <img src="https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hit_box_2d/hit_box_2d.svg" width="24" height="24"/> HitBoxes, <img src="https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/3d/hurt_box_3d/hurt_box_3d.svg" width="24" height="24"/> HurtBoxes, and <img src="https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hit_scan_2d/hit_scan_2d.svg" width="24" height="24"/> HitScans

[![Godot](https://img.shields.io/badge/Godot-4.4%2b-blue?logo=godot-engine)](https://godotengine.org/download)
[![LICENSE](https://img.shields.io/badge/license-MIT-blue)](https://github.com/cluttered-code/godot-health-components/blob/main/addons/health_components/LICENSE)
[![Current Release](https://img.shields.io/github/release/cluttered-code/godot-health-hitbox-hurtbox.svg "Current Release")](https://github.com/cluttered-code/godot-health-hitbox-hurtbox/releases/latest)
[![actions](https://github.com/cluttered-code/godot-health-hitbox-hurtbox/actions/workflows/ci.yml/badge.svg)](https://github.com/cluttered-code/godot-health-hitbox-hurtbox/actions/workflows/ci.yml)
[![Downloads](https://img.shields.io/github/downloads/cluttered-code/godot-health-hitbox-hurtbox/total.svg "Downloads")](https://github.com/cluttered-code/godot-health-hitbox-hurtbox/releases)

[![Live Example](https://img.shields.io/badge/Live_Example-itch.io-fa5c5c)](https://cluttered-code.itch.io/godot-health-hitbox-hurtbox-hitscan)
[![ko-fi](https://img.shields.io/badge/Support%20on-ko--fi-ff5e5b?logo=ko-fi)](https://ko-fi.com/clutteredcode)

> [!CAUTION]
> A lot changed in v5.0.0. It is recommended to update to v4.4.0 before going to v5.0.0 to avoid issues with component name changes. We're working hard to update the documentation.
> The components in the documentation are all now prefixed with "Basic". We added more complex variants to allow for multiple damage types and modifiers.
> Thank for the support!

## Documentation

Check out the [Wiki](https://github.com/cluttered-code/godot-health-hitbox-hurtbox/wiki) for Documentation and tutorials!

## Process and Data Flow
```mermaid
flowchart LR
  HitBox
  HitScan
  HurtBox
  Health

  HitBox -- detect collision and send **amount** --> HurtBox
  HitScan -- detect collision and send **amount** --> HurtBox
  HurtBox -- send **amount** and **multiplier** --> Health
```

## ![Health](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/health/health.svg) Health

`Health` component tracks an entity's health and emits signals for various health realted changes.

![Health inspector](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/images/health_inspector.png "Health Inspector")

## ![HurtBox2D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hurt_box_2d/hurt_box_2d.svg) Hurtbox ![HurtBox3D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/3d/hurt_box_3d/hurt_box_3d.svg)

`HurtBox2D` and `HurtBox3D` components require a `Collision Shape` so it can be detected and is assigned a ![Health](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/health/health.svg) `Health` component to apply damage and healing when hit.

![HurtBox2D Inspector](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/images/basic_hurt_box_2d_inspector.png "HurtBox2D Inspector")

## ![HitBox2D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hit_box_2d/hit_box_2d.svg) Hitbox ![HitBox3D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/3d/hit_box_3d/hit_box_3d.svg)

 `HitBox2D` and `HitBox3D` components require a `Collision Shape` to detect collisions with a ![HurtBox2D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hurt_box_2d/hurt_box_2d.svg) `HurtBox2D` or ![HurtBox3D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/3d/hurt_box_3d/hurt_box_3d.svg) `HurtBox3D` to apply `DAMAGE` or `HEAL`.

![HitBox2D Inspector](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/images/basic_hit_box_2d_inspector.png "HitBox2D Inspector")

## ![HitScan2D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hit_scan_2d/hit_scan_2d.svg) HitScan ![HitScan3D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/3d/hit_scan_3d/hit_scan_3d.svg)

`HitScan2D` and `HitScan3D` components extend `RayCast2D` and `RayCast3D` to detect collisions with a ![Hurtbox2D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/2d/hurt_box_2d/hurt_box_2d.svg) `HurtBox2D` or ![Hurtbox3D](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/addons/health_hitbox_hurtbox/3d/hurt_box_3d/hurt_box_3d.svg) `HurtBox3D` to apply `DAMAGE` or `HEAL`.

![HitScan2D Inspector](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/images/basic_hit_scan_2d_inspector.png "HitScan2D Inspector")

## Live Example Demonstration

[itch.io - godot-health-hitbox-hurtbox-hitscan](https://cluttered-code.itch.io/godot-health-hitbox-hurtbox-hitscan)

## Installation

### Asset Library Installation

1. Open the `AssetLib` tab in the Godot Editor.
2. Search for `Health`, `HitBox`, or `HurtBox` in the search bar.
3. Click the download button next to the Health, HitBoxes, and HurtBoxes plugin.
4. Once the installation is complete, go to `Project` -> `Project Settings` -> `Plugins`.
5. Find the `Health, HitBoxes, and HurtBoxes` plugin in the list and check the box to enable it.

## Usage

![Player Structure](https://raw.githubusercontent.com/cluttered-code/godot-health-hitbox-hurtbox/refs/heads/main/images/character_structure.png "CharacterBody2D Structure")

1. Add a `Health` node to a Node that needs health (ie. `CharacterBody2D` or `StaticBody3D`)
2. Add a `HurtBox2D` node with a `CollisionShape2D` to the same Node.
3. Set the `HurtBox2D` collision layer.
4. `HitBox2D` or `HitScan2D`
	- Create a projectile or melee weapon with a `HitBox2D` and set the collision mask to the same layer as the `HurtBox2D` collision layer. This will automatically apply damage and healing.
	- Create a gun with a `HitScan2D` extending from the barrel and set the collision mask to the same layer as the `HurtBox2D` collision layer. `fire()` needs to be called on the `HitScan2D` to apply damage and healing.

## Issues

Submit issues to the [Github Issues Page](https://github.com/cluttered-code/godot-health-hitbox-hurtbox/issues)
