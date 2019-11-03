#===============================================================================
  @file axis_angle.jl
  @brief Orientation terms of axis-angle representation
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#

struct AxisAngle <: AbstractOrientation
  axis::Tuple{Float64, Float64, Float64}
  angle::Float64
end


axis(axle::AxisAngle)  = axle.axis
angle(axle::AxisAngle) = axle.angle
