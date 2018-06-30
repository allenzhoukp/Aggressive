proc sql;
create table temp4 as select distinct a.*,b.branch_code,b.branch_type,b.F15_T0401D-b.F16_T0401D as value from temp0 a left join temp1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date;
quit;
/*
proc sql;
create table temp4 as select distinct a.*,b.network,b.fundacc,b.branch_type,b.settlevalue as value from temp0 a left join temp3_2 b
on a.stock_code_1=b.code and a.date=b.date;
quit;
*/
proc sql;
create table temp5 as select distinct stock_code_1,event_date,event,sum(value) as value_sum from temp4
where value^=.
group by stock_code_1,event_date;
quit;

proc sql;
create table temp5 as select distinct a.*,a.value_sum/b.avg_vol as value_imb from temp5 a left join broker.T_0401D_4 b
on a.stock_code_1=b.F3_T0401D;
quit;

proc sql;
create table CAR_after1 as select distinct stock_code_1,event_date,sum(abret_index) as indexwin1 
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=1
group by stock_code_1,event_date;
create table CAR_after2 as select distinct stock_code_1,event_date,sum(abret_index) as indexwin2
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=1+5
group by stock_code_1,event_date;
create table CAR_after3 as select distinct stock_code_1,event_date,sum(abret_index) as indexwin3
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=1+10
group by stock_code_1,event_date;
create table CAR_after4 as select distinct stock_code_1,event_date,sum(abret_index) as indexwin4
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=1+20
group by stock_code_1,event_date;
create table CAR_after5 as select distinct stock_code_1,event_date,sum(abret_index) as indexwin5 
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=1+60
group by stock_code_1,event_date;
quit;

proc sort data=temp5;
by stock_code_1 event_date;
run;

data imb_CAR;
merge temp5 CAR_after1 CAR_after2 CAR_after3 CAR_after4 CAR_after5;
by stock_code_1 event_date;
run;

data imb_car;
set imb_car;
if value_imb^=.;
run;

proc sort data=imb_CAR;
by value_imb;
run;

data imb_CAR;
set imb_CAR;
if value_imb^=0;
run;

data _null_;
       set imb_CAR nobs=t;
       call symput("size",t);
       stop;
run;

data imb_CAR;
set imb_CAR;
if _n_<=&size./3 then quintile=1;
if _n_>&size./3 and _n_<=&size./3*2 then quintile=2;
if _n_>&size./3*2 and _n_<= &size./3*3 then quintile=5;
*if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
*if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

data imb_CAR;
set imb_CAR;
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
set imb_CAR;
if Quintile=1 or Quintile=5;
run;


%macro CAR(n);
ODS output Parameterestimates=temp5_1;
proc surveyreg data=imb_CAR;
by quintile;
model indexwin&n.=;
cluster cluster&n;
run;
ODS output close;

ODS output Parameterestimates=temp5_2;
proc surveyreg data=Q1_5;
model indexwin&n.=Q5;
cluster cluster&n;
run;
ODS output close;

data temp5_2;
set temp5_2;
if _n_=1 then delete;
quintile=6;
run;

data temp5_3_&n.;
set temp5_1 temp5_2;
rename estimate=indexwin&n._mean tvalue=indexwin&n._t;
keep quintile estimate tValue;
run;
%mend CAR;

%CAR(1);%CAR(2);%CAR(3);%CAR(4);

data temp5_3;
merge temp5_3_1 temp5_3_2 temp5_3_3 temp5_3_4;
by quintile;
if _n_<6 then group=cats("Q",'_',_n_);
else group='diff';
drop quintile;
rename group=quintile;
run;



