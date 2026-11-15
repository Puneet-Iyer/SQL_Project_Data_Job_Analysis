/*Question: What are the top-paying data scientist jobs, and what skills are required?

- Identify the top 10 highest-paying Data Scientist jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries.*/

with top_paying_jobs as (
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
    limit 10
)


select tpj.*,
sd.skills as skills_required
from top_paying_jobs as tpj
inner join skills_job_dim as sjd on tpj.job_id = sjd.job_id
inner join skills_dim as sd on sjd.skill_id = sd.skill_id
order by tpj.salary_year_avg desc;



