# Agent-Based Epidemic Simulation (MATLAB)

Stochastic agent-based model of an epidemic spreading through a population of **250,000 people** (a 500 × 500 grid) who move between **400 locations** every day. Built as a coursework project at Universidad Carlos III de Madrid.

## How the model works

- Each person is **healthy**, **infected** or **dead**.
- Every simulated day, each person visits 5 random locations. A healthy person who shares a location with an infected person catches the disease with probability 0.25.
- The illness lasts a random number of days (up to 14). When it ends, the person either dies or recovers with antibodies.
- **Public-health measures** switch on automatically when infections cross a threshold:
  - mandatory masks (infection risk × 0.38)
  - mandatory vaccination (infection risk × 0.05)
- The simulation stops when nobody is infected or after 30 days. It then plots the healthy, infected and dead counts over time, with a vertical line on the day each measure starts.

## Run

Open `epidemic_simulation.m` in MATLAB and run it. All parameters (population size, number of locations, probabilities, thresholds, duration) are variables at the top of the script.

## Known limitations

- The list of locations with infected people is not updated correctly in every case (the `ismember` check on line 94).
- The thresholds use the sum of daily infected counts, not the number of cumulative cases.
- Antibodies currently have no effect (`antiC = 1`).
- The nested loops are slow for 250,000 agents and could be vectorised.

## Author

Jorge Tarriño, Universidad Carlos III de Madrid.
