# CrystalOrientations.jl
A package for describing crystal orientations and transforming between their representations consistently. The basis for this package can be found in the tutorial:

"Rowenhorst, David, et al. "Consistent representations of and conversions between 3D rotations." Modelling and Simulation in Materials Science and Engineering 23.8 (2015): 083501. https://iopscience.iop.org/article/10.1088/0965-0393/23/8/083501". 

# Constructing Orientations 
The package includes crystal orientation representations for: 
1. Euler Angles 
   * Bunge
2. Quaternions 
3. Axis-Angle types
   * Axis-Angle
   * Rodrigues-Frank vector 

As an example, one can create an Euler Angles representation of the Bunge (ZXZ) convention via: 

`euls = EulerAngles(Bunge, 0.0, 1.0, 0.3)`
