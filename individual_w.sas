%let event=all;
%let pre=-3;
%let post=-1;

proc sql;
create table &event._60d_imb_w as select distinct a.* from broker.&event._60d_imb_w a,broker.&event._nosuspension b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp1;
set &event._60d_imb_w;
if time_trade>=&pre and time_trade<=&post;
keep stock_code_1 event_date startdate enddate time_trade return_raw abret_month abret_index;
run;

proc sort;
by stock_code_1 event_date time_trade;
run;

data temp1;
set temp1;
by stock_code_1 event_date time_trade;
if first.event_date then do;
CRR=0;CAR_index=0;CAR_month=0;
end;
CRR+return_raw;CAR_index+abret_index;CAR_month+abret_month;
run;

proc sql;
create table temp1 as select distinct a.*,b.F5_T0401W as closeprc,F11_T0401W,F12_T0401W,F13_T0401W,F14_T0401W,7-input(F9_T0401W,6.)*2 as BS,F17_T0401W+F18_T0401W as netBS,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp1 a left join broker.T_0401w_1 b
on a.stock_code_1=b.F3_T0401W and a.startdate=b.startdate and a.enddate=b.enddate and b.F9_T0401W>'2';
quit;

proc sort;
by stock_code_1 F11_T0401W F12_T0401W F13_T0401W F14_T0401W startdate enddate event_date;
run;

data temp1;
set temp1;
by stock_code_1 F11_T0401W F12_T0401W F13_T0401W F14_T0401W startdate enddate event_date;
if first.startdate;
run;

proc sql;
create table temp2 as select distinct stock_code_1,event_date,F11_T0401W,F12_T0401W,F13_T0401W,F14_T0401W,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp1;
quit;

proc sql;
create table Event_appearance_w as select distinct stock_code_1,F11_T0401W,F12_T0401W,F13_T0401W,F14_T0401W,count(distinct event_date) as count,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp2
group by stock_code_1,F11_T0401W,F12_T0401W,F13_T0401W,F14_T0401W;
quit;
/*
proc sql;
create table event_appearance_w as select distinct a.*,b.count as count_1 from event_appearance_w a left join event_appearance b
on a.stock_code_1=b.stock_code_1 and a.F11_T0401w=b.F11_T0401D and a.F12_T0401w=b.F12_T0401D and a.F13_T0401w=b.F13_T0401D and a.F14_T0401w=b.F14_T0401D;
quit;
*/
proc sort;
by descending count;
run;

data Freq_appearance_w;
set Event_appearance_w;
if count>2;
if F11_T0401W^='';
run;

data Freq_appearance_w;
set Freq_appearance_w;
if branch_type='home_city' then home_city=1;else home_city=0;
if branch_type='home_city' or branch_type='same_province' then home_province=1;else home_province=0;
if branch_type='fund' then fund=1;else fund=0;
if branch_type='beijing' or (branch_type='home_city' and head_type='beijing')then beijing=1;else beijing=0;
if branch_type='shanghai' or (branch_type='home_city' and head_type='shanghai')then shanghai=1;else shanghai=0;
if branch_type='other' then other=1;else other=0;
run;

proc sql;
create table distribution as select distinct count as Frequency,count(count) as count,sum(count) as Sum from event_appearance_w
group by count;
quit;

proc sql;
create table T_0401W_1 as select distinct a.* from broker.T_0401w_1 a,Freq_appearance_w b
where a.F3_T0401W=b.stock_code_1 and a.F11_T0401W=b.F11_T0401W and a.F12_T0401W=b.F12_T0401W and a.F13_T0401W=b.F13_T0401W and a.F14_T0401W=b.F14_T0401W;
quit;

proc sql;
create table T_0401D_1 as select distinct a.* from broker.T_0401D_1 a,Freq_appearance_w b
where a.F3_T0401D=b.stock_code_1 and a.F11_T0401D=b.F11_T0401W and a.F12_T0401D=b.F12_T0401W and a.F13_T0401D=b.F13_T0401W and a.F14_T0401D=b.F14_T0401W;
quit;

proc sql;
create table T_0401W_3 as select distinct F3_T0401W,F4_T0401W,head_province,head_city,head_type,startdate,enddate,F5_T0401W,F6_T0401W,F7_T0401W,F8_T0401W,F9_T0401W from T_0401W_1
where F9_T0401W>'2';
quit;

proc sql;
create table T_0401W_3_1 as select distinct F3_T0401W,F4_T0401W,head_province,head_city,startdate,enddate,F5_T0401W,F6_T0401W,F7_T0401W,F8_T0401W,F9_T0401W,branch_type,sum(F17_T0401W+F18_T0401W) as netBS from T_0401W_1
group by F3_T0401W,startdate,enddate,F9_T0401W,branch_type;
quit;

proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as home_city from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate and a.F9_T0401W=b.F9_T0401W and branch_type='home_city';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as same_province from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate and a.F9_T0401W=b.F9_T0401W and branch_type='same_province';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as shanghai from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate and a.F9_T0401W=b.F9_T0401W and branch_type='shanghai';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as beijing from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate and a.F9_T0401W=b.F9_T0401W and branch_type='beijing';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as other from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate and a.F9_T0401W=b.F9_T0401W and branch_type='other';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as fund from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate and a.F9_T0401W=b.F9_T0401W and branch_type='fund';
quit;


data T_0401W_3;
set T_0401W_3;
if home_city=. then home_city=0;
if same_province=. then same_province=0;
if shanghai=. then shanghai=0;
if beijing=. then beijing=0;
if other=. then other=0;
if fund=. then fund=0;
home_province=home_city+same_province;
F9=input(F9_T0401W,6.);
drop F9_T0401W;
rename F9=F9_T0401W;
run;

data T_0401W_3;
set T_0401W_3;
if head_type='shanghai' then shanghai=home_province;
if head_type='beijing' then beijing=home_province;
run;

proc sort data=T_0401W_3 out=T_0401W_3;
by F3_T0401W F9_T0401W startdate;
run;

data imb1;
set T_0401W_3;
home_city=home_city*F8_T0401W;
home_province=home_province*F8_T0401W;
shanghai=shanghai*F8_T0401W;
beijing=beijing*F8_T0401W;
fund=fund*F8_T0401W;
other=other*F8_T0401W;
BS=7-2*F9_T0401W;
run;

proc sql;
create table imb2 as select distinct F3_T0401W,F4_T0401W,head_province,head_city,head_type,startdate,enddate,F5_T0401W,F6_T0401W,F7_T0401W,F8_T0401W,
sum(home_city*BS) as home_city_imb,sum(home_province*BS) as home_province_imb,sum(shanghai*BS) as shanghai_imb,sum(beijing*BS) as beijing_imb,sum(other*BS) as other_imb,sum(fund*BS) as fund_imb
from imb1
group by F3_T0401W,startdate,enddate;
quit;

proc sql;
create table imb3 as select distinct F3_T0401W,mean(F8_T0401W) as avg_vol from imb2
group by F3_T0401W;
quit;

data imb4;
merge imb2 imb3;
by F3_T0401W;
home_city_imb=home_city_imb/avg_vol;
home_province_imb=home_province_imb/avg_vol;
shanghai_imb=shanghai_imb/avg_vol;
beijing_imb=beijing_imb/avg_vol;
fund_imb=fund_imb/avg_vol;
other_imb=other_imb/avg_vol;
run;

proc sql;
create table imb5 as select distinct F3_T0401W,mean(home_city_imb) as home_city_avg,mean(home_province_imb) as home_province_avg,mean(shanghai_imb) as shanghai_avg,mean(beijing_imb) as beijing_avg,mean(other_imb) as other_avg,mean(fund_imb) as fund_avg,
std(home_city_imb) as home_city_std,std(home_province_imb) as home_province_std,std(shanghai_imb) as shanghai_std,std(beijing_imb) as beijing_std,std(other_imb) as other_std,std(fund_imb) as fund_std
from imb4
group by F3_T0401W;
quit;

proc sql;
create table imb6 as select distinct a.*
,a.home_city_imb-b.home_city_avg as home_city_imb_adj
,a.home_province_imb-b.home_province_avg as home_province_imb_adj
,a.shanghai_imb-b.shanghai_avg as shanghai_imb_adj
,a.beijing_imb-b.beijing_avg as beijing_imb_adj
,a.other_imb-b.other_avg as other_imb_adj
,a.fund_imb-b.fund_avg as fund_imb_adj
,(a.home_city_imb-b.home_city_avg)/b.home_city_std as home_city_imb_sdd
,(a.home_province_imb-b.home_province_avg)/b.home_province_std as home_province_imb_sdd
,(a.shanghai_imb-b.shanghai_avg)/b.shanghai_std as shanghai_imb_sdd
,(a.beijing_imb-b.beijing_avg)/b.beijing_std as beijing_imb_sdd
,(a.other_imb-b.other_avg)/b.other_std as other_imb_sdd
,(a.fund_imb-b.fund_avg)/b.fund_std as fund_imb_sdd
from imb4 a left join imb5 b
on a.F3_T0401W=b.F3_T0401W;
quit;

data imb6;
set imb6;
if home_city_imb_sdd=. then home_city_imb_sdd=0;
if home_province_imb_sdd=. then home_province_imb_sdd=0;
if shanghai_imb_sdd=. then shanghai_imb_sdd=0;
if beijing_imb_sdd=. then beijing_imb_sdd=0;
if other_imb_sdd=. then other_imb_sdd=0;
if fund_imb_sdd=. then fund_imb_sdd=0;
run;

data T_0401W_4;
set imb6;
run;

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
on a.stock_code_1=b.F3_T0401W and a.event_date+240>=b.enddate and a.event_date<=b.startdate;
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
from &event._4 a left join T_0401w_4 b
on a.time_trade<0 and a.startdate=b.startdate and a.enddate=b.enddate and a.stock_code_1=b.F3_T0401w;
quit;

data &event._60d_imb_w;
set &event._4;
run;

proc sort;
by stock_code_1 event_date time_trade;
run;

proc sql;
drop table &event._1,&event._2,&event._2_1,&event._4;
quit;
%mend eventimb;

%eventimb(bankloan);
%eventimb(earning);
%eventimb(restructure);
%eventimb(lawsuit);
%eventimb(all);







