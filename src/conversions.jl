#===============================================================================
  @file conversions.jl
  @brief Convert between different orientation representations
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/01/2019

  "Rowenhorst, David, et al. "Consistent representations of and conversions
  between 3D rotations." Modelling and Simulation in Materials Science and
  Engineering 23.8 (2015): 083501."
===============================================================================#
const P = -1.0                                                                  # Sign convention used (-ve)

#=
  @brief Converts a Bunge-Euler representation to a quaternion representation
=#
function quaternion(𝚹::EulerAngles)
  σ = 0.5 * (𝚹.ϕ₁ + 𝚹.ϕ₂)
  δ = 0.5 * (𝚹.ϕ₁ - 𝚹.ϕ₂)
  c = cos(𝚹.Φ * 0.5)
  s = sin(𝚹.Φ * 0.5)

  sgn = sign(c*cos(σ))
  return  Quaternion(  sgn*c*cos(σ),
                      -sgn*P*s*cos(δ),
                      -sgn*P*s*sin(δ),
                      -sgn*P*c*sin(σ) )
end

#=
  @brief Converts a Bunge-Euler representation (radians) to a rotation matrix
         (passive rotation)
=#
function rotationMatrix(𝚹::EulerAngles)
  c1 = cos(𝚹.ϕ₁)
  c  = cos(𝚹.Φ)
  c2 = cos(𝚹.ϕ₂)

  s1 = sin(𝚹.ϕ₁)
  s  = sin(𝚹.Φ)
  s2 = sin(𝚹.ϕ₂)

  return SMatrix{3,3}(                                                      # Note column major sequencing of matrix entries
    c1*c2 - s1*c*s2, -c1*s2 - s1*c*c2, s1*s,
    s1*c2 + c1*c*s2, -s1*s2 + c1*c*c2, -c1*s,
    s*s2           ,  s*c2           , c      )
end

#=
  @brief Converts a quaternion representation to a Bunge-Euler angles
         representation (radians)
=#
function eulerAngles(𝐪::Quaternion)
    s  = 𝐪.s
    v1 = 𝐪.v1
    v2 = 𝐪.v2
    v3 = 𝐪.v3

    s3 = s^2 + v3^2
    v12 = v1^2 + v2^2
    χ   = √(s3*v12)

    if χ == 0
        if v12 == 0
            𝚹 = EulerAngles(atan(-2*P*s*v3, s^2-v3^2), 0.0, 0.0)
        elseif s3 == 0
            𝚹 = EulerAngles(atan(2*v1*v2, v1^2-v2^2), π, 0.0)
        end
    else
        𝚹 = EulerAngles(atan((v1*v3 - P*s*v2)/χ, (-P*s*v1 - v2*v3)/χ),
                        atan(2*χ, s3-v12),
                        atan( (P*s*v2 + v1*v3)/χ, (v2*v3 - P*s*v1)/χ ))
    end

    return 𝚹
end

#=
    @brief Converts the quaternion representation to the rotation
           matrix (passive)
=#
function rotationMatrix(𝐪::Quaternion)
    q = normalize(𝐪)

    q̄ = q.s^2 - (q.v1^2 + q.v2^2 + q.v3^2)
    s1 = q.s * q.v1
    s2 = q.s * q.v2
    s3 = q.s * q.v3
    v12 = q.v1 * q.v2
    v13 = q.v1 * q.v3
    v23 = q.v2 * q.v3

    rotation = zeros(3,3)
    rotation[1,1] = q̄ + 2*q.v1^2
    rotation[1,2] = 2 * (v12 - P*s3)
    rotation[1,3] = 2 * (v13 + P*s2)
    rotation[2,1] = 2 * (v12 + P*s3)
    rotation[2,2] = q̄ + 2*q.v2^2
    rotation[2,3] = 2 * (v23 - P*s1)
    rotation[3,1] = 2 * (v13 - P*s2)
    rotation[3,2] = 2 * (v23 + P*s1)
    rotation[3,3] = q̄ + 2*q.v3^2

    return rotation
end


#=
  @brief Converts a rotation matrix (passive) to the Bunge-Euler angles in
         radians (angles may be different numerically if converted from
         original and converted back but represent the same rotation)
=#
function eulerAngles(α::RotationMatrix)

  if abs(α[3,3]) == 1.0
      𝜭 = EulerAngles(atan(α[1,2], α[1,1]),
                       0.5*π*(1.0 - α[3,3]),
                       0.0)
  else
      ζ = 1.0/sqrt(1.0-α[3,3]^2.0)
      𝜭 = EulerAngles(atan(α[3,1]*ζ, -α[3,2]*ζ),
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
  v1 = 0.5 * P * sqrt(1 + α[1,1] - α[2,2] - α[3,3])
  v2 = 0.5 * P * sqrt(1 - α[1,1] + α[2,2] - α[3,3])
  v3 = 0.5 * P * sqrt(1 - α[1,1] - α[2,2] + α[3,3])

  if α[3,2] < α[2,3]
      v1 = -v1
  end

  if α[1,3] < α[3,1]
      v2 = -v2
  end

  if α[2,1] < α[1,2]
      v3 = -v3
  end

  𝐪 = Quaternion(s, v1, v2, v3)
  return normalize(𝐪)
end
