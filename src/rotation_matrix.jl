#===============================================================================
    @file rotation_matrix.jl
    @brief Representation of orientation via an orientation matrix
    @author Thaddeus Low <thaddeuslow@outlook.com>
    @date 12/20/2019
===============================================================================#
"""
  RotationMatrix{T}
Container for a 3D rotation matrix (3x3)
"""
struct RotationMatrix{T}
  data::SMatrix{3,3,T}
end


"""
Extend Base functionality
"""
iterate(rot::RotationMatrix, i) = iterate(rot.data, i)
getindex(rot::RotationMatrix, i, j) = getindex(rot.data, i, j)
tr(rot::RotationMatrix)  = tr(rot.data)
det(rot::RotationMatrix) = det(rot.data)
adjoint(rot::RotationMatrix) = adjoint(rot.data)
inv(rot::RotationMatrix) = inv(rot.data)
(*)(rot::RotationMatrix, array) = rot.data * array
