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
Euler Angle interface conventions for crystal orientation
"""
abstract type AbstractEulerAngles <: AbstractOrientation end
struct Bunge    <: AbstractEulerAngles end
struct Kocks    <: AbstractEulerAngles end
struct Matthies <: AbstractEulerAngles end
struct Roe      <: AbstractEulerAngles end

struct EulerAngles{P} <: AbstractOrientation where P<:AbstractEulerAngles
    data::Tuple{Float64, Float64, Float64}
    properties::P
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
  return EulerAngles{P}( (θ₁, θ₂, θ₃), P() )
end


"""
Simplified constructor defaults to EulerAngles{Bunge}
"""
@inline function EulerAngles(ϕ₁::Float64, Φ::Float64, ϕ₂::Float64)
  return EulerAngles(Bunge, ϕ₁, Φ, ϕ₂)
end


"""
EulerAngles access operator
"""
@inline function getindex(euls::EulerAngles{P}, i::Int) where P<:AbstractEulerAngles
  return euls.data[i]
end
