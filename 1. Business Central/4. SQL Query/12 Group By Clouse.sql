/* 
Group By Clouse

one or more columns as a group such that all rows wihtin any group have the same values for those columns

Always used with select statement. 
*/

select * from employeInformation;

	SELECT  job FROM employeInformation GROUP BY job;

	SELECT  job, SUM(salary) FROM employeInformation GROUP BY job;

	SELECT  job, MIN(salary) AS 'MIN SALARY' FROM employeInformation GROUP BY job;

	SELECT  job, ROUND(MIN(salary),2) AS 'MIN SALARY' FROM employeInformation GROUP BY job;