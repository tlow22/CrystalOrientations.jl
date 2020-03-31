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
    • Quaternion
    • AxisAngle
    • RodriguesFrank (i.e. Rodrigues-Frank Vector)
    • Homochoric     (i.e. Homochoric Vector)
===============================================================================#
module MicrostructureOrientation

    import StaticArrays: SMatrix
    import Quaternions: Quaternion, normalize
    import LinearAlgebra: tr, eigen

    export
        # 3rd party re-exports
        Quaternion,
        normalize,

        # interfaces.jl
        AbstractOrientation,
        AbstractEulerAngles,
        AbstractAxisAngle,

        # euler_angles.jl
        EulerAngles,
        Bunge,
        Kocks,
        Matthies,
        Roe,

        # axis_angles.jl
        AxisAngle,
        AxisAng,
        RodriguesFrank,
        HomochoricVector,

        # conversions.jl
        rotation_matrix

    # src files
    include("interface.jl")
    include("euler_angles.jl")
    include("axis_angles.jl")
    include("conversions.jl")
end #module
