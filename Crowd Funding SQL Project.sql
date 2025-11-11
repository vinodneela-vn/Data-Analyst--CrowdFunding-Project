use main_project;

select count(id) as Total_ids, count(distinct id) as Unique_ids from main_data;

alter table category add constraint pk_category primary key(id);

alter table creator add constraint pk_creator primary key(id);

alter table calender_table add constraint pk_calender primary key(id);

alter table location add constraint pk_location primary key(id);

alter table main_data add constraint pk_main primary key(id);


SET FOREIGN_KEY_CHECKS = 0;


alter table main_data add constraint fk_main_creator foreign key (creator_id) references creator(id);

alter table main_data add constraint fk_main_category foreign key (category_id) references category(id);

alter table main_data add constraint fk_main_location foreign key (location_id) references location(id);

alter table main_data add constraint fk_calendar foreign key (id) references calendar(id);

set SQL_SAFE_UPDATES=0;
-- 5.1

SELECT state, COUNT(*) AS total_projects
FROM main_data
GROUP BY state
ORDER BY total_projects DESC;


-- 5.2
select country, count(id) as Total_Projects from main_data group by country order by Total_Projects desc;


-- 5.3
select c.name,count(m.id) as Total_Projects from main_data m join category c on m.category_id=c.id group by c.name order by Total_Projects desc limit 10;


-- 5.4
select year(created_at) as Year, quarter(created_at) as Quarter, month(created_at) as Month, count(id) as Total_Projects from main_data
group by year(created_at), quarter(created_at), month(created_at) order by year, quarter, month;
-- 2ndapproach 
select c.year,c.quarter, c.monthfullname ,count(m.id) as Total_Projects from main_data m join calender_table c on m.id=c.id
group by c.year, c.quarter, c.monthfullname order by c.year,c.quarter,c.monthfullname;


-- 6.1
select sum(usd_pledged) as Amount_Raised from main_data where lower(state)="successful";

select concat(round(sum(usd_pledged)/1000000,2)," M") as Amount_Raised from main_data where lower(state)="successful";


-- 6.2
select count(backers_count) as Total_Backers from main_data where lower(state)="successful";

select concat(round(count(backers_count)/1000)," K") as Total_Backers from main_data where lower(state)="successful";


-- 6.3
select round(avg(Day_to_complete),2) As Average_days_successful_projects from main_data where lower(state)="successful";


-- 7.1
select id, backers_count, rank() over(order by backers_count desc) 	as Bankers_Rank from main_data where backers_count is not null 
order by backers_count desc;

select id, backers_count, rank() over(order by backers_count desc) 	as Bankers_Rank from main_data where backers_count is not null 
order by backers_count desc limit 10;


-- 7.2
select id, usd_pledged, rank() over(order by usd_pledged desc) as Amount_Rank from main_data where usd_pledged is not null 
order by usd_pledged desc;

select id, usd_pledged, rank() over(order by usd_pledged desc) as Amount_Rank from main_data where usd_pledged is not null 
order by usd_pledged desc limit 10;


-- 8.1
select cast(sum(case when state ="successful" then 1 else 0 end) as float)*100/count(id) as Success_Rate from main_data;

select concat(round(100*sum(case when state = "successful" then 1 else 0 end)/count(id),2)," %") as Success_Rate from main_data;


-- 8.2
SELECT c.name AS Category_Name, COUNT(*) AS Total_Projects, SUM(CASE WHEN m.state = 'Successful' THEN 1 ELSE 0 END) AS Successful_Projects,
ROUND((SUM(CASE WHEN m.state = 'Successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2) AS Success_Rate_Percentage
FROM main_data AS m JOIN category AS c  ON m.category_id = c.id GROUP BY c.name ORDER BY Success_Rate_Percentage DESC;


-- 8.3
SELECT 
    c.name AS category_name,
    COUNT(p.ID) AS total_projects,
    COUNT(CASE WHEN p.state = 'successful' THEN 1 END) AS successful_projects,
    (COUNT(CASE WHEN p.state = 'successful' THEN 1 END) * 100.0 / COUNT(p.ID)) AS success_percentage
FROM 
    main_data p
JOIN 
    category c 
    ON p.category_id = c.id
GROUP BY 
    c.name
ORDER BY 
    success_percentage DESC;
    
    
    -- 8.4
    SELECT
    CASE
        WHEN goal_USD < 5000 THEN '< 5000'
        WHEN goal_USD BETWEEN 5000 AND 10000 THEN '5000-10000'
        WHEN goal_USD BETWEEN 10001 AND 20000 THEN '10001-20000'
        ELSE '> 20000'
    END AS Goal_Range,
    COUNT(*) AS Total_Projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS Successful_Projects,
    ROUND(
        SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Success_Rate_Percentage
FROM main_data
GROUP BY Goal_Range
ORDER BY 
    CASE 
        WHEN Goal_Range = '< 5000' THEN 1
        WHEN Goal_Range = '5000-10000' THEN 2
        WHEN Goal_Range = '10001-20000' THEN 3
        ELSE 4
    END;






