#===============================================================================rot:
  @file rotation_matrix.jl
  @brief Orientation in terms of a rotation matrix
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#
struct RotationMatrix <: AbstractOrientation
  data::Matrix{Float64}
end

"""
Constructor identity rotation matrix
"""
function one(::Type{RotationMatrix})
  return RotationMatrix(Matrix{Float64}(I, 3, 3))
end


"""
Access rotation matrix
"""
@inline function getindex(rot::RotationMatrix, i::Int, j::Int)
  return rot.data[i,j]
end

"""
Invert rotation matrix
"""
@inline function inv(rot::RotationMatrix)
  return RotationMatrix(inv(rot.data))
end


"""
Tranpose rotation matrix
"""
@inline function adjoint(rot::RotationMatrix)
  return RotationMatrix(adjoint(rot.data))
end


"""
Operators to replicate linear algebra behavior
"""
(*)(rot::RotationMatrix, v::Vector{Float64}) = rot.data * v
