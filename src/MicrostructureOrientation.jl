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
    • AxisAngle
    • Quaternion
    • RodriguesVec (i.e. Rodrigues Vector)
    • HomochorVec  (i.e. Homochoric Vector)
===============================================================================#
module MicrostructureOrientation
  using Reexport
  @reexport using Quaternions

  include("orientation_interface.jl")
  include("euler_angles.jl")
  include("axis_angle.jl")
  include("rodrigues_vector.jl")
  include("homochoric_vector.jl")
  include("conversions.jl")

end #module