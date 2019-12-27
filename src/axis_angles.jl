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

struct AxisAngle{T,A<:AbstractAxisAngle}
  axis::NTuple{3,T}
  angle::T
  properties::A
end


"""
Convenience constructor(s)
"""
function AxisAngle(::Type{A}, n::NTuple{3,T}, θ::T) where {A,T}
  return AxisAngle{T,A}(n, θ, A())
end

"""
Returns axis vector for any AxisOrientation type
"""
axis(ort::P) where P<:AxisAngle = ort.axis
angle(ort::P) where P<:AxisAngle = ort.angle
