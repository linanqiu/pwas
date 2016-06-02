WITH pid_x AS (
  SELECT DISTINCT PID FROM patients WHERE ICD=x AND SEX=sex AND AGE>=l AND AGE<h GROUP BY PID
), pid_y AS (
  SELECT DISTINCT PID FROM patients WHERE ICD=x AND SEX=sex AND AGE>=l AND AGE<h GROUP BY PID
)
SELECT COUNT(pid_x.PID) as kx, COUNT(pid_y,PID) as ky, COUNT(pid_xy.PID) as kxy
FROM pid_x, pid_y
WHERE pid_x.PID=pid_y.PID;

SELECT SUM(N)
FROM patient_counts
WHERE AGE>=l AND AGE<h;
