-- Challenge Deliverable 1
select * from titles
drop table correct_retire_by_title;
select * from retire_by_title;
commit;
rollback;

SELECT ei.emp_no,
	ei.first_name,
	ei.last_name,
	ti.title,
	ti.from_date,
	ti.to_date,
	ei.salary
INTO retire_by_title
FROM emp_info as ei
INNER JOIN titles as ti
	ON (ei.emp_no = ti.emp_no);
	
select * from retire_by_title;
commit;

SELECT COUNT(emp_no), title
INTO count_by_title
From retire_by_title
group by title
order by title;

select * from count_by_title

commit;

-- Shows how many duplicates are in retire_by_title
SELECT first_name,
	last_name,
	count(*)
FROM retire_by_title
GROUP BY first_name,
	last_name
HAVING count(*) > 1;

-- Shows all rows this time
SELECT * FROM
	(SELECT*, count(*)
	OVER
		(PARTITION BY
			first_name,
			last_name
		) AS count
		FROM retire_by_title) tableWithCount
		WHERE tableWithCount.count > 1
		ORDER BY emp_no;


-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 title,
 to_date,
 salary
INTO correct_retire_by_title
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 title,
 to_date,
  salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retire_by_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

Select * from correct_retire_by_title;
commit;

SELECT COUNT(emp_no), title
INTO correct_count_by_title
From correct_retire_by_title
group by title
order by title;

select * from correct_count_by_title
commit;
