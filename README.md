# MUP-RR - Gestão Integrada de Reserva de Salas da UA​

- [1. Inception Phase](#1-inception-phase)
  - [1.1. Context](#11-context)
  - [1.2. Problem](#12-problem)
  - [1.3. Personas](#13-personas)
  - [1.4. Goal](#14-goal)
  - [1.5. Task List](#15-task-list)
  - [1.6. Expected Results](#16-expected-results)
  - [1.7. Related work](#17-related-work)
  - [1.8. Communication Plan](#18-communication-plan)
  - [1.9. Team Roles](#19-team-roles)
  - [1.10. Project calendar](#110-project-calendar)

## 1. Inception Phase

### 1.1. Context

A university like our’s has a large number of rooms and of varying sizes and functionalities, rooms that are used for the classes, meetings, or even for study groups to use.

The university of Aveiro has an initial system of room reservation, developed by an external company, Bullet Solutions, it’s called Bullet Room Booking and contains a central database where all events are registered. This system is soon to be expanded to all of the academic community, that includes over 13000 students, 1150 teachers and researchers and 650 administrative and management staff.

### 1.2. Problem

The rooms in UA are inefficiently used, because of the independent management inherent to each department. A group of teachers from Dbio may want to arrange a meeting but asking the department’s secretary informs them that there won’t be an available room until sunday, however there was an available meeting room all week at DETI. 

The BRB platform was designed to solve this problem providing a central reservation system for all the UA. The web portal of this system allows every user to reserve any room of the university following certain rules according to the permissions of the user. 

However BRB has a few problems that are impeding its release to the full academic community:

Firstly, being a more generic system that could work for any university, it can’t comply with every ruling and exception of UA, so certain people might not fit into the defined user types and permissions.

Secondly, as it stands, when a user registers on BRB he is given the “Default” user type, that doesn’t allow him many features. It then is up to an administrator to manually assign a role to each user according to their position at the university, something the admin would need to know as it’s information external to the BRB.

Managing the access and permissions of the whole academic body would be a task far too complex to be done manually by an administrator.

### 1.3. Personas

- **Academic Staff**

  António Marques, 47 years old lives in Aveiro and currently works at the city’s University as a professor. As a professor, he needs to plan and book certain rooms for his exams. As such, whenever he needs a room for an event in the University, he has to contact the department he wants for availability and book it. António Marques feels like this process is not efficient at all and there should be an automatic way of doing this. As such, he feels that the  Name here feels like an online app that manages this situation would be much easier and efficient  

- **Student**

  Gonçalo Baptista, 20 years old. Lives in Lisbon but studies at Universidade de Aveiro. As a student from another city, he’s renting a room in a very noisy house. As such, he needs a place where he can study and solve his problems with his friends. As the library is almost always full and noise should be kept to a minimum, he feels like booking a room at his department would be a great solution. As a student of ET, the room should be equipped with some machines that he needs for his studies. Gonçalo feels like there should be an application that could let students ask for permission to rent a room so that they can use it.

  - **Room Group Responsible**

  Rita Santos, 56 years old lives in Aveiro and works at the city’s University as a staff member of DETI. Furthermore  she’s the one responsible for the delegation of rooms at the department she works, according to requests from professors and students. She feels that the current procedure for room booking is just too tedious as the time spent defining the needed characteristics of a room and checking availability is just a waste as she has other work to do.     As such, she feels like an easy to use application where all this procedure is summarized would be much more efficient and much less time consuming as she would only have to grant or deny the requests.

### 1.4. Goal

Given this problem, our main and initial goal is to develop a module that will assist the permissions management functionalities of BRB. This module will be called Manager of User Permissions for Room Reservation, or for short MUP-RR.

Our plan is for it to be a sort of communication broker between the BRB and the RCU, the existing system at UA that holds all users and their information. This way our module would detect any new user or change in the user’s status through the RCU and taking into account the defined regulations would decide the permission the user should have and communicate them to BRB.

Completing this and therefore having a usable and manageable system for room booking we want to put it into action and develop a mobile app, oriented for the students of the university, on top of our created module. Intended for students to quickly check the rooms available around them and book them, always according to regulations of course. Having this app would make room use more efficient on the student front at university.

### 1.5. Task List

**Module: Mobile App (Inês Leite, Pedro Marques and Alexandre Rodrigues)**

- **Task 1:** Create use cases.
- **Task 2:** Create prototype.
- **Task 3:** Create Outsystems mobile App.

**Module: Existing Systems Handling (Alexandre Rodrigues and Pedro Marques)**

- **Task 1:** Understand the RCU functionalities.
- **Task 2:** Experiment with BRB.
- **Task 3:** Analyze current types of users and permissions.
- **Task 4:** Determine new users and permission rules.

**Module: Database (Inês Leite and Rui Fernandes)**

- **Task 1:** Create the database prototype.
- **Task 2:** Implement the database schema.

**Module: MUP-RR (Rui Fernandes, Pedro Marques)**

- **Task 1:** Set up data influx from RCU.
- **Task 2:** Implement data processing and permission handling.
- **Task 3:** Establish communications with BRB.

### 1.6. Expected Results

With our project we aim to supply the university with a system that can allow the deployment of BRB to the whole community. Furthermore we wish that our student oriented app that draws on the whole room booking service will come to fruition as an actual useful tool for students in the future, making life at UA slightly more convenient.

### 1.7. Related work

We researched for similar systems and applications, some of which were:

- **Meetio:** [https://www.meetio.com/lp/meeting-room-booking-system](https://www.meetio.com/lp/meeting-room-booking-system)
- **Robin:** [https://robinpowered.com/overview](https://robinpowered.com/overview)
- **Condeco:** [https://www.condecosoftware.com/products/meeting-room-booking/](https://www.condecosoftware.com/products/meeting-room-booking/)

### 1.8. Communication Plan

- **Code Sharing and CI:** For our code sharing we will be using this very Github repository, it is a platform we are very confortable with and some experience following a feature branch workflow using it.

- **Backlog Management:** For backlog management we will use Jira because it is a powerfull tool that provides great project tracking for teams. Additionally we had already used the tool before, and intend on following a Kanban board tactic.

- **Team Communication:** In regards to communication amongst team members we will be using Discord since it’s our more informal day to day platform. As for more formal contact that includes our advisors we will use Microsoft Teams where we can schedule meetings, share files and much more. Additionally we will use Google Drive for quick file sharing and editing, more on the front of presentations and documentation.

### 1.9. Team Roles

- **Project Manager:** [Rui Fernandes](https://github.com/Rui-FMF)
- **DevOps Master:** [Pedro Marques](https://github.com/PedroMarques27)
- **Architect:** [Alexandre Rodrigues](https://github.com/alex-pt01)
- **Product Owner:** [Inês Leite](https://github.com/inespl)
- **Advisor:** [Professor José Vieira](https://www.ua.pt/pt/p/10311461)
- **Co-Advisor:** [Engenheiro Filipe Trancho](https://www.ua.pt/pt/p/10316739)

### 1.10. Project calendar

This is our project calendar....
