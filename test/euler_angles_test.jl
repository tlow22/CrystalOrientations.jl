@testset "euler_angles" begin
    data = (0.1*π, 0.5, 0.25*π)
    eul  = EulerAngles(data...)

    @test eul[1] == data[1]
    @test eul[2] == data[2]
    @test eul[3] == data[3]
    @test eul.data == data
    @test eul ≈  EulerAngles(Bunge, 0.1*π, 0.5, 0.25*π)
    @test eul == EulerAngles(Bunge, 0.1*π, 0.5, 0.25*π)
    @test eul != EulerAngles(Bunge, 0.0, 0.0, 0.0)
    @test eul != EulerAngles(Kocks, 0.1*π, 0.5, 0.25*π)
end
