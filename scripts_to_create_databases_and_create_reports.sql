drop database if exists costs;
create database costs;
use costs;

create table defaultcategories (catid integer not null auto_increment, category varchar(50), primary key(catid));

create table users (userid integer not null auto_increment, name varchar(50), surname varchar(50), user varchar(50) unique, primary key(userid), password text);

create table sources (sourceid integer not null auto_increment, name varchar(50), primary key(sourceid), creatorid integer, foreign key(creatorid) references users(userid), date date);
#drop table userassigns;
create table userassigns (sourceid integer, foreign key(sourceid) references sources(sourceid), userid integer, foreign key(userid) references users(userid), prove boolean default false);

#drop table categories;
create table categories (catid integer not null auto_increment primary key, category varchar(50), sourceid integer, foreign key(sourceid) references sources(sourceid));



create table costs (sourceid integer, foreign key(sourceid) references sources(sourceid), costid integer not null primary key auto_increment, what varchar(50), catid integer,
	foreign key (catid) references categories(catid), amount decimal(6,2),
    payerid integer, foreign key(payerid) references users(userid),
    date date);
#drop table consumers;
create table consumers (costid integer, foreign key(costid) references costs(costid), factor integer, consumerid integer, foreign key(consumerid) references users(userid), prove boolean default false);

describe categories;


show tables;

insert into users(name, surname, user, password) values('Moses','Dastmard','moses',md5('9903'));
insert into users(name, surname, user, password) values('Leyla','Anushe','leylaw',md5('9903'));
insert into sources(name, creatorid, date) values ('Casal', 1, curdate());

insert into categories(category, sourceid) values ('Transport', 1);


insert into costs(sourceid, what, catid, amount, payerid, date) values(1, 'milan ticket', 1, 7.18, 1, curdate());
insert into costs(sourceid, what, catid, amount, payerid, date) values(1, 'milan ticket', 1, 12.8, 2, curdate());
insert into consumers values (1, 1, 1, true);
insert into consumers values (1, 1, 2, false);

insert into consumers values (2, 1, 1, true);
insert into consumers values (2, 1, 2, true);
#select * from sources;
#select * from assigns;
#select * from consumers;select * from users;
#select * from categories;
#select * from costs;
#select * from userassigns;
insert into userassigns value(1, 1, true);
insert into userassigns value(1, 2, true);




#drop view factors;
create view factors as select costid, sum(factor*prove) as sumfactors , sum(prove)/count(prove) as percentprove from consumers group by costid;
select * from factors;
select * from costs join consumers on costs.costid = consumers.costid left join factors on costs.costid = factors.costid;
#drop view agg;
create view agg as select costs.sourceid, costs.costid, costs.what, costs.catid, costs.amount, costs.payerid, costs.date, consumers.factor, consumers.consumerid, consumers.prove, factors.sumfactors, factors.percentprove, consumers.prove*consumers.factor/factors.sumfactors as percentcredit from costs join consumers on costs.costid = consumers.costid left join factors on costs.costid = factors.costid;
select * from agg;
#select * from costs left join categories on costs.catid = categories.catid left join users on costs.payerid = users.userid join consumers on costs.costid = consumers.costid left join factors on costs.costid = factors.costid;
#drop view report;
#create view report as select costs.sourceid, costs.costid, costs.what, costs.amount, categories.category, costs.date, users.user as payer, costs.payerid, consumers.userid as consumerid, consumers.factor, consumers.prove, factors.sumfactors, factors.percent from costs left join categories on costs.catid = categories.catid left join users on costs.payerid = users.userid join consumers on costs.costid = consumers.costid left join factors on costs.costid = factors.costid;
#select * from report;

#drop view spends1;
create view spends1 as select *,
	case 
		when payerid = consumerid then amount - percentcredit*amount
        else -percentcredit*amount
	end as credit from agg;
select * from spends1;
#drop view spends2;

#create view spends2 as select *, case when consumerid = 1 then credit end as moses_credit, case when consumerid = 2 then credit end as leylaw_credit from spends1;
#select * from spends2;
#drop view spends3;
#create view spends3 as select costid, what, amount, category, date, payer, credit, max(moses_credit), max(leylaw_credit) from spends2 group by costid;
#select * from spends3;




