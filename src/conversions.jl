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

function Quaternion(ort::AxisAngle{T, AxisAng})
  θ = angle(ort)/2
  s = sin(θ)
  c = cos(θ)
  n̂ = axis(ort)
  return Quaternion{T}([c, n̂[1]*s, n̂[2]*s, n̂[3]*s])
end




"""
Convert → EulerAngles
"""
function EulerAngles{Bunge}(α::RotationMatrix)

  if abs(α[3,3]) == 1.0
      𝜭 = EulerAngles{Bunge}(atan(α[1,2], α[1,1]),
                             0.5*π*(1.0 - α[3,3]),
                             0.0)
  else
      ζ = 1.0/sqrt(1.0-α[3,3]^2.0)
      𝜭 = EulerAngles{Bunge}(atan(α[3,1]*ζ, -α[3,2]*ζ),
                             acos(α[3,3]),
                             atan(α[1,3]*ζ, α[2,3]*ζ) )
  end

  return 𝜭
end


function EulerAngles{Bunge}(q::Quaternion)
    s  = q.s
    v₁ = q.v₁
    v₂ = q.v2o
    v₃ = q.v₃

    s₃ = s^2 + v₃^2
    v₁₂ = v₁^2 + v₂^2
    χ   = √(s₃*v₁₂)

    if χ == 0
        if v₁₂ == 0
            𝚹 = EulerAngles{Bunge}(atan(-2*P*s*v₃, s^2-v₃^2), 0.0, 0.0)
        elseif s₃ == 0
            𝚹 = EulerAngles{Bunge}(atan(2*v₁*v2, v₁^2-v2^2), π, 0.0)
        end
    else
        𝚹 = EulerAngles{Bunge}(atan((v₁*v₃ - P*s*v2)/χ, (-P*s*v₁ - v2*v₃)/χ),
                               atan(2*χ, s₃-v₁₂),
                               atan( (P*s*v2 + v₁*v₃)/χ, (v2*v₃ - P*s*v₁)/χ ))
    end

    return 𝚹
end



# TODO: END LAST PROGRESS
"""
Converts a Bunge-Euler representation (radians) to a rotation matrix
(passive rotation)
"""
function rot_matrix(euls::EulerAngles{Bunge})
  ϕ₁ = euls[1]
  Φ  = euls[2]
  ϕ₂ = euls[3]

  c1 = cos(ϕ₁)
  c  = cos(Φ)
  c2 = cos(ϕ₂)

  s1 = sin(ϕ₁)
  s  = sin(Φ)
  s2 = sin(ϕ₂)

  return RotationMatrix(
    c1*c2 - s1*c*s2, -c1*s2 - s1*c*c2, s1*s,
    s1*c2 + c1*c*s2, -s1*s2 + c1*c*c2, -c1*s,
    s*s2           ,  s*c2           , c      )


end

#=
  @brief Converts a quaternion representation to a Bunge-Euler angles
         representation (radians)
=#
function EulerAngles{Bunge}(𝐪::Quaternion)
    s  = 𝐪.s
    v₁ = 𝐪.v₁
    v2 = 𝐪.v2
    v₃ = 𝐪.v₃

    s₃ = s^2 + v₃^2
    v₁₂ = v₁^2 + v2^2
    χ   = √(s₃*v₁₂)

    if χ == 0
        if v₁₂ == 0
            euls = EulerAngles{Bunge}(atan(-2*P*s*v₃, s^2-v₃^2), 0.0, 0.0)
        elseif s₃ == 0
            euls = EulerAngles{Bunge}(atan(2*v₁*v2, v₁^2-v2^2), π, 0.0)
        end
    else
        euls = EulerAngles{Bunge}(atan((v₁*v₃ - P*s*v2)/χ, (-P*s*v₁ - v2*v₃)/χ),
                        atan(2*χ, s₃-v₁₂),
                        atan( (P*s*v2 + v₁*v₃)/χ, (v2*v₃ - P*s*v₁)/χ ))
    end

    return euls
end

#=
    @brief Converts the quaternion representation to the rotation
           matrix (passive)
=#
function rotationMatrix(𝐪::Quaternion)
    q = normalize(𝐪)

    q̄ = q.s^2 - (q.v₁^2 + q.v2^2 + q.v₃^2)
    s1 = q.s * q.v₁
    s2 = q.s * q.v2
    s₃ = q.s * q.v₃
    v₁₂ = q.v₁ * q.v2
    v₁3 = q.v₁ * q.v₃
    v23 = q.v2 * q.v₃

    rotation = zeros(3,3)
    rotation[1,1] = q̄ + 2*q.v₁^2
    rotation[1,2] = 2 * (v₁₂ - P*s₃)
    rotation[1,3] = 2 * (v₁3 + P*s2)
    rotation[2,1] = 2 * (v₁₂ + P*s₃)
    rotation[2,2] = q̄ + 2*q.v2^2
    rotation[2,3] = 2 * (v23 - P*s1)
    rotation[3,1] = 2 * (v₁3 - P*s2)
    rotation[3,2] = 2 * (v23 + P*s1)
    rotation[3,3] = q̄ + 2*q.v₃^2

    return rotation
end


#=
  @brief Converts a rotation matrix (passive) to the Bunge-Euler angles in
         radians (angles may be different numerically if converted from
         original and converted back but represent the same rotation)
=#
function EulerAngles{Bunge}(α::RotationMatrix)

  if abs(α[3,3]) == 1.0
      𝜭 = EulerAngles{Bunge}(atan(α[1,2], α[1,1]),
                       0.5*π*(1.0 - α[3,3]),
                       0.0)
  else
      ζ = 1.0/sqrt(1.0-α[3,3]^2.0)
      𝜭 = EulerAngles{Bunge}(atan(α[3,1]*ζ, -α[3,2]*ζ),
                      acos(α[3,3]),
                      atan(α[1,3]*ζ, α[2,3]*ζ) )
  end

  return 𝜭
end


#=
    @brief Converts the (passive) rotation matrix to a quaternion representation
=#
function quaternion(α::RotationMatrix)
  s = 0.5 * sqrt(1 + α[1,1] + α[2,2] + α[3,3])
  v₁ = 0.5 * P * sqrt(1 + α[1,1] - α[2,2] - α[3,3])
  v2 = 0.5 * P * sqrt(1 - α[1,1] + α[2,2] - α[3,3])
  v₃ = 0.5 * P * sqrt(1 - α[1,1] - α[2,2] + α[3,3])

  if α[3,2] < α[2,3]
      v₁ = -v₁
  end

  if α[1,3] < α[3,1]
      v2 = -v2
  end

  if α[2,1] < α[1,2]
      v₃ = -v₃
  end

  𝐪 = Quaternion(s, v₁, v2, v₃)
  return normalize(𝐪)
end
