@testset "axis_angle_types" begin
  # test all axis angle type orientations
  n̂ = (1.0, 0.0, 0.0)
  θ = 1π
  ort1 = AxisAngle(AxisAng, n̂, θ)
  ort2 = AxisAngle(RodriguesFrank, n̂, θ)
  ort3 = AxisAngle(HomochoricVector, n̂, θ)
  Ω    = [ort1 ort2 ort3]

  for ort in Ω
    @test axis(ort) == n̂
    @test angle(ort) == θ
  end
end
