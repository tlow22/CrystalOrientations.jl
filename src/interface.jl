#===============================================================================
    @file orientations_interface.jl
    @brief Interface hierarchy for orientation representations
    @author Thaddeus Low <thaddeuslow@outlook.com>
    @date 11/03/2019
===============================================================================#
abstract type AbstractOrientation end
abstract type AbstractEulerAngles <: AbstractOrientation end
abstract type AbstractAxisAngle <: AbstractOrientation end
