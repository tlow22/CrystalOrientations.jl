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
    AbstractAxisAngle

Abstract supertype for all axis-angle representations of microstructural
orientation common to metallurgists.
"""
struct AxisAng          <: AbstractAxisAngle end
struct RodriguesFrank   <: AbstractAxisAngle end
struct HomochoricVector <: AbstractAxisAngle end


"""
    AxisAngle{E<:AbstractAxisAngle, T<:AbstractFloat}

An interface for different axis-angles type descriptors, implemented
subtypes of AbstractAxisAngle include:
    • AxisAng
    • RodriguesFrank
    • HomochoricVector

The axis is a unit vector, and the angle in radians. 
"""
struct AxisAngle{A<:AbstractAxisAngle, T<:Real}
    axis::Tuple{T, T, T}
    angle::T
end

## Convenience constructors
function AxisAngle(::Type{A}, axis::Tuple{T,T,T}, angle::T) where
                   {A<:AbstractAxisAngle, T<:AbstractFloat}
    return AxisAngle{A,T}(axis, angle)
end

function AxisAngle(::Type{A}, x::T, y::T, z::T, angle::T) where
                   {A<:AbstractAxisAngle, T<:AbstractFloat}
    norm = sqrt(x*x + y*y + z*z)
    axis = (x/norm, y/norm, z/norm)
    return AxisAngle{A,T}(axis, angle)
end

AxisAngle(::Type{A}, x::Real, y::Real, z::Real, θ::Real) where {A} =
    AxisAngle(A, promote(x,y,z,θ)...)


## Extend Base functionality
Base.isapprox(a₁::AxisAngle{E1}, a₂::AxisAngle{E2}) where {E1,E2} =
    E1 == E2 && all(a₁.axis .≈ a₂.axis) && a₁.angle ≈ a₂.angle

Base.isapprox(a₁::AxisAngle{E}, a₂::AxisAngle{E}) where {E} =
    all(a₁.axis .≈ a₂.axis) && a₁.angle ≈ a₂.angle

Base.isequal(a₁::AxisAngle{E1}, a₂::AxisAngle{E2}) where {E1,E2} =
    E1 == E2 && all(a₁.axis .== a₂.axis) && a₁.angle == a₂.angle

Base.isequal(a₁::AxisAngle{E}, a₂::AxisAngle{E}) where {E} =
    all(a₁.axis .== a₂.axis) && a₁.angle == a₂.angle
