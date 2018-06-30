%macro loop(k);
%let begin=&k;
%let sign=-1;
data virtual_1;
set restructure_60d;
if time_trade>=&begin*(-1) and time_trade<=1 and CAR0_1>0 and event_type='S3008';
BS=7-2*F9_T0401D;
run;
/*
proc sql;
create table ABreturn_b5_a1d as select distinct stock_code_1,event_date,accounting_deadline_1,year_q,F6_T0401D,abret_index from broker.restructure_60d
where time_trade<2 and time_trade>=0 and F9_T0401D=4;
create table virtual_2 as select distinct stock_code_1,event_date,accounting_deadline_1,year_q,sum(F6_T0401D) as CRR,sum(abret_index) as CAR  from ABreturn_b5_a1d
group by stock_code_1,event_date;
create table virtual_3 as select distinct a.*,b.CRR,b.CAR from virtual_1 a left join virtual_2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
*/

proc sql;
create table virtual_2 as select distinct stock_code_1,event_date,time_trade, F6_T0401D,abret_index from virtual_1;
quit;

proc sort;
by stock_code_1 event_date descending time_trade;
run;

data virtual_2;
set virtual_2;
by stock_code_1 event_date descending time_trade;
if first.event_date then do;
CRR=0; 
CAR=0;
end;
CRR+F6_T0401D;
CAR+abret_index;
run;

proc sql;
create table virtual_3 as select distinct a.*,b.CRR,b.CAR from virtual_1 a left join virtual_2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade=b.time_trade-1;
quit;

/*
proc sql;
create table virtual_3 as select distinct a.*,b.CRR,b.CAR from virtual_1 a left join virtual_2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade=b.time_trade-1;
create table virtual_4 as select distinct stock_code_1,event_date,sum(home_city*volume_1*BS*CRR)/abs(sum(home_city*volume_1*BS)) as home_city_CRR,sum(home_city*volume_1*BS*CAR)/abs(sum(home_city*volume_1*BS)) as home_city_CAR,
sum(fund*volume_1*BS*CRR)/abs(sum(fund*volume_1*BS)) as fund_CRR,sum(fund*volume_1*BS*CAR)/abs(sum(fund*volume_1*BS)) as fund_CAR,
sum(shanghai*volume_1*BS*CRR)/abs(sum(shanghai*volume_1*BS)) as shanghai_CRR,sum(shanghai*volume_1*BS*CAR)/abs(sum(shanghai*volume_1*BS)) as shanghai_CAR,
sum(shenzhen*volume_1*BS*CRR)/abs(sum(shenzhen*volume_1*BS)) as shenzhen_CRR,sum(shenzhen*volume_1*BS*CAR)/abs(sum(shenzhen*volume_1*BS)) as shenzhen_CAR,
sum(beijing*volume_1*BS*CRR)/abs(sum(beijing*volume_1*BS)) as beijing_CRR,sum(beijing*volume_1*BS*CAR)/abs(sum(beijing*volume_1*BS)) as beijing_CAR,
sum(same_province*volume_1*BS*CRR)/abs(sum(same_province*volume_1*BS)) as same_province_CRR,sum(same_province*volume_1*BS*CAR)/abs(sum(same_province*volume_1*BS)) as same_province_CAR,
sum(other*volume_1*BS*CRR)/abs(sum(other*volume_1*BS)) as other_CRR,sum(other*volume_1*BS*CAR)/abs(sum(other*volume_1*BS)) as other_CAR,
sum(home_province*volume_1*BS*CRR)/abs(sum(home_province*volume_1*BS)) as home_province_CRR,sum(home_province*volume_1*BS*CAR)/abs(sum(home_province*volume_1*BS)) as home_province_CAR
from virtual_3
where BS=-1
group by stock_code_1,event_date;
quit;
*/
proc sql;
create table virtual_4 as select distinct stock_code_1,event_date,F9_T0401D,
sum(home_city*volume_1*BS*CRR)/(sum(home_city*volume_1)) as home_city_CRR,sum(home_city*volume_1*BS*CAR)/(sum(home_city*volume_1)) as home_city_CAR,
sum(fund*volume_1*BS*CRR)/(sum(fund*volume_1)) as fund_CRR,sum(fund*volume_1*BS*CAR)/(sum(fund*volume_1)) as fund_CAR,
sum(shanghai*volume_1*BS*CRR)/(sum(shanghai*volume_1)) as shanghai_CRR,sum(shanghai*volume_1*BS*CAR)/(sum(shanghai*volume_1)) as shanghai_CAR,
sum(beijing*volume_1*BS*CRR)/(sum(beijing*volume_1)) as beijing_CRR,sum(beijing*volume_1*BS*CAR)/(sum(beijing*volume_1)) as beijing_CAR,
sum(other*volume_1*BS*CRR)/(sum(other*volume_1)) as other_CRR,sum(other*volume_1*BS*CAR)/(sum(other*volume_1)) as other_CAR,
sum(home_province*volume_1*BS*CRR)/(sum(home_province*volume_1)) as home_province_CRR,sum(home_province*volume_1*BS*CAR)/(sum(home_province*volume_1)) as home_province_CAR
from virtual_3

group by stock_code_1,event_date;
quit;

data virtual_5;
set virtual_4;
if home_city_CRR=. then home_city_CRR=0;
if home_city_CAR=. then home_city_CAR=0;
if home_province_CRR=. then home_province_CRR=0;
if home_province_CAR=. then home_province_CAR=0;
if fund_CRR=. then fund_CRR=0;
if fund_CAR=. then fund_CAR=0;
if shanghai_CRR=. then shanghai_CRR=0;
if shanghai_CAR=. then shanghai_CAR=0;
if beijing_CRR=. then beijing_CRR=0;
if beijing_CAR=. then beijing_CAR=0;
if other_CRR=. then other_CRR=0;
if other_CAR=. then other_CAR=0;
run;

data virtual_6;
set virtual_4;
if home_city_CAR=. then delete;
if home_province_CAR=. then delete;
if fund_CAR=. then delete;
run;

proc tabulate data=virtual_5 out=virtual_S3008_CAR_full_&begin;
var home_city_car home_province_car fund_car beijing_car shanghai_car other_car ;
table (home_city_car home_province_car fund_car beijing_car shanghai_car other_car)*(mean t);
run;

proc tabulate data=virtual_6 out=virtual_S3008_CAR_part_&begin;
var home_city_car home_province_car fund_car beijing_car shanghai_car other_car ;
table (home_city_car home_province_car fund_car beijing_car shanghai_car other_car)*(mean t);
run;
/*
proc tabulate data=virtual_5 out=virtual_restructure_CRR_&begin;
var home_city_CRR home_province_CRR fund_CRR beijing_CRR shanghai_CRR other_CRR ;
table (home_city_CRR home_province_CRR fund_CRR beijing_CRR shanghai_CRR other_CRR)*(mean t);
run;

ods listing close;
ods output ttests=virtual_return;
proc ttest data=virtual_5;
var home_city_crr home_city_car fund_crr fund_car home_province_crr home_province_car other_crr other_car shanghai_crr shanghai_car beijing_crr beijing_car ;
run;
ods listing;

ods listing close;
ods output ttests=virtual_restructure_ttest_&begin;
proc ttest data=virtual_5;
paired (home_city_car home_province_car fund_car)*(home_province_car fund_car beijing_car shanghai_car other_car);
run;
ods listing;
*/
%mend loop;

%loop(10);
%loop(20);
%loop(30);
