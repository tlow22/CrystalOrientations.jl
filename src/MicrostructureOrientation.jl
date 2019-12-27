#===============================================================================
  @file MicrostructureOrientation.jl
  @brief MicrostructureOrientation module for describing crystallographic
         orientation.
  @author Thaddeus low <thaddeuslow@outlook.com>
  @date 11/03/2019

  This module follows the consistent framework set forth by:

  "Rowenhorst, David, et al. "Consistent representations of and conversions
  between 3D rotations." Modelling and Simulation in Materials Science and
  Engineering 23.8 (2015): 083501."

  and contains the following representations of orientations and conversions
  between them:
    • EulerAngles (Bunge, Kocks, Matthies, Roe)
    • RotationMatrix
    • Quaternion
    • AxisAngle
    • RodriguesFrank (i.e. Rodrigues-Frank Vector)
    • Homochoric     (i.e. Homochoric Vector)
===============================================================================#
module MicrostructureOrientation

  import StaticArrays: SMatrix
  import Quaternions: Quaternion, normalize
  import LinearAlgebra: tr, det
  import Base: *, getindex, inv, adjoint, iterate, angle

  export
    # Euler angles representations
    EulerAngles,
    AbstractEulerAngles,
    Bunge,
    Kocks,
    Matthies,
    Roe,

    # Axis angle type representations
    AxisAngle,
    AbstractAxisAngle,
    AxisAng,
    RodriguesFrank,
    HomochoricVector,
    axis,

    # Rotation matrix representation
    RotationMatrix,
    tr,
    det,

    # Quaternion representation
    Quaternion,
    normalize,

    # Orientation interface
    Orientation,
    AbstractOrientation


    # src files
  include("euler_angles.jl")
  include("rotation_matrix.jl")
  include("axis_angles.jl")
  include("conversions.jl")
  include("orientation_interface.jl")


end #module
