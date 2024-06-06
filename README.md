
# MATLAB Project: Simulated STM Image Generation for DNN Training

## Project Overview
This MATLAB project generates simulated images of Scanning Tunneling Microscopy (STM) to be used as training data for Deep Neural Networks (DNN). The project involves various MATLAB scripts and functions that create synthetic STM images, enabling training and evaluation of DNN models for STM image analysis.

## Contents
- **Atom5.m**: Main script to generate simulated STM images.
- **AtomP.m**: Function to generate atom patterns.
- **DataSim.m**: Function to simulate data based on provided atom patterns.
- **SetPoints.m**: Function to set the points for the STM simulation.
- **Matlab codes.zip**: Compressed file containing additional necessary scripts and functions.

## Requirements
- MATLAB R2021a or later
- Image Processing Toolbox
- Signal Processing Toolbox


## Usage
1. **Run the main script**:
    Open MATLAB, navigate to the project directory, and run the `Atom5.m` script to generate simulated STM images.
    ```matlab
    run('Atom5.m')
    ```
2. **Customize the simulation**:
    Modify the parameters in `Atom5.m` to change the resolution, pattern types, and other simulation settings.
    ```matlab
    res = 256;           % Size of the image
    type = 2;            % Pattern type
    spread = 9 + type^2; % Resolution adjustment
    % Other parameters as needed
    ```

## Script Details

### Atom5.m
- **Purpose**: Generates the simulated STM images by creating two atom patterns and merging them.
- **Key Variables**:
    - `res`: Size of the generated image.
    - `type`: Type of the pattern.
    - `spread`: Controls the spread of the atom patterns.
    - `a1, a2`: Random coefficients for the patterns.

### AtomP.m
- **Purpose**: Generates atom patterns based on provided coefficients and type.
- **Usage**:
    ```matlab
    [u, v, d] = AtomP(coefficients, type, spread)
    ```


### SetPoints.m
- **Purpose**: Sets the points for the STM simulation based on the generated patterns.
- **Usage**:
    ```matlab
    [u, v, d] = SetPoints(u, v, d, spread, size, partition)
    ```


### DataSim.m
- **Purpose**: Simulates data using the generated atom patterns.
- **Usage**:
    ```matlab
    [aa] = DataSim(size, u, v, d, spread, type)
    ```
