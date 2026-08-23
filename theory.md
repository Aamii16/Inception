Absolutely. And honestly, **this is one of the most important things to realize before Inception**: Docker itself is only one piece of the puzzle. If you memorize Docker commands without understanding networking, processes, servers, HTTP, TLS, reverse proxies, volumes, DNS, etc., the project can feel like random magic.

We can build the whole mental model from **zero**, and then map everything back to what you actually need for 42's Inception.

## The big picture

Eventually, you want to be able to look at something like this:

```text
                    Internet
                       │
                       │ HTTPS :443
                       ▼
                ┌─────────────┐
                │    NGINX    │
                │ Web server / │
                │ reverse proxy│
                └──────┬──────┘
                       │
                 HTTP :9000
                       │
                       ▼
                ┌─────────────┐
                │   WordPress │
                │   PHP-FPM   │
                └──────┬──────┘
                       │
                  MariaDB :3306
                       │
                       ▼
                ┌─────────────┐
                │   MariaDB   │
                │   database  │
                └─────────────┘
```

And then you'll understand **why every box exists, why they communicate the way they do, what Docker is doing, where the files live, how the network works, and what happens when you type a URL into your browser.**

That's the goal.

---

# 1. First: what is a server?

Let's start with the word **server**, because it gets used in confusing ways.

A server isn't necessarily a special physical machine.

A **server is fundamentally a program that waits for requests and provides something in response.**

For example:

```text
Browser ───── request ─────> Web server
Browser <──── response ───── Web server
```

Suppose you visit:

```text
https://example.com
```

Your browser essentially says:

> "Hey example.com, give me the webpage."

A web server responds:

> "Sure, here is the HTML/CSS/images/etc."

### But then what's a computer server?

A physical machine can be called a server because it is **running server programs**.

For example:

```text
Physical computer
│
├── Nginx
├── MariaDB
├── SSH server
└── ...
```

The computer isn't inherently a "server."

It's acting as one because it's providing services.

---

# 2. What is a client?

This gives us another fundamental concept:

**Client = asks for something.**

**Server = provides something.**

For example:

```text
Chrome ───────────> Nginx
(client)            (server)
```

Or:

```text
WordPress ─────────> MariaDB
(client)             (server)
```

This relationship is everywhere.

Your browser is a client.

Nginx is a server.

WordPress can be a client when talking to MariaDB.

MariaDB is a server.

---

# 3. How do programs communicate?

Through **networks**.

Imagine two programs:

```text
Program A                    Program B

   🟦                           🟥
    │                            │
    └──────── network ───────────┘
```

They need some way to identify where the other program is.

That's where **IP addresses and ports** come in.

---

# 4. IP addresses

An IP address identifies a machine/interface on a network.

For example:

```text
192.168.1.20
```

You can think of it roughly as:

> "Which computer should I talk to?"

But that's not enough.

Imagine your computer is running:

```text
Nginx
SSH
MariaDB
Minecraft server
```

All on the same machine.

How does a connection know which program it wants?

That's what **ports** are for.

---

# 5. Ports

Think of an IP address as the **building address**.

A port is the **door**.

```text
192.168.1.20
       │
       ├── :22    SSH
       ├── :80    HTTP
       ├── :443   HTTPS
       └── :3306  MariaDB
```

So:

```text
192.168.1.20:80
```

means:

> "Talk to port 80 on this machine."

Ports are numbers from:

```text
0 → 65535
```

Some have conventional purposes:

| Port | Typical use   |
| ---- | ------------- |
| 22   | SSH           |
| 80   | HTTP          |
| 443  | HTTPS         |
| 3306 | MariaDB/MySQL |
| 53   | DNS           |
| 25   | SMTP          |

These aren't magical requirements. A server can technically listen on different ports.

---

# 6. So what happens when you type a website?

Let's finally follow:

```text
https://example.com
```

This introduces several concepts at once.

### Step 1 — DNS

Your computer doesn't inherently know where `example.com` is.

It asks DNS:

> "What IP address belongs to example.com?"

DNS might answer:

```text
example.com → 93.184.216.34
```

So DNS is basically the **phone book of the Internet**.

We'll go deeply into DNS later.

---

# 7. HTTP

Now your browser knows where to go.

It needs a protocol for communicating with the web server.

That's **HTTP**.

HTTP stands for:

**HyperText Transfer Protocol**

A simplified HTTP request looks like:

```text
GET / HTTP/1.1
Host: example.com
```

The server might respond:

```text
HTTP/1.1 200 OK

<html>
    ...
</html>
```

So:

```text
Browser
   │
   │ HTTP request
   ▼
Web server
   │
   │ HTTP response
   ▼
Browser
```

HTTP is essentially a **language/ruleset for web communication**.

---

# 8. Then what is HTTPS?

HTTPS is basically:

> **HTTP protected by TLS**

You'll often hear people say:

> "SSL"

But modern systems use **TLS**.

TLS = **Transport Layer Security**

SSL = older technology that TLS replaced.

So when someone says:

> "Set up SSL"

they usually mean:

> "Set up TLS/HTTPS."

---

# 9. Why do we need TLS?

Imagine you're using normal HTTP:

```text
You ────────────────> Website
        HTTP
```

Someone capable of observing the connection could potentially see the traffic.

For example, if you send:

```text
username: alice
password: secret123
```

you don't want that exposed.

TLS establishes an encrypted connection:

```text
You ═════════════════> Website
          TLS
       encrypted
```

Now intercepted traffic looks like meaningless encrypted data.

TLS provides three major properties:

### 1. Encryption

Other people shouldn't be able to read the communication.

### 2. Authentication

The browser can verify that it's actually communicating with the intended website/server.

### 3. Integrity

Someone shouldn't be able to secretly modify the data while it's traveling.

---

# 10. What is an SSL/TLS certificate?

You've probably seen this:

```text
🔒 https://example.com
```

Behind that is a **certificate**.

Very roughly, a certificate says:

> "This public key belongs to example.com, and a trusted Certificate Authority has verified this."

The important concepts you'll eventually need are:

* private key
* public key
* certificate
* Certificate Authority (CA)
* encryption
* asymmetric cryptography
* symmetric cryptography
* TLS handshake

Don't worry if those words mean nothing yet.

We'll build them from scratch.

---

# 11. Now: what is Nginx?

This is where Inception starts making much more sense.

**Nginx is software.**

It can act as a:

* web server
* reverse proxy
* load balancer
* HTTP server
* TLS termination point

For Inception, the important concepts are primarily:

**web server + reverse proxy + TLS termination.**

---

# 12. Why do we need Nginx?

Imagine WordPress directly exposed to the Internet.

```text
Internet
   │
   ▼
WordPress
```

You could technically build things that way.

But normally you want a dedicated component responsible for handling incoming web traffic.

So:

```text
Internet
   │
   ▼
  Nginx
   │
   ▼
WordPress
```

Nginx receives the external HTTP/HTTPS requests.

It can:

* handle TLS
* accept connections
* inspect HTTP requests
* serve static files
* forward requests
* control access
* perform routing

---

# 13. Nginx as a reverse proxy

This is one of the **most important concepts for Inception**.

Suppose:

```text
Browser
   │
   ▼
 Nginx
   │
   ▼
WordPress
```

The browser doesn't necessarily communicate directly with WordPress.

It communicates with Nginx.

Nginx then says:

> "This request needs to go to WordPress."

and forwards it.

That's a **reverse proxy**.

```text
                 Internal network

Internet
   │
   │ HTTPS
   ▼
┌────────┐
│ Nginx  │
└───┬────┘
    │ HTTP
    ▼
┌────────────┐
│ WordPress  │
└────────────┘
```

This is fundamentally different from a normal forward proxy.

We'll cover that distinction later.

---

# 14. Why not just have WordPress handle HTTPS?

You could build systems differently, but separating responsibilities is useful.

Nginx can handle:

```text
HTTPS
  ↓
TLS
  ↓
HTTP
  ↓
forward request
```

WordPress/PHP can focus on:

```text
"Generate the website."
```

This is an example of **separation of concerns**.

One component handles networking/security.

Another handles application logic.

Another handles data.

---

# 15. What is PHP-FPM?

This is another thing that often confuses people in Inception.

You may think:

> "WordPress is PHP, so Nginx sends requests to PHP."

Not exactly.

Nginx itself doesn't execute PHP.

Instead, you commonly have:

```text
Nginx
  │
  │ FastCGI
  ▼
PHP-FPM
  │
  ▼
PHP application
```

PHP-FPM stands for:

**PHP FastCGI Process Manager**

Its job is essentially to keep PHP processes available to execute PHP code.

So:

```text
Browser
   ↓
Nginx
   ↓
PHP-FPM
   ↓
WordPress PHP code
```

That's another protocol/concept we'll learn: **FastCGI**.

---

# 16. And where does MariaDB fit?

WordPress needs to store data.

For example:

* users
* passwords (hashed)
* posts
* comments
* configuration
* metadata
* etc.

That data belongs in a **database**.

So:

```text
WordPress
    │
    │ SQL
    ▼
MariaDB
```

MariaDB is a **database server**.

Notice the architecture developing:

```text
                    Internet
                        │
                     HTTPS
                        │
                        ▼
                  ┌──────────┐
                  │  Nginx   │
                  └────┬─────┘
                       │
                    FastCGI
                       │
                       ▼
                 ┌───────────┐
                 │ PHP-FPM / │
                 │ WordPress │
                 └─────┬─────┘
                       │
                       │ SQL
                       ▼
                  ┌─────────┐
                  │ MariaDB │
                  └─────────┘
```

**This architecture is the heart of Inception.**

---

# 17. Now we finally get to Docker

Docker solves a different problem.

Imagine your machine has:

```text
Nginx
PHP
PHP extensions
MariaDB
WordPress
configs
dependencies
```

Everything is installed directly onto your operating system.

You can run into:

> "It works on my machine."

Maybe you have:

```text
PHP 8.3
```

but somebody else has:

```text
PHP 8.1
```

Maybe you installed 14 dependencies.

Maybe your configuration conflicts with another project.

Docker gives you **isolated environments**.

---

# 18. What is a container?

A container is an isolated environment for running processes.

Conceptually:

```text
Computer
│
├── Container A
│     └── Nginx
│
├── Container B
│     └── WordPress/PHP
│
└── Container C
      └── MariaDB
```

Instead of installing everything directly into the host environment, you package the application environment.

---

# 19. Containers are NOT virtual machines

This is extremely important.

A VM looks conceptually like:

```text
Physical machine
│
├── Host OS
│
└── Hypervisor
     │
     ├── VM
     │    ├── Guest OS
     │    └── Application
     │
     └── VM
          ├── Guest OS
          └── Application
```

Containers are different:

```text
Physical machine
│
├── Host OS
│
└── Container runtime
     │
     ├── Container
     │    └── Application
     │
     ├── Container
     │    └── Application
     │
     └── Container
          └── Application
```

Containers share the host's **kernel**.

That distinction is fundamental.

---

# 20. Why do containers feel like separate machines?

Because Linux provides mechanisms for isolating processes.

The important Linux concepts are:

### Namespaces

They isolate what processes can see.

For example:

```text
Container A sees:
  PID 1
  PID 2
  ...

Container B sees:
  PID 1
  PID 2
  ...
```

They can have different process/network/mount environments.

### cgroups

Control and account for resources.

For example:

```text
Container A
CPU: limited
RAM: limited

Container B
CPU: limited
RAM: limited
```

These are two major pieces behind Linux containerization.

---

# 21. Docker isn't actually the container itself

This distinction is useful.

Docker provides tools and a platform for creating/running containers.

Underneath, Linux container technology involves things such as:

* namespaces
* cgroups
* filesystem isolation
* capabilities
* networking
* container runtimes

Docker makes these things much easier to use.

So when you run:

```bash
docker run ...
```

you're asking Docker to create/run a container using the underlying container infrastructure.

---

# 22. What is a Docker image?

A **Docker image** is basically a packaged filesystem + metadata/instructions used to create containers.

Think:

```text
IMAGE
  ↓
create
  ↓
CONTAINER
```

You don't normally modify an image directly while it's running.

You create containers from it.

For example:

```text
nginx image
     │
     ├── Container 1
     ├── Container 2
     └── Container 3
```

Same image can produce multiple containers.

---

# 23. Dockerfile

A Dockerfile describes how to build an image.

Conceptually:

```dockerfile
FROM debian

RUN install nginx

COPY nginx.conf ...

CMD ["nginx", ...]
```

Meaning roughly:

> Start from this base filesystem, install things, copy configuration, and specify what should run.

Then:

```text
Dockerfile
    ↓
docker build
    ↓
Image
    ↓
docker run
    ↓
Container
```

This pipeline is absolutely worth understanding.

---

# 24. Why separate containers?

In Inception you typically have:

```text
Nginx container
        │
        ▼
WordPress/PHP container
        │
        ▼
MariaDB container
```

Why not:

```text
ONE BIG CONTAINER
│
├── Nginx
├── PHP
├── WordPress
└── MariaDB
```

Because containers are generally designed around **one main service/responsibility**.

You want:

```text
Container = Nginx
Container = WordPress/PHP-FPM
Container = MariaDB
```

This gives cleaner isolation and management.

---

# 25. How do containers talk to each other?

Docker networking.

You might have:

```text
              Docker network
       ┌─────────────────────────┐
       │                         │
       │  nginx ───── wordpress  │
       │             │           │
       │             │           │
       │           mariadb       │
       │                         │
       └─────────────────────────┘
```

Docker creates a virtual network.

Containers on that network can communicate with each other.

And here's a beautiful Docker concept:

Instead of hardcoding:

```text
192.168.50.23
```

you can often communicate using the **container/service name**.

For example:

```text
wordpress → mariadb:3306
```

Docker's internal DNS resolves the service/container name.

This brings us back to **DNS**.

---

# 26. Container ports vs host ports

This is another major Inception concept.

Suppose Nginx listens inside the container on:

```text
443
```

That doesn't automatically mean the whole Internet can access it.

You can map:

```text
Host :443
      ↓
Container :443
```

For example conceptually:

```text
Internet
   │
   ▼
Host port 443
   │
   ▼
Container port 443
   │
   ▼
Nginx
```

This is **port publishing/mapping**.

Meanwhile, WordPress might listen internally on:

```text
9000
```

but you don't necessarily publish 9000 to the Internet.

Instead:

```text
Nginx container
      │
      │ internal Docker network
      ▼
WordPress container :9000
```

That's an important security/design principle:

> **Only expose what needs to be exposed.**

---

# 27. What about storage?

Here's a huge containerization problem.

Suppose MariaDB stores its database inside the container.

Then you delete the container.

What happens?

Potentially:

```text
Container deleted
       ↓
database filesystem gone
       ↓
💀
```

That's why we need **volumes**.

A volume allows persistent data to live outside the disposable container layer.

Conceptually:

```text
MariaDB container
       │
       ▼
   /var/lib/mysql
       │
       ▼
Docker volume
       │
       ▼
Persistent storage
```

Now:

```text
delete container
       ↓
create new container
       ↓
attach same volume
       ↓
database still exists
```

This leads to another major concept:

**ephemeral vs persistent data.**

---

# 28. Containers are meant to be disposable

This is one of the biggest mindset changes when learning Docker.

Don't think:

> "My container is my server and I'll manually modify it forever."

Think:

> "My container is a reproducible instance created from an image."

If something is wrong:

```text
old container
    ↓
destroy
    ↓
build/fix image
    ↓
create new container
```

Persistent data goes into volumes.

Configuration should be reproducible.

---

# 29. Docker Compose

Now suppose you have:

```text
Nginx
WordPress
MariaDB
Network
Volumes
Environment variables
```

Managing everything individually becomes annoying.

Docker Compose lets you describe the whole application stack.

Conceptually:

```text
compose.yml

services:
    nginx
    wordpress
    mariadb

networks:
    ...

volumes:
    ...
```

Then Compose can create the architecture.

Think of it as:

> **"Here is the blueprint for my entire multi-container application."**

---

# 30. Environment variables

You'll also encounter things like:

```text
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
```

Environment variables are values provided to a process through its environment.

For example:

```text
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
```

Your application can read those values.

This is useful because you don't want to hardcode configuration everywhere.

---

# 31. But passwords are special

You should understand the difference between:

**configuration**

and

**secrets**.

For example:

```text
database name = wordpress
```

is generally not a secret.

But:

```text
database password = ********
```

is a secret.

Docker has mechanisms for handling secrets, though the exact requirements depend on the project.

For 42, you'll need to understand where credentials are stored and how they're passed around rather than blindly copying examples.

---

# 32. There are a LOT more concepts

And this is where I think we should structure your learning instead of throwing 50 definitions at you.

For Inception, I would divide the theory into **layers**.

## Layer 1 — Computer/network fundamentals

Learn:

* client vs server
* processes
* ports
* IP addresses
* TCP
* UDP
* sockets
* localhost
* loopback
* LAN/WAN
* routing
* DNS
* `/etc/hosts`

---

## Layer 2 — Web fundamentals

Learn:

* HTTP
* HTTP request
* HTTP response
* HTTP methods
* status codes
* headers
* cookies
* sessions
* URLs
* domains
* MIME types
* static vs dynamic content

---

## Layer 3 — Security

Learn:

* HTTP vs HTTPS
* TLS
* SSL terminology
* certificates
* public/private keys
* Certificate Authorities
* TLS handshake
* encryption
* hashing
* password hashing
* authentication vs authorization

---

## Layer 4 — Web servers

Learn:

* what a web server actually does
* Nginx
* server blocks
* listening sockets
* reverse proxy
* forward proxy
* FastCGI
* PHP-FPM
* static files
* dynamic applications

---

## Layer 5 — Databases

Learn:

* database
* DBMS
* SQL
* tables
* rows
* columns
* primary keys
* relationships
* transactions
* MariaDB/MySQL
* database users
* database authentication
* database persistence

---

## Layer 6 — Linux

This is **very important for 42**.

Learn:

* processes
* PID
* PID 1
* signals
* `fork`
* `exec`
* permissions
* users/groups
* filesystem
* mounts
* `/proc`
* `/sys`
* environment variables
* daemons
* foreground/background processes
* logs
* sockets

---

## Layer 7 — Containerization

Then learn:

* virtualization vs containerization
* Docker
* Docker Engine
* Docker CLI
* Docker daemon
* Docker image
* Docker container
* Dockerfile
* image layers
* build context
* registries
* Docker Hub
* container lifecycle
* namespaces
* cgroups
* capabilities
* container filesystem

---

## Layer 8 — Docker networking

Learn:

* bridge networks
* container IPs
* Docker DNS
* port publishing
* `EXPOSE`
* `-p`
* inter-container communication
* host networking
* network namespaces

---

## Layer 9 — Docker storage

Learn:

* writable container layer
* bind mounts
* volumes
* persistent data
* mount points
* database persistence

---

## Layer 10 — Docker Compose

Learn:

* services
* networks
* volumes
* dependencies
* environment variables
* build
* image
* restart policies
* health checks
* Compose networking

---

# 33. And then there's the actual Inception architecture

After those foundations, we can reconstruct your project from zero:

```text
                         INTERNET
                             │
                             │
                         DNS / hosts
                             │
                             ▼
                       Host machine
                             │
                         port 443
                             │
                    ┌────────▼────────┐
                    │     NGINX       │
                    │                 │
                    │ TLS certificate │
                    │ private key     │
                    └────────┬────────┘
                             │
                       Docker network
                             │
                    ┌────────▼────────┐
                    │  WordPress /    │
                    │    PHP-FPM      │
                    └────────┬────────┘
                             │
                         SQL :3306
                             │
                    ┌────────▼────────┐
                    │    MariaDB      │
                    └────────┬────────┘
                             │
                         Volume
                             │
                    ┌────────▼────────┐
                    │ Persistent data │
                    └─────────────────┘
```

At that point, **nothing in this diagram should feel mysterious.**

You'll be able to point at each arrow and say:

> "This is TCP."

> "This is HTTP."

> "This is HTTPS."

> "This is TLS."

> "This is FastCGI."

> "This is SQL."

> "This is Docker's internal network."

> "This is a published host port."

> "This is persistent storage."

And, more importantly, you'll know **why it is there**.

---

# 34. One very important distinction

Don't try to memorize definitions like:

> "Nginx is a reverse proxy."

Instead ask:

### What problem does it solve?

For example:

**Problem:** I have an application that shouldn't directly handle Internet-facing TLS/network traffic.

**Solution:** Put Nginx in front of it.

```text
Internet
   ↓
Nginx
   ↓
Application
```

Then:

**Problem:** My application needs a database.

**Solution:** MariaDB.

```text
Application
     ↓
 MariaDB
```

Then:

**Problem:** I don't want my application environment to depend on my host machine.

**Solution:** Containerization.

```text
Host
 ├── container
 ├── container
 └── container
```

Then:

**Problem:** Containers can disappear, but my database must survive.

**Solution:** Persistent volumes.

```text
Container ───── Volume
```

That's how I want you to learn this.

---

# 35. The order I'd teach you

Rather than giving you a giant textbook dump, I'd suggest we go through it **like a course**, one layer at a time.

### Part 1 — The Internet

We'll start with:

```text
What actually happens when I type google.com?
```

and learn:

**DNS → IP → TCP → port → HTTP → response**

### Part 2 — HTTP

We'll dissect a real HTTP request:

```text
GET /index.php HTTP/1.1
Host: example.com
Cookie: ...
```

and understand every piece.

### Part 3 — HTTPS/TLS

We'll build the intuition for:

```text
public key
private key
certificate
CA
TLS handshake
encryption
```

without drowning in cryptography.

### Part 4 — Nginx

We'll actually understand:

```text
listen 443 ssl;
server_name ...
location ...
proxy_pass ...
fastcgi_pass ...
```

instead of treating Nginx configuration as magic.

### Part 5 — PHP-FPM + WordPress + MariaDB

We'll follow a request all the way through:

```text
Browser
 ↓
Nginx
 ↓
PHP-FPM
 ↓
WordPress
 ↓
MariaDB
 ↓
WordPress
 ↓
PHP-FPM
 ↓
Nginx
 ↓
Browser
```

### Part 6 — Linux processes

We'll understand why containers need a process, what PID 1 is, signals, foreground processes, and why things like:

```bash
CMD
ENTRYPOINT
```

matter.

### Part 7 — Docker

Then:

```text
Dockerfile
   ↓
Image
   ↓
Container
```

and we'll dig into what is actually happening underneath.

### Part 8 — Docker networking

We'll make:

```text
nginx ↔ wordpress ↔ mariadb
```

work and understand **how** it works.

### Part 9 — Volumes

We'll understand why:

```text
rm container
```

shouldn't mean:

```text
💀 database gone
```

### Part 10 — Compose

Finally we'll assemble everything.

And then we'll take the **actual Inception requirements** and translate every requirement into the underlying theory.

---

The most important thing is: **don't worry that you currently don't know what you don't know.** That's exactly what makes this difficult. Docker tutorials often start halfway through the story and casually throw around words like *daemon, socket, bridge network, reverse proxy, TLS termination, FastCGI, volume, namespace,* and *PID 1* as though everyone already understands them.

We can fill those gaps **from the ground up**.

If you're ready, I'd start with **Part 1: "What actually happens when I type `https://something.com` into my browser?"** That's the foundation that makes almost everything else—Nginx, ports, DNS, TCP, HTTPS, Docker networking—click into place.
 Absolutely — and since you've already done **Webserv**, we can go much deeper than the usual beginner explanation without wasting time on HTTP/client-server basics.

I'll treat this as a **theory course for Inception**, with the goal that by the end you can explain the architecture rather than just make it work.

Your requested scope is:

1. **Networking:** TCP, UDP, DNS, plus a few things that become important for Docker
2. **Web basics:** domains + static vs dynamic content
3. **Security:** TLS/SSL, certificates, public/private keys, CA, handshake, encryption, hashing, authentication/authorization
4. **Web server:** listening sockets *inside containers* vs host/web server
5. **Database:** persistence only
6. **Linux:** most container-relevant Linux concepts
7. **Docker:** everything
8. **Docker networking:** everything
9. **Docker storage:** everything
10. **Docker Compose:** everything

Let's do it properly.

---

# PART 1 — Networking

Since you've done Webserv, you probably already have this mental model:

```text
client
   │
   │ connect()
   ▼
server socket
   │
   │ accept()
   ▼
client socket
```

And you've probably worked with:

```cpp
socket()
bind()
listen()
accept()
recv()
send()
```

That's great.

Now we're going to zoom **below** that level and understand what TCP and UDP are actually doing.

---

# 1. TCP vs UDP — the fundamental idea

TCP and UDP are both **transport-layer protocols**.

Their job is essentially:

> Take data produced by an application and get it between two endpoints across a network.

You can think of the stack approximately like this:

```text
Application
    │
    │ HTTP
    ▼
Transport
    │
    │ TCP / UDP
    ▼
Internet
    │
    │ IP
    ▼
Network hardware
    │
    ▼
Ethernet / Wi-Fi
```

For example, when your browser communicates with an HTTPS server:

```text
HTTP
  ↓
TLS
  ↓
TCP
  ↓
IP
  ↓
Ethernet/Wi-Fi
```

Docker networking will eventually make much more sense once this stack is clear.

---

# 2. What does TCP actually provide?

TCP gives you a **reliable, ordered byte stream** between two endpoints.

Those words are extremely important.

### Reliable

If data gets lost, TCP can detect that and retransmit it.

### Ordered

Suppose you send:

```text
A B C D E
```

and packets arrive:

```text
A C B E D
```

Your application shouldn't have to deal with that.

TCP reassembles the stream into:

```text
A B C D E
```

### Byte stream

This one is especially important.

TCP doesn't understand:

```text
HTTP request #1
HTTP request #2
```

It just sees:

```text
bytes bytes bytes bytes bytes...
```

That's why in Webserv you cannot assume:

```cpp
recv(...)
```

means:

> "I received exactly one HTTP request."

You already encountered this, probably through partial reads and HTTP parsing.

TCP is a **stream**, not a message protocol.

---

# 3. TCP packets

When you send a lot of data:

```text
Hello, this is a very long message...
```

TCP doesn't necessarily send it as one giant thing.

The data gets divided into pieces and transported in **TCP segments**, which travel inside IP packets.

Very simplified:

```text
Application
     │
     │ 10 KB
     ▼
    TCP
     │
     ├── segment
     ├── segment
     ├── segment
     └── segment
          │
          ▼
          IP
```

The receiving TCP stack reconstructs the stream.

---

# 4. How does TCP know whether something was lost?

This is where **sequence numbers** and **acknowledgements** come in.

Imagine:

```text
Sender                         Receiver

  DATA #1 ──────────────────────>
  DATA #2 ──────────────────────>
  DATA #3 ──────────────────────>
  
             <────────────────── ACK
```

The receiver acknowledges what it received.

If something doesn't arrive:

```text
DATA #1 ────────────────────────>
DATA #2 ────────X

DATA #3 ────────────────────────>
```

The sender eventually realizes:

> "Something is missing."

and retransmits.

That's one of the fundamental mechanisms that makes TCP reliable.

---

# 5. TCP three-way handshake

You probably know this already, but let's make the reason behind it clear.

Before TCP starts transmitting application data, the endpoints establish a connection.

Conceptually:

```text
Client                         Server

   SYN ─────────────────────────>
   
       <──────────────── SYN-ACK
   
   ACK ─────────────────────────>
```

### SYN

> "I want to establish a TCP connection."

### SYN-ACK

> "I received your request, and I also want to establish the connection."

### ACK

> "Got it."

Now the connection is established.

This is why when your Webserv does:

```cpp
listen()
```

and later:

```cpp
accept()
```

there is a whole TCP mechanism happening underneath your code.

---

# 6. What is a TCP connection?

This is subtle but important for Docker later.

A TCP connection is identified by a combination roughly like:

```text
source IP
source port
destination IP
destination port
protocol = TCP
```

For example:

```text
192.168.1.50:52341
        ↓
192.168.1.100:443
```

So multiple clients can connect to:

```text
server:443
```

because their **source ports/IPs differ**.

That's how one Nginx server can handle thousands of connections on port 443.

---

# 7. UDP

UDP is much simpler.

UDP basically says:

> "Here's a datagram. Send it."

There isn't the same TCP connection establishment.

No:

```text
SYN
SYN-ACK
ACK
```

No built-in guarantee that the packet arrives.

No built-in guarantee that packets arrive in order.

No built-in retransmission mechanism.

Conceptually:

```text
Sender                     Receiver

 DATA #1 ───────────────────>
 DATA #2 ─────────X

 DATA #3 ───────────────────>
```

The application is responsible for dealing with loss/order if it cares.

---

# 8. Why would anyone use UDP?

Because all that TCP reliability has a cost.

UDP is lightweight and has lower protocol overhead.

It's useful when:

* speed matters
* occasional packet loss is acceptable
* the application handles reliability itself
* you don't want connection-oriented behavior

Examples include:

* DNS
* DHCP
* streaming/real-time applications
* many multiplayer games
* some modern protocols such as QUIC

---

# 9. TCP vs UDP mental model

Think:

### TCP

> "I want a reliable conversation."

```text
connection
reliability
ordering
retransmission
byte stream
```

### UDP

> "Here's a packet. Good luck."

```text
datagrams
no connection
no guaranteed delivery
no guaranteed ordering
low overhead
```

---

# 10. Why does DNS use UDP?

This brings us nicely to DNS.

DNS is usually a **request/response** interaction.

Your computer asks:

```text
"What is the IP of example.com?"
```

The DNS server responds:

```text
"93.184.216.34"
```

That's a very small exchange.

Using TCP's full connection machinery for every little DNS query would be unnecessarily expensive.

So traditionally DNS uses:

```text
UDP :53
```

There are exceptions where DNS uses TCP, such as certain large responses and zone transfers.

---

# PART 2 — DNS

DNS is much more interesting than simply:

> "domain → IP."

That's the basic idea, but let's understand what actually happens.

---

# 11. Domain names

Suppose you type:

```text
https://www.example.com
```

The domain is:

```text
example.com
```

and:

```text
www
```

is a **subdomain**.

The domain name has a hierarchy.

Read it from right to left:

```text
www.example.com
│   │       │
│   │       └── TLD
│   └────────── domain
└────────────── subdomain
```

For:

```text
example.com
```

`.com` is the **TLD** (Top-Level Domain).

Examples:

```text
.com
.org
.net
.ma
.fr
.uk
```

Then:

```text
example.com
```

is a domain under `.com`.

And:

```text
www.example.com
api.example.com
mail.example.com
```

are names under `example.com`.

---

# 12. DNS is distributed

This is a really important concept.

There isn't one giant database somewhere saying:

```text
google.com → 142.250...
github.com → ...
example.com → ...
```

DNS is **distributed and hierarchical**.

Very roughly:

```text
                    Root
                     │
          ┌──────────┼──────────┐
         .com       .org       .ma
           │
         example
           │
        www.example
```

Different DNS servers are responsible for different portions of this hierarchy.

---

# 13. Root DNS servers

At the top is the **DNS root**.

You can conceptually think:

```text
"Who handles .com?"
```

The root can point you toward the `.com` DNS infrastructure.

Then:

```text
"Who handles example.com?"
```

The `.com` infrastructure can point you toward the authoritative DNS servers for `example.com`.

Then:

```text
"What is www.example.com?"
```

The authoritative DNS server can answer.

---

# 14. Recursive DNS resolver

But your computer usually doesn't perform all of this itself.

Instead, it talks to a **recursive DNS resolver**.

For example:

```text
Your computer
      │
      │ "What's example.com?"
      ▼
Recursive resolver
      │
      ├── asks root
      ├── asks .com
      └── asks authoritative server
```

Then it returns the answer to you.

---

# 15. DNS caching

Now imagine millions of people ask:

```text
"What is google.com?"
```

You don't want the resolver performing the entire hierarchy every single time.

So DNS responses are **cached**.

DNS records have a **TTL**:

**Time To Live**

For example:

```text
google.com → 142.250.x.x
TTL = 300 seconds
```

The resolver can cache that result for 300 seconds.

This is why DNS changes aren't always instantly visible everywhere.

---

# 16. DNS records

DNS doesn't only store IP addresses.

There are several record types.

### A

Domain → IPv4 address

```text
example.com → 93.184.216.34
```

### AAAA

Domain → IPv6 address

```text
example.com → 2606:...
```

### CNAME

An alias.

```text
www.example.com
        ↓
example.com
```

### MX

Mail server information.

```text
example.com → mail.example.com
```

### TXT

Arbitrary textual information used for various purposes, including domain verification and email-security mechanisms.

There are others, but these are enough for now.

---

# 17. How does your computer know which DNS resolver to use?

Your operating system gets DNS configuration from somewhere.

Often through **DHCP** when joining a network.

For example:

```text
DHCP
 ↓
"Use DNS server 192.168.1.1"
```

Your OS then knows:

```text
DNS resolver = ...
```

You can inspect DNS-related configuration on Linux through tools/files such as:

```bash
resolvectl
```

and, depending on the system:

```text
/etc/resolv.conf
```

Modern Linux systems may have `systemd-resolved` managing this.

---

# 18. `/etc/hosts`

This one is particularly relevant to Inception.

Linux can resolve hostnames locally using:

```text
/etc/hosts
```

For example:

```text
127.0.0.1    localhost
127.0.1.1    mymachine
```

You can add:

```text
127.0.0.1    mywebsite.local
```

Then:

```text
mywebsite.local
```

can resolve locally without asking external DNS, depending on the system's name-resolution configuration.

This becomes relevant when you're developing locally and need a domain name pointing to your machine.

---

# PART 3 — Domains

You specifically asked about domains.

A **domain name is human-friendly naming for network resources**.

Instead of remembering:

```text
142.250.72.14
```

you remember:

```text
google.com
```

But there's another important concept:

### Domain ≠ website

A domain is a name.

A website is an application/service accessible through that name.

You can have:

```text
example.com
```

pointing to one server.

You can have:

```text
api.example.com
```

pointing somewhere completely different.

And:

```text
mail.example.com
```

could point to yet another service.

---

# PART 4 — Static vs Dynamic Content

This distinction becomes relevant when understanding Nginx + WordPress.

## Static content

A static resource is essentially:

> "Give me this file."

For example:

```text
index.html
style.css
logo.png
script.js
```

Nginx can simply read:

```text
/path/to/style.css
```

and send it to the browser.

```text
Browser
   │
   │ GET /style.css
   ▼
Nginx
   │
   │ read file
   ▼
style.css
```

Nothing needs to be computed.

---

# 19. Dynamic content

Dynamic content means:

> The response is generated based on some logic/data/request.

For example, WordPress receives:

```text
GET /my-post
```

and might:

1. execute PHP
2. query MariaDB
3. retrieve the post
4. construct HTML
5. return it

So:

```text
Browser
   │
   ▼
Nginx
   │
   ▼
PHP / WordPress
   │
   ▼
MariaDB
   │
   ▼
WordPress generates HTML
   │
   ▼
Nginx
   │
   ▼
Browser
```

The response isn't simply:

```text
cat somefile.html
```

It's generated.

That's **dynamic content**.

---

# PART 5 — Security

Now we're getting into one of the most important parts of Inception.

# 20. HTTP vs HTTPS

HTTP:

```text
Browser ───── HTTP ─────> Server
```

HTTPS:

```text
Browser ═════ TLS ═══════> Server
             ↑
           HTTP
```

HTTPS isn't a completely different application protocol.

It's essentially:

```text
HTTP
 +
TLS
```

---

# 21. What problem does TLS solve?

Imagine you're on a network and send:

```text
GET /private/account
Cookie: session=abc123
```

Without encryption, someone capable of observing traffic might read it.

TLS aims to provide:

### Confidentiality

Others can't read the traffic.

### Integrity

Others can't silently modify the traffic.

### Authentication

Your browser can verify the server's identity through certificates and trusted CAs.

---

# 22. Symmetric encryption

Let's start with the simpler kind.

Suppose Alice and Bob share a secret:

```text
secret key = XYZ
```

Alice encrypts:

```text
"hello"
```

with XYZ.

Bob uses the same key:

```text
XYZ
```

to decrypt it.

```text
Alice
  │
  │ encrypt with KEY
  ▼
encrypted data
  │
  ▼
Bob
  │
  │ decrypt with KEY
  ▼
"hello"
```

That's **symmetric encryption**.

Same secret key for encryption/decryption.

It's fast.

---

# 23. The problem with symmetric encryption

How do Alice and Bob initially agree on:

```text
KEY = XYZ
```

without somebody intercepting it?

If Alice sends:

```text
"Here is our secret key: XYZ"
```

an attacker could steal it.

This is where asymmetric cryptography helps.

---

# 24. Public and private keys

Asymmetric cryptography uses a pair:

```text
PUBLIC KEY
PRIVATE KEY
```

The public key can be shared.

The private key must remain secret.

Conceptually:

```text
               Server
            ┌───────────┐
            │ Public key │ ← share
            │ Private key│ ← SECRET
            └───────────┘
```

The exact cryptographic mathematics is complicated, but the important concept is:

> The two keys are mathematically related and allow operations that wouldn't be possible with a normal shared secret.

---

# 25. Why can't everyone just use public/private encryption forever?

Because asymmetric cryptography is comparatively expensive.

Symmetric encryption is much faster.

So TLS uses both.

Very roughly:

```text
Asymmetric cryptography
        ↓
securely establish/agree on
        ↓
symmetric session key
        ↓
use fast symmetric encryption
        ↓
encrypt actual traffic
```

That's a crucial idea.

---

# 26. What is a certificate?

Here's where things become interesting.

Suppose your browser connects to:

```text
example.com
```

The server gives the browser a certificate containing information such as:

```text
Domain: example.com
Public key: ABC...
Issued by: Some CA
Validity: ...
```

The certificate essentially helps establish:

> "This public key is associated with example.com."

But who do you trust?

---

# 27. Certificate Authorities

That's what **Certificate Authorities (CAs)** are for.

A CA is a trusted organization that can issue certificates.

Your operating system/browser comes with a collection of trusted CA certificates.

So conceptually:

```text
Browser
   │
   │ trusts
   ▼
CA certificate
   │
   │ verifies
   ▼
example.com's certificate
   │
   │ contains
   ▼
example.com's public key
```

This forms a **chain of trust**.

---

# 28. Why can't an attacker simply create a certificate for Google?

They could create one.

The problem is:

```text
attacker certificate
       ↓
signed by attacker
       ↓
browser doesn't trust attacker
       ↓
❌
```

The browser wants a certificate that chains back to a trusted CA.

---

# 29. TLS handshake — conceptual version

Let's simplify the modern TLS handshake heavily.

You connect:

```text
Browser
   │
   │ ClientHello
   ▼
Server
```

The client and server negotiate things like:

* TLS version
* cryptographic algorithms
* key exchange parameters

The server sends its certificate.

The browser verifies the certificate.

Then the cryptographic handshake establishes shared keying material.

Eventually:

```text
Browser ═══════════════════ Server
           encrypted
           connection
```

Now HTTP can travel through that encrypted connection.

---

# 30. Important correction: the certificate doesn't encrypt the whole website

This is a common misconception.

People sometimes imagine:

```text
certificate
    ↓
encrypt everything
```

Not really.

The certificate primarily participates in **authentication and establishment of trust/key exchange**.

Once the TLS session is established, the actual application traffic is normally protected using efficient **symmetric encryption**.

---

# 31. Private key

The server has a private key corresponding to its certificate/public key.

For example:

```text
/etc/nginx/ssl/
├── certificate.crt
└── private.key
```

The private key is extremely sensitive.

If someone steals it, depending on the circumstances and cryptographic setup, they may be able to impersonate the server or compromise aspects of its security.

That's why:

```text
private.key
```

should have restrictive permissions.

---

# 32. TLS vs SSL

You'll encounter both names.

Historically:

```text
SSL 1.0
SSL 2.0
SSL 3.0
```

Then:

```text
TLS 1.0
TLS 1.1
TLS 1.2
TLS 1.3
```

Modern secure systems use TLS.

**SSL is obsolete.**

But people still casually say:

> "SSL certificate"

when they mean:

> "TLS certificate."

For Inception, you'll almost certainly encounter this terminology.

---

# 33. Encryption vs hashing

These are very different.

### Encryption

You can decrypt it with the appropriate key.

```text
plaintext
   ↓ encrypt
ciphertext
   ↓ decrypt
plaintext
```

### Hashing

You produce a one-way digest.

```text
password
   ↓
hash function
   ↓
digest
```

The idea is not:

```text
digest → original password
```

You generally cannot simply reverse a cryptographic hash.

---

# 34. Why hash passwords?

Suppose a database contains:

```text
username | password
alice    | secret123
```

If the database gets stolen, the attacker immediately knows the password.

Instead, the application stores something like:

```text
username | password_hash
alice    | $2b$...
```

When Alice logs in:

```text
entered password
       ↓
hash/verify
       ↓
compare with stored hash
```

Modern password hashing uses dedicated password-hashing algorithms such as bcrypt, Argon2, etc., rather than simply doing:

```text
SHA256(password)
```

We'll keep this distinction clear:

> **Hashing passwords ≠ encrypting passwords.**

---

# 35. Authentication vs authorization

Another important security distinction.

### Authentication

> "Who are you?"

For example:

```text
username + password
```

### Authorization

> "What are you allowed to do?"

For example:

```text
Alice → can read posts
Alice → cannot delete users
Admin → can delete users
```

So:

```text
Authentication
      ↓
"Who are you?"
      ↓
Authorization
      ↓
"What can you do?"
```

---

# PART 6 — Linux concepts you need for Docker

Now we're going to get much closer to the actual containerization theory.

You don't need to become a Linux kernel developer for Inception.

But you should understand what Linux is doing underneath Docker.

---

# 36. Everything is a process

A running program becomes a **process**.

For example:

```text
nginx
php-fpm
mariadbd
```

are processes.

Linux assigns each process a PID:

```text
PID 1
PID 237
PID 421
```

You can inspect processes with:

```bash
ps
```

or:

```bash
ps aux
```

or:

```bash
top
```

---

# 37. Process tree

Processes form relationships.

You might see:

```text
PID 1
 ├── process A
 │    └── process B
 └── process C
```

You can inspect relationships with tools such as:

```bash
pstree
```

This becomes extremely relevant in containers.

---

# 38. Foreground vs background

Suppose your container runs:

```bash
nginx
```

Depending on configuration, Nginx might daemonize itself and move into the background.

But a container needs a main process to stay alive.

Conceptually:

```text
container
   │
   └── main process
          │
          └── must remain running
```

If the main process exits:

```text
PID 1 exits
   ↓
container stops
```

This is why Docker's:

```dockerfile
CMD
ENTRYPOINT
```

are so important.

We'll go deep into them later.

---

# 39. Signals

Linux processes communicate/control each other using **signals**.

Examples:

```text
SIGTERM
SIGKILL
SIGINT
SIGHUP
```

For example:

```bash
kill -TERM 123
```

means:

> Send SIGTERM to PID 123.

Docker uses signals when stopping containers.

For example, conceptually:

```text
docker stop
    ↓
SIGTERM
    ↓
application gets chance to shut down cleanly
```

If it doesn't stop after the grace period, Docker may eventually use:

```text
SIGKILL
```

SIGKILL is much more forceful.

The process cannot catch/handle SIGKILL.

---

# 40. PID 1

This deserves special attention.

On a normal Linux system:

```text
PID 1
```

is the first userspace process.

Traditionally something like:

```text
systemd
```

might be PID 1.

Inside a container, however, you might have:

```text
PID 1
└── nginx
```

or:

```text
PID 1
└── php-fpm
```

depending on how you build it.

PID 1 has special responsibilities regarding orphaned processes and signal handling.

This is one reason container processes sometimes behave unexpectedly when they're not designed to run as PID 1.

---

# 41. Filesystem

Linux has one unified filesystem hierarchy:

```text
/
├── bin
├── etc
├── home
├── usr
├── var
├── tmp
└── ...
```

A process sees a filesystem.

Containers manipulate what filesystem a process sees.

That will become extremely important.

---

# 42. Mounts

A **mount** makes a filesystem or filesystem location available at a path.

Conceptually:

```text
some storage
     │
     ▼
/var/lib/mysql
```

This is fundamental to Docker volumes.

A container can have:

```text
/var/lib/mysql
```

mapped to persistent storage outside its writable container layer.

---

# 43. `/proc`

Linux exposes process/kernel information through pseudo-filesystems.

One of the most famous is:

```text
/proc
```

For example:

```text
/proc/1
```

contains information about PID 1.

Containers use Linux isolation mechanisms that affect what processes can see here.

---

# 44. `/sys`

Another important pseudo-filesystem:

```text
/sys
```

It exposes information about devices, kernel subsystems, cgroups, etc.

You don't need to memorize its structure for Inception, but understand:

> Linux exposes a lot of kernel/system state through special filesystem interfaces.

---

# 45. Linux namespaces

**Now we're at the heart of containers.**

A namespace isolates a particular aspect of the system.

Important namespaces include:

```text
PID
Network
Mount
UTS
IPC
User
```

You don't need every kernel detail, but understand the idea.

---

# 46. PID namespace

Normally:

```text
Host

PID 1
PID 2
PID 3
PID 4
```

A container can have its own PID namespace:

```text
Host                         Container

PID 500  ──────────────────> PID 1
PID 501  ──────────────────> PID 2
```

Inside the container, the process may see:

```text
PID 1
PID 2
```

rather than the host's actual PID numbers.

This makes the container feel like it has its own process universe.

---

# 47. Network namespace

This is extremely important for Docker networking.

Normally the host has network interfaces such as:

```text
eth0
lo
```

A container can have its own **network namespace**.

Inside the container, you might see:

```text
eth0
lo
```

but they are not simply the host's interfaces.

The container gets its own:

* network interfaces
* routing table
* IP addresses
* network stack context
* ports

So when Nginx inside a container says:

```text
listen 443;
```

it is listening inside **that network namespace**.

This is the key to your question about listening sockets.

---

# 48. Listening sockets inside containers

Suppose:

```text
Host
│
├── port 443
│
└── Docker container
      └── Nginx
           └── listens on 443
```

There are actually different networking contexts involved.

Inside the container:

```text
container network namespace
        │
        └── 0.0.0.0:443
             ↑
           Nginx
```

That means:

> Nginx listens on port 443 **inside the container's network namespace**.

It does **not automatically mean**:

> The host's port 443 is listening.

Docker can explicitly publish the container port:

```text
Host :443
   ↓
Docker networking/NAT
   ↓
Container :443
   ↓
Nginx
```

This distinction is **very important for Inception**.

---

# 49. `0.0.0.0` inside a container

Suppose Nginx does:

```text
listen 0.0.0.0:443;
```

It means:

> Listen on port 443 on all interfaces available **inside that network namespace**.

If the container has:

```text
eth0 = 172.20.0.2
lo   = 127.0.0.1
```

then:

```text
0.0.0.0:443
```

means Nginx accepts connections arriving through the container's interfaces.

It doesn't mean:

> every machine on the Internet can connect.

Network reachability still depends on Docker networking and host port publishing/firewall rules.

---

# 50. cgroups

The other huge Linux concept behind containers is:

**control groups = cgroups**

Namespaces answer:

> "What can this process see?"

Cgroups answer:

> "How many resources can this process/group use?"

For example:

```text
Container A
├── CPU limit
├── memory limit
└── process limits
```

This helps prevent one workload from consuming everything.

---

# 51. Namespaces + cgroups

This is a very useful mental model:

```text
           Containers
               │
        ┌──────┴──────┐
        │             │
   Namespaces      cgroups
        │             │
        ↓             ↓
   "What can       "How much
    I see?"         can I use?"
```

There are more pieces to container isolation, but these two are fundamental.

---

# PART 7 — Docker

Now we can finally talk about Docker with the necessary foundations.

---

# 52. What problem does Docker solve?

Imagine your application requires:

```text
Debian
Nginx
PHP
specific PHP extensions
MariaDB
specific configuration
specific filesystem structure
```

You want to package this environment so it behaves consistently.

Docker provides tooling to:

```text
build
package
distribute
run
manage
```

containerized applications.

---

# 53. Docker architecture

A simplified Docker architecture:

```text
             Docker CLI
                │
                │ commands
                ▼
          Docker daemon
             (dockerd)
                │
        ┌───────┼────────┐
        │       │        │
     images  networks  volumes
        │
        ▼
    containers
```

When you type:

```bash
docker ps
```

you're using the Docker CLI to communicate with Docker's backend.

---

# 54. Docker daemon

The Docker daemon is commonly:

```text
dockerd
```

It manages Docker objects such as:

* containers
* images
* networks
* volumes

So:

```text
docker CLI
    ↓
Docker daemon
    ↓
Docker infrastructure
```

---

# 55. Docker image

An image is a **template/package from which containers are created**.

For example:

```text
Debian + nginx + configuration
```

could become an image.

Then:

```text
image
  ├── container A
  ├── container B
  └── container C
```

Each container gets its own writable layer on top of the image.

---

# 56. Image layers

This is an important Docker concept.

Suppose your Dockerfile:

```dockerfile
FROM debian
RUN apt update
RUN apt install nginx
COPY nginx.conf /etc/nginx/nginx.conf
```

Docker can represent the resulting filesystem as layers.

Conceptually:

```text
┌──────────────────────────────┐
│ nginx.conf                   │ ← layer
├──────────────────────────────┤
│ nginx installation           │ ← layer
├──────────────────────────────┤
│ apt update                   │ ← layer
├──────────────────────────────┤
│ Debian base image            │ ← layer
└──────────────────────────────┘
```

Layers can be reused.

That's why Docker images can be efficient when constructed well.

---

# 57. Image vs container

This distinction should become automatic.

### Image

A packaged template.

```text
IMAGE
```

### Container

A running instance of an image.

```text
IMAGE
   ↓
CONTAINER
```

You can have:

```text
nginx-image
    ↓
container 1
container 2
container 3
```

---

# 58. Container writable layer

When a container runs, Docker typically adds a writable layer above the read-only image layers.

Conceptually:

```text
Container
┌────────────────────────┐
│ Writable container     │
│ layer                  │
├────────────────────────┤
│ Image layer             │
├────────────────────────┤
│ Image layer             │
├────────────────────────┤
│ Base image              │
└────────────────────────┘
```

If you modify a file inside the container, the modification goes into the container's writable layer.

Destroy the container:

```text
writable layer
      ↓
   deleted
```

That's why container-local data is generally not considered persistent storage.

---

# 59. Dockerfile

A Dockerfile describes how to build an image.

Common instructions:

```dockerfile
FROM
RUN
COPY
ADD
WORKDIR
CMD
ENTRYPOINT
EXPOSE
ENV
```

You don't need to memorize them blindly.

We should understand what each one means and **when it affects the resulting image vs the running container**.

---

# 60. `FROM`

```dockerfile
FROM debian
```

means:

> Start the image from this base image.

It gives you an initial filesystem/userspace.

---

# 61. `RUN`

```dockerfile
RUN apt-get update
```

executes something **while building the image**.

That's the key.

```text
docker build
    ↓
RUN commands happen
    ↓
new image layers
```

It doesn't mean:

> Run this every time the container starts.

That's `CMD`/`ENTRYPOINT` territory.

---

# 62. `COPY`

```dockerfile
COPY nginx.conf /etc/nginx/nginx.conf
```

copies files from the Docker **build context** into the image.

This distinction is important:

```text
Host build context
       ↓ COPY
Docker image
```

---

# 63. Build context

When you run:

```bash
docker build .
```

the:

```text
.
```

is the build context.

Docker can access files inside that context for things like:

```dockerfile
COPY
```

This is why:

```dockerfile
COPY ../something ...
```

doesn't work the way beginners often expect: files outside the build context aren't normally available to the build.

---

# 64. `CMD`

`CMD` specifies the default command to run when a container starts.

Conceptually:

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

Then:

```text
docker run image
       ↓
container starts
       ↓
CMD runs
```

---

# 65. `ENTRYPOINT`

`ENTRYPOINT` is related but has a different semantic role.

It defines the main executable/entrypoint of the container.

For example:

```dockerfile
ENTRYPOINT ["some-script"]
```

Then arguments can be passed to that entrypoint.

The distinction between `CMD` and `ENTRYPOINT` is worth learning carefully because it's commonly misunderstood.

---

# 66. `EXPOSE`

This one causes tons of confusion.

If you write:

```dockerfile
EXPOSE 443
```

it does **not** mean:

> Publish port 443 to the host.

It's metadata/documentation indicating that the application intends to use that port.

Actual host publishing happens through Docker's networking configuration, for example with Compose.

So:

```text
EXPOSE 443
```

≠

```text
Host :443 → Container :443
```

---

# 67. Docker registry

Where do images come from?

A **registry** stores images.

For example:

```text
Docker Hub
```

Conceptually:

```text
Registry
   │
   └── nginx image
   └── debian image
   └── ...
```

You can:

```bash
docker pull ...
```

to retrieve an image.

And:

```bash
docker push ...
```

to upload one to a registry.

For Inception, you'll generally build your own images rather than simply using prebuilt application images if the project requirements require custom Dockerfiles.

---

# 68. Container lifecycle

A container can go through states like:

```text
created
   ↓
running
   ↓
stopped
   ↓
removed
```

Important distinction:

### Stopped ≠ removed

A stopped container still exists.

You can start it again.

When you remove it:

```text
docker rm
```

the container itself is gone.

Its writable container layer goes with it.

Volumes can remain depending on how they're managed.

---

# 69. Docker networking

Now let's connect everything.

Docker can create a network:

```text
my-network
```

Then:

```text
nginx ─────┐
           │
wordpress ─┼── my-network
           │
mariadb ───┘
```

Each container gets network connectivity through that network.

---

# 70. Docker bridge networking

A common Docker network type is:

```text
bridge
```

Conceptually, Docker creates a virtual network environment.

You can imagine:

```text
Host
│
│ Docker bridge
│
├──── container A
├──── container B
└──── container C
```

Containers connected to the same bridge network can communicate.

---

# 71. Docker DNS

Here's a beautiful connection between our earlier DNS discussion and Docker.

Suppose Compose creates services:

```yaml
services:
  nginx:
  wordpress:
  mariadb:
```

Inside the Docker network, services can generally resolve each other by service name.

So WordPress can conceptually connect to:

```text
mariadb:3306
```

instead of:

```text
172.20.0.4:3306
```

Docker provides internal name resolution.

So:

```text
wordpress
    │
    │ "mariadb"
    ▼
Docker DNS
    │
    ▼
MariaDB container IP
```

This is why you should generally **not hardcode container IP addresses**.

---

# 72. Container IPs are disposable

Suppose:

```text
mariadb
IP = 172.20.0.5
```

You recreate it:

```text
mariadb
IP = 172.20.0.7
```

If WordPress had:

```text
DB_HOST=172.20.0.5
```

it breaks.

If instead:

```text
DB_HOST=mariadb
```

Docker DNS resolves the current address.

That's a huge reason service discovery by name is useful.

---

# 73. Port publishing

Now distinguish two things:

### Container-to-container

```text
wordpress → mariadb:3306
```

This is internal Docker networking.

You don't need to publish MariaDB to your host just for WordPress to reach it.

### Host-to-container

```text
Host :443
    ↓
Nginx container :443
```

This requires publishing/mapping the port.

This distinction is **critical**.

---

# 74. `EXPOSE` vs published port

Remember:

```text
EXPOSE 443
```

means roughly:

> This containerized application uses 443.

Publishing means:

```text
Host :443
    ↓
Container :443
```

You can think:

```text
EXPOSE
   =
documentation/metadata

ports:
   =
actual host ↔ container port mapping
```

---

# 75. Docker network namespaces

Now combine this with our Linux knowledge.

Each container can have its own network namespace.

So:

```text
Container A
network namespace
    eth0
    IP 172.20.0.2
```

and:

```text
Container B
network namespace
    eth0
    IP 172.20.0.3
```

They're isolated network environments connected through Docker's virtual networking.

That's a big part of what makes:

```text
nginx:443
```

different from:

```text
host:443
```

---

# PART 8 — Docker storage

Now persistence.

# 76. Why containers shouldn't store important persistent data

Imagine MariaDB:

```text
MariaDB container
       │
       └── /var/lib/mysql
```

If that data only exists in the container's writable layer:

```text
delete container
       ↓
data disappears
```

That's undesirable.

So we attach persistent storage.

---

# 77. Docker volumes

A Docker volume is managed persistent storage.

Conceptually:

```text
MariaDB
   │
   ▼
/var/lib/mysql
   │
   ▼
Docker volume
   │
   ▼
Host-managed persistent storage
```

Now:

```text
delete MariaDB container
       ↓
volume remains
       ↓
new MariaDB container
       ↓
attach volume
       ↓
data remains
```

---

# 78. Bind mounts vs volumes

These are related but different.

### Bind mount

You explicitly map a host path:

```text
Host:
 /home/me/data

        ↓

Container:
 /var/lib/mysql
```

You control the host path.

### Volume

Docker manages the storage location:

```text
Docker volume
      ↓
Container /var/lib/mysql
```

Docker handles where the volume lives.

For Inception, understanding this distinction is important.

---

# 79. Why persistence matters for WordPress

WordPress itself has persistent things too.

For example:

```text
wp-content/
```

can contain uploaded media and other persistent content.

So depending on the project architecture, you need to determine which data must survive container recreation.

The general rule is:

> **Container filesystem = disposable. Persistent data = volume/storage.**

---

# PART 9 — Docker Compose

Now we can assemble everything.

---

# 80. What problem does Compose solve?

Without Compose, you'd manually do something like:

```text
create network
create volume
build nginx
run nginx
build wordpress
run wordpress
build mariadb
run mariadb
connect everything
configure ports
configure environment
```

Compose lets you describe the entire architecture declaratively.

Something conceptually like:

```yaml
services:

  nginx:
    ...

  wordpress:
    ...

  mariadb:
    ...

networks:
    ...

volumes:
    ...
```

Then Compose creates the environment.

---

# 81. Services

A Compose **service** describes a type of container/application.

For example:

```yaml
services:
  nginx:
  wordpress:
  mariadb:
```

Think:

```text
service definition
       ↓
container(s)
```

In your Inception project, each major component is typically a service.

---

# 82. Compose networks

You can define:

```yaml
networks:
  inception:
```

and attach:

```text
nginx ─────┐
wordpress ─┼── inception network
mariadb ───┘
```

Now the containers can communicate over the internal network.

---

# 83. Compose volumes

You can define persistent storage:

```yaml
volumes:
  mariadb_data:
  wordpress_data:
```

Then attach them to services.

Conceptually:

```text
MariaDB
   │
   ▼
mariadb_data

WordPress
   │
   ▼
wordpress_data
```

---

# 84. Compose environment

Compose can provide environment variables:

```yaml
environment:
  DB_HOST: mariadb
  DB_NAME: wordpress
```

The process inside the container receives them.

Then the application can read:

```text
DB_HOST=mariadb
```

and connect through Docker's DNS.

---

# 85. Compose dependency vs readiness

This is subtle and worth knowing.

You might say:

```text
wordpress depends_on mariadb
```

That can express startup ordering/dependency relationships.

But:

> "MariaDB container started"

doesn't necessarily mean:

> "MariaDB is ready to accept database connections."

A process can be running while still initializing.

That's why concepts such as **health checks** can matter.

---

# 86. Health checks

A health check asks:

> "Is this service actually healthy?"

For example, instead of merely:

```text
MariaDB process exists
```

you might test:

```text
Can I actually connect to MariaDB?
```

Then Docker can track something like:

```text
starting
healthy
unhealthy
```

This becomes important in larger containerized systems.

---

# 87. Restart policies

Compose can specify what should happen when a container exits.

Conceptually:

```text
process crashes
     ↓
Docker sees container stopped
     ↓
restart according to policy
```

This is useful for services that should remain running.

---

# 88. The entire Inception mental model

Now let's put everything together.

```text
                         BROWSER
                            │
                            │
                     HTTPS / TCP
                            │
                            ▼
                    HOST MACHINE
                            │
                        port 443
                            │
                     Docker port mapping
                            │
                            ▼
                 ┌────────────────────┐
                 │   NGINX CONTAINER  │
                 │                    │
                 │ network namespace  │
                 │ listening :443     │
                 │ TLS                │
                 └─────────┬──────────┘
                           │
                    Docker network
                           │
                           ▼
                 ┌────────────────────┐
                 │ WORDPRESS CONTAINER│
                 │                    │
                 │ PHP-FPM            │
                 │ WordPress          │
                 └─────────┬──────────┘
                           │
                      TCP / SQL
                           │
                           ▼
                 ┌────────────────────┐
                 │ MARIADB CONTAINER  │
                 │                    │
                 │ MariaDB            │
                 └─────────┬──────────┘
                           │
                           ▼
                    Docker volume
                           │
                           ▼
                   PERSISTENT DATA
```

And underneath all of those containers:

```text
                    Linux
                      │
          ┌───────────┴───────────┐
          │                       │
     namespaces                cgroups
          │                       │
    isolation                  resources
          │
     ┌────┼────────────┐
     │    │            │
    PID  NET         MOUNT
     │    │            │
     ▼    ▼            ▼
 processes networking filesystem
```

And Docker sits above that:

```text
                Docker
                   │
       ┌───────────┼───────────┐
       │           │           │
    images      networks    volumes
       │           │           │
       ▼           ▼           ▼
   containers   connectivity persistence
```

And Compose describes the whole thing:

```text
                compose.yml
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
        nginx     wordpress   mariadb
          │          │          │
          └──────────┼──────────┘
                     │
              Docker network
                     │
                  volumes
```

---

# 89. The really important connections

At this point, I want you to notice that these aren't isolated technologies.

They're layers sitting on top of each other:

```text
┌─────────────────────────────────────────┐
│             WordPress                   │
├─────────────────────────────────────────┤
│             PHP-FPM                     │
├─────────────────────────────────────────┤
│             FastCGI                     │
├─────────────────────────────────────────┤
│              Nginx                      │
├─────────────────────────────────────────┤
│          HTTP / HTTPS                   │
├─────────────────────────────────────────┤
│             TLS                         │
├─────────────────────────────────────────┤
│             TCP                         │
├─────────────────────────────────────────┤
│              IP                         │
├─────────────────────────────────────────┤
│       Docker networking                 │
├─────────────────────────────────────────┤
│       Linux network namespace           │
├─────────────────────────────────────────┤
│              Linux                     │
├─────────────────────────────────────────┤
│          Physical machine               │
└─────────────────────────────────────────┘
```

You don't need to memorize this exact diagram.

The important thing is understanding that **each layer provides something to the layer above it.**

---

# 90. And this is why Inception can seem overwhelming

The project isn't really:

> "Learn Docker."

It's more like:

```text
Linux
  ↓
processes
  ↓
network namespaces
  ↓
TCP/IP
  ↓
Docker networking
  ↓
containers
  ↓
Nginx
  ↓
TLS
  ↓
PHP-FPM
  ↓
WordPress
  ↓
MariaDB
  ↓
persistent storage
  ↓
Compose
```

Docker is sitting in the **middle of a much larger ecosystem**.

And because you've already done Webserv, you're actually in a very good position: you've already understood a large chunk of the application/network side. The major new mental shift is going **downward** into Linux/container internals.

---

# 91. What I would learn next

Before jumping straight into Docker commands, I'd spend one more focused section on the **Linux/container boundary**, because this is where a lot of Inception questions become easy.

Specifically:

### A. Linux namespaces in more depth

```text
PID namespace
Network namespace
Mount namespace
IPC namespace
UTS namespace
User namespace
```

### B. cgroups

How resource isolation actually works.

### C. Linux capabilities

Why containers aren't simply "root on the host."

### D. Container filesystem

```text
image layers
     ↓
writable container layer
     ↓
mounts
     ↓
volumes
```

### E. What actually happens when `docker run` executes

We can follow:

```bash
docker run ...
```

all the way down:

```text
Docker CLI
   ↓
Docker daemon
   ↓
image
   ↓
container filesystem
   ↓
network namespace
   ↓
veth pair
   ↓
bridge
   ↓
cgroups
   ↓
namespaces
   ↓
PID 1
   ↓
your application
```

**That is the point where Docker stops feeling like magic.**

And then we can move into the practical Inception side: Dockerfiles, `ENTRYPOINT` vs `CMD`, build layers/cache, Compose, networks, volumes, port mappings, and finally reconstruct the whole Nginx → WordPress → MariaDB stack from scratch.
