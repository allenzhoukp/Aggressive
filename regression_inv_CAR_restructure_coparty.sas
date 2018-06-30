%let start=0;
%let end=1;
%let event=restructure;
%let pre=-10;

proc sql;
create table &event._60d_imb as select distinct a.* from broker.all_eerbl_60d_imb_restructure a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.&event.=1;
quit;


proc sql;
create table imb_b10 as select distinct stock_code_1,event_date
,sum(coparty_city_imb_adj) as coparty_city_imbb10
,sum(coparty_outprovince_imb_adj) as coparty_outprovince_imbb10
,sum(home_city_imb_adj) as homecity_imbb10
,sum(outall_imb_adj) as outall_imbb10
,mean(volume_yuan) as vol_b10
from &event._60d_imb
where time_trade<&start and time_trade>=&start+&pre
group by stock_code_1,event_date;
quit;

proc sql;
create table avg_vol as select distinct F3_T0401D as stock_code_1,mean(F8_T0401D) as avg_vol from broker.imb2
group by stock_code_1;
quit;

data imb_b10;
merge imb_b10 avg_vol;
by stock_code_1;
run;

data imb_b10;
set imb_b10;
abvol_b10=vol_b10/avg_vol-1;
run;

%macro abRet(r);

data regression_inv_&event._&r;
length event $20.;
length investor $30.;
event='';
investor='';
run;

proc sql;
create table CAR_before as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.before 
from &event._60d_imb
where time_trade>=&start+&pre and time_trade<&start
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after1 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win1 
from &event._60d_imb
where time_trade>=&start and time_trade<=&end
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after2 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win2
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+5
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after3 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win3
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+10
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after4 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win4
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+20
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after5 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win5 
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+60
group by stock_code_1,event_date;
quit;

proc sql;
create table CAR_after6 as select distinct stock_code_1,event_date,sum(abret_&r.) as &r.win6 
from &event._60d_imb
where time_trade>=&start and time_trade<=&end+60
group by stock_code_1,event_date;
quit;

data imb_CAR;
merge imb_b10 CAR_before CAR_after1 CAR_after2 CAR_after3 CAR_after4 CAR_after5 CAR_after6;
by stock_code_1 event_date;
run;

%macro sort(inv);

proc sql;
create table imb_CAR1 as select * from imb_CAR
where &inv._imbb10^=. and &inv._imbb10^=0;
quit;

data imb_car1;
set imb_car1;
cluster1=week(event_date)+(year(event_date)-2007)*100;
cluster2=week(event_date)+(year(event_date)-2007)*100;
cluster3=month(event_date)+(year(event_date)-2007)*100;
cluster4=month(event_date)+(year(event_date)-2007)*100;
cluster5=qtr(event_date)+(year(event_date)-2007)*100;
cluster6=qtr(event_date)+(year(event_date)-2007)*100;
run;

%macro CAR(n);
ODS output Parameterestimates=temp1;
proc surveyreg data=imb_car1;
model &inv._imbb10=&r.win&n. &r.before abvol_b10;
cluster cluster&n;
run;
ODS output close;

data temp3_&n.;
set temp1;
if _n_=2;
Parameter="&inv";
rename Parameter=investor estimate=&r.win&n._coef tValue=&r.win&n._t;
keep Parameter estimate tValue;
run;
%mend CAR;

%CAR(1);%CAR(2);%CAR(3);%CAR(4);%CAR(5);%CAR(6);

data temp3;
merge temp3_1 temp3_2 temp3_3 temp3_4 temp3_5 temp3_6;
by investor;
run;

data regression_inv_&event._&r.;
set regression_inv_&event._&r. temp3;
run;

%mend sort;

%sort(homecity);
%sort(coparty_city);
%sort(coparty_outprovince);
%sort(outall);

data regression_inv_&event._&r.;
set regression_inv_&event._&r.;
event="&event.";
if investor^='';
run;

%mend abRet;

%abRet(index);
%abRet(month);

proc sql;
drop table imb_b10,imb_car,imb_car1,CAR_after1,CAR_after2,CAR_after3,CAR_after4,CAR_after5,CAR_after6,Q1_5,all_60d_imb,earning_60d_imb,earning_forecast_60d_imb,restructure_60d_imb,bankloan_60d_imb,
lawsuit_60d_imb,governor_60d_imb,suspension_60d_imb,temp1,temp2,temp3,temp3_1,temp3_2,temp3_3,temp3_4,temp3_5,temp3_6;
quit;
