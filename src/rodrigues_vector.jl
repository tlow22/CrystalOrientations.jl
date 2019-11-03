#===============================================================================
  @file rodrigues_vector.jl
  @brief Orientation terms of the Rodrigues vector
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#
struct RodriguesVec <: AbstractOrientation
  axis::Tuple{Float64, Float64, Float64}
  angle::Float64
end

axis(ort::RodriguesVec) = ort.axis
angle(ort::RodriguesVec) = ort.angle
