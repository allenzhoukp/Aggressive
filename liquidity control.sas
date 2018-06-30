%let event=all;
%let pre=10;
%let after=21;

proc sql;
create table &event._60d_imb as select distinct a.* from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.&event.=1;
quit;

proc sql;
create table temp1 as select distinct * from broker.T_0401D_4
where F3_T0401D in (select stock_code_1 from &event._60d_imb);
quit;

data temp2_1;
set &event._60d_imb;
if time_trade>=-&pre and time_trade<0;
before=1;
run;

data temp2_2;
set &event._60d_imb;
if time_trade>=0 and time_trade<=&pre;
after=1;
run;

proc sql;
create table temp3 as select distinct a.*,b.before from temp1 a left join temp2_1 b
on a.F3_T0401D=b.stock_code_1 and a.date=b.date;
quit;

proc sql;
create table temp3 as select distinct a.*,b.after from temp3 a left join temp2_2 b
on a.F3_T0401D=b.stock_code_1 and a.date=b.date;
quit;

data no&event._event;
set temp3;
if before=. and after=.;
rename F3_T0401D=stock_code_1 date=event_date;
keep F3_T0401D date;
run;

data no&event._1;
set no&event._event;
keep stock_code_1 event_date;
run;

proc sql;
create table no&event._2 as select distinct a.stock_code_1,a.event_date,b.date,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
from no&event._1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.event_date+180>=b.date and a.event_date<=b.date;
quit;

proc sort;
by stock_code_1 event_date  date;
run;

data no&event._2;
set no&event._2;
by stock_code_1 event_date date;
if first.event_date then time_trade=-1;
time_trade+1;
run;

proc sql;
create table no&event._2_1 as select distinct a.*,b.head_type,b.date,b.all_imb_adj,b.beijing_imb_adj,b.shanghai_imb_adj,b.home_city_imb_adj,b.home_province_imb_adj,b.other_imb_adj,b.fund_imb_adj
from no&event._1 a left join broker.T_0401D_4 b
on a.event_date>b.date and a.event_date-120<=b.date and a.stock_code_1=b.F3_T0401D;
quit;

proc sql;
create table no&event._2_1 as select distinct a.*,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
from no&event._2_1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.date=b.date;
quit;

proc sort;
by stock_code_1 event_date  descending date;
run;

data no&event._2_1;
set no&event._2_1;
by stock_code_1 event_date descending date;
if first.event_date then time_trade=0;
time_trade+(-1);
run;

data no&event._4;
set no&event._2 no&event._2_1;
if event_date^=.;
run;

proc sort data=no&event._4 out=no&event._4;
by stock_code_1 event_date time_trade;
run;

proc sql;
create table no&event._5 as select distinct a.* from no&event._4 a,no&event._4 b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.time_trade=-1*&pre.;
quit;

data no&event._5;
set no&event._5;
if time_trade>=-1*&pre.;
if time_trade<=&after.;
run;

proc sql;
create table no&event._6_1 as select distinct a.stock_code_1,a.event_date,sum(a.abret_index) as indexa&after.,sum(a.abret_month) as montha&after.
from no&event._5 a
where a.time_trade>=0
group by a.stock_code_1,a.event_date;
quit;

proc sql;
create table no&event._6_2 as select distinct b.stock_code_1,b.event_date,
sum(b.abret_index) as indexb10,sum(b.abret_month) as monthb10,std(b.return_raw) as stdb10
,sum(b.all_imb_adj) as all_imbb10
,sum(b.beijing_imb_adj) as beijing_imbb10
,sum(b.shanghai_imb_adj) as shanghai_imbb10
,sum(b.other_imb_adj) as other_imbb10
,sum(b.home_city_imb_adj) as home_city_imbb10
,sum(b.home_province_imb_adj) as home_province_imbb10
,sum(b.fund_imb_adj) as fund_imbb10
from no&event._5 b
where b.time_trade<0
group by b.stock_code_1,b.event_date;
quit;

data no&event._6;
merge no&event._6_1 no&event._6_2;
by stock_code_1 event_date;
run;

data no&event._6;
set no&event._6;
week=week(event_date)+100*(year(event_date)-2007);
month=month(event_date)+100*(year(event_date)-2007);
run;

proc sort data=no&event._6;
by event_date;
run;

data &event._liquidity;
length type $40.;
type='';
run;

%macro ret(r);
%macro reg(inv);
proc reg data=no&event._6 outest=temp4 tableout;
by event_date;
model &r.a&after.=&inv._imbb10 &r.b10;
run;
quit;

data temp4;
set temp4;
type="&inv._&r.";
if _type_='PARMS';
rename &inv._imbb10=co_imbb10 &r.b10=co_abretb10;
keep type event_date intercept &inv._imbb10 &r.b10;
run;

proc reg data=no&event._6 outest=temp5 tableout;
by event_date;
model &r.a&after.=&inv._imbb10 &r.b10 stdb10;
run;
quit;

data temp5;
set temp5;
type="&inv._&r._stdb10";
if _type_='PARMS';
rename &inv._imbb10=co_imbb10 &r.b10=co_abretb10 stdb10=co_stdb10;
keep type event_date intercept &inv._imbb10 &r.b10 stdb10;
run;

data no&event._6;
set no&event._6;
interaction=stdb10*&inv._imbb10;
run;

proc reg data=no&event._6 outest=temp6 tableout;
by event_date;
model &r.a&after.=&inv._imbb10 &r.b10 stdb10 interaction;
run;
quit;

data temp6;
set temp6;
type="&inv._&r._interaction";
if _type_='PARMS';
rename &inv._imbb10=co_imbb10 &r.b10=co_abretb10 stdb10=co_stdb10 interaction=co_interaction;
keep type event_date intercept &inv._imbb10 &r.b10 stdb10 interaction;
run;

data &event._liquidity;
set &event._liquidity temp4 temp5 temp6;
run;
%mend reg;

%reg(all);
%reg(home_province);
%reg(home_city);
%reg(shanghai);
%reg(beijing);
%reg(other);
%reg(fund);
%mend ret;

%ret(index);
%ret(month);

data liquidity_&pre._1;
set &event._liquidity;
if type^='';
run;

proc sql;
create table aaa as select distinct event_date,count(distinct stock_code_1) as count from no&event._6
group by event_date;
quit;

proc sort;
by descending count;
run;

proc sql;
create table liquidity_&pre. as select distinct * from liquidity_&pre._1
where event_date in (select event_date from aaa where count>=150);
quit;





