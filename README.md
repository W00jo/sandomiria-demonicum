# Sandomiria Demonicum

## Overview

Sandomiria Demonicum is set in medieval Sandomierz, where the player takes control of an immortal champion fighting against otherworldly creatures that have invaded once-holy and beautiful lands.

Blending real historical inspirations with the dark fantasy aesthetics of the 1980s, Sandomiria Demonicum delivers a, first-person action experience focused on intense combat against hordes of the undead and monsters.

## Project structure

- **assets/** → Art, audio, fonts, shaders
- **docs/** → Notes and changelog
- **scenes/** → Main game scenes and their respective `scripts`

## How to run

`project.godot`

## Naming conventions

These naming conventions follow the Godot Engine style. Breaking these will make your code clash with the built-in naming conventions, leading to inconsistent code. As a summary table:

| Type | Convention | Example |
| --- | --- | --- |
| File names | snake_case | `yaml_parsed.gd` |
| class_name | PascalCase | `class_name YAMLParser` |
| Node names | PascalCase | `Camera3D`, `Player` |
| Functions | snake_case | `func load_level():` |
| Variables | snake_case | `var particle_effect` |
| Signals | snake_case | always in past tense `signal door_opened` |
| Constants | CONSTANT_CASE | `const MAX_SPEED = 200` |
| enum names | PascalCase | `enum Element` |
| enum members | CONSTANT_CASE | `{EARTH, WATER, AIR, FIRE}` |

## Code order

```html
01. @tool, @icon, @static_unload
02. class_name
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods:
 1. _init()
 2. _enter_tree()
 3. _ready()
 4. _process()
 5. _physics_process()
 6. remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses
```

## Credits

List any free/paid assets, tools, or contributors.

*Summarized from Godot Docs*.
