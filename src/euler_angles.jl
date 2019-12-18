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

struct EulerAngles{E<:AbstractEulerAngles,T} <: AbstractOrientation
  data::NTuple{3,T}
  properties::E
end

"""
Constructor for EulerAngles with different conventions available (as-spelled):
    • Bunge     (ϕ₁, Φ, ϕ₂)
    • Roe       (Ψ, Θ, Φ)
    • Kocks     (Ψ, Θ, ϕ)
    • Matthies  (α, β, γ)
"""
@inline function EulerAngles(::Type{E}, θ₂::T, θ₁::T, θ₃::T) where
                             {E<:AbstractEulerAngles, T}
  return EulerAngles{E,T}( (θ₁, θ₂, θ₃), P() )
end


"""
Default constructor: Bunge convention
"""
EulerAngles(ϕ₁::T, Φ::T, ϕ₂::T) where T = EulerAngles(Bunge, ϕ₁, Φ, ϕ₂)



"""
Extend Base functionality to EulerAngles
"""
getindex(euls::EulerAngles, i) = euls.data[i]
