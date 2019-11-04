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
Access functions
"""
@inline function axis(orientation::P) where P<:AxisOrientations
  return orientatino.axis
end

@inline function angle(orientation::P) where P<:AxisOrientations
  return orientatino.angle
end
