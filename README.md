# Introduction
📊Welcome to my SQL Portfolio Project, where I explore the data job market with a focus on Data Scientist roles. This project is a personal exploration into identifying the top-paying Data Scientist jobs, the most in-demand skills, and the intersection of high demand with high salaries in the field of data science. Through SQL, I analyze job market trends to uncover valuable insights into salary distributions, essential technical skills, and career opportunities in the field of data science.

🔍Check out my SQL queries here: [Project_SQL](/Project_SQL/)

# Background
The motivation behind this project stemmed from my desire to better understand the Data Scientist job market. I aimed to discover which skills are the most in-demand and highest-paying, making my career development and job search more targeted and effective.

The data for this analysis is from Luke Barousse’s SQL Course. This dataset includes details on job titles, salaries, locations, and required skills.

## The questions I wanted to answer through my SQL queries were:

1. What are the top-paying Data Scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Scientists?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a Data Scientist looking to maximize their value in the job market?

# Tools I used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

### The Analysis

Each query for this project aimed at investigating specific aspects of the data scientist job market. Here’s how I approached each question:

### 1. Top Paying Data Scientist Jobs

To identify the highest-paying roles, I filtered data scientist positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
~~~sql
select 
    jf.job_id,
    jf.job_title,
    jf.job_schedule_type,
    jf.salary_year_avg,
    jf.job_posted_date,
    jf.job_location,
    cd.name as company_name
from 
    job_postings_fact as jf
    left join company_dim as cd on jf.company_id = cd.company_id
where 
    job_title = 'Data Scientist' 
    and job_location = 'Anywhere'
    and salary_year_avg is not null
order by 
    salary_year_avg desc
limit 10;
~~~

### 2. Skills for Top Paying Jobs
~~~sql
with top_paying_jobs as (
    select 
        jf.job_id,
        jf.job_title,
        jf.job_schedule_type,
        jf.salary_year_avg,
        jf.job_posted_date,
        jf.job_location,
        cd.name as company_name
    from 
        job_postings_fact as jf
        left join company_dim as cd on jf.company_id = cd.company_id
    where
        job_title = 'Data Scientist' 
        and job_location = 'Anywhere'
        and salary_year_avg is not null
    order by 
        salary_year_avg desc
    limit 10
)

select tpj.*,
    sd.skills as skills_required
from 
    top_paying_jobs as tpj
    inner join skills_job_dim as sjd on tpj.job_id = sjd.job_id
    inner join skills_dim as sd on sjd.skill_id = sd.skill_id
order by 
    tpj.salary_year_avg desc;
~~~


### 3. In-Demand Skills for Data Scientists

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

~~~sql
Select
skills_dim.skills,
COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Scientist'
GROUP BY 
    skills_dim.skills
ORDER BY 
    demand_count DESC
limit 5;
~~~

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

~~~~sql
Select
skills_dim.skills as skills,
round(AVG(job_postings_fact.salary_year_avg), 2) AS average_salary
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Scientist' and job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skills 
ORDER BY 
    average_salary DESC
~~~~

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

~~~sql
with demand_skills as (
Select
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Scientist'
    and job_postings_fact.salary_year_avg IS NOT NULL
    and job_postings_fact.job_work_from_home = 'True'
GROUP BY 
    skills_dim.skills,
    skills_dim.skill_id
)

,average_salary as (
Select
        skills_dim.skill_id,
        skills_dim.skills,
        round(avg(job_postings_fact.salary_year_avg),2) AS average_salary
FROM 
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
        job_postings_fact.job_title_short = 'Data Scientist'
        and job_postings_fact.salary_year_avg IS NOT NULL
        and job_postings_fact.job_work_from_home = 'True'
GROUP BY 
        skills_dim.skills,
        skills_dim.skill_id
    )

select 
        ds.skill_id,ds.skills, 
        ds.demand_count,
        avg_sal.average_salary
from  
        demand_skills as ds
        inner join average_salary as avg_sal on ds.skill_id = avg_sal.skill_id
order by 
    ds.demand_count desc,
    avg_sal.average_salary desc
~~~

# What I Learned
Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for common table expressions.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.


# Insights

1. **Top-Paying Data Scientist Jobs**: Remote Data Scientist positions listed as "Anywhere" offer competitive salaries, with the highest annual salary reaching $375,000.
2. **Top Skills for Data Scientist Jobs**: Python, SQL and R are the most frequently required skills in Data Scientist job postings, followed by R, SAS, and Tableau. This highlights the importance of programming, database querying, statistical analysis, and data visualization skills in the field.
3. **Most In-Demand Skills**: Python is the most demanded skill in Data Scientist job postings, with 114,016 mentions, followed by SQL (79,174) and R (59,754). SAS and Tableau also rank among the top five, highlighting the strong demand for programming, database querying, statistical analysis, and data visualization skills.

4. **Skills with Higher Salaries**: Asana has the highest average salary among the listed skills at $215,477, followed by Airtable ($201,143) and Red Hat ($189,500). Other skills, such as Watson, Elixir, and Lua, are also associated with higher average salaries, suggesting that specialized technical skills can offer strong earning potential.
5. **Optimal Skills for Job Market Value**: Python and SQL stand out as the most valuable skills for Data Scientists due to their high demand and competitive average salaries. Specialized tools such as R, AWS, Spark, TensorFlow, and PyTorch also offer higher average salaries, making them strong skills to develop for better career opportunities.


# Conclusion

This project enhanced my SQL skills and provided valuable insights into the data scientist job market. The analysis helped me understand the most in-demand skills, the skills associated with higher salaries, and the technologies worth prioritizing for career growth. Aspiring data scientists can use these findings to guide their learning and job search efforts by focusing on a combination of high-demand and high-paying skills. Overall, this project highlights the importance of continuous learning and adapting to emerging trends in the field of data science.
