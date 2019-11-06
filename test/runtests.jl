#===============================================================================
  @file runtests.jl
  @brief Runs unit tests
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#

using MicrostructureOrientation, Test

include("euler_angles_test.jl")
include("rotation_matrix_test.jl")
include("axis_angle_types_test.jl")
