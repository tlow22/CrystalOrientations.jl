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
getindex(rot::RotationMatrix, i, j) = getindex(rot.data, i, j)
(*)(rot::RotationMatrix, array) = rot.data * array
