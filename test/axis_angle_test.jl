@testset "axis_angle_types" begin
  # test all axis angle type orientations
  ort1 = AxisAngle((1.0, 1.0, 1.0), π)
  ort2 = RodriguesFrank((1.0, 1.0, 1.0), π)
  ort3 = HomochoricVector((1.0, 1.0, 1.0), π)
  Ω    = [ort1 ort2 ort3]

  ort11 = Orientation(ort1)
  ort22 = Orientation(ort2)
  ort33 = Orientation(ort3)
  Γ     = [ort11, ort22, ort33]

  for (i, ort) in enumerate(Ω)
    @test axis(ort) == axis(Γ[i])
    @test angle(ort) == angle(Γ[i])
  end
end
