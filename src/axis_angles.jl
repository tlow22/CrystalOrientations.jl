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
"""
struct AxisAngle{A<:AbstractAxisAngle, T<:AbstractFloat}
    axis::NTuple{3,T}
    angle::T

    function AxisAngle(::Type{A}, n::NTuple{3,T}, θ::T) where {A,T}
      return new{A,T}(n, θ)
    end
end


## Extend Base functionality
Base.getindex(euls::AxisAngle, i) = euls.data[i]

Base.isapprox(𝛉₁::AxisAngle{E1}, 𝛉₂::AxisAngle{E2}) where {E1,E2} =
    (E1 == E2) && all(𝛉₁.axis .≈ 𝛉₂.axis) && (𝛉₁.angle ≈ 𝛉₂.angle)

Base.isapprox(𝛉₁::AxisAngle{E}, 𝛉₂::AxisAngle{E}) where {E} =
    (𝛉₁.axis == 𝛉₂.axis) && (𝛉₁.angle == 𝛉₂.angle)

Base.isequal(𝛉₁::AxisAngle{E1}, 𝛉₂::AxisAngle{E2}) where {E1,E2}=
    (E1 == E2) && (𝛉₁.axis == 𝛉₂.axis) && (𝛉₁.angle == 𝛉₂.angle)

Base.isequal(𝛉₁::AxisAngle{E}, 𝛉₂::AxisAngle{E}) where {E}=
    (𝛉₁.axis == 𝛉₂.axis) && (𝛉₁.angle == 𝛉₂.angle)
