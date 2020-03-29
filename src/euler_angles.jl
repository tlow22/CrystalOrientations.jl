#===============================================================================
    @file orientations_types.jl
    @brief Representations of crystal orientation
    @author Thaddeus Low <thaddeuslow@outlook.com>
    @date 11/02/2019

    References:
    1) http://pajarito.materials.cmu.edu/rollett/27750/L2-Components_EulerAngles-19Jan16.pptx

    TODO: functions for EulerAngle conventions other than Bunge
          (currently not in need, implement according to future need)

===============================================================================#
"""
    AbstractEulerAngles

Abstract supertype for all EulerAngle representations of microstructural
orientation common to metallurgists.
"""
abstract type AbstractEulerAngles end
struct Bunge    <: AbstractEulerAngles end
struct Kocks    <: AbstractEulerAngles end
struct Matthies <: AbstractEulerAngles end
struct Roe      <: AbstractEulerAngles end

"""
    EulerAngles{E<:AbstractEulerAngles, T<:AbstractFloat}

An interface for different Euler angles conventions, implemented
subtypes of AbstractEulerAngles include:
    • Bunge     (ϕ₁, Φ, ϕ₂)
    • Roe       (Ψ, Θ, Φ)
    • Kocks     (Ψ, Θ, ϕ)
    • Matthies  (α, β, γ)
"""
struct EulerAngles{E<:AbstractEulerAngles, T<:AbstractFloat}
    data::NTuple{3,T}

    function EulerAngles(::Type{E}, θ₁::T, θ₂::T, θ₃::T) where
                        {E<:AbstractEulerAngles, T<:AbstractFloat}
        return new{E,T}((θ₁, θ₂, θ₃))
    end
end

## Convenience constructors
function EulerAngles(T, ::Type{E}, θ₁, θ₂, θ₃) where E<:AbstractEulerAngles
    return EulerAngles{E,T}( (T(θ₁), T(θ₂), T(θ₃)), E() )
end

EulerAngles(ϕ₁::T, Φ::T, ϕ₂::T) where {T} = EulerAngles(Bunge, ϕ₁, Φ, ϕ₂)

## Extend Base functionality
Base.getindex(euls::EulerAngles, i) = euls.data[i]
