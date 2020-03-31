@testset "Conversions" begin

    θ = EulerAngles(Bunge, π/6, 0.0, 0.0)
    n = AxisAngle(AxisAng, (0.0,0.0,1.0), π/6)
    q = normalize(Quaternion(2.0, 3.0, 0.258819, 0.9659258))

    @test EulerAngles(Bunge, Quaternion(θ))         ≈ θ
    @test EulerAngles(Bunge, AxisAngle(AxisAng, θ)) ≈ θ
    @test EulerAngles(Bunge, rotation_matrix(θ))    ≈ θ

    @test Quaternion(rotation_matrix(q))            ≈ q
    @test Quaternion(AxisAngle(AxisAng, q))         ≈ q
    @test Quaternion(EulerAngles(Bunge, q))         ≈ q

    @test AxisAngle(AxisAng, rotation_matrix(n))    ≈ n
    @test AxisAngle(AxisAng, Quaternion(n))         ≈ n
    @test AxisAngle(AxisAng, EulerAngles(Bunge, n)) ≈ n
end
