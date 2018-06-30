/*
proc sql;
create table restructure_50d  as select distinct a.* from price_limit_first a join broker.non_bsg b
on a.stock_code_1=b.F3_T0401D;
quit;
*/


proc sql;
create table ratio_mean_b20_b16 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<-15 and time_trade>=-20 and F9_T0401D=3;
create table ratio_mean_b20_b16 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b20_b16,mean(shanghai_sdd20) as shanghai_sdd20_mean_b20_b16,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b20_b16,mean(other_city_sdd20) as other_city_sdd20_mean_b20_b16,mean(same_province_sdd20) as same_province_sdd20_mean_b20_b16,mean(home_sdd20) as home_sdd20_mean_b20_b16,mean(fund_sdd20) as fund_sdd20_mean_b20_b16,mean(nothome_sdd20) as nothome_sdd20_mean_b20_b16  from ratio_mean_b20_b16
group by stock_code_1,first_date;

create table ratio_mean_b15_b11 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<-10 and time_trade>=-15 and F9_T0401D=3;
create table ratio_mean_b15_b11 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b15_b11,mean(shanghai_sdd20) as shanghai_sdd20_mean_b15_b11,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b15_b11,mean(other_city_sdd20) as other_city_sdd20_mean_b15_b11,mean(same_province_sdd20) as same_province_sdd20_mean_b15_b11,mean(home_sdd20) as home_sdd20_mean_b15_b11,mean(fund_sdd20) as fund_sdd20_mean_b15_b11,mean(nothome_sdd20) as nothome_sdd20_mean_b15_b11 from ratio_mean_b15_b11
group by stock_code_1,first_date;

create table ratio_mean_b10_b6 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<5 and time_trade>=-10 and F9_T0401D=3;
create table ratio_mean_b10_b6 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b10_b6,mean(shanghai_sdd20) as shanghai_sdd20_mean_b10_b6,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b10_b6,mean(other_city_sdd20) as other_city_sdd20_mean_b10_b6,mean(same_province_sdd20) as same_province_sdd20_mean_b10_b6,mean(home_sdd20) as home_sdd20_mean_b10_b6,mean(fund_sdd20) as fund_sdd20_mean_b10_b6,mean(nothome_sdd20) as nothome_sdd20_mean_b10_b6 from ratio_mean_b10_b6
group by stock_code_1,first_date;

create table ratio_mean_b5_b1 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table ratio_mean_b5_b1 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b5_b1,mean(shanghai_sdd20) as shanghai_sdd20_mean_b5_b1,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b5_b1,mean(other_city_sdd20) as other_city_sdd20_mean_b5_b1,mean(same_province_sdd20) as same_province_sdd20_mean_b5_b1,mean(home_sdd20) as home_sdd20_mean_b5_b1,mean(fund_sdd20) as fund_sdd20_mean_b5_b1,mean(nothome_sdd20) as nothome_sdd20_mean_b5_b1  from ratio_mean_b5_b1
group by stock_code_1,first_date;

create table ratio_mean_b20_b6 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<-5 and time_trade>=-20 and F9_T0401D=3;
create table ratio_mean_b20_b6 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b20_b6,mean(shanghai_sdd20) as shanghai_sdd20_mean_b20_b6,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b20_b6,mean(other_city_sdd20) as other_city_sdd20_mean_b20_b6,mean(same_province_sdd20) as same_province_sdd20_mean_b20_b6,mean(home_sdd20) as home_sdd20_mean_b20_b6,mean(fund_sdd20) as fund_sdd20_mean_b20_b6,mean(nothome_sdd20) as nothome_sdd20_mean_b20_b6 from ratio_mean_b20_b6
group by stock_code_1,first_date;

create table ratio_mean_b15_b6 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<-5 and time_trade>=-15 and F9_T0401D=3;
create table ratio_mean_b15_b6 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b15_b6,mean(shanghai_sdd20) as shanghai_sdd20_mean_b15_b6,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b15_b6,mean(other_city_sdd20) as other_city_sdd20_mean_b15_b6,mean(same_province_sdd20) as same_province_sdd20_mean_b15_b6,mean(home_sdd20) as home_sdd20_mean_b15_b6,mean(fund_sdd20) as fund_sdd20_mean_b15_b6,mean(nothome_sdd20) as nothome_sdd20_mean_b15_b6  from ratio_mean_b15_b6
group by stock_code_1,first_date;

create table ratio_mean_b5_b3 as select distinct stock_code_1,first_date,beijing_sdd20,shanghai_sdd20,shenzhen_sdd20,other_city_sdd20,same_province_sdd20,home_sdd20,fund_sdd20,nothome_sdd20 from restructure_50d 
where time_trade<-2 and time_trade>=-5 and F9_T0401D=3;
create table ratio_mean_b5_b3 as select distinct stock_code_1,first_date, mean(beijing_sdd20) as beijing_sdd20_mean_b5_b3,mean(shanghai_sdd20) as shanghai_sdd20_mean_b5_b3,mean(shenzhen_sdd20) as shenzhen_sdd20_mean_b5_b3,mean(other_city_sdd20) as other_city_sdd20_mean_b5_b3,mean(same_province_sdd20) as same_province_sdd20_mean_b5_b3,mean(home_sdd20) as home_sdd20_mean_b5_b3,mean(fund_sdd20) as fund_sdd20_mean_b5_b3,mean(nothome_sdd20) as nothome_sdd20_mean_b5_b3  from ratio_mean_b5_b3
group by stock_code_1,first_date;

create table return_b1_b5d as select distinct stock_code_1,first_date,F6_T0401D from restructure_50d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table return_b1_b5d as select distinct stock_code_1,first_date, sum(F6_T0401D) as return_b1_b5d  from return_b1_b5d
group by stock_code_1,first_date;

create table return_b6_b20d as select distinct stock_code_1,first_date,F6_T0401D from restructure_50d
where time_trade<-5 and time_trade>=-20 and F9_T0401D=3;
create table return_b6_b20d as select distinct stock_code_1,first_date, sum(F6_T0401D) as return_b6_b20d  from return_b6_b20d
group by stock_code_1,first_date;

create table return_a0_a1d as select distinct stock_code_1,first_date,F6_T0401D from restructure_50d
where time_trade<2 and time_trade>=0 and F9_T0401D=3;
create table return_a0_a1d as select distinct stock_code_1,first_date, sum(F6_T0401D) as return_a0_a1d  from return_a0_a1d
group by stock_code_1,first_date;

create table return_b3_a1d as select distinct stock_code_1,first_date,F6_T0401D   from restructure_50d
where time_trade<2 and time_trade>=-3 and F9_T0401D=3;
create table return_b3_a1d as select distinct stock_code_1,first_date, sum(F6_T0401D) as return_b3_a1d  from return_b3_a1d
group by stock_code_1,first_date;

create table return_b1_b3d as select distinct stock_code_1,first_date,F6_T0401D from restructure_50d
where time_trade<0 and time_trade>=-3 and F9_T0401D=3;
create table return_b1_b3d as select distinct stock_code_1,first_date, sum(F6_T0401D) as return_b1_b3d  from return_b1_b3d
group by stock_code_1,first_date;

create table return_b5_a1d as select distinct stock_code_1,first_date,F6_T0401D from restructure_50d
where time_trade<2 and time_trade>=-5 and F9_T0401D=3;
create table return_b5_a1d as select distinct stock_code_1,first_date, sum(F6_T0401D) as return_b5_a1d  from return_b5_a1d
group by stock_code_1,first_date;

create table ABreturn_b1_b5d as select distinct stock_code_1,first_date,Abret_month from restructure_50d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table ABreturn_b1_b5d as select distinct stock_code_1,first_date, sum(Abret_month) as ABreturn_b1_b5d  from ABreturn_b1_b5d
group by stock_code_1,first_date;

create table ABreturn_b6_b20d as select distinct stock_code_1,first_date,Abret_month from restructure_50d
where time_trade<-5 and time_trade>=-20 and F9_T0401D=3;
create table ABreturn_b6_b20d as select distinct stock_code_1,first_date, sum(Abret_month) as ABreturn_b6_b20d  from ABreturn_b6_b20d
group by stock_code_1,first_date;

create table ABreturn_a0_a1d as select distinct stock_code_1,first_date,Abret_month  from restructure_50d
where time_trade<2 and time_trade>=0 and F9_T0401D=3;
create table ABreturn_a0_a1d as select distinct stock_code_1,first_date, sum(Abret_month) as ABreturn_a0_a1d  from ABreturn_a0_a1d
group by stock_code_1,first_date;

create table ABreturn_b3_a1d as select distinct stock_code_1,first_date,Abret_month  from restructure_50d
where time_trade<2 and time_trade>=-3 and F9_T0401D=3;
create table ABreturn_b3_a1d as select distinct stock_code_1,first_date, sum(Abret_month) as ABreturn_b3_a1d  from ABreturn_b3_a1d
group by stock_code_1,first_date;

create table ABreturn_b1_b3d as select distinct stock_code_1,first_date,Abret_month from restructure_50d
where time_trade<0 and time_trade>=-3 and F9_T0401D=3;
create table ABreturn_b1_b3d as select distinct stock_code_1,first_date, sum(Abret_month) as ABreturn_b1_b3d  from ABreturn_b1_b3d
group by stock_code_1,first_date;

create table ABreturn_b5_a1d as select distinct stock_code_1,first_date,Abret_month from restructure_50d
where time_trade<2 and time_trade>=-5 and F9_T0401D=3;
create table ABreturn_b5_a1d as select distinct stock_code_1,first_date, sum(Abret_month) as ABreturn_b5_a1d  from ABreturn_b5_a1d
group by stock_code_1,first_date;

create table BM as select distinct a.stock_code_1,a.first_date,b.BM from restructure_50d a left join broker.BM_ratio b
on qtr(a.first_date)=qtr(b.date) and year(a.first_date)=year(b.date) and a.stock_code_1=b.stock_code_1;
create table MarCap as select distinct stock_code_1,first_date,Marcap from restructure_50d
where time_trade<0 and time_trade>=-5 and F9_T0401D=3;
create table MarCap as select distinct stock_code_1,first_date, mean(Marcap) as MarCap  from MarCap
group by stock_code_1,first_date;
quit;

proc sql;
create table predict_restructure_buy_sdd20 as select distinct a.stock_code_1,a.first_date,b.return_a0_a1d,c.return_b1_b3d,d.return_b5_a1d,e.return_b1_b5d,f.return_b6_b20d,g.abreturn_a0_a1d,h.abreturn_b1_b3d,i.abreturn_b5_a1d,j.abreturn_b1_b5d,k.abreturn_b6_b20d,n.return_b3_a1d,o.ABreturn_b3_a1d,l.MarCap,m.BM from restructure_50d a ,return_a0_a1d b,return_b1_b3d c,return_b5_a1d d,return_b1_b5d e,return_b6_b20d f,abreturn_a0_a1d g,abreturn_b1_b3d h,abreturn_b5_a1d i,abreturn_b1_b5d j,abreturn_b6_b20d k,Marcap l,BM m,return_b3_a1d n,ABreturn_b3_a1d o
where a.stock_code_1=f.stock_code_1 and a.first_date=f.first_date and a.stock_code_1=b.stock_code_1 and a.first_date=b.first_date and a.stock_code_1=c.stock_code_1 and a.first_date=c.first_date and a.stock_code_1=d.stock_code_1 and a.first_date=d.first_date and a.stock_code_1=e.stock_code_1 and a.first_date=e.first_date and a.stock_code_1=g.stock_code_1 and a.first_date=g.first_date and a.stock_code_1=h.stock_code_1 and a.first_date=h.first_date and a.stock_code_1=i.stock_code_1 and a.first_date=i.first_date and a.stock_code_1=j.stock_code_1 and a.first_date=j.first_date and a.stock_code_1=k.stock_code_1 and a.first_date=k.first_date and a.stock_code_1=l.stock_code_1 and a.first_date=l.first_date and a.stock_code_1=m.stock_code_1 and a.first_date=m.first_date and a.stock_code_1=n.stock_code_1 and a.first_date=n.first_date and a.stock_code_1=o.stock_code_1 and a.first_date=o.first_date;


create table predict_restructure_buy_sdd20 as select distinct a.*,
b.beijing_sdd20_mean_b15_b11,b.shanghai_sdd20_mean_b15_b11,b.shenzhen_sdd20_mean_b15_b11,b.other_city_sdd20_mean_b15_b11,b.same_province_sdd20_mean_b15_b11,b.home_sdd20_mean_b15_b11,b.fund_sdd20_mean_b15_b11,b.nothome_sdd20_mean_b15_b11, 
c.beijing_sdd20_mean_b20_b16,c.shanghai_sdd20_mean_b20_b16,c.shenzhen_sdd20_mean_b20_b16,c.other_city_sdd20_mean_b20_b16,c.same_province_sdd20_mean_b20_b16,c.home_sdd20_mean_b20_b16,c.fund_sdd20_mean_b20_b16,c.nothome_sdd20_mean_b20_b16,
d.beijing_sdd20_mean_b20_b6,d.shanghai_sdd20_mean_b20_b6,d.shenzhen_sdd20_mean_b20_b6,d.other_city_sdd20_mean_b20_b6,d.same_province_sdd20_mean_b20_b6,d.home_sdd20_mean_b20_b6,d.fund_sdd20_mean_b20_b6,d.nothome_sdd20_mean_b20_b6,
e.beijing_sdd20_mean_b5_b1,e.shanghai_sdd20_mean_b5_b1,e.shenzhen_sdd20_mean_b5_b1,e.other_city_sdd20_mean_b5_b1,e.same_province_sdd20_mean_b5_b1,e.home_sdd20_mean_b5_b1,e.fund_sdd20_mean_b5_b1,e.nothome_sdd20_mean_b5_b1,
f.beijing_sdd20_mean_b15_b6,f.shanghai_sdd20_mean_b15_b6,f.shenzhen_sdd20_mean_b15_b6,f.other_city_sdd20_mean_b15_b6,f.same_province_sdd20_mean_b15_b6,f.home_sdd20_mean_b15_b6,f.fund_sdd20_mean_b15_b6,f.nothome_sdd20_mean_b15_b6,
g.beijing_sdd20_mean_b5_b3,g.shanghai_sdd20_mean_b5_b3,g.shenzhen_sdd20_mean_b5_b3,g.other_city_sdd20_mean_b5_b3,g.same_province_sdd20_mean_b5_b3,g.home_sdd20_mean_b5_b3,g.fund_sdd20_mean_b5_b3,g.nothome_sdd20_mean_b5_b3, 
h.beijing_sdd20_mean_b10_b6,h.shanghai_sdd20_mean_b10_b6,h.shenzhen_sdd20_mean_b10_b6,h.other_city_sdd20_mean_b10_b6,h.same_province_sdd20_mean_b10_b6,h.home_sdd20_mean_b10_b6,h.fund_sdd20_mean_b10_b6,h.nothome_sdd20_mean_b10_b6
from predict_restructure_buy_sdd20 a, ratio_mean_b15_b11 b, ratio_mean_b20_b16 c, ratio_mean_b20_b6 d, ratio_mean_b5_b1 e, ratio_mean_b15_b6 f, ratio_mean_b5_b3 g,ratio_mean_b10_b6 h
where a.stock_code_1=b.stock_code_1 and a.first_date=b.first_date and a.stock_code_1=c.stock_code_1 and a.first_date=c.first_date and a.stock_code_1=d.stock_code_1 and a.first_date=d.first_date and a.stock_code_1=e.stock_code_1 and a.first_date=e.first_date and a.stock_code_1=f.stock_code_1 and a.first_date=f.first_date and a.stock_code_1=g.stock_code_1 and a.first_date=g.first_date and a.stock_code_1=h.stock_code_1 and a.first_date=h.first_date;
quit;

