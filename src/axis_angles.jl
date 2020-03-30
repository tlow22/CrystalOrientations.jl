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
    EulerAngles{E<:AbstractEulerAngles, T<:AbstractFloat}

An interface for different Euler angles conventions, implemented
subtypes of AbstractEulerAngles include:
    • Bunge     (ϕ₁, Φ, ϕ₂)
    • Roe       (Ψ, Θ, Φ)
    • Kocks     (Ψ, Θ, ϕ)
    • Matthies  (α, β, γ)
"""
struct AxisAngle{A<:AbstractAxisAngle, T<:AbstractFloat}
    axis::NTuple{3,T}
    angle::T

    function AxisAngle(::Type{A}, n::NTuple{3,T}, θ::T) where {A,T}
      return new{A,T}(n, θ)
    end
end
