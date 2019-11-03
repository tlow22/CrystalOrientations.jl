#===============================================================================
  @file orientations_interface.jl
  @brief An interface for representing different orientations
  @author Thaddeus Low <thaddeuslow@outlook.com>
  @date 11/03/2019
===============================================================================#
"""
Orientation interface
"""
abstract type AbstractOrientation end

struct Orientation{P<:AbstractOrientation}
  data::P
end
