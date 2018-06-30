%let start=0;
%let end=1;
%let pre=-10;

%macro event(event);

proc sql;
create table &event._60d_imb as select distinct a.* from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.&event.=1;
quit;


proc sql;
create table &event._60d_imb as select distinct a.*,b.funds_per_capita as subgroup from &event._60d_imb a left join broker.industry_address b
on a.stock_code_1=b.stock_code_1;
quit;

data &event._60d_imb;
set &event._60d_imb;
if subgroup<=3 then subgroup=0;
if subgroup>3 then subgroup=1;
run;

/*
proc sql;
create table &event._60d_imb as select distinct * from &event._60d_imb
where stock_code_1 in (select distinct stock_code_1 from broker.analyst_coverage where size=3);
quit;

proc sql;
create table &event._60d_imb as select distinct * from &event._60d_imb 
where stock_code_1 in (select code from broker.state where state=1);
quit;

proc sql;
create table &event._60d_imb as select distinct a.* from &event._60d_imb a,&event._important b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.size=1;
quit;

proc sql;
create table &event._60d_imb as select * from &event._60d_imb
where stock_code_1 in (select F3_T0401D from broker.head_other);
quit;
*/

proc sql;
create table imb_b10 as select distinct stock_code_1,event_date
,sum(abret_index) as indexb10,sum(abret_month) as monthb10
,sum(all_imb_adj) as all_imbb10
,sum(beijing_imb_adj) as beijing_imbb10
,sum(shanghai_imb_adj) as shanghai_imbb10
,sum(other_imb_adj) as other_imbb10
,sum(home_city_imb_adj) as home_city_imbb10
,sum(home_province_imb_adj) as home_province_imbb10
,sum(fund_imb_adj) as fund_imbb10
,subgroup
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

proc sql;
create table imb_CAR1 as select distinct a.*,b.intercept,b.co_imbb10,b.co_abretb10
from imb_CAR1 a left join broker.liquidity_15 b
on b.type="&inv._&r._liquidity";
quit;

data imb_CAR1;
set imb_CAR1;
&r.win7=intercept+co_imbb10*&inv._imbb10+co_abretb10*&r.b10;
&r.win8=&r.win6 -intercept-co_imbb10*&inv._imbb10-co_abretb10*&r.b10;
run;

proc sort;
by &inv._imbb10;
run;

data imb_car1_1;
set imb_car1;
if subgroup=1;
run;

data _null_;
       set imb_car1_1 nobs=t;
       call symput("size",t);
       stop;
run;


data imb_car1_1;
set imb_car1_1;
if _n_<=&size./5 then quintile=1;
if _n_>&size./5 and _n_<=&size./5*2 then quintile=2;
if _n_>&size./5*2 and _n_<= &size./5*3 then quintile=3;
if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

data imb_car1_2;
set imb_car1;
if subgroup=0;
run;

data _null_;
       set imb_car1_2 nobs=t;
       call symput("size",t);
       stop;
run;


data imb_car1_2;
set imb_car1_2;
if _n_<=&size./5 then quintile=1;
if _n_>&size./5 and _n_<=&size./5*2 then quintile=2;
if _n_>&size./5*2 and _n_<= &size./5*3 then quintile=3;
if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

data imb_car1;
set imb_car1_1 imb_car1_2;
run;

proc sort;
by quintile;
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
if quintile=5 then Q5=1;
run;

data Q1_5;
set imb_car1;
if Quintile=1 or Quintile=5;
Q5_subgroup=Q5*subgroup;
run;

%macro CAR(n);
ODS output Parameterestimates=temp1;
proc surveyreg data=imb_car1;
by quintile;
model &r.win&n.=subgroup;
cluster cluster&n;
run;
ODS output close;

ODS output Parameterestimates=temp2;
proc surveyreg data=Q1_5;
model &r.win&n.=Q5 Q5_subgroup subgroup;
cluster cluster&n;
run;
ODS output close;

data temp1;
set temp1;
if mod(_n_,2)=0;
run;

data temp2;
set temp2;
if _n_^=3 then delete;
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

%sort(all);

%sort(home_province);
%sort(home_city);
%sort(fund);
%sort(shanghai);
%sort(beijing);
%sort(other);


data sort_inv_&event._&r.;
set sort_inv_&event._&r.;
if quintile^='';
run;

data sort_inv_&event._&r.;
set sort_inv_&event._&r.;
if quintile^='';
if mod(_n_,6)=0;
event="&event.";
run;

%mend abRet;

%abRet(index);
%abRet(month);

%mend event;

%event(earning);
%event(earning_forecast);
%event(restructure);
%event(bankloan);
%event(lawsuit);
%event(suspension);
%event(governor);
%event(all);

data indivi_sort_index;
set sort_inv_all_index sort_inv_earning_index sort_inv_earning_forecast_index sort_inv_restructure_index sort_inv_bankloan_index sort_inv_lawsuit_index sort_inv_suspension_index sort_inv_governor_index;
run;

data indivi_sort_month;
set sort_inv_all_month sort_inv_earning_month sort_inv_earning_forecast_month sort_inv_restructure_month sort_inv_bankloan_month sort_inv_lawsuit_month sort_inv_suspension_month sort_inv_governor_month;
run;
/*
proc sql;
drop table imb_b10,imb_car,imb_car1,CAR_after1,CAR_after2,CAR_after3,CAR_after4,CAR_after5,CAR_after6,Q1_5,all_60d_imb,earning_60d_imb,earning_forecast_60d_imb,restructure_60d_imb,bankloan_60d_imb,
lawsuit_60d_imb,governor_60d_imb,suspension_60d_imb,temp1,temp2,temp3,temp3_1,temp3_2,temp3_3,temp3_4,temp3_5,temp3_6,
sort_inv_all_index,sort_inv_earning_index,sort_inv_earning_forecast_index,sort_inv_restructure_index,sort_inv_bankloan_index,sort_inv_lawsuit_index,sort_inv_suspension_index,sort_inv_governor_index,
sort_inv_all_month,sort_inv_earning_month,sort_inv_earning_forecast_month,sort_inv_restructure_month,sort_inv_bankloan_month,sort_inv_lawsuit_month,sort_inv_suspension_month,sort_inv_governor_month;
quit;
