-- SELECT 문 
-- DML 중 하나로, 저장되어있는 데이터를 
-- 조회하기 위해 사용하는 쿼리
-- SELECT 절: 조회하는 데이터 중 특정 컬럼만 출력
SELECT 
	emp_id
	, `name`  -- `(백틱)으로 감싸면, 컬럼으로 인식 시킨다 라는 의미
	, gender
FROM employees
;
-- ASterrisk (*) : 모든 컬럼 조회
SELECT 
	*
FROM employees
;	
-- WHERE 절 : 특정 컬럼의 값이 조건에 맞는 데이터만 조회
-- 사번이 10009번인 사원의 모든 정보 조회
SELECT 
	*
FROM employees
WHERE emp_id = 10009
;
-- 사원명이 "박보람"인 사원의 정보를 조회
SELECT 
	emp.`name` 
	, emp.birth
FROM employees  emp -- AS 생략 
WHERE 
	`name` = "박보람"
;

-- 생일 2000-01-01 이후인 사원 모두 조회
SELECT 
	*
FROM employees
WHERE 
	birth >= '2000-01-01' 
;

-- 퇴사하지 않은 사원 정보 조회
-- NULL 값으로 조회 할 때
SELECT 
	*
FROM employees
WHERE
	fire_at IS NULL
;

-- 퇴사한 사원 정보 조회
SELECT 
	*
FROM employees
WHERE
	fire_at IS NOT NULL
;