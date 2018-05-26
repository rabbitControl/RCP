![Alt RCP diagram](./RCP_diagram.svg)
(RCP example to control a host application with other devices)


# RCP
Remote Control Protocol

A binary data-format definition to describe data values and user interface elements.
It is intended to expose parameters (values) from a host application to a client in a defined way. It was created with UI clients in mind which update values at the host application. It can also be used in a non-UI case.

[F.A.Q.](https://github.com/rabbitControl/RCP/wiki/F.A.Q.)

![Specification](https://github.com/rabbitControl/RCP/wiki/Specification)

## RCP Levels:
- ![Value](https://github.com/rabbitControl/RCP/wiki/Value-Specification): Number, String, Color, … This is the value without visual representation
- ![Widget](https://github.com/rabbitControl/RCP/wiki/Widget-Specification) (optional): Button, Slider, … This is the visual representation of a Value. A Widget must be implemented client-side. The protocol defines standard widgets for basic types. Optionally complex types can be added when needed.
- __Layout__ (optional): Placement of widgets on a screen: The Layouting of Widgets defines how widgets are placed on screen by defining standard containers.
- __Style__ (optional): Look (colors, shading, ...) of widgets on a screen: CSS styling of widgets

The first draft version of RCP only defines 1. (Values) and 2. (Widgets)

## Status

Work in progress  
Request for Comments (RFC)

Join the discussion on riot:  
https://riot.im/app/#/room/#rcp:matrix.org
