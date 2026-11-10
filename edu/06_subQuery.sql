-- 서브쿼리(SubQuery)

-- -----------------------
-- WHERE 절에서 사용
-- -----------------------
-- 단일 행 서브 쿼리
-- 서브쿼리가 단일 행 비교 연산자와 함께 사용할 때는
-- 반드시 서브쿼리의 결과 수가 1건 이하여야 한다.
-- 결과가 2건 이상일 경우 오류 발생
-- D001 부서장의 사번과 이름을 출력
SELECT
	emp.emp_id
	,emp.`name`
FROM employees emp
WHERE 
	emp.emp_id = (
	-- 'D001' 부서의 현재 부서장 사번 획득
	SELECT 
		depm.emp_id	
	FROM department_managers depm
	WHERE 
		depm.end_at IS NULL
		AND depm.dept_code = 'D001'
	)
;

SELECT 
	emp.emp_id
	,emp.`name`
FROM employees emp 
	JOIN department_managers depm
	ON 
		depm.dept_code='D001'
		AND emp.emp_id=depm.emp_id
		AND depm.end_at IS NULL
;

-- 다중 행 서브 쿼리
-- 서브 쿼리의 결과가 2건 이상을 반환 할 경우
-- 반드시 다중 행 비교연산자(IN,ALL,ANY,SOME,EXISTS)를 사용
-- 현재 부서장인 사원의 사번과 이름을 출력
 SELECT
	emp.emp_id
	,emp.`name`
FROM employees emp
WHERE 
	emp.emp_id IN (
	-- 현재 부서장들 사번 획득
	SELECT 
		depm.emp_id	
	FROM department_managers depm
	WHERE 
		depm.end_at IS NULL
	)
;

-- 다중 열 서브쿼리
-- 현재 'D002'  부서장이 해당 부서에 소속된 날짜 출력
SELECT 
	depe.start_at
FROM department_emps depe
WHERE
	(depe.emp_id , depe.dept_code) IN (
	SELECT 
	depm.emp_id
	,depm.dept_code
	FROM department_managers depm
	WHERE 
		depm.dept_code = 'D002'
		AND depm.end_at IS NULL 
	)
;

-- 연관 서브쿼리
-- 서브쿼리 내에서 메인쿼리의 컬럼이 사용된 서브쿼리
-- 부서장직을 지냈던 경력이 있는 사원의 정보를 출력
SELECT
	emp.*
FROM employees emp
WHERE
	emp.emp_id IN (
		SELECT
			depm.emp_id
		FROM department_managers depm
		WHERE
			depm.emp_id = emp.emp_id
	)
;
-- JOIN문
SELECT 
	emp.*
FROM employees emp
	JOIN department_managers depm
	ON emp.emp_id = depm.emp_id
;
-- 과거 JOIN문
SELECT 
	emp.*
FROM employees emp,department_managers depm
WHERE emp.emp_id = depm.emp_id
;		

-- --------------------
-- SELECT 절에서 사용
-- --------------------
-- 사원별 역대 전체 급여 평균
SELECT 
	emp.emp_id
	,(
		SELECT 
			AVG(sal.salary)
		FROM salaries sal
		WHERE 
			sal.emp_id = emp.emp_id
	) avg_sal
FROM employees emp
;

-- ----------------------
-- FROM 절에서 사용
-- ----------------------
SELECT
	tmp.*	
FROM (
	SELECT 
		emp.emp_id
		,emp.`name`
	FROM employees emp
	WHERE 
		fire_at IS NOT NULL
) tmp
;

-- --------------------
-- INSERT 문에서 사용
-- --------------------
INSERT INTO employees(
	employees.emp_id
	,employees.`name`
	,employees.birth
	,employees.gender
	,employees.hire_at
) 
VALUES (
	(SELECT MAX(emp.emp_id) +1  FROM employees emp)
	,'둘리'
	,'1980-01-01'
	,'M'
	,NOW()
);

-- ----------------------------
-- UPDATE 문에서 사용
-- ----------------------------
-- 퇴사한 사원의 직급 테이블의 직급 종료일을
-- 퇴사일로 갱신
UPDATE title_emps 
SET 
	title_emps.end_at = (
		SELECT employees.fire_at 
		FROM employees
		WHERE 
			employees.emp_id = 100009
	) 
WHERE
	title_emps.emp_id = 100009
	AND title_emps.end_at IS NULL 
;