%let start=0;
%let end=1;
%let event=bankloan;
%let pre=-10;

proc sql;
create table &event._60d_imb as select distinct a.* from broker.all_eerbl_60d_imb_bankloan a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.&event.=1;
quit;

proc sql;
create table imb_b10 as select distinct stock_code_1,event_date
,sum(bbranch_city_imb_adj) as bbranch_city_imbb10
,sum(bbranch_outprovince_imb_adj) as bbranch_outprovince_imbb10
,sum(home_city_imb_adj) as homecity_imbb10
,sum(bhead_city_imb_adj) as bhead_city_imbb10
,sum(bhead_outprovince_imb_adj) as bhead_outprovince_imbb10
,sum(outall_imb_adj) as outall_imbb10
from &event._60d_imb
where time_trade<&start and time_trade>=&start+&pre
group by stock_code_1,event_date;
quit;


%macro abRet(r);

data sort_inv_&event._&r;
length event $20.;
length quintile $20.;
event='';
quintile='';
run;

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
merge imb_b10 CAR_after1 CAR_after2 CAR_after3 CAR_after4 CAR_after5 CAR_after6;
by stock_code_1 event_date;
run;

%macro sort(inv);

proc sql;
create table imb_CAR1 as select * from imb_CAR
where &inv._imbb10^=. and &inv._imbb10^=0;
quit;


proc sort;
by &inv._imbb10;
run;

data _null_;
       set imb_car1 nobs=t;
       call symput("size",t);
       stop;
run;


data imb_car1;
set imb_car1;
if _n_<=&size./5 then quintile=1;
if _n_>&size./5 and _n_<=&size./5*2 then quintile=2;
if _n_>&size./5*2 and _n_<= &size./5*3 then quintile=3;
if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

data imb_car1;
set imb_car1;
cluster1=week(event_date)+(year(event_date)-2007)*100;
cluster2=week(event_date)+(year(event_date)-2007)*100;
cluster3=month(event_date)+(year(event_date)-2007)*100;
cluster4=month(event_date)+(year(event_date)-2007)*100;
cluster5=qtr(event_date)+(year(event_date)-2007)*100;
cluster6=qtr(event_date)+(year(event_date)-2007)*100;
if quintile=1 then Q5=0;
else Q5=1;
run;

data Q1_5;
set imb_car1;
if Quintile=1 or Quintile=5;
run;

%macro CAR(n);
ODS output Parameterestimates=temp1;
proc surveyreg data=imb_car1;
by quintile;
model &r.win&n.=;
cluster cluster&n;
run;
ODS output close;

ODS output Parameterestimates=temp2;
proc surveyreg data=Q1_5;
model &r.win&n.=Q5;
cluster cluster&n;
run;
ODS output close;

data temp2;
set temp2;
if _n_=1 then delete;
quintile=6;
run;

data temp3_&n.;
set temp1 temp2;
rename estimate=&r.win&n._mean tvalue=&r.win&n._t;
keep quintile estimate tValue;
run;
%mend CAR;

%CAR(1);%CAR(2);%CAR(3);%CAR(4);%CAR(5);%CAR(6);

data temp3;
merge temp3_1 temp3_2 temp3_3 temp3_4 temp3_5 temp3_6;
by quintile;
if _n_<6 then group=cats("&inv",'_',quintile);
else group=cats("&inv",'_diff');
drop quintile;
rename group=quintile;
run;

data sort_inv_&event._&r.;
set sort_inv_&event._&r. temp3;
run;

%mend sort;

%sort(homecity);
%sort(bhead_city);
%sort(bhead_outprovince);
%sort(bbranch_city);
%sort(bbranch_outprovince);
%sort(outall);


data sort_inv_&event._&r.;
set sort_inv_&event._&r.;
if quintile^='';
run;

data sort_inv_&event._&r.;
set sort_inv_&event._&r.;
if quintile^='';
if mod(_n_,6)>=0;
event="&event.";
run;

%mend abRet;

%abRet(index);
%abRet(month);

proc sql;
drop table imb_b10,imb_car,imb_car1,CAR_after1,CAR_after2,CAR_after3,CAR_after4,CAR_after5,CAR_after6,Q1_5,all_60d_imb,earning_60d_imb,earning_forecast_60d_imb,restructure_60d_imb,bankloan_60d_imb,
lawsuit_60d_imb,governor_60d_imb,suspension_60d_imb,temp1,temp2,temp3,temp3_1,temp3_2,temp3_3,temp3_4,temp3_5,temp3_6;
quit;
