@testset "euler_angles" begin
  data = (0.1*π, 0.5, 0.25*π)
  eul = EulerAngles(data...)

  @test eul.properties == Bunge()
  @test eul.data == data
  @test eul[1] == 0.1*π
  @test eul[2] == 0.5
  @test eul[3] == 0.25*π
end
