data imb1;
set broker.T_0401D_3;
all1=all*F8_T0401D;
home_city=home_city*F8_T0401D;
home_province=home_province*F8_T0401D;
shanghai=shanghai*F8_T0401D;
beijing=beijing*F8_T0401D;
fund=fund*F8_T0401D;
other=other*F8_T0401D;
BS=7-2*F9_T0401D;
run;

proc sql;
create table imb2 as select distinct F3_T0401D,F4_T0401D,head_province,head_city,head_type,date,F5_T0401D,F6_T0401D,F7_T0401D,F8_T0401D,
sum(all1*BS) as all_imb,sum(home_city*BS) as home_city_imb,sum(home_province*BS) as home_province_imb,sum(shanghai*BS) as shanghai_imb,sum(beijing*BS) as beijing_imb,sum(other*BS) as other_imb,sum(fund*BS) as fund_imb
from imb1
group by F3_T0401D,date;
quit;

proc sql;
create table imb3 as select distinct F3_T0401D,mean(F8_T0401D) as avg_vol from imb2
group by F3_T0401D;
quit;

data imb4;
merge imb2 imb3;
by F3_T0401D;
all_imb=all_imb/avg_vol;
home_city_imb=home_city_imb/avg_vol;
home_province_imb=home_province_imb/avg_vol;
shanghai_imb=shanghai_imb/avg_vol;
beijing_imb=beijing_imb/avg_vol;
fund_imb=fund_imb/avg_vol;
other_imb=other_imb/avg_vol;
run;

proc sql;
create table imb5 as select distinct F3_T0401D,mean(all_imb) as all_avg,mean(home_city_imb) as home_city_avg,mean(home_province_imb) as home_province_avg,mean(shanghai_imb) as shanghai_avg,mean(beijing_imb) as beijing_avg,mean(other_imb) as other_avg,mean(fund_imb) as fund_avg,
std(all_imb) as all_std,std(home_city_imb) as home_city_std,std(home_province_imb) as home_province_std,std(shanghai_imb) as shanghai_std,std(beijing_imb) as beijing_std,std(other_imb) as other_std,std(fund_imb) as fund_std
from imb4
group by F3_T0401D;
quit;

proc sql;
create table imb6 as select distinct a.*
,a.all_imb-b.all_avg as all_imb_adj
,a.home_city_imb-b.home_city_avg as home_city_imb_adj
,a.home_province_imb-b.home_province_avg as home_province_imb_adj
,a.shanghai_imb-b.shanghai_avg as shanghai_imb_adj
,a.beijing_imb-b.beijing_avg as beijing_imb_adj
,a.other_imb-b.other_avg as other_imb_adj
,a.fund_imb-b.fund_avg as fund_imb_adj
,(a.all_imb-b.all_avg)/b.all_std as all_imb_sdd
,(a.home_city_imb-b.home_city_avg)/b.home_city_std as home_city_imb_sdd
,(a.home_province_imb-b.home_province_avg)/b.home_province_std as home_province_imb_sdd
,(a.shanghai_imb-b.shanghai_avg)/b.shanghai_std as shanghai_imb_sdd
,(a.beijing_imb-b.beijing_avg)/b.beijing_std as beijing_imb_sdd
,(a.other_imb-b.other_avg)/b.other_std as other_imb_sdd
,(a.fund_imb-b.fund_avg)/b.fund_std as fund_imb_sdd
from imb4 a left join imb5 b
on a.F3_T0401D=b.F3_T0401D;
quit;

data imb6;
set imb6;
if all_imb_sdd=. then all_imb_sdd=0;
if home_city_imb_sdd=. then home_city_imb_sdd=0;
if home_province_imb_sdd=. then home_province_imb_sdd=0;
if shanghai_imb_sdd=. then shanghai_imb_sdd=0;
if beijing_imb_sdd=. then beijing_imb_sdd=0;
if other_imb_sdd=. then other_imb_sdd=0;
if fund_imb_sdd=. then fund_imb_sdd=0;
run;

data T_0401D_4;
set imb6;
run;
