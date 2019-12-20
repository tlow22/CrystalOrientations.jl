#===============================================================================
  @file conversions.jl
  @brief Convert between different orientation representations
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/01/2019
===============================================================================#
const P = -1                                                                  # Sign convention used (-ve)

"""
Convert <:AbstractOrientation → Quaternion{T}
"""
Quaternion(quat::Quaternion) = quat

function Quaternion(euls::EulerAngles{T, Bunge}) where T
  ϕ₁ = euls[1]
  Φ  = euls[2]
  ϕ₂ = euls[3]

  σ = (ϕ₁ + ϕ₂)/2
  δ = (ϕ₁ - ϕ₂)/2
  c = cos(Φ/2)
  s = sin(Φ/2)

  sgn = sign(c*cos(σ))
  return  Quaternion{T}( sgn*c*cos(σ),
                        -sgn*P*s*cos(δ),
                        -sgn*P*s*sin(δ),
                        -sgn*P*c*sin(σ) )
end

function Quaternion(rot::RotationMatrix{T}) where T
  # compute quaternion components
  q₀ = 1/2 * sqrt(1 + rot[1,1] + rot[2,2] + rot[3,3])
  q₁ = P/2 * sqrt(1 + rot[1,1] - rot[2,2] - rot[3,3])
  q₂ = P/2 * sqrt(1 - rot[1,1] + rot[2,2] - rot[3,3])
  q₃ = P/2 * sqrt(1 - rot[1,1] - rot[2,2] + rot[3,3])

  # modify component signs if necessary
  if rot[3,2] < rot[2,3]
    q₁ = -q₁
  end

  if rot[1,3] < rot[3,1]
    q₂ = -q₂
  end

  if rot[2,1] < rot[1,2]
    q₃ = -q₃
  end

  return normalize(Quaternion{T}(q₀, q₁, q₂, q₃))
end

function Quaternion(ort::AxisAngle{T, AxisAng}) where T
  θ = angle(ort)/2
  s = sin(θ)
  c = cos(θ)
  n̂ = axis(ort)
  return Quaternion{T}([c, n̂[1]*s, n̂[2]*s, n̂[3]*s])
end


"""
Convert <:AbstractOrientation → EulerAngles
"""
function EulerAngles(::Type{E}, α::RotationMatrix{T}) where
                     {E<:AbstractEulerAngles, T}

  if abs(α[3,3]) == 1.0
    𝜭 = EulerAngles{T,Bunge}(atan(α[1,2], α[1,1]),
                             0.5*π*(1.0 - α[3,3]),
                             0.0)
  else
    ζ = 1/sqrt(1-α[3,3]^2)
    𝜭 = EulerAngles{T,Bunge}(atan(α[3,1]*ζ, -α[3,2]*ζ),
                             acos(α[3,3]),
                             atan(α[1,3]*ζ, α[2,3]*ζ) )
  end

  return 𝜭
end

function EulerAngles(::Type{E}, q::Quaternion{T}) where
                     {E<:AbstractEulerAngles, T}
  s  = q.s
  v₁ = q.v1
  v₂ = q.v2
  v₃ = q.v3

  s₃ = s^2 + v₃^2
  v₁₂ = v₁^2 + v₂^2
  χ   = √(s₃*v₁₂)

  if χ == 0
      if v₁₂ == 0
          𝚹 = EulerAngles{T,Bunge}(atan(-2*P*s*v₃, s^2-v₃^2), 0.0, 0.0)
      elseif s₃ == 0
          𝚹 = EulerAngles{T,Bunge}(atan(2*v₁*v₂, v₁^2-v₂^2), π, 0.0)
      end
  else
      𝚹 = EulerAngles{Bunge}(atan((v₁*v₃ - P*s*v2)/χ, (-P*s*v₁ - v2*v₃)/χ),
                             atan(2*χ, s₃-v₁₂),
                             atan( (P*s*v2 + v₁*v₃)/χ, (v2*v₃ - P*s*v₁)/χ ))
  end

  return 𝚹
end


"""
Convert <:AbstractOrientation → RotationMatrix
"""
function RotationMatrix(eul::EulerAngle{T,Bunge}) where T
  c₁ = cos(eul[1])
  c  = cos(eul[2])
  c₂ = cos(eul[3])
  s₁ = sin(eul[1])
  s  = sin(eul[2])
  s₂ = sin(eul[3])

  return RotationMatrix(SMatrix{3,3,T}(c₁*c₂ - s₁*c*s₂, -c₁*s₂ - s₁*c*c₂,  s₁*s,
                                       s₁*c₂ + c₁*c*s₂, -s₁*s₂ - c₁*c*c₂, -c₁*s,
                                       s*s₂,             s*c₂,          ,  c))
end

function RotationMatrix(ort::AxisAngle{T, AxisAng}) where T
  (n₁, n₂, n₃) = normalize(collect(axis(ort)))
  ω = angle(ort)
  c = cos(ω)
  s = sin(ω)

  n₁₂ = n₁*n₂
  n₁₃ = n₁*n₃
  n₂₃ = n₂*n₃

  return RotationMatrix(
          SMatrix{3,3,T}(
            c + (1-c)*n₁*n₁, (1-c)*n₁₂ - s*n₃, (1-c)*n₁₃ + s*n₂,
            (1-c)*n₁₂ + s*n₃, c + (1-c)*n₂*n₂, (1-c)*n₂₃ - s*n₁,
            (1-c)*n₁₃ - s*n₂, (1-c)*n₂₃ + s*n₁, c + (1-c)*n₃*n₃) )
end

function RotationMatrix(ort::Quaternion{T}) where T
  q = normalize(ort)
  q₀ = q.s
  q₁ = q.v1
  q₂ = q.v2
  q₃ = q.v3
  q̄  = q₀*q₀ - (q₁*q₁ + q₂*q₂ + q₃*q₃)

  return RotationMatrix{T}(
          (SMatrix{3,3,T}(
                   q̄ + 2*q₁*q₁,  2(q₁*q₂ + P*q₀*q₃),   2(q₁*q₃ - P*q₀*q₂),
            2(q₁*q₂ - P*q₀*q₃),         q̄ + 2*q₂*q₂,   2(q₂*q₃ + P*q₀*q₁),
            2(q₁*q₃ + P*q₀*q₂),  2(q₂*q₃ - P*q₀*q₁),   q̄ + 2*q₃*q₃) ))
end


"""
Convert <:AbstractOrientation → AxisAngle{AxisAng}
"""
function AxisAngle(::Type{AxisAng}, ort::EulerAngle{T,Bunge}) where T
  (ϕ₁, Φ, ϕ₂) = ort.data
  t = tan(Φ/2)
  σ = (ϕ₁+ϕ₂)/2
  δ = (ϕ₁-ϕ₂)/2
  τ = sqrt(t*t + sin(σ)^2)

  ratio = P/τ
  axis  = (-ratio*t*cos(δ), -ratio*t*sin(δ), -ratio*sin(σ))
  α     = 2*atan(τ/cos(σ))

  if α > π
    axis = .-axis
    α    = 2π-α
  end

  return AxisAngle{T,AxisAng}(axis, angle)
end

function AxisAngle(::Type{AxisAng}, ort::)
