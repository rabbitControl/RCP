# Versioning

RCP is using a version consisting of a major and minor version number. The following versions are used in Info Data:

### server rcp-version:
The rcp version implemented by the server

### server handshake-version:
The rcp version used by the server derived from protocol features (e.g.: options) actually in use. This is the minimum required version a client needs to support.

### client rcp-version:
The rcp version implemented by the client

### client handshake-version:
The minimum major version the client implements (backward compatibility version)


Compatibility between the server and a client is ensured if the server handshake-version is between the clients rcp-version and clients handshake-version (inclusive).
See [Protocol Flow](Flow.md) for the version handshake and more details.


e.g.:
		
server rcp | server handshake | client rcp | client handshake | result
-- | -- | -- | -- | --
1.0 | 1.0 | 1.0 | 1.0 | ok
2.0 | 2.0 | 1.0 | 1.0 | not ok
2.0 | 2.0 | 2.0 | 1.0 | ok
2.3 | 2.1 | 2.2 | 2.0 | ok
2.3 | 2.3 | 2.2 | 2.0 | not ok



## Version Changes

RCP aims to encourage the introduction of new features over time without the danger of immediate incompatibilities.
To make this possible version changes follow the following rules:

## Guidlines for increasing the version number

The following is an incomplete list of considerations on when to increase the minor and major version.

### Minor changes
all optional additions:
- add an option to: Datatype, Widget, InfoData, Parameter
- a new packet type that is not mandatory for the [protocol flow](Flow.md)
- a new datatype, widget

### Major changes
all non-optionals add/modify/remove:
- non-optional in Datatype, Widget, InfoData, Parameter, Update packet
- all structural changes: e.g. packetstructure, lang string structure
- a new packet type that is mandatory for the [protocol flow](Flow.md)
- all removals
