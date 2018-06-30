proc sql;
create table BS_ratio as select distinct F3_T0401D as stock_code_1,
sum(home_city*F8_T0401D*(7-2*F9_T0401D))/sum(home_city*F8_T0401D) as home_city_nor
,sum(home_province*F8_T0401D*(7-2*F9_T0401D))/sum(home_province*F8_T0401D) as home_province_nor
,sum(fund*F8_T0401D*(7-2*F9_T0401D))/sum(fund*F8_T0401D) as fund_nor
,sum(shanghai*F8_T0401D*(7-2*F9_T0401D))/sum(shanghai*F8_T0401D) as shanghai_nor
,sum(beijing*F8_T0401D*(7-2*F9_T0401D))/sum(beijing*F8_T0401D) as beijing_nor
,sum(other*F8_T0401D*(7-2*F9_T0401D))/sum(other*F8_T0401D) as other_nor
from broker.T_0401D_3
group by F3_T0401D;
quit;

proc sql;
create table BS_ratio_imb as select distinct F3_T0401D as stock_code_1,
sum(sign(home_city_imb))/sum(abs(sign(home_city_imb))) as home_city_nor
,sum(sign(home_province_imb))/sum(abs(sign(home_province_imb))) as home_province_nor
,sum(sign(fund_imb))/sum(abs(sign(fund_imb))) as fund_nor
,sum(sign(shanghai_imb))/sum(abs(sign(shanghai_imb))) as shanghai_nor
,sum(sign(beijing_imb))/sum(abs(sign(beijing_imb))) as beijing_nor
,sum(sign(other_imb))/sum(abs(sign(other_imb))) as other_nor
from broker.imb2
group by F3_T0401D;
quit;


proc sql;
create table earning_60d as select distinct a.* from broker.earning_60d a,broker.earning_event b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
proc sql;
create table restructure_60d as select distinct a.* from broker.restructure_60d a,broker.restructure_important b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
data infraction_60d;
set broker.infraction_60d;
run;
data lawsuit_60d;
set broker.lawsuit_60d;
run;

proc sql;
create table earning_60d_imb as select distinct a.* from broker.earning_60d_imb a,broker.earning_event b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
proc sql;
create table restructure_60d_imb as select distinct a.* from broker.restructure_60d_imb a,broker.restructure_important b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
data infraction_60d_imb;
set broker.infraction_60d_imb;
run;
data lawsuit_60d_imb;
set broker.lawsuit_60d_imb;
run;

%macro VR(event);
%macro loop(k);
%let begin=&k;
%let sign=-1;
data VR_1;
set &event._60d;
if time_trade>=&begin*(-1) and time_trade<=1 and CAR0_1<0;
BS=7-2*F9_T0401D;
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

data VRimb_1;
set &event._60d_imb;
if time_trade>=&begin*(-1) and time_trade<=1 and CAR0_1<0;
run;

proc sql;
create table head_other as select distinct F3_T0401D from broker.T_0401D_3
where head_type='other';
quit;

proc sql;
create table VRimb_1 as select distinct * from VRimb_1
where stock_code_1 in (select F3_T0401D from head_other);
quit;

proc sql;
create table VRimb_2 as select distinct stock_code_1,event_date,time_trade, F6_T0401D,abret_index from VRimb_1;
quit;

proc sort;
by stock_code_1 event_date descending time_trade;
run;

data VRimb_2;
set VRimb_2;
by stock_code_1 event_date descending time_trade;
if first.event_date then do;
CRR=0; 
CAR=0;
end;
CRR+F6_T0401D;
CAR+abret_index;
run;

proc sql;
create table VRimb_3 as select distinct a.*,b.CRR,b.CAR from VRimb_1 a left join VRimb_2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade=b.time_trade-1;
quit;

proc sql;
create table VR_4 as select distinct a.stock_code_1,a.event_date,
sum(a.home_city*a.volume_1*a.BS*a.CAR0_1)/(sum(a.home_city*a.volume_1))-b.home_city_nor*a.CAR0_1 as home_city_CAR0_1,sum(a.home_city*a.volume_1*a.BS*a.CAR)/(sum(a.home_city*a.volume_1))-b.home_city_nor*mean(a.CAR) as home_city_CAR,
sum(a.fund*a.volume_1*a.BS*a.CAR0_1)/(sum(a.fund*a.volume_1))-b.fund_nor*a.CAR0_1 as fund_CAR0_1,sum(a.fund*a.volume_1*a.BS*a.CAR)/(sum(a.fund*a.volume_1))-b.fund_nor*mean(a.CAR) as fund_CAR,
sum(a.shanghai*a.volume_1*a.BS*a.CAR0_1)/(sum(a.shanghai*a.volume_1))-b.shanghai_nor*a.CAR0_1 as shanghai_CAR0_1,sum(a.shanghai*a.volume_1*a.BS*a.CAR)/(sum(a.shanghai*a.volume_1))-b.shanghai_nor*mean(a.CAR) as shanghai_CAR,
sum(a.beijing*a.volume_1*a.BS*a.CAR0_1)/(sum(a.beijing*a.volume_1))-b.beijing_nor*a.CAR0_1 as beijing_CAR0_1,sum(a.beijing*a.volume_1*a.BS*a.CAR)/(sum(a.beijing*a.volume_1))-b.beijing_nor*mean(a.CAR) as beijing_CAR,
sum(a.other*a.volume_1*a.BS*a.CAR0_1)/(sum(a.other*a.volume_1))-b.other_nor*a.CAR0_1 as other_CAR0_1,sum(a.other*a.volume_1*a.BS*a.CAR)/(sum(a.other*a.volume_1))-b.other_nor*mean(a.CAR) as other_CAR,
sum(a.home_province*a.volume_1*a.BS*a.CAR0_1)/(sum(a.home_province*a.volume_1))-b.home_province_nor*a.CAR0_1 as home_province_CAR0_1,sum(a.home_province*a.volume_1*a.BS*a.CAR)/(sum(a.home_province*a.volume_1))-b.home_province_nor*mean(a.CAR) as home_province_CAR
from VR_3 a,BS_ratio b
where time_trade<0 and a.stock_code_1=b.stock_code_1
group by a.stock_code_1,a.event_date;
quit;
/*
proc sql;
create table VR_4 as select distinct stock_code_1,event_date,
sum(home_city*volume_1*BS*CAR0_1)/(sum(home_city*volume_1)) as home_city_CAR0_1,sum(home_city*volume_1*BS*CAR)/(sum(home_city*volume_1)) as home_city_CAR,
sum(fund*volume_1*BS*CAR0_1)/(sum(fund*volume_1)) as fund_CAR0_1,sum(fund*volume_1*BS*CAR)/(sum(fund*volume_1)) as fund_CAR,
sum(shanghai*volume_1*BS*CAR0_1)/(sum(shanghai*volume_1)) as shanghai_CAR0_1,sum(shanghai*volume_1*BS*CAR)/(sum(shanghai*volume_1)) as shanghai_CAR,
sum(beijing*volume_1*BS*CAR0_1)/(sum(beijing*volume_1)) as beijing_CAR0_1,sum(beijing*volume_1*BS*CAR)/(sum(beijing*volume_1)) as beijing_CAR,
sum(other*volume_1*BS*CAR0_1)/(sum(other*volume_1)) as other_CAR0_1,sum(other*volume_1*BS*CAR)/(sum(other*volume_1)) as other_CAR,
sum(home_province*volume_1*BS*CAR0_1)/(sum(home_province*volume_1)) as home_province_CAR0_1,sum(home_province*volume_1*BS*CAR)/(sum(home_province*volume_1)) as home_province_CAR
from VR_3;
where time_trade<0
group by stock_code_1,event_date;
quit;
*/
proc sql;
create table VR_4_vol as select distinct a.stock_code_1,a.event_date
,sum(a.home_city*a.volume_1*a.BS*sign(a.CAR0_1))/(sum(a.home_city*a.volume_1))-b.home_city_nor*sign(a.CAR0_1) as home_city_VOL
,sum(a.fund*a.volume_1*a.BS*sign(a.CAR0_1))/(sum(a.fund*a.volume_1))-b.fund_nor*sign(a.CAR0_1) as fund_VOL
,sum(a.shanghai*a.volume_1*a.BS*sign(a.CAR0_1))/(sum(a.shanghai*a.volume_1))-b.shanghai_nor*sign(a.CAR0_1) as shanghai_VOL
,sum(a.beijing*a.volume_1*a.BS*sign(a.CAR0_1))/(sum(a.beijing*a.volume_1))-b.beijing_nor*sign(a.CAR0_1) as beijing_VOL
,sum(a.other*a.volume_1*a.BS*sign(a.CAR0_1))/(sum(a.other*a.volume_1))-b.other_nor*sign(a.CAR0_1) as other_VOL
,sum(a.home_province*a.volume_1*a.BS*sign(a.CAR0_1))/(sum(a.home_province*a.volume_1))-b.home_province_nor*sign(a.CAR0_1) as home_province_VOL
from VR_3 a,BS_ratio b
where time_trade<0 and a.stock_code_1=b.stock_code_1
group by a.stock_code_1,a.event_date;
quit;

proc sql;
create table VR_4_fre as select distinct a.stock_code_1,a.event_date
,sum(sign(a.home_city_imb)*sign(a.CAR0_1))/sum(sign(abs(home_city_imb)))-b.home_city_nor*sign(a.CAR0_1) as home_city_fre
,sum(sign(a.fund_imb)*sign(a.CAR0_1))/sum(sign(abs(fund_imb)))-b.fund_nor*sign(a.CAR0_1) as fund_fre
,sum(sign(a.shanghai_imb)*sign(a.CAR0_1))/sum(sign(abs(shanghai_imb)))-b.shanghai_nor*sign(a.CAR0_1) as shanghai_fre
,sum(sign(a.beijing_imb)*sign(a.CAR0_1))/sum(sign(abs(beijing_imb)))-b.beijing_nor*sign(a.CAR0_1) as beijing_fre
,sum(sign(a.other_imb)*sign(a.CAR0_1))/sum(sign(abs(other_imb)))-b.other_nor*sign(a.CAR0_1) as other_fre
,sum(sign(a.home_province_imb)*sign(a.CAR0_1))/sum(sign(abs(home_province_imb)))-b.home_province_nor*sign(a.CAR0_1) as home_province_fre
from VRimb_3 a,BS_ratio_imb b
where time_trade<0 and a.stock_code_1=b.stock_code_1
group by a.stock_code_1,a.event_date;
quit;

proc sql;
create table VR_4_n as select distinct a.stock_code_1,a.event_date
,sum(sign(a.home_city_imb)*a.CAR0_1)/sum(sign(abs(home_city_imb)))-b.home_city_nor*a.CAR0_1 as home_city_n_CAR0_1
,sum(sign(a.fund_imb)*a.CAR0_1)/sum(sign(abs(fund_imb)))-b.fund_nor*a.CAR0_1 as fund_n_CAR0_1
,sum(sign(a.shanghai_imb)*a.CAR0_1)/sum(sign(abs(shanghai_imb)))-b.shanghai_nor*a.CAR0_1 as shanghai_n_CAR0_1
,sum(sign(a.beijing_imb)*a.CAR0_1)/sum(sign(abs(beijing_imb)))-b.beijing_nor*a.CAR0_1 as beijing_n_CAR0_1
,sum(sign(a.other_imb)*a.CAR0_1)/sum(sign(abs(other_imb)))-b.other_nor*a.CAR0_1 as other_n_CAR0_1
,sum(sign(a.home_province_imb)*a.CAR0_1)/sum(sign(abs(home_province_imb)))-b.home_province_nor*a.CAR0_1 as home_province_n_CAR0_1
from VRimb_3 a,BS_ratio_imb b
where time_trade<0 and a.stock_code_1=b.stock_code_1
group by a.stock_code_1,a.event_date;
quit;

data VR_4;
merge VR_4 VR_4_n VR_4_fre VR_4_vol;
by stock_code_1 event_date;
run;

data VR_5;
set VR_4;
if home_city_CAR0_1=. then home_city_CAR0_1=0;
if home_city_CAR=. then home_city_CAR=0;
if home_province_CAR0_1=. then home_province_CAR0_1=0;
if home_province_CAR=. then home_province_CAR=0;
if fund_CAR0_1=. then fund_CAR0_1=0;
if fund_CAR=. then fund_CAR=0;
if shanghai_CAR0_1=. then shanghai_CAR0_1=0;
if shanghai_CAR=. then shanghai_CAR=0;
if beijing_CAR0_1=. then beijing_CAR0_1=0;
if beijing_CAR=. then beijing_CAR=0;
if other_CAR0_1=. then other_CAR0_1=0;
if other_CAR=. then other_CAR=0;
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

/*
ods listing close;
ods output ttests=ttests;
proc ttest data =VR_5;
paired home_province_car fund_car;
run;
ods listing;

proc transpose data=ttests out=ttests let;
ID Variable;
run;

data tpair_&event._&begin;
set ttests;
if _n_=3;
run;
*/
%mend loop;
%loop(10);
%loop(20);
%loop(5);
%mend VR;

%VR(restructure);
%VR(earning);
%VR(infraction);
%VR(lawsuit);
