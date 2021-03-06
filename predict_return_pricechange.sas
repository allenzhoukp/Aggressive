/*
proc sql;
create table lawsuit_60d as select distinct a.* from price_limit_first a join broker.non_bsg b
on a.stock_code_1=b.F3_T0401D;
quit;
*/


proc sql;
create table ratio_mean_b20_b16 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<-15 and time_trade>=-20 and F9_T0401D=3;
create table ratio_mean_b20_b16 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b20_b16,mean(shanghai_sdd20) as shanghai_sdd20_mean_b20_b16,mean(other_sdd20) as other_sdd20_mean_b20_b16,mean(home_city_sdd20) as home_city_sdd20_mean_b20_b16,mean(home_province_sdd20) as home_province_sdd20_mean_b20_b16,mean(fund_sdd20) as fund_sdd20_mean_b20_b16 from ratio_mean_b20_b16
group by stock_code_1,event_date;

create table ratio_mean_b15_b11 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<-10 and time_trade>=-15 and F9_T0401D=3;
create table ratio_mean_b15_b11 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b15_b11,mean(shanghai_sdd20) as shanghai_sdd20_mean_b15_b11,mean(other_sdd20) as other_sdd20_mean_b15_b11,mean(home_city_sdd20) as home_city_sdd20_mean_b15_b11,mean(home_province_sdd20) as home_province_sdd20_mean_b15_b11,mean(fund_sdd20) as fund_sdd20_mean_b15_b11 from ratio_mean_b15_b11
group by stock_code_1,event_date;

create table ratio_mean_b10_b6 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<5 and time_trade>=-10 and F9_T0401D=3;
create table ratio_mean_b10_b6 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b10_b6,mean(shanghai_sdd20) as shanghai_sdd20_mean_b10_b6,mean(other_sdd20) as other_sdd20_mean_b10_b6,mean(home_city_sdd20) as home_city_sdd20_mean_b10_b6,mean(home_province_sdd20) as home_province_sdd20_mean_b10_b6,mean(fund_sdd20) as fund_sdd20_mean_b10_b6 from ratio_mean_b10_b6
group by stock_code_1,event_date;

create table ratio_mean_b5_b1 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table ratio_mean_b5_b1 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b5_b1,mean(shanghai_sdd20) as shanghai_sdd20_mean_b5_b1,mean(other_sdd20) as other_sdd20_mean_b5_b1,mean(home_city_sdd20) as home_city_sdd20_mean_b5_b1,mean(home_province_sdd20) as home_province_sdd20_mean_b5_b1,mean(fund_sdd20) as fund_sdd20_mean_b5_b1 from ratio_mean_b5_b1
group by stock_code_1,event_date;

create table ratio_mean_b20_b1 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<0 and time_trade>=-20 and F9_T0401D=3;
create table ratio_mean_b20_b1 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b20_b1,mean(shanghai_sdd20) as shanghai_sdd20_mean_b20_b1,mean(other_sdd20) as other_sdd20_mean_b20_b1,mean(home_city_sdd20) as home_city_sdd20_mean_b20_b1,mean(home_province_sdd20) as home_province_sdd20_mean_b20_b1,mean(fund_sdd20) as fund_sdd20_mean_b20_b1 from ratio_mean_b20_b1
group by stock_code_1,event_date;

create table ratio_mean_b15_b1 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<0 and time_trade>=-15 and F9_T0401D=3;
create table ratio_mean_b15_b1 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b15_b1,mean(shanghai_sdd20) as shanghai_sdd20_mean_b15_b1,mean(other_sdd20) as other_sdd20_mean_b15_b1,mean(home_city_sdd20) as home_city_sdd20_mean_b15_b1,mean(home_province_sdd20) as home_province_sdd20_mean_b15_b1,mean(fund_sdd20) as fund_sdd20_mean_b15_b1 from ratio_mean_b15_b1
group by stock_code_1,event_date;

create table ratio_mean_b10_b1 as select distinct stock_code_1,event_date,beijing_sdd20,shanghai_sdd20,other_sdd20,home_city_sdd20,home_province_sdd20,fund_sdd20 from lawsuit_60d
where time_trade<0 and time_trade>=-10 and F9_T0401D=3;
create table ratio_mean_b10_b1 as select distinct stock_code_1,event_date, mean(beijing_sdd20) as beijing_sdd20_mean_b10_b1,mean(shanghai_sdd20) as shanghai_sdd20_mean_b10_b1,mean(other_sdd20) as other_sdd20_mean_b10_b1,mean(home_city_sdd20) as home_city_sdd20_mean_b10_b1,mean(home_province_sdd20) as home_province_sdd20_mean_b10_b1,mean(fund_sdd20) as fund_sdd20_mean_b10_b1  from ratio_mean_b10_b1
group by stock_code_1,event_date;

create table return_b1_b5d as select distinct stock_code_1,event_date,F6_T0401D from lawsuit_60d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table return_b1_b5d as select distinct stock_code_1,event_date, sum(F6_T0401D) as return_b1_b5d  from return_b1_b5d
group by stock_code_1,event_date;

create table return_b6_b20d as select distinct stock_code_1,event_date,F6_T0401D from lawsuit_60d
where time_trade<-5 and time_trade>=-20 and F9_T0401D=3;
create table return_b6_b20d as select distinct stock_code_1,event_date, sum(F6_T0401D) as return_b6_b20d  from return_b6_b20d
group by stock_code_1,event_date;

create table return_a0_a1d as select distinct stock_code_1,event_date,F6_T0401D from lawsuit_60d
where time_trade<2 and time_trade>=0 and F9_T0401D=3;
create table return_a0_a1d as select distinct stock_code_1,event_date, sum(F6_T0401D) as return_a0_a1d  from return_a0_a1d
group by stock_code_1,event_date;

create table return_b3_a1d as select distinct stock_code_1,event_date,F6_T0401D   from lawsuit_60d
where time_trade<2 and time_trade>=-3 and F9_T0401D=3;
create table return_b3_a1d as select distinct stock_code_1,event_date, sum(F6_T0401D) as return_b3_a1d  from return_b3_a1d
group by stock_code_1,event_date;

create table return_b1_b3d as select distinct stock_code_1,event_date,F6_T0401D from lawsuit_60d
where time_trade<0 and time_trade>=-3 and F9_T0401D=3;
create table return_b1_b3d as select distinct stock_code_1,event_date, sum(F6_T0401D) as return_b1_b3d  from return_b1_b3d
group by stock_code_1,event_date;

create table return_b5_a1d as select distinct stock_code_1,event_date,F6_T0401D from lawsuit_60d
where time_trade<2 and time_trade>=-5 and F9_T0401D=3;
create table return_b5_a1d as select distinct stock_code_1,event_date, sum(F6_T0401D) as return_b5_a1d  from return_b5_a1d
group by stock_code_1,event_date;

create table ABreturn_b1_b5d as select distinct stock_code_1,event_date,abret_index from lawsuit_60d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table ABreturn_b1_b5d as select distinct stock_code_1,event_date, sum(abret_index) as ABreturn_b1_b5d  from ABreturn_b1_b5d
group by stock_code_1,event_date;

create table ABreturn_b6_b20d as select distinct stock_code_1,event_date,abret_index from lawsuit_60d
where time_trade<-5 and time_trade>=-20 and F9_T0401D=3;
create table ABreturn_b6_b20d as select distinct stock_code_1,event_date, sum(abret_index) as ABreturn_b6_b20d  from ABreturn_b6_b20d
group by stock_code_1,event_date;

create table ABreturn_a0_a1d as select distinct stock_code_1,event_date,abret_index  from lawsuit_60d
where time_trade<2 and time_trade>=0 and F9_T0401D=3;
create table ABreturn_a0_a1d as select distinct stock_code_1,event_date, sum(abret_index) as ABreturn_a0_a1d  from ABreturn_a0_a1d
group by stock_code_1,event_date;

create table ABreturn_b3_a1d as select distinct stock_code_1,event_date,abret_index  from lawsuit_60d
where time_trade<2 and time_trade>=-3 and F9_T0401D=3;
create table ABreturn_b3_a1d as select distinct stock_code_1,event_date, sum(abret_index) as ABreturn_b3_a1d  from ABreturn_b3_a1d
group by stock_code_1,event_date;

create table ABreturn_b1_b3d as select distinct stock_code_1,event_date,abret_index from lawsuit_60d
where time_trade<0 and time_trade>=-3 and F9_T0401D=3;
create table ABreturn_b1_b3d as select distinct stock_code_1,event_date, sum(abret_index) as ABreturn_b1_b3d  from ABreturn_b1_b3d
group by stock_code_1,event_date;

create table ABreturn_b5_a1d as select distinct stock_code_1,event_date,abret_index from lawsuit_60d
where time_trade<2 and time_trade>=-5 and F9_T0401D=3;
create table ABreturn_b5_a1d as select distinct stock_code_1,event_date, sum(abret_index) as ABreturn_b5_a1d  from ABreturn_b5_a1d
group by stock_code_1,event_date;

create table BM as select distinct a.stock_code_1,a.event_date,b.BM from lawsuit_60d a left join broker.BM_ratio b
on qtr(a.event_date)=qtr(b.date) and year(a.event_date)=year(b.date) and a.stock_code_1=b.stock_code_1;
create table MarCap as select distinct stock_code_1,event_date,Marcap from lawsuit_60d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table MarCap as select distinct stock_code_1,event_date, mean(Marcap) as MarCap  from MarCap
group by stock_code_1,event_date;
quit;

proc sql;
create table predict_lawsuit_buy_sdd20 as select distinct a.stock_code_1,a.event_date,b.return_a0_a1d,c.return_b1_b3d,d.return_b5_a1d,e.return_b1_b5d,f.return_b6_b20d,g.abreturn_a0_a1d,h.abreturn_b1_b3d,i.abreturn_b5_a1d,j.abreturn_b1_b5d,k.abreturn_b6_b20d,n.return_b3_a1d,o.ABreturn_b3_a1d,l.MarCap,m.BM from lawsuit_60d a,return_a0_a1d b,return_b1_b3d c,return_b5_a1d d,return_b1_b5d e,return_b6_b20d f,abreturn_a0_a1d g,abreturn_b1_b3d h,abreturn_b5_a1d i,abreturn_b1_b5d j,abreturn_b6_b20d k,Marcap l,BM m,return_b3_a1d n,ABreturn_b3_a1d o
where a.stock_code_1=f.stock_code_1 and a.event_date=f.event_date and a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.stock_code_1=c.stock_code_1 and a.event_date=c.event_date and a.stock_code_1=d.stock_code_1 and a.event_date=d.event_date and a.stock_code_1=e.stock_code_1 and a.event_date=e.event_date and a.stock_code_1=g.stock_code_1 and a.event_date=g.event_date and a.stock_code_1=h.stock_code_1 and a.event_date=h.event_date and a.stock_code_1=i.stock_code_1 and a.event_date=i.event_date and a.stock_code_1=j.stock_code_1 and a.event_date=j.event_date and a.stock_code_1=k.stock_code_1 and a.event_date=k.event_date and a.stock_code_1=l.stock_code_1 and a.event_date=l.event_date and a.stock_code_1=m.stock_code_1 and a.event_date=m.event_date and a.stock_code_1=n.stock_code_1 and a.event_date=n.event_date and a.stock_code_1=o.stock_code_1 and a.event_date=o.event_date;


create table predict_lawsuit_buy_sdd20 as select distinct a.*,
b.beijing_sdd20_mean_b15_b11,b.shanghai_sdd20_mean_b15_b11,b.other_sdd20_mean_b15_b11,b.home_city_sdd20_mean_b15_b11,b.home_province_sdd20_mean_b15_b11,b.fund_sdd20_mean_b15_b11,
c.beijing_sdd20_mean_b20_b16,c.shanghai_sdd20_mean_b20_b16,c.other_sdd20_mean_b20_b16,c.home_city_sdd20_mean_b20_b16,c.home_province_sdd20_mean_b20_b16,c.fund_sdd20_mean_b20_b16,
d.beijing_sdd20_mean_b20_b1,d.shanghai_sdd20_mean_b20_b1,d.other_sdd20_mean_b20_b1,d.home_city_sdd20_mean_b20_b1,d.home_province_sdd20_mean_b20_b1,d.fund_sdd20_mean_b20_b1,
e.beijing_sdd20_mean_b5_b1,e.shanghai_sdd20_mean_b5_b1,e.other_sdd20_mean_b5_b1,e.home_city_sdd20_mean_b5_b1,e.home_province_sdd20_mean_b5_b1,e.fund_sdd20_mean_b5_b1,
f.beijing_sdd20_mean_b15_b1,f.shanghai_sdd20_mean_b15_b1,f.other_sdd20_mean_b15_b1,f.home_city_sdd20_mean_b15_b1,f.home_province_sdd20_mean_b15_b1,f.fund_sdd20_mean_b15_b1,
g.beijing_sdd20_mean_b10_b1,g.shanghai_sdd20_mean_b10_b1,g.other_sdd20_mean_b10_b1,g.home_city_sdd20_mean_b10_b1,g.home_province_sdd20_mean_b10_b1,g.fund_sdd20_mean_b10_b1, 
h.beijing_sdd20_mean_b10_b6,h.shanghai_sdd20_mean_b10_b6,h.other_sdd20_mean_b10_b6,h.home_city_sdd20_mean_b10_b6,h.home_province_sdd20_mean_b10_b6,h.fund_sdd20_mean_b10_b6
from predict_lawsuit_buy_sdd20 a, ratio_mean_b15_b11 b, ratio_mean_b20_b16 c, ratio_mean_b20_b1 d, ratio_mean_b5_b1 e, ratio_mean_b15_b1 f, ratio_mean_b10_b1 g,ratio_mean_b10_b6 h
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.stock_code_1=c.stock_code_1 and a.event_date=c.event_date and a.stock_code_1=d.stock_code_1 and a.event_date=d.event_date and a.stock_code_1=e.stock_code_1 and a.event_date=e.event_date and a.stock_code_1=f.stock_code_1 and a.event_date=f.event_date and a.stock_code_1=g.stock_code_1 and a.event_date=g.event_date and a.stock_code_1=h.stock_code_1 and a.event_date=h.event_date;
quit;

