#===============================================================================
    @file conversions.jl
    @brief Converts between different orientation representations
    @author Thaddeus Low <thaddeuslow@outlook.com>
    @date 11/01/2019
===============================================================================#
const P = -1                                                                    # Sign convention used (-ve)

## orientation to Quaternion converters
"""
    Quaternion(euler_angle)

Converts EulerAngles → Quaternion{T}
"""
function Quaternion(ort::EulerAngles{Bunge, T}) where {T}
    ϕ₁ = ort[1]
    Φ  = ort[2]
    ϕ₂ = ort[3]

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

"""
    Quaternion(rotation_matrix)

Converts 3x3 rotation matrix → Quaternion{T}
"""
function Quaternion(rot::AbstractArray{T,2}) where {T}
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

"""
    Quaternion(axis_angle)

Converts AxisAngle{AxisAng} → Quaternion{T}
"""
function Quaternion(ort::AxisAngle{AxisAng, T}) where {T}
  θ = ort.angle/2
  s = sin(θ)
  c = cos(θ)
  n̂ = ort.axis
  return Quaternion{T}([c, n̂[1]*s, n̂[2]*s, n̂[3]*s])
end

## orientation → EulerAngles converters
"""
    EulerAngles(rotation_matrix)

Converts 3x3 rotation matrix → EulerAngles{Bunge}
"""
function EulerAngles(::Type{Bunge}, α::AbstractArray{T,2}) where {T}
  if abs(α[3,3]) == 1
    𝜭 = EulerAngles{Bunge,T}(atan(α[1,2], α[1,1]), π/2*(1 - α[3,3]), 0)
  else
    ζ = 1/sqrt(1-α[3,3]*α[3,3])
    𝜭 = EulerAngles{Bunge,T}(atan(α[3,1]*ζ, -α[3,2]*ζ),
                             acos(α[3,3]),
                             atan(α[1,3]*ζ, α[2,3]*ζ) )
  end

  return 𝜭
end

function EulerAngles(::Type{Bunge}, q::Quaternion{T}) where {T}
    s  = q.s
    v₁ = q.v1
    v₂ = q.v2
    v₃ = q.v3

    s₃ = s*s + v₃v₃
    v₁₂ = v₁*v₁ + v₂*v₂
    χ   = √(s₃*v₁₂)

    if χ == 0
        if v₁₂ == 0
            𝚹 = EulerAngles{Bunge,T}(atan(-2*P*s*v₃, s*s-v₃*v₃), 0, 0)
        elseif s₃ == 0
            𝚹 = EulerAngles{Bunge,T}(atan(2*v₁*v₂, v₁*v₁-v₂*v₂), π, 0)
        end
    else
      𝚹 = EulerAngles{Bunge}(atan((v₁*v₃ - P*s*v2)/χ, (-P*s*v₁ - v2*v₃)/χ),
                           atan(2*χ, s₃-v₁₂),
                           atan( (P*s*v2 + v₁*v₃)/χ, (v2*v₃ - P*s*v₁)/χ ))
    end

  return 𝚹
end

## orientation → 3x3 rotation matrix converters
"""
        rotation_matrix(euler_angles)

Converts EulerAngles representation → 3x3 rotation matrix
"""
function rotation_matrix(ort::EulerAngles{Bunge,T}) where {T}
    c₁ = cos(ort[1])
    c  = cos(ort[2])
    c₂ = cos(ort[3])
    s₁ = sin(ort[1])
    s  = sin(ort[2])
    s₂ = sin(ort[3])

    return SMatrix{3,3,T}(c₁*c₂-s₁*c*s₂, -c₁*s₂-s₁*c*c₂,  s₁*s,
                          s₁*c₂+c₁*c*s₂, -s₁*s₂-c₁*c*c₂, -c₁*s,
                          s*s₂,             s*c₂,         c)
end

"""
        rotation_matrix(axis_angle)

Converts AxisAngle{AxisAng} representation → 3x3 rotation matrix
"""
function rotation_matrix(ort::AxisAngle{AxisAng, T}) where {T}
    (n₁, n₂, n₃) = normalize(collect(ort.axis))
    ω = ort.angle
    c = cos(ω)
    s = sin(ω)

    n₁₂ = n₁*n₂
    n₁₃ = n₁*n₃
    n₂₃ = n₂*n₃

    return SMatrix{3,3,T}(c + (1-c)*n₁*n₁, (1-c)*n₁₂ - s*n₃, (1-c)*n₁₃ + s*n₂,
                          (1-c)*n₁₂ + s*n₃, c + (1-c)*n₂*n₂, (1-c)*n₂₃ - s*n₁,
                          (1-c)*n₁₃ - s*n₂, (1-c)*n₂₃ + s*n₁, c + (1-c)*n₃*n₃)
end

"""
        rotation_matrix(quaternion)

Converts Quaternion representation → 3x3 rotation matrix
"""
function rotation_matrix(ort::Quaternion{T}) where {T}
    q = normalize(ort)
    q₀ = q.s
    q₁ = q.v1
    q₂ = q.v2
    q₃ = q.v3
    q̄  = q₀*q₀ - (q₁*q₁ + q₂*q₂ + q₃*q₃)

    return SMatrix{3,3,T}(q̄ + 2*q₁*q₁,  2(q₁*q₂ + P*q₀*q₃),   2(q₁*q₃ - P*q₀*q₂),
                          2(q₁*q₂ - P*q₀*q₃),         q̄ + 2*q₂*q₂,   2(q₂*q₃ + P*q₀*q₁),
                          2(q₁*q₃ + P*q₀*q₂),  2(q₂*q₃ - P*q₀*q₁),   q̄ + 2*q₃*q₃)
end


"""
    AxisAngle(AxisAng, euler_angle)

Converts EulerAngle → AxisAngle{AxisAng}
"""
function AxisAngle(::Type{AxisAng}, ort::EulerAngles{Bunge,T}) where {T}
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

"""
    AxisAngle(AxisAng, rodrigues_vec)

Converts RodriguesFrank vector → AxisAngle{AxisAng}
"""
function AxisAngle(::Type{AxisAng}, ort::AxisAngle{RodriguesFrank,T}) where {T}
    ρ = norm(ort.axis)
    ω = 2*atan(ρ)
    n̂ = ort.axis./ρ
    return AxisAngle{T,AxisAng}(n̂, ω)
end

"""
    AxisAngle(AxisAng, quaternion)

Converts Quaternion → AxisAngle{AxisAng}
"""
function AxisAngle(::Type{AxisAng}, ort::Quaternion{T}) where {T}
    q₀ = ort.s
    q₁ = ort.v1
    q₂ = ort.v2
    q₃ = ort.v3
    ω  = 2*acos(q₀)

    if ω ≈ 0
        n̂ = (0, 0, 1)
    else
        if q₀ ≈ 0
            n̂ = (q₁, q₂, q₃)
            ω = π
        else
            s = sign(q₀)/sqrt(q₁*q₁ + q₂*q₂ + q₃*q₃)
            n̂ = (s*q₁, s*q₂, s*q₃)
        end
    end

    return AxisAngle{AxisAng}(n̂, ω)
end
