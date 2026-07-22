---
name: Optimize Simplify Addon
overview: "Non-breaking cleanup: extract shared helpers to collapse 2D/3D and Basic duplication, fix HitScan/HitBox consistency and small bugs, gate Health debug noise, and refresh docs/tests — without changing public class names, signals, or exported APIs."
todos:
  - id: "1.1"
    content: "HitScan clone parity (2D + 3D)"
    status: completed
  - id: "1.2"
    content: "Basic init clear+set (all six basic_* scripts)"
    status: completed
  - id: "1.3"
    content: "Deep HealthModifiedAction.clone()"
    status: completed
  - id: "1.4"
    content: "Health verbose_debug gate"
    status: completed
  - id: "1.5"
    content: "Health explicit enum NONE checks"
    status: completed
  - id: "1.6"
    content: "Drop unused old_max in Health.max setter"
    status: completed
  - id: "2.1"
    content: "Add shared/hit_collision_logic.gd"
    status: pending
  - id: "2.2"
    content: "Add shared/hurt_box_logic.gd"
    status: pending
  - id: "2.3"
    content: "Add shared/basic_action_factory.gd"
    status: pending
  - id: "2.4"
    content: "Thin HitBox/HitScan 2D+3D wrappers"
    status: pending
  - id: "2.5"
    content: "Thin HurtBox 2D+3D wrappers"
    status: pending
  - id: "2.6"
    content: "Thin Basic* 2D+3D wrappers"
    status: pending
  - id: "2.7"
    content: "Refactor plugin.gd to data-driven loop"
    status: pending
  - id: "3.1"
    content: "Update README for v5 actions/modifiers"
    status: completed
  - id: "3.2"
    content: "Tests: HitScan clones"
    status: completed
  - id: "3.3"
    content: "Tests: Basic init no duplicates"
    status: completed
  - id: "3.4"
    content: "Tests: HealthModifiedAction deep clone"
    status: completed
  - id: "3.5"
    content: "Tests: fill() + Health.modifiers / convert_affect"
    status: completed
  - id: "3.6"
    content: "Bump plugin.cfg to 5.0.5"
    status: pending
isProject: true
---

# Optimize and simplify (API-stable)

Constraint: **no breaking public API**. Keep existing `class_name`s, signals, exports, and method signatures. Deduplicate via shared static helpers and thinner wrappers; keep separate 2D/3D node scripts because Godot custom types must extend `Area2D`/`Area3D` / `RayCast2D`/`RayCast3D`.

**Status legend:** ✅ done · 🚧 in_progress · ⏳ todo

## Target architecture

```mermaid
flowchart TB
  subgraph publicAPI [Public node types unchanged]
    HB2[HitBox2D]
    HB3[HitBox3D]
    HS2[HitScan2D]
    HS3[HitScan3D]
    Hurt2[HurtBox2D]
    Hurt3[HurtBox3D]
    BasicHit[BasicHitBox_HitScan]
    BasicHurt[BasicHurtBox]
  end
  subgraph shared [New shared helpers]
    HitLogic[hit_collision_logic.gd]
    HurtLogic[hurt_box_logic.gd]
    BasicFactory[basic_action_factory.gd]
  end
  HB2 --> HitLogic
  HB3 --> HitLogic
  HS2 --> HitLogic
  HS3 --> HitLogic
  Hurt2 --> HurtLogic
  Hurt3 --> HurtLogic
  BasicHit --> BasicFactory
  BasicHurt --> BasicFactory
```

## Progress overview

```mermaid
flowchart LR
  P1["Phase 1 Correctness - done"] --> P2["Phase 2 Shared helpers - todo"]
  P2 --> P3["Phase 3 Docs tests version - todo"]
```

| Status | Phase | Description |
|--------|-------|-------------|
| ✅ | 1 | Correctness and small cleanups |
| ⏳ | 2 | Deduplicate shared logic |
| 🚧 | 3 | Docs, tests, version bump (README done; tests/version remain) |

---

## Phase 1 — Correctness and small cleanups (low risk)

```mermaid
flowchart TB
  subgraph phase1 [Phase 1 - done]
    T11["1.1 HitScan clone parity - done"]
    T12["1.2 Basic init clear+set - done"]
    T13["1.3 Deep HealthModifiedAction.clone - done"]
    T14["1.4 Health verbose_debug - done"]
    T15["1.5 Explicit enum NONE checks - done"]
    T16["1.6 Drop unused old_max - done"]
  end
  T11 --> T12
  T12 --> T13
  T13 --> T14
  T14 --> T15
  T15 --> T16
```

| Status | ID | Task | Details |
|--------|----|------|---------|
| ✅ | 1.1 | HitScan clone parity | Clone actions before `apply_all_actions` in [`hit_scan_2d.gd`](addons/health_hitbox_hurtbox/2d/hit_scan_2d/hit_scan_2d.gd) and [`hit_scan_3d.gd`](addons/health_hitbox_hurtbox/3d/hit_scan_3d/hit_scan_3d.gd) (same as HitBox) |
| ✅ | 1.2 | Basic init clear+set | In all six `basic_*` scripts, replace `actions.append(...)` / assign-into-modifiers with clear + set so re-entry does not accumulate stale entries |
| ✅ | 1.3 | Deep `HealthModifiedAction.clone()` | In [`health_modified_action.gd`](addons/health_hitbox_hurtbox/resources/health_modified_action.gd), deep-clone `action` and `modifier` |
| ✅ | 1.4 | Health `verbose_debug` | Gate all `print_debug` in [`health.gd`](addons/health_hitbox_hurtbox/health/health.gd) behind `@export var verbose_debug: bool = false` |
| ✅ | 1.5 | Explicit enum NONE checks | Use `!= Health.Affect.NONE` / `!= HealthActionType.Enum.NONE` instead of truthiness on enums in convert paths |
| ✅ | 1.6 | Drop unused `old_max` | Remove unused `old_max` in `Health.max` setter if still present |

---

## Phase 2 — Deduplicate shared logic (main simplify win)

Introduce `addons/health_hitbox_hurtbox/shared/` with static helper scripts (no new custom types, no new public nodes).

Thin 2D/3D scripts keep `class_name`, `@export`s, signals, `@tool` / editor bits; call shared helpers with typed callables / local node refs.

```mermaid
flowchart TB
  subgraph helpers [Create helpers]
    T21["2.1 hit_collision_logic.gd - todo"]
    T22["2.2 hurt_box_logic.gd - todo"]
    T23["2.3 basic_action_factory.gd - todo"]
  end
  subgraph wrappers [Thin wrappers]
    T24["2.4 HitBox / HitScan 2D+3D - todo"]
    T25["2.5 HurtBox 2D+3D - todo"]
    T26["2.6 Basic star wrappers - todo"]
  end
  T27["2.7 Data-driven plugin.gd - todo"]
  T21 --> T24
  T22 --> T25
  T23 --> T26
  T24 --> T27
  T25 --> T27
  T26 --> T27
```

| Status | ID | Task | Details |
|--------|----|------|---------|
| ⏳ | 2.1 | `hit_collision_logic.gd` | Area-entered / fire routing: ignore flag, HitBox vs HurtBox vs unknown, clone actions, emit via callables |
| ⏳ | 2.2 | `hurt_box_logic.gd` | Filter null actions, map to `HealthModifiedAction`, call `health.apply_all_modified_actions` |
| ⏳ | 2.3 | `basic_action_factory.gd` | `_type_from_affect`, build/sync single `HealthAction` for Basic Hit/Scan; build KINETIC/MEDICINE modifier dict for Basic Hurt |
| ⏳ | 2.4 | Thin HitBox / HitScan wrappers | Wire 2D+3D HitBox and HitScan scripts to `hit_collision_logic` |
| ⏳ | 2.5 | Thin HurtBox wrappers | Wire 2D+3D HurtBox scripts to `hurt_box_logic` |
| ⏳ | 2.6 | Thin Basic\* wrappers | Wire all six Basic scripts to `basic_action_factory` |
| ⏳ | 2.7 | Data-driven `plugin.gd` | Collapse [`plugin.gd`](addons/health_hitbox_hurtbox/plugin.gd) to a table of `{name, base, script, icon}` and one register/unregister loop |

---

## Phase 3 — Docs and tests (confidence, no API change)

Keep mirrored 2D/3D test suites; shared assertion helpers are optional and not required in the first pass.

```mermaid
flowchart TB
  T31["3.1 Update README - done"]
  subgraph tests [Tests]
    T32["3.2 HitScan clones - done"]
    T33["3.3 Basic init - done"]
    T34["3.4 Deep clone - done"]
    T35["3.5 fill and modifiers - done"]
  end
  T36["3.6 Bump plugin.cfg to 5.0.5 - todo"]
  T31 --> T32
  T32 --> T33
  T33 --> T34
  T34 --> T35
  T35 --> T36
```

| Status | ID | Task | Details |
|--------|----|------|---------|
| ✅ | 3.1 | Update README | Update [`addons/health_hitbox_hurtbox/README.md`](addons/health_hitbox_hurtbox/README.md) (and root README if duplicated) for **actions + modifiers** and Basic vs complex nodes |
| ✅ | 3.2 | Test HitScan clones | Assert actions array unchanged after fire |
| ✅ | 3.3 | Test Basic init | Assert init does not duplicate actions/modifiers |
| ✅ | 3.4 | Test deep clone | Assert `HealthModifiedAction.clone()` is deep |
| ✅ | 3.5 | Test fill + modifiers | Cover `fill()` and `Health.modifiers` / `convert_affect` gaps |
| ⏳ | 3.6 | Version bump | Bump [`plugin.cfg`](addons/health_hitbox_hurtbox/plugin.cfg) to `5.0.5` |

---

## Explicitly out of scope

```mermaid
flowchart LR
  O1[Merge 2D 3D classes]
  O2[Remove Basic types]
  O3[Slim Health signals]
  O4[Change modifier layering]
  O5[Hide HitScan _collider]
```

| Item | Reason |
|------|--------|
| Merging 2D/3D into single classes or removing Basic\* types | Breaking / over-scope |
| Slimming Health’s signal surface | Breaking |
| Changing HurtBox vs Health dual-modifier layering | Behavior change |
| Hiding HitScan `_collider` test seam | Needs test refactor |

---

## Success criteria

```mermaid
flowchart TB
  S1[Scenes and class_name keep working]
  S2[2D 3D Basic share one collision logic]
  S3[HitScan and HitBox apply actions the same way]
  S4[Debug spam off by default]
  S5[Tests cover helpers via public APIs]
  S6[plugin.cfg at 5.0.5]
```
