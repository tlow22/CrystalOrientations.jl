@testset "euler_angles" begin
  # test standard convention
  eul = EulerAngles(0.1*π, 0.5, 0.25*π)
  @test eul.properties == Bunge()
  @test eul.data == (0.1*π, 0.5, 0.25*π)
  @test eul[1] == 0.1*π
  @test eul[2] == 0.5
  @test eul[3] == 0.25*π

  # test different conventions
  conventions = [Bunge, Kocks, Matthies, Roe]
  for T in conventions
    @test EulerAngles(T, 0.0, 0.0, 0.0).properties == T()
  end
end
