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
end

## Convenience constructors
function EulerAngles(::Type{E}, θ₁::Real, θ₂::Real, θ₃::Real) where
                    {E<:AbstractEulerAngles, T<:AbstractFloat}
    𝛉 = promote(θ₁, θ₂, θ₃)
    return EulerAngles{E,eltype(𝛉)}(𝛉)
end

EulerAngles(ϕ₁::Real, Φ::Real, ϕ₂::Real) = EulerAngles(Bunge, ϕ₁, Φ, ϕ₂)


## Extend Base functionality
Base.getindex(euls::EulerAngles, i) = euls.data[i]
Base.isapprox(𝛉₁::EulerAngles{E1}, 𝛉₂::EulerAngles{E2}) where {E1,E2} =
    (E1 == E2) && all(𝛉₁.data .≈ 𝛉₂.data)

Base.isapprox(𝛉₁::EulerAngles{E}, 𝛉₂::EulerAngles{E}) where {E} =
    all(𝛉₁.data .≈ 𝛉₂.data)

Base.isequal(𝛉₁::EulerAngles{E1}, 𝛉₂::EulerAngles{E2}) where {E1,E2}=
    all(𝛉₁.data .== 𝛉₂.data) && (E1 == E2)

Base.isequal(𝛉₁::EulerAngles{E}, 𝛉₂::EulerAngles{E}) where {E}=
    all(𝛉₁.data .== 𝛉₂.data)
