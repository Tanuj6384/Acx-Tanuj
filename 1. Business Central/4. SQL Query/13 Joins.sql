/* JOINS   */
-----------------------------------------------------------------------------
/* 1)Inner Join */
SELECT emp_id,emp_name,emp_salary,dept_name,dept_location
FROM employeee INNER JOIN department
ON employeee.emp_deptId=department.deptid;

	/*OR*/
SELECT e.emp_id,e.emp_name,e.emp_salary,d.dept_name,d.dept_location
FROM employeee e INNER JOIN department d
ON e.emp_deptId=d.deptid;

-----------------------------------------------------------------------------------
/*  2) Outer Join  */

        /* (i)LEFT OUTER JOIN */

		SELECT e.emp_id,e.emp_name,e.emp_salary,d.dept_name,d.dept_location
		FROM employeee e LEFT OUTER JOIN department d
		ON e.emp_deptId=d.deptid;

		/* (ii)RIGHT OUTER JOIN */

		SELECT e.emp_id,e.emp_name,e.emp_salary,d.dept_name,d.dept_location
		FROM employeee e RIGHT OUTER JOIN department d
		ON e.emp_deptId=d.deptid;
		 
		/* (iii)FULL OUTER JOIN */

		SELECT e.emp_id,e.emp_name,e.emp_salary,d.dept_name,d.dept_location
		FROM employeee e FULL OUTER JOIN department d
		ON e.emp_deptId=d.deptid;
