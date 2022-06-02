# CSE_115_HOUSEMATES

# Housemates IOS App!

**Housemates** is an iOS mobile app that aims to enhance the communication between you and your housemates.

Our goal is to create a User-friendly and easy-to-use iOS app where users can establish schedules, organize chores, and establish house rules. In future releases, we are planning to add more features depending on the amount of time left.

# Installation Guide

Welcome to our **Housemates repository**, we will be outlining the steps needed to download and run our application.

## Github Repository

- Clone the github repository

## Backend Setup

 1. From the terminal, navigate to CSE_115_HOUSEMATES > backend 
 2. Load Environment Variables
	 - MacOS:
		- Run the command source ./env.sh
		- Run the command echo $DB_IP
		- This command should return 34.82.251.52 (as it is the database IP address)
	- Windows:
		- Open ‘System’ in the Windows task bar
		- In the ‘Settings’ window, under ‘Related Settings’, click ‘Advanced System Settings’
		- Click ‘Environment Variables’
		- Click ‘New’ to create a new variable
		-  Create a new variable for each variable in env.sh
3. Once the variables are loaded, run the command: python app.py
	 - This command should launch the Flask application

## Frontend Setup

1.  Download latest XCode version on Mac
2.  Open the XCode project file using XCode: CSE_115_HOUSEMATES/Housemates/Housemates.xcodeproj
3.  Launch the iPhone Simulator
