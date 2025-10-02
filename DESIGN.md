# Design

> Begin with the end in mind

  -- DIR maxim

Use good judgement, think about the goal, write code in service of that goal.

## User

The user is assumed to be a diver with appropriate training who is capable of
doing everything this program can do themselves.

## UX

- Prefer shallow menus 

Settings should be as high in the hierarchy as is reasonable. Rather than
putting key settings under a "Settings" submenu, display them top level. The
menu structure should be easy to visualize for a user.

- Speed of access should be inverse to frequency of access

Think about what the user is likely to want most often and make that easiest to
access.

- Aggressively display key values

When displaying computed results, try to ensure that the user sees the major
factors it was computed from.

- Consistent color scheme

Use a black background with white text for input screens.
Use a white background with black text for output screens.

## Coding practices

This program computes values that have safety implications. While this program
absolutely *does not guarantee* "FITNESS FOR A PARTICULAR PURPOSE", the goal is
to be as correct as possible. Safe coding principles are in full effect here.

### Be as precise as possible

- Do not round during calculations
- Do not cast to lower precision types

Note: `Float` is used throughout the codebase for floating point values. This
needs to be evaluated.

### Lose precision in the direction of safety

For practical purposes exact values usually need to be rounded to a reasonable
level of precision. When doing this, always round in the direction of safety.

Examples:
- Consumables should round towards infinity; never display a number that is
  less than the exact value
- Maximum depths should round towards 0, minimum depths toward infinity

## Display verifiable values

The results of calculations using displayed values should never be more than
the displayed result.

### Unit conversions are for display only

SI units are assumed throughout the codebase.

- When accepting input, convert to SI as early as possible
- When displaying output, convert to display units as late as possible
- Do not perform calculations in non-SI units
  - Rounding as a formatting step is OK

