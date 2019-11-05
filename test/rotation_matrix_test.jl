@testset "rotation_matrix" begin

  matrix = rand(3,3)
  vector = rand(3)
  rotMat = RotationMatrix(matrix)
  rotI   = one(RotationMatrix)
  @test rotI.data == Matrix{Float64}(I,3,3)
  @test inv(rotMat).data == inv(matrix)
  @test rotMat'.data == matrix'
  @test rotMat * vector == matrix * vector

  for j=1:3, i=1:3
    @test matrix[i,j] == rotMat[i,j]
  end
end
