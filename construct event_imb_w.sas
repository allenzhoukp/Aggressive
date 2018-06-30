%macro eventimb(event);
data &event._1;
set broker.&event._event;
keep stock_code_1 event_date;
run;

proc sql;
create table &event._2 as select distinct a.stock_code_1,a.event_date,b.date,b.volume_yuan,b.Marcap_osd,b.Marcap,b.return_raw,b.abret_month,b.abreturn_index as abret_index 
from &event._1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.event_date+240>=b.date and a.event_date<=b.date;
quit;

proc sort;
by stock_code_1 event_date date;
run;

data &event._2;
set &event._2;
by stock_code_1 event_date date;
if first.event_date then time_trade=-1;
time_trade+1;
run;

proc sql;
create table &event._2_1 as select distinct a.stock_code_1,a.event_date,b.startdate,b.enddate 
from &event._1 a left join broker.T_0401w_1 b
on a.stock_code_1=b.F3_T0401W and a.event_date-120<=b.startdate and a.event_date>b.enddate;
quit;


proc sql;
create table &event._2_1 as select distinct a.stock_code_1,a.event_date,a.startdate,a.enddate,sum(b.volume_yuan) as volume_yuan_w,mean(b.Marcap_osd) as Marcap_osd_w,mean(b.Marcap) as Marcap_w,sum(b.return_raw) as return_raw,sum(b.abret_month) as abret_month,sum(b.abreturn_index) as abret_index 
from &event._2_1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.enddate>=b.date and a.startdate<=b.date
group by a.stock_code_1,a.event_date,a.startdate,a.enddate;
quit;

proc sort;
by stock_code_1 event_date descending startdate enddate;
run;

data &event._2_1;
set &event._2_1;
by stock_code_1 event_date descending startdate enddate;
if first.event_date then time_trade=0;
time_trade+(-1);
run;

proc sql;
create table &event._2_2 as select distinct a.stock_code_1,a.event_date,b.startdate,b.enddate 
from &event._1 a left join broker.T_0401w_1 b
on a.stock_code_1=b.F3_T0401W and a.event_date+240>=b.enddate and a.event_date<b.enddate;
quit;


proc sql;
create table &event._2_2 as select distinct a.stock_code_1,a.event_date,a.startdate,a.enddate,sum(b.volume_yuan) as volume_yuan_w,mean(b.Marcap_osd) as Marcap_osd_w,mean(b.Marcap) as Marcap_w,sum(b.return_raw) as return_raw,sum(b.abret_month) as abret_month,sum(b.abreturn_index) as abret_index 
from &event._2_2 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.enddate>=b.date and a.startdate<=b.date
group by a.stock_code_1,a.event_date,a.startdate,a.enddate;
quit;

proc sort;
by stock_code_1 event_date startdate enddate;
run;

data &event._2_2;
set &event._2_2;
by stock_code_1 event_date startdate enddate;
if first.event_date then time_trade=-1;
time_trade+1;
run;

data &event._4;
set &event._2 &event._2_1 &event._2_2;
if event_date^=.;
run;


proc sql;
create table &event._4 as select distinct a.*,b.head_type,b.beijing_imb_adj,b.shanghai_imb_adj,b.home_city_imb_adj,b.home_province_imb_adj,b.other_imb_adj,b.fund_imb_adj
from &event._4 a left join broker.T_0401w_4 b
on a.time_trade<0 and a.startdate=b.startdate and a.enddate=b.enddate and a.stock_code_1=b.F3_T0401w;
quit;

data &event._60d_imb_w;
set &event._4;
run;

proc sort;
by stock_code_1 event_date time_trade;
run;

proc sql;
drop table &event._1,&event._2,&event._2_1,&event._2_2,&event._4;
quit;
%mend eventimb;

%eventimb(bankloan);
%eventimb(earning);
%eventimb(restructure);
%eventimb(lawsuit);
%eventimb(all);
