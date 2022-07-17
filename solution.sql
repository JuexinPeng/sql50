# 1
select s1.sid, s1.score score1, s2.score score2 from sc s1 join sc s2 on s1.sid = s2.sid where s1.cid = 1 and s2.cid = 2; 
## 1.1
select s.*, t.score1, t.score2 from student s join (select s1.sid, s1.score score1, s2.score score2 from sc s1 join sc s2 on s1.sid = s2.sid where s1.cid = 1 and s2.cid = 2 and s1.score > s2.score) t on s.sid = t.sid;
## 1.2
select s.*, t.score1, t.score2 from student s join (select t1.sid, t1.score score1, t2.score score2 from (select * from sc where cid = 1) t1 left join (select * from sc where cid = 2) t2 on t1.sid = t2.sid where t1.score > t2.score or t2.score is null) t on s.sid = t.sid;
## 1.3
select s.*, t.score1, t.score2 from student s join (select t2.sid, t1.score score1, t2.score score2 from (select * from sc where cid = 1) t1 right join (select * from sc where cid = 2) t2 on t1.sid = t2.sid where t1.score is null) t on s.sid = t.sid;

# 2
select s.sid, s.sname, t.avg_score from student s join (select avg(score) avg_score, sid from sc group by sid having avg(score) >= 60) t on s.sid = t.sid;

# 3
select s.* from student s join (select distinct sid from sc) t on s.sid = t.sid;

# 4
select s.*, t.count_course, t.sum_score from student s left join (select sid, count(*) count_course, sum(score) sum_score from sc group by sid) t on s.sid = t.sid;
## 4.1
select s.*, t.count_course, t.sum_score from student s join (select sid, count(*) count_course, sum(score) sum_score from sc group by sid) t on s.sid = t.sid;

# 5
select count(*) from teacher where tname like '李%';

# 6
select * from student where sid in (select distinct sid from sc where cid = (select cid from course c join (select * from teacher where tname = '张三') t on c.tid = t.tid));

# 7
select * from student where sid not in (select sid from sc group by sid having count(*) = 3);

# 8 
select * from student where sid in (select distinct sid from sc where cid in (select cid from sc where sid = '01'));

# 9
select * from student where sid in (select distinct t1.sid from sc right join (select s.sid, t.cid from student s cross join (select cid from sc where sid = '01') t) t1 on sc.sid = t1.sid and sc.cid = t1.cid where sc.sid is null);

# 10
select sname from student where sid not in (select sid from sc where cid in (select cid from course where tid = (select tid from teacher where tname = '张三')));

# 11
select s.sid, s.sname, t.avg_score from student s join (select sid, avg(score) avg_score from sc where score < 60 group by sid having count(*) >= 2) t on s.sid = t.sid;

# 12
select s.* from student s join (select sid from sc where cid = '01' and score < 60 order by score desc) t on s.sid = t.sid;

# 13
create view v1 as select sid, score from sc where cid = '01';
create view v2 as select sid, score from sc where cid = '02';
create view v3 as select sid, score from sc where cid = '03';
create view v4 as select s.sid, avg(score) from sc s group by s.sid order by avg(score) desc;
select v4.sid, v1.score score1, v2.score score2, v3.score score3, v4.`avg(score)` avg_score from v4 left join v1 on v4.sid = v1.sid left join v2 on v4.sid = v2.sid left join v3 on v4.sid = v3.sid;

# 14
select
	cid,
	max(score) max_score, 
	min(score) min_score, 
	avg(score) avg_score, 
	sum(if(score >= 60, 1, 0)) / count(*) pass_rate,
	sum(if(score >= 70 and score < 80, 1, 0)) / count(*) med_rate,
	sum(if(score >= 80 and score < 90, 1, 0)) / count(*) good_rate,
	sum(if(score >= 90, 1, 0)) / count(*) excel_rate
from
	sc
group by
	cid;

# 15
select sid, cid, score, rank() over (partition by cid order by score desc) as `rank` from sc;
## 15.1
select sid, cid, score, dense_rank() over (partition by cid order by score desc) as `rank` from sc;

# 16
select sid, sum(score) sum_score, rank() over (order by sum(score) desc) as `rank` from sc group by sid;
## 16.1
select sid, sum(score) sum_score, dense_rank() over (order by sum(score) desc) as `rank` from sc group by sid;

# 17
select 
	s.cid,
	c.cname,
	sum(if(score >= 85 and score <= 100, 1, 0)) '[100-85]',
	sum(if(score >= 85 and score <= 100, 1, 0)) / count(*) '[100-85] rate',
	sum(if(score >= 70 and score < 85, 1, 0)) '[85-70]',
	sum(if(score >= 70 and score < 85, 1, 0)) / count(*) '[85-70] rate',
	sum(if(score >= 60 and score < 70, 1, 0)) '[70-60]',
	sum(if(score >= 60 and score < 70, 1, 0)) / count(*) '[70-60] rate',
	sum(if(score < 60, 1, 0)) '[60-0]',
	sum(if(score < 60, 1, 0)) / count(*) '[60-0] rate'
from 
	sc s
join 
	course c 
on
	s.cid = c.CId 
group by
	cid;

# 18
select * from (select *, rank() over (partition by cid order by score desc) as `rank` from sc) t where `rank` <= 3;

# 19
select cid, count(*) from sc group by cid;

# 20
select sid, sname from student where sid in (select sid from sc group by sid having count(*) = 2);

# 21
select ssex, count(*) from student group by ssex;

# 22
select * from student where sname like '%风%';

# 23
select sname, count(*) from student group by sname having count(*) > 1;

# 24
select sname from student where year(sage) = 1990;

# 25
select cid, avg(score) avg_score from sc group by cid order by avg_score desc, cid asc; 

# 26
select s.sid, s.sname, avg(score) avg_score from sc join student s on sc.sid = s.sid group by sid having avg_score >= 85;

# 27
select s.sname, score from sc join student s on sc.sid = s.sid where cid = (select cid from course where cname = '数学') and score < 60;

# 28
select s.sname, sc.cid, sc.score from student s right join sc on s.sid = sc.sid;

# 29
select s.sname, c.cname, sc.score from sc left join student s on sc.sid = s.sid left join course c on sc.cid = c.cid where score > 70;

# 30
select s.sname, c.cname, sc.score from sc left join student s on sc.sid = s.sid left join course c on sc.cid = c.cid where score < 60;

# 31
select s.sid, s.sname from student s join sc on s.sid = sc.sid where sc.cid = '01' and score >= 80;

# 32
select c.cname, count(*) from sc join course c on sc.cid = c.cid group by sc.cid;

# 33
select s.*, sc.score from student s join sc on s.sid = sc.sid join course c on sc.cid = c.cid join teacher t on c.tid = t.tid where t.tname = '张三' order by sc.score desc limit 1;

# 34
select sc.sid, max(sc.score) max_score from sc join course c on sc.cid = c.cid join teacher t on c.tid = t.tid;
select s.*, ms.max_score from student s join (select sc.sid, max(sc.score) max_score from sc join course c on sc.cid = c.cid join teacher t on c.tid = t.tid) ms on s.sid = ms.sid;

# 35
select distinct s1.* from sc s1 join sc s2 on s1.sid = s2.sid where s1.cid != s2.cid and s1.score = s2.score;

# 36
select * from (select *, rank() over (partition by cid order by score desc) as `rank` from sc) t where `rank` < 3;

# 37
select cid, count(*) from sc group by cid having count(*) > 5;

# 38
select sid from sc group by sid having count(*) >= 2;

# 39
select s.* from sc join student s on sc.sid = s.sid group by sid having count(*) = (select count(*) from course);

# 40
select sname, year(now()) - year(sage) from student;

# 41
select sname, floor(datediff(now(), sage) / 365) from student;

# 42
select week(now());
select * from student where week(sage) = week(now());

# 43
select * from student where week(sage) = week(now()) + 1;

# 44
select * from student where month(sage) = month(now());

# 45
select * from student where month(sage) = month(now()) + 1;
