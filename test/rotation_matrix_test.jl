@testset "rotation_matrix" begin

  euls = EulerAngles(0.5π, 1.0π, 0.0)
  rot  = RotationMatrix(euls)

  # test adjoint and inverse functionality
  @test rot' == rot.data'
  @test inv(rot) == inv(rot.data)
  @test rot' ≈ inv(rot)

  # test determinant and trace functionality
  @test det(rot) ≈ 1
  @test tr(rot) ≈ -1
end
