%macro eventimb(event);
data &event._1;
set &event._event;
keep stock_code_1 event_date;
run;

proc sql;
create table &event._2 as select distinct a.stock_code_1,a.event_date,b.date,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
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
create table &event._2_1 as select distinct a.stock_code_1,a.event_date,b.date,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
from &event._1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.event_date>b.date and a.event_date-60<=b.date;
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
create table &event._4 as select distinct a.*,b.head_type,b.date,b.all_imb_adj,b.beijing_imb_adj,b.shanghai_imb_adj,b.home_city_imb_adj,b.home_province_imb_adj,b.other_imb_adj,b.fund_imb_adj
from &event._4 a left join broker.T_0401D_4 b
on a.date=b.date and a.stock_code_1=b.F3_T0401D;
quit;

proc sort data=&event._4 out=&event._4;
by stock_code_1 event_date time_trade;
run;

/* 
data &event._4_1;
set &event._4;
by stock_code_1 event_date  date;
if first.event_date then No_1=0;
No_1+1;
run;

proc sql;
create table day0 as select distinct stock_code_1,event_date,No_1 as No_2 from &event._4_1
where time=0;
quit;

data &event._4_2;
merge &event._4_1 day0;
by stock_code_1 event_date ;
run;

data &event._4_2;
set &event._4_2;
time_trade=No_1-No_2;
run;


data &event._4_3;
set &event._4_2;
drop No_1 No_2;
run;
*/

data &event._60d_imb;
set &event._4;
run;

proc sort;
by stock_code_1 event_date time_trade;
run;

proc sql;
drop table &event._1,&event._2,&event._2_1,&event._4;
quit;

%mend eventimb;

%eventimb(rating);

