# Computational Microscopy

Welcome to the Computational Microscopy project! This repository contains two main parts:

1. **STM Image Simulation**: MATLAB scripts to generate simulated Scanning Tunneling Microscopy (STM) images.
2. **Deep Neural Networks (DNNs)**: Python code for training an autoencoder on the simulated STM images.

## Project Structure

- **STMImageSimulation**: This directory contains MATLAB scripts for generating simulated STM images. These images are used to train our Deep Neural Network (DNN).
- **DNNs**: This folder contains the autoencoder code implemented in Python.

## Getting Started

### STM Image Simulation

1. **Navigate to the STMImageSimulation directory:**
    ```sh
    cd STMImageSimulation
    ```

2. **Run the MATLAB scripts to generate simulated STM images:**
    - `Atom5.m`: Defines the atomic interaction model.
    - `AtomP.m`: Generates random atomic positions.
    - `DataSim.m`: Simulates STM data with random atomic positions.
    - `SetPoints.m`: Generates a regular grid of atomic positions.
    - `sets.m`: Simulates STM data with a regular grid of atomic positions.

3. **Example usage:**
    ```matlab
    % Open MATLAB and run the main script to generate STM images
<<<<<<< HEAD
    run('Atom5.m')
=======
    run('DataSim.m')
>>>>>>> b84fa47 (Updated README)
    ```

### Deep Neural Networks (DNNs)

1. **Navigate to the DNNs directory:**
    ```sh
    cd DNNs
    ```

2. **Install the necessary Python packages:**
    ```sh
    pip install -r requirements.txt
    ```

3. **Train the autoencoder:**
    - Use the provided scripts to load the simulated STM images and train the autoencoder.

<<<<<<< HEAD

=======
4. **Example usage:**
    ```sh
    python train_autoencoder.py
>>>>>>> b84fa47 (Updated README)
    ```

## Directory Overview

### STMImageSimulation

- `Atom5.m`: Calculates a 3D radial function to model STM interactions.
- `AtomP.m`: Generates random atomic positions.
- `DataSim.m`: Main script for generating and visualizing STM images.
- `SetPoints.m`: Generates evenly spaced atomic positions.
- `sets.m`: Simulates STM data with regular atomic grid positions.

### DNNs

<<<<<<< HEAD

=======
- `train_autoencoder.py`: Python script to train the autoencoder on the simulated STM images.
- `autoencoder_model.py`: Defines the autoencoder architecture.
- `data_loader.py`: Loads and preprocesses the STM images for training.
>>>>>>> b84fa47 (Updated README)

## License

This project is licensed under the MIT License.

