-- <SubQuery GPT 예제 1.>
-- salaries 테이블에서 전체 급여의 평균보다 높은 급여를 받는 사원의 다음 정보를 조회하세요.
-- 사원번호 (emp_id)
-- 급여 (salary)
-- 조건:
-- 전체 급여의 평균을 서브쿼리로 구할 것
-- 퇴사 여부와 관계없이 모든 급여 데이터를 대상으로 할 것
-- 급여가 높은 순서대로 정렬할 것
-- 힌트: AVG(), WHERE, SELECT 내부 서브쿼리
SELECT 
	sal.emp_id
	,sal.salary
FROM salaries sal
WHERE 
	  sal.salary>=(
		SELECT 	
			AVG(salary)
		FROM salaries
	)
ORDER BY salary DESC 
;
-- <SubQuery GPT 예제 2.>
-- salaries 테이블에서 현재 재직 중인 급여 데이터 중 가장 높은 급여를 받는 사원의 정보를 조회하세요.

-- 조회 항목:
-- 사원번호 (emp_id)
-- 급여 (salary)
-- 조건:
-- 현재 급여 데이터는 end_at IS NULL
-- 가장 높은 급여와 동일한 급여를 받는 사원이 여러 명이라면 모두 조회할 것
-- 서브쿼리를 활용할 것
-- 힌트: MAX(), WHERE, 서브쿼리
SELECT 
	emp_id
	,salary
FROM salaries
WHERE 
	end_at IS NULL 
	AND salary = (
		SELECT
			MAX(salary)
		FROM salaries
	)
;
-- <SubQuery GPT 예제 3.>
-- 각 부서의 현재 소속 사원들의 평균 급여를 계산하고, 전체 재직 사원의 평균 급여보다 높은 부서만 조회하세요.

-- 조회 항목:
-- 부서명 (departments.dept_name)
-- 부서 코드 (departments.dept_code)
-- 부서별 평균 급여
-- 조건:
-- department_emps 테이블의 현재 소속 정보만 사용
-- salaries 테이블의 현재 급여 정보만 사용
-- 부서별 평균 급여가 전체 재직 사원의 평균 급여보다 높은 부서만 조회
-- 부서별 평균 급여 내림차순 정렬
-- 서브쿼리를 반드시 활용할 것
-- 힌트:
-- JOIN
-- GROUP BY
-- AVG()
-- HAVING
-- 서브쿼리
SELECT 
	dept.dept_name
	,dept.dept_code
	,AVG(salary) avg_sal
FROM departments dept
	JOIN department_emps demp
	ON dept.dept_code = demp.dept_code   
	JOIN salaries sal 
	ON  demp.emp_id=sal.emp_id
WHERE 
	dept.end_at IS NULL 
	AND sal.end_at IS NULL 
		AND  demp.end_at IS NULL
GROUP BY dept.dept_code, dept.dept_name HAVING AVG(sal.salary) >  (
 	SELECT 
 		AVG(salary)
 	FROM salaries
 	WHERE 	
 		end_at IS NULL 
	)
ORDER BY avg_sal DESC 
;

SELECT
    dept.dept_name
    ,dept.dept_code
    ,AVG(sal.salary) AS avg_salary
FROM departments dept
    JOIN department_emps demp
        ON dept.dept_code = demp.dept_code
    JOIN salaries sal
        ON demp.emp_id = sal.emp_id
WHERE
    demp.end_at IS NULL
    AND sal.end_at IS NULL
GROUP BY
    dept.dept_code
    ,dept.dept_name
HAVING
    AVG(sal.salary) > (
        SELECT AVG(salary)
        FROM salaries
        WHERE end_at IS NULL
    )
ORDER BY
    avg_salary DESC
;