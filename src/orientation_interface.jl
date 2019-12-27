#===============================================================================
  @file orientations_interface.jl
  @brief An interface for representing different orientations
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#
const AbstractOrientation = Union{EulerAngles, AxisAngle, Quaternion,
                                  RotationMatrix}

"""
  Orientation{T,P}

An interface for storing microstructural orientation information.
"""
struct Orientation{P<:AbstractOrientation}
  data::P
end
