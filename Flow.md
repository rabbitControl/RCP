# Protocol Flow

## Version Handshake

1. Client sends a info-packet
1. Server receives info-packet
1. Server sends info-packet to client
1. Server checks if its runtime-version is between client rcp-version and base-version (inclusive)
	1. Version ok -> wait for [Initialization](#Initialization)
	1. Version mismatch:
		1. Server is strict -> close connection
		1. Server not strict -> wait for [Initialization](#Initialization)
1. Client receives info:
	1. Version ok: [Initialization](#Initialization)
	1. Version missmatch:
		1. Decide to close connection
		1. Or client sends initialize and skip packages if a parsing error occurs due to unknown options. See: [Initialization](#Initialization)

## Initialization
  
6. A client sends an initialize-packet with a value of 0 to request all parameters from the server
6. The server answers with a initialize-packet containing the number of parameters it will send (This allows a client to draw a progress-bar while receiving the initial set of parameters.)
6. The server sends update packets with all the requested parameters
6. After receiving all parameters the client is fully initialized

## Update

10. Server and clients send update or update-value packets
10. Servers may also remove Parameters with a remove-packet
