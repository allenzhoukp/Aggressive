proc sql;
create table earning_60d_imb as select distinct a.* from broker.earning_60d_imb a,broker.earning_event_match b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
proc sql;
create table restructure_60d_imb as select distinct a.* from broker.restructure_60d_imb a,broker.restructure_event_match b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
data infraction_60d_imb;
set broker.infraction_60d_imb;
run;
data lawsuit_60d_imb;
set broker.lawsuit_60d_imb;
run;

proc sql;
create table BS_ratio as select distinct 
sum(sign(home_city_imb))/sum(abs(sign(home_city_imb))) as home_city_nor
,sum(sign(home_province_imb))/sum(abs(sign(home_province_imb))) as home_province_nor
,sum(sign(fund_imb))/sum(abs(sign(fund_imb))) as fund_nor
,sum(sign(shanghai_imb))/sum(abs(sign(shanghai_imb))) as shanghai_nor
,sum(sign(beijing_imb))/sum(abs(sign(beijing_imb))) as beijing_nor
,sum(sign(other_imb))/sum(abs(sign(other_imb))) as other_nor
from broker.imb2;
quit;

%macro VR(event);
%macro loop(k);
%let begin=&k;
%let sign=-1;
data VR_1;
set &event._60d_imb;
if time_trade>=&begin*(-1) and time_trade<=1 and CAR0_1>0;
run;

proc sql;
create table head_other as select distinct F3_T0401D from broker.T_0401D_3
where head_type='other';
quit;

proc sql;
create table VR_1 as select distinct * from VR_1
where stock_code_1 in (select F3_T0401D from head_other);
quit;

proc sql;
create table VR_2 as select distinct stock_code_1,event_date,time_trade, F6_T0401D,abret_index from VR_1;
quit;

proc sort;
by stock_code_1 event_date descending time_trade;
run;

data VR_2;
set VR_2;
by stock_code_1 event_date descending time_trade;
if first.event_date then do;
CRR=0; 
CAR=0;
end;
CRR+F6_T0401D;
CAR+abret_index;
run;

proc sql;
create table VR_3 as select distinct a.*,b.CRR,b.CAR from VR_1 a left join VR_2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade=b.time_trade-1;
quit;

proc sql;
create table VR_4 as select distinct stock_code_1,event_date,
sum(home_city_imb*CAR0_1)/sum(abs(home_city_imb)) as home_city_CAR0_1,sum(home_city_imb*CAR)/sum(abs(home_city_imb)) as home_city_CAR,
sum(fund_imb*CAR0_1)/sum(abs(fund_imb)) as fund_CAR0_1,sum(fund_imb*CAR)/sum(abs(fund_imb)) as fund_CAR,
sum(shanghai_imb*CAR0_1)/sum(abs(shanghai_imb)) as shanghai_CAR0_1,sum(shanghai_imb*CAR)/sum(abs(shanghai_imb)) as shanghai_CAR,
sum(beijing_imb*CAR0_1)/sum(abs(beijing_imb)) as beijing_CAR0_1,sum(beijing_imb*CAR)/sum(abs(beijing_imb)) as beijing_CAR,
sum(other_imb*CAR0_1)/sum(abs(other_imb)) as other_CAR0_1,sum(other_imb*CAR)/sum(abs(other_imb)) as other_CAR,
sum(home_province_imb*CAR0_1)/sum(abs(home_province_imb)) as home_province_CAR0_1,sum(home_province_imb*CAR)/sum(abs(home_province_imb)) as home_province_CAR
from VR_3
where time_trade<0
group by stock_code_1,event_date;
quit;

proc sql;
create table VR_4_n as select distinct stock_code_1,event_date,CAR0_1,
sum(sign(home_city_imb)*CAR0_1)/sum(sign(abs(home_city_imb))) as home_city_n_CAR0_1,
sum(sign(fund_imb)*CAR0_1)/sum(sign(abs(fund_imb))) as fund_n_CAR0_1,
sum(sign(shanghai_imb)*CAR0_1)/sum(sign(abs(shanghai_imb))) as shanghai_n_CAR0_1,
sum(sign(beijing_imb)*CAR0_1)/sum(sign(abs(beijing_imb))) as beijing_n_CAR0_1,
sum(sign(other_imb)*CAR0_1)/sum(sign(abs(other_imb))) as other_n_CAR0_1,
sum(sign(home_province_imb)*CAR0_1)/sum(sign(abs(home_province_imb))) as home_province_n_CAR0_1
from VR_3
where time_trade<0
group by stock_code_1,event_date;
quit;
/*
proc sql;
create table VR_4_n as select distinct a.stock_code_1,a.event_date
,a.home_city_n_CAR0_1-a.CAR0_1*b.home_city_nor as home_city_n_CAR0_1
,a.home_province_n_CAR0_1-a.CAR0_1*b.home_province_nor as home_province_n_CAR0_1
,a.fund_n_CAR0_1-a.CAR0_1*b.fund_nor as fund_n_CAR0_1
,a.shanghai_n_CAR0_1-a.CAR0_1*b.shanghai_nor as shanghai_n_CAR0_1
,a.beijing_n_CAR0_1-a.CAR0_1*b.beijing_nor as beijing_n_CAR0_1
,a.other_n_CAR0_1-a.CAR0_1*b.other_nor as other_n_CAR0_1
from VR_4_n a,BS_ratio b;
quit;
*/
proc sql;
create table VR_4_fre as select distinct stock_code_1,event_date,
sum(sign(home_city_imb)*sign(CAR0_1))/sum(sign(abs(home_city_imb))*sign(abs(CAR0_1))) as home_city_fre,
sum(sign(fund_imb)*sign(CAR0_1))/sum(sign(abs(fund_imb))*sign(abs(CAR0_1))) as fund_fre,
sum(sign(shanghai_imb)*sign(CAR0_1))/sum(sign(abs(shanghai_imb))*sign(abs(CAR0_1))) as shanghai_fre,
sum(sign(beijing_imb)*sign(CAR0_1))/sum(sign(abs(beijing_imb))*sign(abs(CAR0_1))) as beijing_fre,
sum(sign(other_imb)*sign(CAR0_1))/sum(sign(abs(other_imb))*sign(abs(CAR0_1))) as other_fre,
sum(sign(home_province_imb)*sign(CAR0_1))/sum(sign(abs(home_province_imb))*sign(abs(CAR0_1))) as home_province_fre
from VR_3
where time_trade<0
group by stock_code_1,event_date;
quit;

proc sql;
create table VR_4_vol as select distinct stock_code_1,event_date,
sum(home_city_imb*sign(CAR0_1))/sum(abs(home_city_imb)*sign(abs(CAR0_1))) as home_city_vol,
sum(fund_imb*sign(CAR0_1))/sum(abs(fund_imb)*sign(abs(CAR0_1))) as fund_vol,
sum(shanghai_imb*sign(CAR0_1))/sum(abs(shanghai_imb)*sign(abs(CAR0_1))) as shanghai_vol,
sum(beijing_imb*sign(CAR0_1))/sum(abs(beijing_imb)*sign(abs(CAR0_1))) as beijing_vol,
sum(other_imb*sign(CAR0_1))/sum(abs(other_imb)*sign(abs(CAR0_1))) as other_vol,
sum(home_province_imb*sign(CAR0_1))/sum(abs(home_province_imb)*sign(abs(CAR0_1))) as home_province_vol
from VR_3
where time_trade<0
group by stock_code_1,event_date;
quit;

data VR_4;
merge VR_4 VR_4_n VR_4_fre VR_4_vol;
by stock_code_1 event_date;
run;

data VR_5;
set VR_4;
if other_CAR=. then other_CAR=0;
if home_city_CAR=. then home_city_CAR=0;
if home_province_CAR=. then home_province_CAR=0;
if fund_CAR=. then fund_CAR=0;
if shanghai_CAR=. then shanghai_CAR=0;
if beijing_CAR=. then beijing_CAR=0;
if home_city_CAR0_1=. then home_city_CAR0_1=0;
if home_province_CAR0_1=. then home_province_CAR0_1=0;
if fund_CAR0_1=. then fund_CAR0_1=0;
if shanghai_CAR0_1=. then shanghai_CAR0_1=0;
if beijing_CAR0_1=. then beijing_CAR0_1=0;
if other_CAR0_1=. then other_CAR0_1=0;
if other_n_CAR0_1=. then other_n_CAR0_1=0;
if home_city_n_CAR0_1=. then home_city_n_CAR0_1=0;
if home_province_n_CAR0_1=. then home_province_n_CAR0_1=0;
if fund_n_CAR0_1=. then fund_n_CAR0_1=0;
if shanghai_n_CAR0_1=. then shanghai_n_CAR0_1=0;
if beijing_n_CAR0_1=. then beijing_n_CAR0_1=0;
if other_fre=. then other_fre=0;
if home_city_fre=. then home_city_fre=0;
if home_province_fre=. then home_province_fre=0;
if fund_fre=. then fund_fre=0;
if shanghai_fre=. then shanghai_fre=0;
if beijing_fre=. then beijing_fre=0;
if other_vol=. then other_vol=0;
if home_city_vol=. then home_city_vol=0;
if home_province_vol=. then home_province_vol=0;
if fund_vol=. then fund_vol=0;
if shanghai_vol=. then shanghai_vol=0;
if beijing_vol=. then beijing_vol=0;
run;

data VR_6;
set VR_4;
if home_city_CAR=. then delete;
if home_province_CAR=. then delete;
if fund_CAR=. then delete;
run;

proc tabulate data=VR_5 out=VR_&event._CAR_full_&begin;
var home_city_car home_province_car fund_car beijing_car shanghai_car other_car ;
table (home_city_car home_province_car fund_car beijing_car shanghai_car other_car)*(mean median n t);
run;

proc tabulate data=VR_4 out=VR_&event._CAR_self_&begin;
var home_city_car home_province_car fund_car beijing_car shanghai_car other_car ;
table (home_city_car home_province_car fund_car beijing_car shanghai_car other_car)*(mean median n t);
run;

proc tabulate data=VR_5 out=VR_&event._CAR0_1_full_&begin;
var home_city_CAR0_1 home_province_CAR0_1 fund_CAR0_1 beijing_CAR0_1 shanghai_CAR0_1 other_CAR0_1 ;
table (home_city_CAR0_1 home_province_CAR0_1 fund_CAR0_1 beijing_CAR0_1 shanghai_CAR0_1 other_CAR0_1)*(mean median n t);
run;

proc tabulate data=VR_4 out=VR_&event._CAR0_1_self_&begin;
var home_city_CAR0_1 home_province_CAR0_1 fund_CAR0_1 beijing_CAR0_1 shanghai_CAR0_1 other_CAR0_1 ;
table (home_city_CAR0_1 home_province_CAR0_1 fund_CAR0_1 beijing_CAR0_1 shanghai_CAR0_1 other_CAR0_1)*(mean median n t);
run;

proc tabulate data=VR_5 out=VR_&event._n_CAR0_1_full_&begin;
var home_city_n_CAR0_1 home_province_n_CAR0_1 fund_n_CAR0_1 beijing_n_CAR0_1 shanghai_n_CAR0_1 other_n_CAR0_1 ;
table (home_city_n_CAR0_1 home_province_n_CAR0_1 fund_n_CAR0_1 beijing_n_CAR0_1 shanghai_n_CAR0_1 other_n_CAR0_1)*(mean median n t);
run;

proc tabulate data=VR_4 out=VR_&event._n_CAR0_1_self_&begin;
var home_city_n_CAR0_1 home_province_n_CAR0_1 fund_n_CAR0_1 beijing_n_CAR0_1 shanghai_n_CAR0_1 other_n_CAR0_1 ;
table (home_city_n_CAR0_1 home_province_n_CAR0_1 fund_n_CAR0_1 beijing_n_CAR0_1 shanghai_n_CAR0_1 other_n_CAR0_1)*(mean median n t);
run;

proc tabulate data=VR_5 out=VR_&event._fre_full_&begin;
var home_city_fre home_province_fre fund_fre beijing_fre shanghai_fre other_fre ;
table (home_city_fre home_province_fre fund_fre beijing_fre shanghai_fre other_fre)*(mean median n t);
run;

proc tabulate data=VR_4 out=VR_&event._fre_self_&begin;
var home_city_fre home_province_fre fund_fre beijing_fre shanghai_fre other_fre ;
table (home_city_fre home_province_fre fund_fre beijing_fre shanghai_fre other_fre)*(mean median n t);
run;

proc tabulate data=VR_5 out=VR_&event._vol_full_&begin;
var home_city_vol home_province_vol fund_vol beijing_vol shanghai_vol other_vol ;
table (home_city_vol home_province_vol fund_vol beijing_vol shanghai_vol other_vol)*(mean median n t);
run;

proc tabulate data=VR_4 out=VR_&event._vol_self_&begin;
var home_city_vol home_province_vol fund_vol beijing_vol shanghai_vol other_vol ;
table (home_city_vol home_province_vol fund_vol beijing_vol shanghai_vol other_vol)*(mean median n t);
run;

data home_province;
set VR_4;
rename home_province_CAR0_1=CAR0_1 home_province_CAR=CAR home_province_n_CAR0_1=n_CAR0_1 home_province_fre=fre home_province_vol=vol;
type=0;
keep type home_province_CAR0_1 home_province_CAR home_province_n_CAR0_1 home_province_fre home_province_vol;
run;

data fund;
set VR_4;
rename fund_CAR0_1=CAR0_1 fund_CAR=CAR fund_n_CAR0_1=n_CAR0_1 fund_fre=fre fund_vol=vol;
type=1;
keep type fund_CAR0_1 fund_CAR fund_n_CAR0_1 fund_fre fund_vol;
run;

data t_twosample;
set home_province fund;
run;

ods listing close;
ods output ttests=ttests;
proc ttest data =t_twosample;
class type;
var CAR CAR0_1 n_CAR0_1 fre vol;
run;
ods listing;

proc transpose data=ttests out=ttests let;
ID Variable;
run;

data t_&event._&begin;
set ttests;
if _n_=3;
run;

proc npar1way data =t_twosample noprint;
class type;
var CAR CAR0_1 n_CAR0_1 fre vol;
output out=wilcoxon wilcoxon;
run;

data wilcoxon;
set wilcoxon;
keep _VAR_ P2_wil;
run;

proc transpose data=wilcoxon out=wil_&event._&begin;
id _VAR_;
run;

%mend loop;
%loop(10);
%loop(20);
%loop(5);
%mend VR;

%VR(infraction);
%VR(earning);
%VR(restructure);
%VR(lawsuit);
