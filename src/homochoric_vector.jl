#===============================================================================
  @file homochoric_vector.jl
  @brief Orientation in terms of the homochoric_vector
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#
struct HomochoricVec <: AbstractOrientation
  axis::Tuple{Float64, Float64, Float64}
  angle::Float64
end

axis(ort::HomochoricVec) = ort.axis
angle(ort::HomochoricVec) = ort.angle
