#===============================================================================
  @file axis_angles.jl
  @brief Orientation represented in terms of an axis and rotation angle
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 12/19/2019

  Currently available axis-angle representations:
  1) AxisAng
  2) RodriguesFrank
  3) HomochoricVector
===============================================================================#
"""
Axis angle type orientation structures
"""
abstract type AbstractAxisAngle end
struct AxisAng <: AbstractAxisAngle end
struct RodriguesFrank <: AbstractAxisAngle end
struct HomochoricVector <: AbstractAxisAngle end

struct AxisAngle{T,A<:AbstractAxisAngle} <: AbstractOrientation
  axis::NTuple{3,T}
  angle::T
  properties::A
end

"""
Returns axis vector for any AxisOrientation type
"""
axis(ort::P) where P<:AxisAngle = ort.axis
angle(ort::P) where P<:AxisAngle = ort.angle
