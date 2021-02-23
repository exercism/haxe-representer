# Haxe Representer 

A normalizing representer for Exercism's Haxe track.

## Progress

Currently the following is normalized by the representer:

- [x] Comments
- [x] Whitespace
- [x] Braces
- [x] Exponents
- [x] Keywords (final, inline, public, private)
- [x] Identifiers (classes, members, enums, typedefs)
- [x] Booleans
- [x] Import statements
- [x] Using statements
- [x] Declaration order of vars, functions, enums, typedefs


## Design

The high-level steps the representer takes:

1. Apply formatting to original source code using haxe-formatter
2. Parse into AST using haxe-parser
3. Apply normalizations
4. Convert AST back to source code
5. Apply formatting to normalized code
6. Write out representation and mapping
