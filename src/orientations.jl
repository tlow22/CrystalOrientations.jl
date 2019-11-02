#===============================================================================
    @file orientations.jl
    @brief Representations of crystal orientation
    @author Thaddeus Low <thaddeuslow@outlook.com>
    @date 11/01/2019
===============================================================================#
abstract type AbstractOrientation end

struct BungeEulerAngles <: AbstractOrientation
    phi1::Float64
    Phi::Float64
    phi2::Float64
end

struct RotationMatrix <: AbstractOrientation
    data::SMatrix{3,3,Float64,9}
end

const Orientation = Union{EulerAngles, Quaternion, RotationMatrix}
