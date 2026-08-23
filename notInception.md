# Understanding Websites, Servers, Hosting, Cloud Computing, and WordPress

> A simple introduction to the basic concepts behind modern websites and applications.

---

## 1. The Basic Idea

A website or application is **software that needs a place to run**.

It may contain:

* Code
* Images
* Text
* User information
* Other data

That software needs a computer to run on.

That computer can be your own computer, a company's computer, or a computer provided by a hosting or cloud company.

A simple view is:

```text
User
  ↓
Internet
  ↓
Server
  ↓
Application
  ↓
Database
```

---

## 2. Server

A **server** is a computer that provides something to other computers over a network.

A physical server is simply a computer designed to:

* Run for long periods of time
* Handle many requests
* Store data
* Communicate over a network

For example, when you visit a website, your browser sends a request to a server.

```text
Your browser
     ↓
  Internet
     ↓
   Server
     ↓
Website data
     ↓
Your browser
```

The word **server** can also refer to software that performs the job of serving something.

So there are two common meanings:

* **Physical server** → an actual computer
* **Web server** → software that handles web requests

---

## 3. Nginx

**Nginx** is software commonly used as a **web server**.

It is not a physical computer.

It runs on a computer and can receive requests from browsers.

```text
Browser
   ↓
Internet
   ↓
Physical/virtual server
   ↓
Nginx
   ↓
Website/application
```

Nginx can receive a request such as:

```text
"Give me example.com/about"
```

and help deliver the appropriate content back to the browser.

Other software can perform similar jobs, such as Apache.

---

## 4. Hosting

**Hosting** means providing a place and the necessary resources for a website or application to run on an internet-connected computer.

A simple definition:

> **Hosting = having your website or application run on a server connected to the internet.**

You do not normally need to own the physical server yourself.

You can rent resources from another company.

```text
Website
   ↓
Hosting
   ↓
Server
   ↓
Internet
```

---

## 5. Hosting Companies

A **hosting company** provides server resources to customers.

Instead of buying and maintaining your own physical server, you can pay a hosting company to provide access to one.

```text
You
 ↓
Hosting company
 ↓
Server
 ↓
Your website
```

Depending on the hosting service, the company may manage things such as:

* Physical servers
* Networking
* Storage
* Operating systems
* Security
* Backups
* Server software
* Databases

The exact amount of management depends on the type of hosting.

---

## 6. Self-Hosted WordPress

**Self-hosted WordPress** means running the WordPress software on hosting that you choose and manage.

It does **not** mean that you must own a physical server.

You can rent the server from a hosting company and still have self-hosted WordPress.

```text
You
 ↓
Hosting company
 ↓
Server
 ↓
WordPress
 ↓
Your website
```

Self-hosted WordPress generally gives you more control and responsibility over the WordPress environment.

---

## 7. WordPress

**WordPress is software used to create and manage websites.**

It provides tools for creating:

* Pages
* Blog posts
* Images
* Menus
* Users
* Online stores
* Other website content

WordPress itself needs a place to run, so it runs on a server.

A simplified WordPress environment might look like:

```text
Server
 ├── Linux
 ├── Nginx
 ├── PHP
 ├── Database
 └── WordPress
```

---

## 8. WordPress.com and WordPress.org

### WordPress.com

**WordPress.com is a hosted service.**

Much of the technical environment is managed for you.

```text
You
 ↓
WordPress.com
 ↓
Infrastructure
 ↓
WordPress
 ↓
Website
```

You can focus more on creating and managing the website.

### WordPress.org

**WordPress.org provides the WordPress software.**

You can install that software on hosting that you choose.

```text
You
 ↓
Choose hosting
 ↓
Server
 ↓
Install WordPress
 ↓
Website
```

This approach is commonly called **self-hosted WordPress**.

---

## 9. PHP

**PHP is a programming language commonly used by WordPress.**

WordPress is primarily written in PHP.

When someone visits a WordPress page, PHP helps WordPress process the request and generate the appropriate webpage.

A simplified process is:

```text
Browser
   ↓
Nginx
   ↓
PHP
   ↓
WordPress
   ↓
HTML
   ↓
Browser
```

The browser receives the resulting webpage and displays it.

---

## 10. Databases

A **database** is an organized system for storing and retrieving information.

WordPress uses a database to store information about the website.

For example:

```text
Database

Users
 ├── Alice
 ├── Bob
 └── John

Posts
 ├── First post
 ├── Second post
 └── Third post

Comments
 ├── Comment 1
 └── Comment 2
```

A database can store:

* Posts
* Pages
* Users
* Comments
* Settings
* Plugin information
* Other website data

A simple way to think about a database is:

> **An organized place where an application keeps information.**

---

## 11. Infrastructure

**Infrastructure** is a broad term for the underlying technology that allows an application or service to operate.

It can include:

* Physical servers
* CPU
* RAM
* Storage
* Networking
* Data centers
* Operating systems
* Security systems
* Server software
* Other supporting services

A simplified view:

```text
Application
    ↑
PHP / Runtime
    ↑
Web server
    ↑
Operating system
    ↑
CPU / RAM / Storage
    ↑
Physical infrastructure
    ↑
Data center / Networking
```

Infrastructure is not one specific thing.

It is an **umbrella term for the underlying resources and systems that support an application**.

---

## 12. Computing

**Computing** simply means using computers to perform work.

Examples:

* Running an application
* Processing data
* Storing information
* Playing a game
* Running a website
* Training an AI model

When you see the word "computing", you can generally think:

> **Things involving computers and the processing of information.**

---

## 13. Cloud Computing

**Cloud computing means using computing resources provided remotely over a network, usually the internet.**

Instead of buying and maintaining all the physical computers yourself, you can use resources provided by a cloud provider.

```text
Your computer
     ↓
  Internet
     ↓
Cloud provider
     ↓
Computing resources
```

Cloud computing can provide:

* Virtual computers
* Storage
* Databases
* Networking
* Software services
* AI services
* Messaging services
* Other computing capabilities

The cloud is **not one special computer**.

It is a large collection of computing infrastructure that can be accessed as services.

---

## 14. Cloud Providers

A **cloud provider** is a company that provides cloud computing resources and services.

Examples include:

* Amazon Web Services (AWS)
* Microsoft Azure
* Google Cloud

A cloud provider can offer many different services:

```text
Cloud provider
 ├── Virtual computers
 ├── Storage
 ├── Databases
 ├── Networking
 ├── Security services
 ├── AI services
 └── Other services
```

Cloud providers are generally broader than traditional website hosting companies.

---

## 15. Third-Party Providers

A **third-party provider** is an outside company providing a service to you.

For example:

```text
You
 ↓
AWS
 ↓
Your application
```

AWS is a third party because it is an external company providing computing resources instead of you owning and managing all of the infrastructure yourself.

Simply put:

> **Third party = another company providing something that your project needs.**

---

## 16. Cloud Services

**Cloud services** are computing capabilities provided remotely by a cloud provider.

They can include:

```text
Computing
Storage
Databases
Networking
Security
Email
AI
Analytics
```

A cloud service does not necessarily mean "a server."

You can use many different capabilities without directly managing the physical hardware behind them.

---

## 17. Hosting vs Cloud Services

A **hosting company** generally focuses on providing a place for websites or applications to run.

A **cloud provider** usually provides a larger collection of computing services that developers can combine to build applications.

### Hosting

> "I need somewhere for my website to live."

```text
Hosting company
      ↓
    Server
      ↓
   Website
```

### Cloud

> "I need computing resources for my application."

```text
Cloud provider
      ↓
 ┌────┼───────┐
 ↓    ↓       ↓
VM  Storage  Database
 ↓
Application
```

There is significant overlap.

A cloud provider can host websites, and a hosting company can use cloud infrastructure.

The main difference is usually **scope and flexibility**.

---

## 18. Android and Laptop Applications

Cloud computing is not limited to websites.

An application can run:

* On a phone
* On a laptop
* On a server
* Or across several of these

For example, an Android application can run code directly on the phone:

```text
Android phone
 └── Application
```

But it can also communicate with a server:

```text
Android app
      ↓
   Internet
      ↓
    Server
      ↓
   Database
```

The same is true for laptop applications.

Some applications work completely offline.

Others communicate with servers to:

* Store user information
* Synchronize data
* Send messages
* Process information
* Authenticate users
* Store files
* Connect multiple users

Therefore, an application does not have to be a website to use cloud computing.

---

## 19. IaaS — Infrastructure as a Service

**IaaS means Infrastructure as a Service.**

The provider gives you basic computing resources, such as a virtual computer.

```text
Cloud provider
      ↓
Virtual machine
      ↓
You manage:
 ├── Operating system
 ├── Server software
 ├── Application
 └── Other configuration
```

IaaS gives you **more control but more responsibility**.

A simple way to remember it:

> **IaaS = "Give me a computer."**

---

## 20. PaaS — Platform as a Service

**PaaS means Platform as a Service.**

Instead of giving you a relatively empty virtual computer, the provider gives you a more prepared environment for running your application.

The goal is to let developers focus more on **writing their application** and less on managing the underlying infrastructure.

```text
Your application/code
        ↓
       PaaS
        ↓
Infrastructure
```

A PaaS may handle things such as:

* Server setup
* Operating system
* Runtime environment
* Scaling
* Some networking
* Deployment
* Other infrastructure management

The exact responsibilities depend on the PaaS.

A simple way to remember it:

> **PaaS = "Give me a place that is already prepared to run my application."**

---

## 21. IaaS vs PaaS

The main difference is **how much of the underlying environment you manage**.

```text
             MORE CONTROL
                  ↑
                  │
                 IaaS
         "Give me a computer."
                  │
                  │
                 PaaS
     "Give me a ready environment
        for my application."
                  │
                  ↓
          LESS MANAGEMENT
```

With IaaS, you manage more of the underlying environment.

With PaaS, the provider manages more of it so you can focus on your application.

---

## 22. SaaS — Software as a Service

**SaaS means Software as a Service.**

Instead of building or managing the software yourself, you simply use software provided by someone else.

Examples include:

* Google Docs
* Online email
* Project management applications
* Online accounting software

The basic idea:

```text
You
 ↓
Internet
 ↓
Software provided by someone else
```

A simple way to remember the three:

```text
IaaS → "Give me a computer." 💻

PaaS → "Give me somewhere ready to run my code." 🏗️

SaaS → "Give me the finished software." 🖥️
```

---

## 23. How Everything Fits Together

A typical application might look like:

```text
                    USER
                     │
                     ↓
               📱 / 💻 DEVICE
                     │
                  Internet
                     │
                     ↓
              CLOUD / HOST
                     │
                  SERVER
                     │
              Operating System
                     │
                   Nginx
                     │
                Application
                     │
                  Database
```

For a WordPress website, the application environment might look like:

```text
Server
 ├── Linux
 ├── Nginx
 ├── PHP
 ├── Database
 └── WordPress
```

For another application, the technologies could be completely different.

The general idea remains:

> **Applications need computing resources to run, and those resources can be provided by your own hardware, a hosting company, or a cloud provider.**

---

## 24. Quick Reference

| Term                | Simple meaning                                                    |
| ------------------- | ----------------------------------------------------------------- |
| **Computer**        | A machine that performs computing work                            |
| **Server**          | A computer or software that provides something to other computers |
| **Physical server** | An actual physical computer                                       |
| **Virtual server**  | A virtual computer created using physical hardware                |
| **Nginx**           | Software that can act as a web server                             |
| **Hosting**         | Providing a place/resources for a website or application to run   |
| **Hosting company** | A company that provides hosting                                   |
| **WordPress**       | Software for creating and managing websites                       |
| **PHP**             | A programming language used by WordPress                          |
| **Database**        | Organized storage for application data                            |
| **Infrastructure**  | The underlying technology supporting an application               |
| **Cloud computing** | Using computing resources remotely as services                    |
| **Cloud provider**  | A company providing cloud computing resources                     |
| **Cloud service**   | A particular computing capability provided through the cloud      |
| **IaaS**            | Basic computing infrastructure, such as virtual machines          |
| **PaaS**            | A prepared environment for building and running applications      |
| **SaaS**            | Finished software provided as a service                           |

---

## 25. The Main Mental Model

When the terminology becomes confusing, come back to this:

```text
                    APPLICATION
                         │
                         ↓
                 Needs a place to run
                         │
                         ↓
                     COMPUTER
                         │
             ┌───────────┴───────────┐
             ↓                       ↓
       Your own computer       Someone else's
                                  computer
                                      │
                         ┌────────────┴────────────┐
                         ↓                         ↓
                   Hosting company          Cloud provider
                         │                         │
                       Hosting               Cloud services
```

The most important ideas are:

> **A server is a computer.**

> **Nginx is software running on a computer.**

> **Hosting is providing a place for an application to run.**

> **WordPress is software that runs on a server.**

> **A database stores information for an application.**

> **Infrastructure is the underlying technology supporting an application.**

> **Cloud computing is using computing resources as services instead of managing all the underlying hardware yourself.**

> **IaaS gives you more of the computer.**

> **PaaS gives you a more prepared environment for your application.**

> **SaaS gives you the finished application.**
