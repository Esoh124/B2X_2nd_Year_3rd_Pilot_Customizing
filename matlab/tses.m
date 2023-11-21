% 예제 데이터 생성
A = randn(31, 200);
B = randn(1, 200);

% 상관 관계 계산을 위한 루프
correlations = zeros(31, 1);
for i = 1:31
    correlations(i) = corr(A(i, :)', B');  % 전치 연산자를 사용하여 벡터를 열 벡터로 변환
end

% 결과 출력
disp('A의 각 행과 B의 상관 관계:');
disp(correlations);
