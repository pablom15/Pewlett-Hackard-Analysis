-- Challenge Deliverable 2
-- Mentorship Eligibility Table

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	de.from_date,
	de.to_date
INTO mentorship_eligible
FROM employees as e
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
INNER JOIN dept_employees as de
	ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01');

select * from mentorship_eligible

commit;
	
-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 to_date
INTO mentorship_eligible_corrected
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 to_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM mentorship_eligible
 ) tmp WHERE rn = 1
ORDER BY emp_no;

select * from mentorship_eligible_corrected

commit;
	
-- Shows duplicates
SELECT first_name,
	last_name,
	count(*)
FROM mentorship_eligible_corrected
GROUP BY first_name,
	last_name
HAVING count(*) > 1;
	
rollback;