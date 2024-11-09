# Team Management API

A RESTful API built with Ruby on Rails for managing teams and their members. This project includes user authentication and CRUD operations for teams and team members. 

## Table of Contents
- [Features](#features)
- [Technologies](#technologies)
- [Getting Started](#getting-started)
- [API Documentation](#api-documentation)

## Features

- **User Authentication and Authorization**
  - JWT-based authentication for secure user signup and signin.
  - Authorization rules:
    - Only team owners can modify team details.
    - Only team owners can add or remove team members.
    - Team members have view-only access to team information.

- **Team Management**
  - **Create Team**: Allows team owners to create a new team with a name, description, and owner assignment.
  - **View Team**: Retrieve details for a specific team.
  - **Update Team**: Team owners can edit the team's name and description.
  - **Delete Team**: Team owners can remove teams from the system.
  - **List Teams**: Retrieve a list of all teams in the system.

- **Team Member Management**
  - **Add Team Members**: Team owners can add members to a team using user IDs.
  - **Remove Team Members**: Team owners can remove members from a team.
  - **List Team Members**: Retrieve a list of all members in a team, including their user details and role.
  - **Filter Team Members**: Search for team members by their name or attributes.
  - **View Member Details**: Get detailed information for a specific team member.

- **API Documentation and Testing**
  - Full API documentation available with Swagger, allowing easy testing and interaction with all endpoints.

- **Search Functionality**
  - Built-in search to locate team members by name, email, or other attributes, enabling quick and easy team member filtering.

## Technologies
- **Ruby**: 2.6.6
- **Rails**: ~> 5.2.2
- **Database**: PostgreSQL

## Getting Started

### Prerequisites
Ensure you have the following installed:
- [Ruby 2.6.6](https://www.ruby-lang.org/en/downloads/)
- [Rails ~> 5.2.2](https://guides.rubyonrails.org/v5.2/)
- [PostgreSQL](https://www.postgresql.org/download/)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/pranavdodiya/team-management-system.git
   cd team-management-system
   bundle install
   rails db:create db:migrate
   rails server

## API Documentation
1. The API endpoints are documented with Swagger. You can access the documentation by visiting:
    http://localhost:3000/api-docs


