# Ft_Irc - Internet Relay Chat Server

A lightweight **Internet Relay Chat (IRC) server** implemented in **C++98** as part of the 42 curriculum.

The project focuses on network programming, TCP sockets, non-blocking I/O, client/server communication, IRC protocol commands, channel management, and object-oriented programming.

---

## Overview

The server accepts multiple IRC clients and manages communication between them through channels or private messages.

```text
                    ┌─────────────────┐
                    │    IRC Server   │
                    │                 │
                    │  TCP / IPv4     │
                    │  select()       │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
           Client A       Client B       Client C
              │              │              │
              └──────────────┼──────────────┘
                             │
                         #channel
```

Clients connect through a TCP socket and communicate with the server using IRC-style commands.

---

## Features

### Server

* TCP/IPv4 server
* Non-blocking server socket
* Multiple simultaneous clients
* `select()`-based I/O multiplexing
* Client connection/disconnection handling
* Server-side command parsing
* Signal handling for graceful shutdown
* Port and password validation

### Client Registration

Clients can register using:

* `PASS`
* `NICK`
* `USER`

The server maintains client registration states:

```text
UNAUTHENTICATED
       │
       ▼
 AUTHENTICATED
       │
       ▼
   REGISTERED
```

Commands are only available when the client reaches the required registration state.

---

## Supported Commands

The server implements several common IRC commands:

| Command   | Description                            |
| --------- | -------------------------------------- |
| `PASS`    | Authenticate using the server password |
| `NICK`    | Set or change nickname                 |
| `USER`    | Register username and real name        |
| `JOIN`    | Join an IRC channel                    |
| `PART`    | Leave a channel                        |
| `PRIVMSG` | Send private or channel messages       |
| `KICK`    | Remove a user from a channel           |
| `INVITE`  | Invite a user to a channel             |
| `TOPIC`   | Read or modify a channel topic         |
| `MODE`    | Modify channel modes                   |
| `WHO`     | Query channel/user information         |
| `PING`    | Check connection availability          |
| `PONG`    | Respond to a ping                      |
| `QUIT`    | Disconnect from the server             |

---

### Example
![an interface](/interface.png)

### Channel Management

Channels are represented by dedicated `Channel` objects.

The implementation supports:

* Channel creation
* Joining and leaving channels
* Channel operators
* Channel topics
* Private channel keys
* Invite-only channels
* User limits
* Topic privileges
* Broadcasting messages
* Operator management

### Channel Modes

The server supports channel modes including:

```text
+i    Invite-only
+t    Topic restricted to operators
+k    Channel password/key
+l    Maximum number of users
+o    Channel operator
```

Example:

```text
MODE #42 +i
MODE #42 +k secret
MODE #42 +l 20
MODE #42 +o alice
```

---

## Message Handling

Messages can be sent either to a channel or directly to another client.

### Channel message

```text
PRIVMSG #42 :Hello everyone!
```

The server broadcasts the message to the users currently connected to the channel.

### Private message

```text
PRIVMSG alice :Hello!
```

The message is delivered directly to the target client.

---

## Network Architecture

The server uses **non-blocking TCP sockets** and `select()` to handle multiple connections without creating a thread for every client.

The main event loop follows this model:

```text
        ┌───────────────┐
        │   Server      │
        │ socket setup  │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │    select()   │
        └───────┬───────┘
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
 New connection     Client activity
        │                │
        ▼                ▼
  accept()          recv()
                         │
                         ▼
                  Parse command
                         │
                         ▼
                  Command handler
                         │
                         ▼
                     send()
```

This allows the server to monitor multiple sockets through a single event loop.

---

## Architecture

The project is divided into several main components:

```text
├── Server
│   ├── Socket management
│   ├── Client connections
│   ├── Event loop
│   └── Command dispatching
│
├── Client
│   ├── Socket
│   ├── Nickname
│   ├── Username
│   ├── Registration state
│   └── Channel membership
│
├── Channel
│   ├── Connected clients
│   ├── Operators
│   ├── Topic
│   ├── Channel key
│   └── Channel modes
│
└── Command handlers
    ├── JOIN
    ├── PART
    ├── MODE
    ├── NICK
    ├── TOPIC
    └── ...
```

---

### Main Components

**`Server`**

Responsible for socket creation, connection handling, the `select()` event loop, client management, and command dispatching.

**`Client`**

Stores client information such as socket descriptor, nickname, username, IP address, registration state, and channel membership.

**`Channel`**

Manages channel users, operators, topics, channel keys, invitations, limits, and message broadcasting.

**Command handlers**

Individual command implementations are separated into dedicated source files where appropriate.

---

## Technologies

* **C++98**
* POSIX sockets
* TCP/IP
* IPv4
* `select()`
* Non-blocking I/O
* STL containers
* Make


---

## Compilation

Clone the repository:

```bash
git clone <repository-url>
cd Internet-Relay-Chat
```

Compile:

```bash
make
```

This produces:

```text
ircserv
```

To remove object files:

```bash
make clean
```

To remove all generated files:

```bash
make fclean
```

To rebuild:

```bash
make re
```

---

## Running the Server

The server requires a port and password:

```bash
./ircserv <port> <password>
```

For example:

```bash
./ircserv 6667 mypassword
```

The server accepts ports from **6665 to 6669**.

Once started, the server listens for incoming TCP connections.

---

## Connecting a Client

You can connect using an IRC client such as **Irssi**, **WeeChat**, or another IRC-compatible client.

Example using Netcat for basic protocol testing:

```bash
nc localhost 6667
```

Then register:

```text
PASS mypassword
NICK alice
USER alice 0 * :Alice
```

After registration, commands such as:

```text
JOIN #42
PRIVMSG #42 :Hello!
```

can be used.

---

## 42 Project

`ft_irc` is part of the **42 curriculum** and is designed to provide hands-on experience with network programming and C++.

The main challenge is building a functional multi-client server while handling network events, protocol commands, client states, and channel rules within the constraints of **C++98**.
