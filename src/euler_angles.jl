#===============================================================================
    @file orientations_types.jl
    @brief Representations of crystal orientation
    @author Thaddeus Low <thaddeuslow@outlook.com>
    @date 11/02/2019

    References:
    1) http://pajarito.materials.cmu.edu/rollett/27750/L2-Components_EulerAngles-19Jan16.pptx

===============================================================================#
"""
Euler Angle interface conventions for crystal orientation
"""
abstract type AbstractEulerAngles <: AbstractOrientation end
struct Bunge    <: AbstractEulerAngles end
struct Kocks    <: AbstractEulerAngles end
struct Matthies <: AbstractEulerAngles end
struct Roe      <: AbstractEulerAngles end

struct EulerAngles{P} <: AbstractOrientation where P<:AbstractEulerAngles
    data::Tuple{Float64, Float64, Float64}
end

"""
Default constructor: EulerAngles{Bunge}
"""
@inline function EulerAngles(ϕ₁::Float64, Φ::Float64, ϕ₂::Float64)
  return EulerAngles{Bunge}(Tuple(ϕ₁, Φ, ϕ₂))
end


"""
Constructor for EulerAngles with different conventions available (as-spelled):
    • Bunge     (ϕ₁, Φ, ϕ₂)
    • Roe       (Ψ, Θ, Φ)
    • Kocks     (Ψ, Θ, ϕ)
    • Matthies  (α, β, γ)
"""
@inline function EulerAngles(::Type{P},
                             θ₁::Float64,
                             θ₂::Float64,
                             θ₃::Float64) where P<:AbstractEulerAngles
    return EulerAngles{P}(Tuple(θ₁, θ₂, θ₃))
end


"""
EulerAngles access/operator definitions
"""
@inline function ([])(euls::EulerAngles{P}, idx::Int) where P<:AbstractEulerAngles
    return euls.data[idx]
end
