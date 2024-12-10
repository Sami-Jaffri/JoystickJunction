# Joystick Junction

Joystick Junction is your ultimate gateway to the thrilling universe of gaming! Born out of a passion for gaming and technology, this platform was created as a project for COSC 304 at the University of British Columbia (UBC). Designed to be a one-stop hub for exploring and managing triple-A game titles, Joystick Junction offers a sleek, user-friendly interface where gamers can discover blockbuster games, organize their library, and stay updated on the latest industry trends. Whether you're a casual player or a hardcore enthusiast, Joystick Junction has something to amplify your gaming experience.

## Getting Started

Follow these instructions to set up and run the project locally.

### Prerequisites

Ensure the following are installed on your system:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### Installation and Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/Sami-Jaffri/JoystickJunction.git
   cd JoystickJunction
   ```

2. Run the application using Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Access the web application:
   Open your browser and navigate to `http://localhost/shop/loaddata.jsp` (or the port specified in the `docker-compose.yml` file). This will load the database for the website. From there navigate to `http://localhost/shop/login.jsp`

### Stopping the Application

To stop the running application:
```bash
docker-compose down
```

### File Structure

- `Dockerfile`: Configuration for building the application image.
- `docker-compose.yml`: Orchestrates the application services.

### Contributing

Contributions are welcome! Please fork the repository and create a pull request with your proposed changes.

---

Happy gaming! 🎮
