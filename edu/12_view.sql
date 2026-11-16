-- -----------------------
-- VIEW
-- -----------------------
-- VIEW 생성
-- 	CREATE [OR REPLACE] VIEW 뷰명
-- 	AS
-- 		뷰를 생성 할 SELECT 문
-- 	;
-- 	** [OR REPLACE] : 기존의 뷰가 있을 경우 덮어쓰기를 합니다. **
CREATE VIEW view_avg_salary_by_dept
AS 
	-- 부서별 현재 연봉 평균 구하기
	-- 부서코드,부서명,평균연봉 출력
 	SELECT
		depe.dept_code
		,dep.dept_name
		,CEIL(AVG(sal.salary)) avg_sal
	FROM department_emps depe
		JOIN departments dep
			ON dep.dept_code = depe.dept_code
		JOIN salaries sal
			ON sal.emp_id = depe.emp_id
				AND sal.end_at IS NULL 
				AND depe.end_at IS NULL 
	GROUP BY depe.dept_code,dep.dept_name
	ORDER BY dep.dept_code 
;

-- VIEW 조회
SELECT 
	*
FROM view_avg_salary_by_dept
;

-- VIEW 삭제
DROP VIEW view_avg_salary_by_dept;