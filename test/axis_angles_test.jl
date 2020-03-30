@testset "axis_angle_types" begin
    # test constructors
    n̂  = (1.0, 0.0, 0.0)
    θ  = π
    Ω₁ = AxisAngle(AxisAng, n̂, θ)
    Ω₂ = AxisAngle(RodriguesFrank, n̂, θ)
    Ω₃ = AxisAngle(HomochoricVector, n̂, θ)
    Ω  = [Ω₁, Ω₂, Ω₃]

    for ort in Ω
        @test ort.axis  == n̂
        @test ort.angle == θ
    end
end
