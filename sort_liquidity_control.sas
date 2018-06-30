%let start=0;
%let end=1;
%let pre=-10;

%macro event(event);

proc sql;
create table &event._60d_imb as select distinct a.* from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.&event.=1;
quit;

proc sql;
create table imb_b10 as select distinct stock_code_1,event_date
,sum(abret_index) as indexb10,sum(abret_month) as monthb10,std(return_raw) as stdb10
,sum(all_imb_adj) as all_imbb10
,sum(beijing_imb_adj) as beijing_imbb10
,sum(shanghai_imb_adj) as shanghai_imbb10
,sum(other_imb_adj) as other_imbb10
,sum(home_city_imb_adj) as home_city_imbb10
,sum(home_province_imb_adj) as home_province_imbb10
,sum(fund_imb_adj) as fund_imbb10
from &event._60d_imb
where time_trade<&start and time_trade>=&start+&pre
group by stock_code_1,event_date;
quit;


%macro abRet(r);

data sort_inv_&event._&r;
run;

proc sql;
create table CAR_after1 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win1 
from &event._60d_imb
where time_trade>=&start and time_trade<=&end
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after2 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win2
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+5
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after3 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win3
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+10
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after4 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win4
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+20
group by stock_code_1,event_date;
quit;

data imb_CAR;
merge imb_b10 CAR_after1 CAR_after2 CAR_after3 CAR_after4;
by stock_code_1 event_date;
run;

%macro sort(inv);
proc sql;
create table imb_CAR1 as select * from imb_CAR
where &inv._imbb10^=. and &inv._imbb10^=0;
quit;

proc sort;
by &inv._imbb10;
run;

data _null_;
       set imb_car1 nobs=t;
       call symput("size",t);
       stop;
run;


data imb_car1;
set imb_car1;
if _n_<=&size./5 then quintile=1;
if _n_>&size./5 and _n_<=&size./5*2 then quintile=2;
if _n_>&size./5*2 and _n_<= &size./5*3 then quintile=3;
if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

data imb_car1;
set imb_car1;
cluster1=week(event_date)+(year(event_date)-2007)*100;
cluster2=week(event_date)+(year(event_date)-2007)*100;
cluster3=month(event_date)+(year(event_date)-2007)*100;
cluster4=month(event_date)+(year(event_date)-2007)*100;
cluster5=qtr(event_date)+(year(event_date)-2007)*100;
cluster6=qtr(event_date)+(year(event_date)-2007)*100;
if quintile=1 then Q5=0;
if quintile=5 then Q5=1;
week=week(event_date)+100*(year(event_date)-2007);
month=month(event_date)+100*(year(event_date)-2007);
run;

proc sql;
create table imb_CAR1 as select distinct a.*,b.intercept,b.co_imbb10,b.co_abretb10
from imb_CAR1 a left join liquidity_10 b
on b.type="&inv._&r." and a.event_date=b.event_date;
quit;

data imb_CAR1;
set imb_CAR1;
&r.ecar1=intercept+co_imbb10*&inv._imbb10+co_abretb10*&r.b10;
&r.car1=&r.win4 -intercept-co_imbb10*&inv._imbb10-co_abretb10*&r.b10;
drop intercept co_imbb10 co_abretb10;
run;

proc sql;
create table imb_CAR1 as select distinct a.*,b.intercept,b.co_imbb10,b.co_abretb10,b.co_stdb10
from imb_CAR1 a left join liquidity_10 b
on b.type="&inv._&r._stdb10" and a.event_date=b.event_date;
quit;

data imb_CAR1;
set imb_CAR1;
&r.ecar2=intercept+co_imbb10*&inv._imbb10+co_abretb10*&r.b10+co_stdb10*stdb10;
&r.car2=&r.win4 -intercept-co_imbb10*&inv._imbb10-co_abretb10*&r.b10-co_stdb10*stdb10;
drop intercept co_imbb10 co_abretb10 co_stdb10;
run;

proc sql;
create table imb_CAR1 as select distinct a.*,b.intercept,b.co_imbb10,b.co_abretb10,b.co_stdb10,b.co_interaction
from imb_CAR1 a left join liquidity_10 b
on b.type="&inv._&r._interaction" and a.event_date=b.event_date;
quit;

data imb_CAR1;
set imb_CAR1;
&r.ecar3=intercept+co_imbb10*&inv._imbb10+co_abretb10*&r.b10+co_stdb10*stdb10+co_interaction*stdb10*&inv._imbb10;
&r.car3=&r.win4 -intercept-co_imbb10*&inv._imbb10-co_abretb10*&r.b10-co_stdb10*stdb10-co_interaction*stdb10*&inv._imbb10;
drop intercept co_imbb10 co_abretb10 co_stdb10 co_interaction;
run;

data imb_CAR1;
set imb_CAR1;
if &r.ecar1=. then &r.ecar1=0;
if &r.ecar2=. then &r.ecar2=0;
if &r.ecar3=. then &r.ecar3=0;
if &r.car1=. then &r.car1=&r.win4;
if &r.car2=. then &r.car2=&r.win4;
if &r.car3=. then &r.car3=&r.win4;
if &r.ecar1^=0;
run;

proc sort;
by quintile;
run;

data imb_car1_&r.;
set imb_car1;
run;

data Q1_5;
set imb_car1;
if Quintile=1 or Quintile=5;
run;

ODS output Parameterestimates=temp1_1;
proc surveyreg data=imb_car1;
by quintile;
model &r.win4=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp1_2;
proc surveyreg data=imb_car1;
by quintile;
model &r.ecar1=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp1_3;
proc surveyreg data=imb_car1;
by quintile;
model &r.car1=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp1_4;
proc surveyreg data=imb_car1;
by quintile;
model &r.ecar2=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp1_5;
proc surveyreg data=imb_car1;
by quintile;
model &r.car2=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp1_6;
proc surveyreg data=imb_car1;
by quintile;
model &r.ecar3=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp1_7;
proc surveyreg data=imb_car1;
by quintile;
model &r.car3=;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_1;
proc surveyreg data=Q1_5;
model &r.win4=Q5;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_2;
proc surveyreg data=Q1_5;
model &r.ecar1=Q5;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_3;
proc surveyreg data=Q1_5;
model &r.car1=Q5;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_4;
proc surveyreg data=Q1_5;
model &r.ecar2=Q5;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_5;
proc surveyreg data=Q1_5;
model &r.car2=Q5;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_6;
proc surveyreg data=Q1_5;
model &r.ecar3=Q5;
cluster cluster4;
run;
ODS output close;

ODS output Parameterestimates=temp2_7;
proc surveyreg data=Q1_5;
model &r.car3=Q5;
cluster cluster4;
run;
ODS output close;

%macro loop(n);
data temp2_&n.;
set temp2_&n.;
if _n_=1 then delete;
quintile=6;
run;

data temp3_&n.;
set temp1_&n. temp2_&n.;
rename estimate=&r.win&n._mean tvalue=&r.win&n._t;
keep quintile estimate tValue;
run;
%mend loop;
%loop(1);%loop(2);%loop(3);%loop(4);%loop(5);%loop(6);%loop(7);

data temp3;
merge temp3_1 temp3_2 temp3_3 temp3_4 temp3_5 temp3_6 temp3_7;
by quintile;
run;

data sort_inv_&event._&r.;
set sort_inv_&event._&r. temp3;
run;
%mend sort;

%sort(all);
/*
%sort(home_province);
%sort(home_city);
%sort(fund);
%sort(shanghai);
%sort(beijing);
%sort(other);
*/
data _null_;
       set imb_car1 nobs=t;
       call symput("size",t);
       stop;
run;

data sort_liquidity_&r.;
set sort_inv_&event._&r.;
if quintile^='';
size=&size.;
run;
/*
data sort_inv_&event._&r.;
set sort_inv_&event._&r.;
if quintile^='';
if mod(_n_,6)=0;
event="&event.";
*/
run;

%mend abRet;

%abRet(index);
%abRet(month);

%mend event;
/*
%event(earning);
%event(earning_forecast);
%event(restructure);
%event(bankloan);
%event(lawsuit);
%event(suspension);
%event(governor);
*/
%event(all);


proc sql;
drop table imb_b10,imb_car,imb_car1,CAR_after1,CAR_after2,CAR_after3,CAR_after4,CAR_after5,CAR_after6,Q1_5,all_60d_imb,earning_60d_imb,earning_forecast_60d_imb,restructure_60d_imb,bankloan_60d_imb,
lawsuit_60d_imb,governor_60d_imb,suspension_60d_imb,temp1_1,temp1_2,temp1_3,temp1_4,temp1_5,temp1_6,temp1_7,temp2_1,temp2_2,temp2_3,temp2_4,temp2_5,temp2_6,temp2_7,temp3,temp3_1,temp3_2,temp3_3,temp3_4,temp3_5,temp3_6,temp3_7,
sort_inv_all_index,sort_inv_earning_index,sort_inv_earning_forecast_index,sort_inv_restructure_index,sort_inv_bankloan_index,sort_inv_lawsuit_index,sort_inv_suspension_index,sort_inv_governor_index,
sort_inv_all_month,sort_inv_earning_month,sort_inv_earning_forecast_month,sort_inv_restructure_month,sort_inv_bankloan_month,sort_inv_lawsuit_month,sort_inv_suspension_month,sort_inv_governor_month;
quit;
