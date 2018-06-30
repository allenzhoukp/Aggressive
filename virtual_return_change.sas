%macro loop(k);
%let begin=&k;
%let sign=-1;
data virtual_1;
set restructure_60d_adj;
if time_trade>=&begin*(-1) and time_trade<=1 and CAR0_1>-100;
BS=7-2*F9_T0401D;
run;

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

proc sql;
create table virtual_4 as select distinct stock_code_1,event_date,F9_T0401D,
sum(home_city_adj20*BS*CRR)/(sum(abs(home_city_adj20))) as home_city_CRR,sum(home_city_adj20*BS*CAR)/(sum(abs(home_city_adj20))) as home_city_CAR,
sum(fund_adj20*BS*CRR)/(sum(abs(fund_adj20))) as fund_CRR,sum(fund_adj20*BS*CAR)/(sum(abs(fund_adj20))) as fund_CAR,
sum(shanghai_adj20*BS*CRR)/(sum(abs(shanghai_adj20))) as shanghai_CRR,sum(shanghai_adj20*BS*CAR)/(sum(abs(shanghai_adj20))) as shanghai_CAR,
sum(beijing_adj20*BS*CRR)/(sum(abs(beijing_adj20))) as beijing_CRR,sum(beijing_adj20*BS*CAR)/(sum(abs(beijing_adj20))) as beijing_CAR,
sum(other_adj20*BS*CRR)/(sum(abs(other_adj20))) as other_CRR,sum(other_adj20*BS*CAR)/(sum(abs(other_adj20))) as other_CAR,
sum(home_province_adj20*BS*CRR)/(sum(abs(home_province_adj20))) as home_province_CRR,sum(home_province_adj20*BS*CAR)/(sum(abs(home_province_adj20))) as home_province_CAR
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

proc tabulate data=virtual_5 out=virtual_restructure_CAR_full_&begin;
var home_city_car home_province_car fund_car beijing_car shanghai_car other_car ;
table (home_city_car home_province_car fund_car beijing_car shanghai_car other_car)*(mean t);
run;

proc tabulate data=virtual_6 out=virtual_restructure_CAR_part_&begin;
var home_city_car home_province_car fund_car beijing_car shanghai_car other_car ;
table (home_city_car home_province_car fund_car beijing_car shanghai_car other_car)*(mean t);
run;
%mend loop;

%loop(10);
%loop(20);
%loop(30);
