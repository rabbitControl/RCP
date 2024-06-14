## RCP Levels:
- __Value__: Number, String, Color, … This is the value without visual representation
- __Widget__ (optional): Button, Slider, … This is the visual representation of a Value. A Widget must be implemented client-side. The protocol defines standard widgets for basic types. Optionally complex types can be added when needed.
- __Layout__ (optional): Placement of widgets on a screen: The Layouting of Widgets defines how widgets are placed on screen by defining standard containers.
- __Style__ (optional): Look (colors, shading, ...) of widgets on a screen: CSS styling of widgets

The first draft version of RCP only defines 1. (Values) and 2. (Widgets)

-> Have a look at the [Value Specification](RCPValue.md)

-> Have a look at the [Widget Specification](RCPWidget.md)


## Endianess

The format is using big endian

## Framing

Data Framing is not scope of this protocol.

of interest. use a:
- prefix stream with magic (e.g.: 0x04 0x0F 0x05 0x09)
- SLIP RFC 1055

## Types

- string-tiny: prefixed with size [uint8] followed by [UTF-8 string-data]
- string-short: prefixed with size [uint16] followed by [UTF-8 string-data]
- string: prefixed with size [uint32] followed by [UTF-8 string-data]
- multilanguage: list of: [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code (3-bytes in ascii) followed by string-tiny, string-short or string. list is terminated with 0. additional to the ISO 639-3 codes we define a special code for no specific language: "any"

## Package

| Name          | ID hex/dec   | Value           | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **command** | - | byte | - | n | command of package |
| timestamp | 0x11(17) | uint64 | 0 | y | optional timestamp |
| data | 0x12(18) | - | - | y | package data. type depends on command |
| **terminator** | 0 | byte | 0 | n | package terminator |

note: we may want to send id/timestamp before the data, to decide if packet is valid (udp case), prefix the value with data-id. otherwise we need to parse the data before to get id/timestamp

chaining Parameters: data can contain more than one Parameter.

### command table:

| command   | ID   | expected data | comment   |
|-----------|------|---------------|-----------|
| info | 0x01 | null or Info Data | if no data is sent: it has to be answered with an info command including info data. if data is sent, it must not be answered by an info command.
| initialize | 0x02 | null or ID Data | if no data is sent: request for all parameters. sends update command(s) to client.
| discover | 0x03 | null or ID Data | if no data is sent: request for all parameters. parameters are sent without typdedefinition-options, without value and userdata. discover only discovers on level, no subgroups are discovered. sends update command(s) to client.
| update | 0x04 |	Parameter
| remove | 0x05 | ID Data
| updatevalue | 0x06 | specialized smallest update-value format

- clients usually send: info, discover, initialize, update, updateValue
- server ususally sends: info, add, update, updateValue, remove


## ID Data

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **id**         | - | int16  | 0 | n | id of parameterGroup or Parameter


## Info Data

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **version**   | - | tiny-string    | "" |n| rcp protocol version
| applicationid       | 0x1a	(26)   | tiny-string    | "" |y| Can be used to identify the server/client application
| applicationversion       | 0x1b	(27)   | tiny-string    | "" |y| version of application
| **terminator**    | 0 | 1 byte | 0 | n | terminator


## Parameter:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **id** | - | int16 | - | n | unique identifier (can not be 0. see: parent)
| **typedefinition** |	- | TypeDefinition | - | n | typedefinition of value. see: [Value Specification](RCPValue.md)
| value | 0x20 (32) | known from typedefinition | ? | y |	value (length is known by type!)
| label | 0x21 (33)	| multilanguage string-tiny | "" | y | Human readable identifier
| description | 0x22 (34) | multilanguage string-short | "" | y | can be shown as a tooltip
| tags | 0x23 (35)	|	string-tiny | "" | y | space separated list of tags
| order | 0x24 (36)	|	int32 | 0 | y | sorting for parameters. allows for most simple layout: a higher order sorts a parameter after a parameter with a lower order
| parentid | 0x25 (37)	|	int16 | 0 | y | specifies another parameterGroup as parent.
| widget | 0x26 (38) | widget data | text-input-widget | y | see: [Widget Specification](RCPWidget.md)
| userdata | 0x27 (39) | size-prefixed bytearray | - | y | various user-data. e.g.: metadata, tags, ...
| userid | 0x28 (40) | string-tiny | "" | y | user id
| readonly | 0x29 (41) | byte | false | y | read only
| **terminator** | 0 | 1 byte | 0 | n | terminator


## ParameterGroup:

A ParameterGroup is a Parameter without value/defaultValue and a fixed TypeDefintion (group).

A ParameterGroup allows to structure your parameters and can be used to discover parameters on different levels.

A Parameter can only be child of excactly one group.


## Root Parameter Group

This parameter group is a virtual Parameter-group which does always exist.
It defines the highes level in the hirarchy tree.

The id of the root-group is 0.

No other Parameter is allowed to have this id.


## updateValue

to optimize the update of the value of a parameter, there is a specialized updateValue command in the form:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **command**       | 0x06         | byte           | -               | n | updateValue command
| **parameter id**  |              | int16          | 0               | n | parameter id
| **mandatory part of datatype**   |              | byte           | 0               | n | datatype
| **value**         |              | type of datatype  | ?               | n | the value

this reduces the amount of data to be sent for a simple value udpate.

e.g.:

updating a int32 with id 0x01 to value 255:

0x06 0x01 0x01 0x15 0x00 0x00 0x00 0xFF (8 bytes)
