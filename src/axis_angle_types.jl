#===============================================================================
  @file axis_angle.jl
  @brief Orientation terms of axis-angle representation
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#
"""
Axis angle type orientation structures
"""
struct AxisAngle <: AbstractOrientation
  axis::Tuple{Float64, Float64, Float64}
  angle::Float64
end

struct RodriguesFrank <: AbstractOrientation
  axis::Tuple{Float64, Float64, Float64}
  angle::Float64
end

struct HomochoricVector <: AbstractOrientation
  axis::Tuple{Float64, Float64, Float64}
  angle::Float64
end

const AxisOrientations = Union{RodriguesFrank, HomochoricVector, AxisAngle}


"""
Returns axis vector for any AxisOrientation type
"""
@inline function axis(orientation::P) where P<:AxisOrientations
  return orientation.axis
end

"""
Returns rotation angle about an axis vector for any AxisOrientation type
"""
@inline function angle(orientation::P) where P<:AxisOrientations
  return orientation.angle
end


"""
Returns axis vector for Orientation interface of type AxisOrientation
"""
@inline function axis(ort::Orientation{P}) where P<:AxisOrientations
  return axis(ort.data)
end


"""
Returns rotation angle about an axis vector for Orientation interface of type
AxisOrientation
"""
@inline function angle(ort::Orientation{P}) where P<:AxisOrientations
  return angle(ort.data)
end
