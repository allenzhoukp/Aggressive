data earning;
set broker.earning_important;
length event $20.;
event='earning';
predictable=1;
keep stock_code_1 event_date event predictable;
run;

data earning_forecast;
set broker.earning_forecast_important;
length event $20.;
event='earning_forecast';
keep stock_code_1 event_date event;
run;

data restructure;
set broker.restructure_important;
length event $20.;
event='restructure';
keep stock_code_1 event_date event;
run;

data bankloan;
set broker.bankloan_important;
length event $20.;
event='bankloan';
keep stock_code_1 event_date event;
run;

data lawsuit;
set broker.lawsuit_important;
length event $20.;
event='lawsuit';
keep stock_code_1 event_date event;
run;

data suspension;
set broker.suspension_important;
length event $20.;
event='suspension';
keep stock_code_1 event_date event;
run;

data governor;
set broker.governor_event_14;
length event $20.;
event='governor';
keep stock_code_1 event_date event;
run;

data all_eerbl;
set earning earning_forecast restructure bankloan lawsuit suspension governor;
keep stock_code_1 event_date event;
run;

proc sort;
by stock_code_1 event_date;
run;

proc sql;
create table all_eerbl as select distinct a.*,b.predictable from all_eerbl a left join earning b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data broker.all_eerbl;
set all_eerbl;
if predictable=. then predictable=0;

if predictable=1 and event^='earning' then delete;

all=1;
if event='earning' then earning=1; else earning=0;
if event='earning_forecast' then earning_forecast=1; else earning_forecast=0;
if event='restructure' then restructure=1; else restructure=0;
if event='bankloan' then bankloan=1; else bankloan=0;
if event='lawsuit' then lawsuit=1; else lawsuit=0;
if event='suspension' then suspension=1; else suspension=0;
if event='governor' then governor=1; else governor=0;
run;

%macro eventimb(event);
data &event._1;
set broker.&event.;
keep stock_code_1 event_date event;
run;

proc sql;
create table &event._2 as select distinct a.stock_code_1,a.event_date,a.event,b.date,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
from &event._1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.event_date+240>=b.date and a.event_date<=b.date;
quit;

proc sort;
by stock_code_1 event_date  date;
run;

data &event._2;
set &event._2;
by stock_code_1 event_date date;
if first.event_date then time_trade=-1;
time_trade+1;
run;

proc sql;
create table &event._2_1 as select distinct a.stock_code_1,a.event_date,a.event,b.date,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
from &event._1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.event_date>b.date and a.event_date-120<=b.date;
quit;

proc sort;
by stock_code_1 event_date  descending date;
run;

data &event._2_1;
set &event._2_1;
by stock_code_1 event_date descending date;
if first.event_date then time_trade=0;
time_trade+(-1);
run;

data &event._4;
set &event._2 &event._2_1;
if event_date^=.;
run;


proc sql;
create table &event._4 as select distinct a.*,b.head_type,b.all_imb_adj,b.beijing_imb_adj,b.shanghai_imb_adj,b.home_city_imb_adj,b.home_province_imb_adj,b.other_imb_adj,b.fund_imb_adj
from &event._4 a left join broker.T_0401D_4 b
on a.date=b.date and a.stock_code_1=b.F3_T0401D;
quit;

proc sort data=&event._4 out=&event._4;
by stock_code_1 event_date time_trade;
run;

data &event._60d_imb;
set &event._4;
run;

proc sort;
by stock_code_1 event_date time_trade;
run;

%mend eventimb;
%eventimb(all_eerbl);

data clean_event;
set all_eerbl_60d_imb;
if time_trade=0 or time_trade=-1;
if date^=.;
if (time_trade=0 and date-event_date<=7) or (time_trade=-1 and date-event_date>=-7) or event='restructure' or event='lawsuit';
distance=date-event_date;
keep stock_code_1 event_date date time_trade event distance;
run;

proc sql;
create table broker.all_eerbl as select distinct a.* from broker.all_eerbl a,clean_event b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table broker.all_eerbl_60d_imb as select distinct a.* from all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
/*
%macro clean(event);
proc sort data=broker.all_eerbl out=event_&event.;
where &event.=1;
by stock_code_1 event_date;
run;

data event_&event.;
set event_&event.;
lagstock=lag(stock_code_1);
lagevent=lag(event_date);
format lagevent date.;
run;

data event_&event.;
set event_&event.;
if stock_code_1=lagstock and lagevent-event_date>-14 then delete;
drop lagstock lagevent;
run;
%mend clean;
%clean(all);

proc sql;
create table broker.all_eerbl as select distinct a.* from broker.all_eerbl a,event_all b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

%clean(restructure);
%clean(bankloan);
%clean(lawsuit);
%clean(suspension);

data broker.all_eerbl;
set broker.all_eerbl;
if event='earning' or event='earning_forecast';
run;

data broker.all_eerbl;
set broker.all_eerbl event_restructure event_bankloan event_lawsuit event_suspension;
run;
*/
proc sort;
by stock_code_1 event_date;
run;

proc sql;
create table CAR0_1 as select distinct stock_code_1,event_date,sum(abret_index) as index0_1
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=10
group by stock_code_1,event_date;
quit;

data CAR0_1;
set CAR0_1;
if abs(index0_1)>-1;
run;

proc sql;
create table broker.all_eerbl as select distinct a.* from broker.all_eerbl a,CAR0_1 b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table broker.all_eerbl_60d_imb as select distinct a.* from all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table broker.all_eerbl as select distinct stock_code_1,event_date,sum(predictable) as predictable,sum(earning) as earning,sum(earning_forecast) as earning_forecast,sum(restructure) as restructure,sum(bankloan) as bankloan,sum(lawsuit) as lawsuit,sum(suspension) as suspension,sum(governor) as governor
from broker.all_eerbl
group by stock_code_1,event_date;
quit;

data broker.all_eerbl;
set broker.all_eerbl;
all=1;
run;
/*
proc sql;
create table CAR as select distinct a.stock_code_1,a.event_date,sum(a.abret_index) as CAR
from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade>=0 and a.time_trade<=20
group by a.stock_code_1,a.event_date;
quit;

data CAR;
set CAR;
lagstock=lag(stock_code_1);
lagevent=lag(event_date);
lagCAR=lag(CAR);
format lagevent date.;
run;

proc sort data=CAR;
by stock_code_1 descending event_date;
run;

data CAR;
set CAR;
leadstock=lag(stock_code_1);
leadevent=lag(event_date);
leadCAR=lag(CAR);
format lagevent date.;
run;

data CAR;
set CAR;
if stock_code_1=lagstock and lagevent-event_date>-14 and abs(CAR)<=abs(lagCAR) then delete;
if stock_code_1=leadstock and leadevent-event_date<14 and abs(CAR)<=abs(leadCAR) then delete;
run;

proc sql;
create table broker.all_eerbl as select distinct a.* from broker.all_eerbl a,CAR b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table broker.all_eerbl_60d_imb as select distinct a.* from all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
*/

proc sql;
create table imb_b10 as select distinct stock_code_1,event_date
,sum(abret_index) as indexb10,sum(abret_month) as monthb10
,sum(all_imb_adj) as all_imbb10
,sum(beijing_imb_adj) as beijing_imbb10
,sum(shanghai_imb_adj) as shanghai_imbb10
,sum(other_imb_adj) as other_imbb10
,sum(home_city_imb_adj) as home_city_imbb10
,sum(home_province_imb_adj) as home_province_imbb10
,sum(fund_imb_adj) as fund_imbb10
from broker.all_eerbl_60d_imb
where time_trade<=&post and time_trade>=&pre
group by stock_code_1,event_date;
quit;

data imb_b10;
merge imb_b10 broker.all_eerbl;
by stock_code_1 event_date;
run;

data imb_b10;
set imb_b10;
if all_imbb10^=. and all_imbb10^=0;
run;

proc sort;
by all_imbb10;
run;

data _null_;
       set imb_b10 nobs=t;
       call symput("size",t);
       stop;
run;


data imb_b10;
set imb_b10;
if _n_<=&size./5*1 or _n_>&size./5*4;
important=1;
keep stock_code_1 event_date important;
run;

proc sort;
by stock_code_1 event_date;
run;

data broker.all_eerbl;
set broker.all_eerbl;
drop count important No first_half;
run;

proc sql;
create table temp1 as select distinct stock_code_1,count(distinct event_date) as count from imb_b10
group by stock_code_1;
quit;

data temp1;
merge broker.all_eerbl temp1;
by stock_code_1;
run;

data temp1;
merge temp1 imb_b10;
by stock_code_1 event_date;
run;

data temp1;
set temp1;
if important=. then important=0;
if count=. then count=0;
run;

data temp1;
set temp1;
by stock_code_1 event_date;
if first.stock_code_1 then No=0;
if important=1 then No+1;
run;

data temp1;
set temp1;
if No<=(count)/2 then first_half=1;
else if No<=(count)*2/2 then first_half=2;
else first_half=3;
run;

data broker.all_eerbl;
set temp1;
run;

proc sql;
create table all_eerbl as select * from broker.all_eerbl
where stock_code_1 in (select F3_T0401D from broker.T_0401D_1) and event_date>='01jul07'd and event_date<='31dec08'd;
quit;
/*
proc sql;
create table broker.all_eerbl_60d_imb as select distinct a.*,max(b.event_date) as event_date_1 from broker.all_eerbl_60d_imb a left join broker.all_eerbl b
on a.stock_code_1=b.stock_code_1 and b.event_date<a.event_date
group by a.stock_code_1,a.event_date;
quit;

data broker.all_eerbl_60d_imb;
set broker.all_eerbl_60d_imb;
format event_date_1 date.;
if event_date>event_date_1 and date<event_date_1 then delete;

run;
*/



