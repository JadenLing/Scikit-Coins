# Imaging Shiny App
Implementation of Scikit Counting Coins onto a R/Shiny App

As per the Subject Matter Expert's (Lachie) recommendation, we have implemented the Image Segementation example from Scikit as a base for the Shiny app
- This is because we want a simple example to see how feasible it is for an implementation, also because we know what the intended output is


### R/Shiny UI Setup Guide

#### Prerequisites
- Ensure access to Milton HPC and OnDemand.
- If you lack access, follow the provided setup instructions.
  
#### Initial Setup
1. Log into OnDemand.
2. Navigate to **CLUSTERS -> SLURM SHELL ACCESS**.
3. Enter your password (note that it won't be displayed on the screen).
4. Clone the repository: `git clone https://github.com/JadenLing/Scikit-Coins.git`.

#### Launching OnDemand Shiny App
1. Navigate to **Shiny App** setup.
2. Configure your session:
   - Partition: interactive
   - R Version: 4.2.3
   - CPUs: 4
   - Memory: 8GB
   - Additional Modules: R shiny
  
3. Specify the Shiny App directory: `/home/users/allstaff/<username>/Scikit-Coins` (use a directory, not a file name).
   - For a basic app, name the file `app.R`.
   - For an app with both UI and server files, name them `ui.R` and `server.R` respectively.
4. If there are issues, consult the session log and output log.
5. Click **Launch -> Connect to Shiny App** to start your application.
