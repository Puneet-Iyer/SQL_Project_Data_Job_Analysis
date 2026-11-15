/*Question : what are the Top Paying Data Scientist Jobs*
- What are the top 10 highest paying Data Scientist jobs available remotely
- Focuses on job postings with specified salary (Removing NULL values)
- Why? To higlight the top-paying opportunities for Data Scientists offering insights into employment options and location flexibility.*/

select 
jf.job_id,
jf.job_title,
jf.job_schedule_type,
jf.salary_year_avg,
jf.job_posted_date,
jf.job_location,
cd.name as company_name
from job_postings_fact as jf
left join company_dim as cd on jf.company_id = cd.company_id
where job_title = 'Data Scientist' 
  and job_location = 'Anywhere'
  and salary_year_avg is not null
order by salary_year_avg desc
limit 10;