data rating_event;
set broker.rating_event_full;
if substr(content,1,2)='上' or substr(content,1,2)='下' then do;
rating1=substr(content,1,4);
rating2=substr(content,12,4);
securitycorp=substr(content,17,8);
end;
else do;
rating2=substr(content,8,4);
securitycorp=substr(content,13,8);
end;
run;

proc sort data=rating_event;
by stock_code_1 securitycorp event_date;
run;

data rating_event;
set rating_event;
if rating2='卖出' then grade=1;
if rating2='减持' then grade=2;
if rating2='中性' then grade=3;
if rating2='增持' then grade=4;
if rating2='买入' then grade=5;
run;

data rating_event;
set rating_event;
lagrating2=lag(rating2);
lagsecuritycorp=lag(securitycorp);
laggrade=lag(grade);
run;

data rating_event;
set rating_event;
if lagrating2=rating2 and lagsecuritycorp=securitycorp  then delete;
if rating2='减持' or rating2='卖出';
drop lagrating2 lagsecuritycorp
run;

proc sort data=rating_event out=broker.rating_event;
by stock_code_1 event_date;
run;

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

proc sql;
create table temp1 as select distinct a.*,b.date,b.F8_T0401D,b.F14_T0401D,7-2*input(b.F9_T0401D,6.) as BS,b.F17_T0401D+F18_T0401D as netBS
from broker.rating_event a left join broker.T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and b.F9_T0401D>'2';
quit;

data temp1;
set temp1;
if substr(F14_T0401D,1,8)=securitycorp then securitycorp_type=1;
else securitycorp_type=0;
run;

proc sql;
create table temp2 as select distinct stock_code_1,event_date,date,F8_T0401D,F14_T0401D,BS,netBS,max(securitycorp_type) as securitycorp_type from temp1
group by stock_code_1,event_date,date,F14_T0401D;
quit;

proc sql;
create table temp3 as select distinct stock_code_1,event_date,date,F8_T0401D from temp2;
quit;

proc sql;
create table temp3 as select distinct a.*,sum(b.netBS*b.BS) as securitycorp from temp3 a left join temp2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.securitycorp_type=1
group by b.stock_code_1,b.event_date,b.date;
quit;

data temp3;
set temp3;
if securitycorp=. then securitycorp=0;
run;

proc sql;
create table temp4 as select distinct stock_code_1,event_date,mean(F8_T0401D) as avg_vol from temp3
group by stock_code_1,event_date;
quit;

data temp3;
merge temp3 temp4;
by stock_code_1;
securitycorp=securitycorp/avg_vol;
if event_date^=.;
run;

proc sql;
create table temp5 as select distinct stock_code_1,event_date,mean(securitycorp) as securitycorp_avg from temp3
group by stock_code_1,event_date;
quit;

proc sql;
create table temp3 as select distinct a.*,a.securitycorp-b.securitycorp_avg as securitycorp_imb_adj
from temp3 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table rating_60d_imb as select distinct a.*,b.securitycorp_imb_adj from rating_60d_imb a left join temp3 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date;
quit;

