## RCP Levels:
- [Value](RCPValue.md):
  - Value without visual representation
  - Boolean, Numbers, String, Color, etc.
  - Custom type

- [Widget](RCPWidget.md):
  - The visual representation of a value
  - Widgets must be implemented client-side
  - The protocol defines standard widgets for basic types
  - Button, Slider, Dial, etc.
  - Custom widget


## Endianess

For multi byte data words, network byte order (big endian) is used.

## Byte / Bits

1 byte equals to 8 bits (one octet).

## Terminator

A 0-byte is used to mark the end of optional properties.

## Property order

Optional properties can be ordered randomly.
## String types

RCP uses two different string types which are defined in the following form:

- string-short:
  - A string prefixed with the string length using \<uint8> as the prefix followed by UTF-8 string-data.
- string-long:
  - A string prefixed with the string length using \<uint16> as the prefix followed by UTF-8 string-data.

## Multilanguage string:

RCP supports multiple languages by using multi-language strings. A `Multilanguage string` contains multiple versions of the string in different languages. Each language is prefixed with a [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code or `any` for no specific language.  

All the languages are transmitted at once. We decided to favour this over a different approach where languages would need to be declared and translations would need to be fetched when switching a language in a frontend.

  - A terminated list of [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code (3-bytes in ascii) followed by a string-short or string-long.
  - The list is terminated with a 0-byte.
  - Additionally to the [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) codes we define a special code for no specific language: `any` which is used as default language.


## Packet

| Name          | ID hex&nbsp;(dec)   | Value   | Default value   | Optional   | Description   |
| --------------|---------------------|---------|-----------------|------------|---------------|
| **command** | - | byte | - | n | Command of packet. |
| timestamp | 0x11(17) | uint64 | 0 | y | A timestamp. |
| data | 0x12(18) | - | - | y | packet data. The type depends on the command. |
| **terminator** | 0 | byte | 0 | n | Terminator |

If a timestamp is present it must be the first option in the packet.  
This allows to decide if a packet is valid or not (e.g. when using UDP as transport). If the data would be written before the timestamp we would need to fully parse the data before reaching the timestamp to decide if the packet is valid.


### Command table

| Command   | ID   | Expected data | Comment   |
|-----------|------|---------------|-----------|
| info | 0x01 | not set or "Info Data" | If no data is set in the packet it is a request for "Info Data". In this case a info-packet with valid "Info Data" needs to be sent back to the origin of the request.<br>If data is set in the packet it must not be answered.
| initialize | 0x02 | - | Request for all parameters. A server needs to send update-packets for all parameters to (only) the requesting client to fully initialize that client. Only after sending all parameters to a client the server starts sending incremental update packets.
| update | 0x04 | Parameter | Incremental update packets must only be sent to fully initialized clients.<br>Data chaining: the data field can contain more than one [Parameter Data](#parameter-data).
| remove | 0x05 | ID Data | This is used to identify parameters for deletion.<br>Data chaining: the data field can contain more than one [ID Data](#ID-data).
| updatevalue | 0x06 | update-value format | See [Update-value packet](#Update-value-packet). Valueupdate packets must only be sent to fully initialized clients. 

- Clients send: info, initialize, update, updatevalue
- Servers send: info, update, updatevalue, remove


## ID Data

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **id**         | - | int16  | 0 | n | The id of a parameter.


## Info Data

| Name          | ID hex&nbsp;(dec)   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **version**   | - | string-short    | - | n | String in [semver](https://semver.org/) format.
| applicationid       | 0x1a	(26)   | string-short    | "" |y| Can be used to identify the server/client application
| **terminator**    | 0 | 1 byte | 0 | n | Terminator


## Parameter Data

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **id** | - | int16 | - | - | Unique parameter identifier. Needs to be != 0.<br>A parameter-id of 0 identifies the virtual root group. Also see "parent".
| **typedefinition** |	- | [Typedefinition](RCPValue.md) | - | n | Typedefinition of value.<br/>See: [Typedefinition](RCPValue.md)
| value | 0x20 (32) | known from typedefinition | type-specific default | y |	The value. Byte-length is known from type.
| label | 0x21 (33)	| multilanguage string-short | "" | y | Human readable identifier.
| description | 0x22 (34) | multilanguage string-long | "" | y | The description of the parameter.
| tags | 0x23 (35)	|	string-short | "" | y | Space separated list of tags. (Tags containing spaces are not supported)
| order | 0x24 (36)	|	int32 | 0 | y | Allows to sort paramters. This is useful when using auto-layouts like a list of parameters.
| parentid | 0x25 (37)	|	[Parameter Id](#Parameter-Id) | 0 | y | Specifies a ParameterGroup as parent. See [Parameter Group](#Parameter-Group).
| widget | 0x26 (38) | [Widget data](RCPWidget.md) | textbox-widget (0x0011) | y | Specify the widget for this parameter. Senseful defaults are specified for different datatypes. See [Widget data](RCPWidget.md) for more information.
| userdata | 0x27 (39) | uint32 size-prefixed array of bytes | - | y | A place for various user-data.
| userid | 0x28 (40) | string-short | "" | y | A custom user-id
| readonly | 0x29 (41) | byte | 0 (false) | y | If the parameter is read-only a server does not accept remote updates. On a client the widget is disabled showing the current value.
| enabled | 0x30 (42) | byte | 1 (true) | y | If not enabled the (client) widget does not show a value and disables the visual representation of the parameter (grayed out). This indicates a parameter currently not in use.
| **terminator** | - | byte | 0 | n | Terminator


## Parameter Group:

A `Parameter Group` is a parameter without value and a group-typedefintion without a default-value to organize parameters in a tree structure.

A parameter can only be child of excactly one group (see parent-option of parameter).

#### Default override:

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| widget | 0x26 (38) | widget data | List-widget (0x8000) | y | See: [Widget Specification](RCPWidget.md)


#### Root Parameter Group

The root `Parameter Group` is a virtual group which does always exist. It defines the highest level in the hirarchy tree.

The parameter-id of the root group is 0.

No other Parameter is allowed to use this parameter id.


## Update-value packet

To optimize the update of a parameter-value, the update-value packet exists in the form of:

| Name          | Type      | Value   | Optional   | Description   |
| --------------|-----------|---------|------------|---------------|
| **command**       | byte           | 0x06     | n | Update-value command.
| **parameter id**  | int16          | 0        | n | Parameter id.<br>A value of 0 is invalid, the packet shall be discarded in this case.
| **mandatory part of datatype**   | bytes | datatype-data | n | Mandatory part of the datatype.<br>Needed to be able to resolve this packet.
| **value**         | type of datatype  | value-data | n | the value of type as defined in Datatype.

This packet reduces the amount of data to be sent for a simple value udpate.

e.g.:

Updating a parameter of \<int32> with id 1 to value 255 only needs 8 bytes:

`0x06 0x00 0x01 0x15 0x00 0x00 0x00 0xFF`
