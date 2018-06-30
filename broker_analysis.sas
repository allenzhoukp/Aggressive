/*
data aaa;
set broker.T_0401d_1;
if F9_t0401d>'2';
net_abs=F17_T0401D+F18_T0401D;
run;

proc sort;
by F3_T0401D date descending net_abs;
run;

data aaa;
set aaa;
lag_code=lag(F3_T0401D);
lag_date=lag(date);
run;

data aaa;
set aaa;
if _n_=0 or F3_T0401D^=lag_code or date^=lag_date then No=0;
No+1;
run;

data aaa;
set aaa;
if No<11;
drop net_abs lag_code lag_date No;
run;
*/
data temp1;
*set aaa;
set broker.T_0401D_1;
if index(F14_T0401D,'Ãñ×å')>0;
if F9_t0401d>2;
run;

data temp0;
set broker.all_eerbl_60d_imb;
if time_trade<0 and time_trade>-11;
run;

proc sql;
create table temp1 as select distinct a.*,b.branch_code from temp1 a left join broker.minzu_code b
on a.F12_T0401D=b.F12_T0401D;
quit;

proc sql;
create table temp1 as select distinct a.*,b.event_date,b.event,b.time_trade from temp1 a left join temp0 b
on a.F3_T0401D=b.stock_code_1 and a.date=b.date;
quit;

data temp1_1;
set temp1;
if time_trade^=.;
run;

data temp1_2;
set temp1;
if time_trade=.;
drop event_date event time_trade;
run;

proc sql;
create table temp2 as select distinct a.*,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type from broker.broker_daily a,temp1_1 b
where a.code=b.F3_T0401D and a.date=b.date and a.network=b.branch_code;
quit;

proc sql;
create table temp2_0 as select distinct a.*,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type,b.event_date,b.event,b.time_trade from broker.broker_daily a,temp1_1 b
where a.code=b.F3_T0401D and a.date=b.date and a.network=b.branch_code;
quit;
/*
proc sql;
create table temp2 as select distinct a.*,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type from broker.broker_daily a,temp1_2 b
where a.code=b.F3_T0401D and a.date=b.date and a.network=b.branch_code;
quit;
*/
data temp2;
set temp2;
value_abs=abs(settlevalue);
run;

proc sort;
by code date network descending value_abs;
run;

data temp2_1;
set temp2;
by code date network descending value_abs;
if first.network;
run;

data temp2_2;
set temp2;
by code date network descending value_abs;
if not first.network;
run;

data temp2_2;
set temp2_2;
by code date network descending value_abs;
if first.network;
run;

data temp2_3;
set temp2_1 temp2_2;
run;

proc sql;
create table temp3 as select distinct code,date,network,branch_province,branch_city,head_province,head_city,branch_type,sum(settlevalue) as value_sum from temp2
group by code,date,network;
quit;

proc sql;
create table temp3 as select distinct a.*,b.F15_T0401D-b.F16_T0401D as value_true from temp3 a left join temp1 b
on a.code=b.F3_t0401d and a.date=b.date and a.network=b.branch_code;
quit;

proc sql;
create table temp3 as select distinct a.*,b.settlevalue as value_1st from temp3 a left join temp2_1 b
on a.code=b.code and a.date=b.date and a.network=b.network;
quit;

proc sql;
create table temp3 as select distinct a.*,b.settlevalue as value_2nd from temp3 a left join temp2_2 b
on a.code=b.code and a.date=b.date and a.network=b.network;
quit;

data temp3;
set temp3;
if value_2nd=. then value_2nd=0;
run;

data temp3;
set temp3;
ratio_1st=value_1st/value_sum;
ratio_2nd=(value_1st+value_2nd)/value_sum;
run;

data temp3_1;
set temp3;
if abs(value_sum-value_true)/abs(value_true)>0.05 then delete;
if ratio_1st>ratio_2nd then ratio_max=ratio_1st;
else ratio_max=ratio_2nd;
run;

data temp3_1;
set temp3_1;
bin_ratio_1st=round(ratio_1st,0.1);
bin_ratio_2nd=round(ratio_2nd,0.1);
bin_ratio_max=round(ratio_max,0.1);
run;

proc sort;
by descending ratio_max;
run;

proc sql;
create table temp3_1 as select distinct a.*,b.avg_vol,a.value_1st/b.avg_vol as imb_1st from temp3_1 a left join broker.T_0401D_4 b
on a.code=b.F3_T0401D;
quit;

proc sql;
create table temp3_2 as select distinct a.*,b.value_sum,b.avg_vol from temp2 a,temp3_1 b
where a.code=b.code and a.date=b.date and a.network=b.network;
create table temp2_1_1 as select distinct a.* from temp2_1 a,temp3_1 b
where a.code=b.code and a.date=b.date and a.network=b.network;
quit;

data _null_;
       set temp3_1 nobs=t;
       call symput("size",t);
       stop;
run;

proc sql;
create table histo_3_1_max as select distinct bin_ratio_max as number,count(bin_ratio_max)/&size as ratio_max from temp3_1
group by bin_ratio_max;
create table histo_3_1_1st as select distinct bin_ratio_1st as number,count(bin_ratio_1st)/&size as ratio_1st from temp3_1
group by bin_ratio_1st;
create table histo_3_1_2nd as select distinct bin_ratio_2nd as number,count(bin_ratio_2nd)/&size as ratio_2nd from temp3_1
group by bin_ratio_2nd;
quit;

data histo_3_1;
input number;
cards;
-1
-0.9
-0.8
-0.7
-0.6
-0.5
-0.4
-0.3
-0.2
-0.1
0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1
1.1
1.2
1.3
1.4
1.5
1.6
1.7
1.8
1.9
2
2.1
2.2
2.3
2.4
2.5
2.6
2.7
;
run;

proc sql;
create table histo_3_1 as select distinct a.*,b.ratio_1st from histo_3_1 a left join histo_3_1_1st b
on a.number=b.number;
create table histo_3_1 as select distinct a.*,b.ratio_2nd from histo_3_1 a left join histo_3_1_2nd b
on a.number=b.number;
create table histo_3_1 as select distinct a.*,b.ratio_max from histo_3_1 a left join histo_3_1_max b
on a.number=b.number;
quit;

data histo_3_1;
set histo_3_1;
if ratio_max=. then ratio_max=0;
if ratio_1st=. then ratio_1st=0;
if ratio_2nd=. then ratio_2nd=0;
run;

proc sql;
create table a1 as select distinct mean(ratio_1st) as ratio_mean,median(ratio_1st) as ratio_median,mean(abs(imb_1st)) as imb_abs_mean,median(abs(imb_1st)) as imb_abs_median from temp3_1;
create table a2 as select distinct mean(ratio_1st) as ratio_mean,median(ratio_1st) as ratio_median,mean(abs(imb_1st)) as imb_abs_mean,median(abs(imb_1st)) as imb_abs_median from temp3_1
where branch_type='home_city' or branch_type='same_province';
create table a3 as select distinct mean(ratio_1st) as ratio_mean,median(ratio_1st) as ratio_median,mean(abs(imb_1st)) as imb_abs_mean,median(abs(imb_1st)) as imb_abs_median from temp3_1
where branch_type^='home_city' and branch_type^='same_province';
quit;

data aa;
set a1 a2 a3;
format group $6.;
if _n_=1 then group='all';
if _n_=2 then group='home';
if _n_=3 then group='other';
run;

proc sql;
create table temp3_3 as select distinct a.* from broker.broker_daily a,temp2_1_1 b
where a.network=b.network and a.code=b.code and a.fundacc=b.fundacc;
quit;

proc sql;
create table temp3_3 as select distinct a.*,b.event_date from temp3_3 a left join temp0 b
on a.code=b.stock_code_1 and a.date=b.date;
quit;

proc sql;
create table temp3_3 as select distinct a.*,b.branch_type from temp3_3 a left join temp2_1_1 b
on a.network=b.network and a.code=b.code and a.fundacc=b.fundacc;
quit;

proc sql;
create table value_sum as select distinct network,code,date,sum(amount) as amount_sum,sum(settlevalue) as value_sum from broker.broker_daily
group by network,code,date;
quit;

proc sql;
create table temp3_3 as select distinct a.*,b.amount_sum,b.value_sum from temp3_3 a left join value_sum b
on a.network=b.network and a.code=b.code and a.date=b.date;
quit;

proc sql;
create table temp3_3 as select distinct a.*,b.avg_vol from temp3_3 a left join broker.T_0401D_4 b
on a.code=b.F3_T0401D;
quit;

data temp3_3;
set temp3_3;
ratio=settlevalue/value_sum;
imb=settlevalue/avg_vol;
imb_abs=abs(settlevalue/avg_vol);
run;

proc sql;
create table temp3_3_1 as select distinct network,code,fundacc,branch_type,amount,date,settlevalue,amount_sum,value_sum,avg_vol,ratio,imb,imb_abs from temp3_3
where event_date^=.;
quit;

proc sql;
create table temp3_3_2 as select distinct network,code,fundacc,branch_type,amount,date,settlevalue,amount_sum,value_sum,avg_vol,ratio,imb,imb_abs from temp3_3
where event_date=.;
quit;

proc sql;
create table b1 as select distinct mean(ratio) as ratio_mean,median(ratio) as ratio_median,mean(imb_abs) as imb_abs_mean,median(imb_abs) as imb_abs_median from temp3_3_1;
create table b2 as select distinct mean(ratio) as ratio_mean,median(ratio) as ratio_median,mean(imb_abs) as imb_abs_mean,median(imb_abs) as imb_abs_median from temp3_3_1
where branch_type='home_city' or branch_type='same_province';
create table b3 as select distinct mean(ratio) as ratio_mean,median(ratio) as ratio_median,mean(imb_abs) as imb_abs_mean,median(imb_abs) as imb_abs_median from temp3_3_1
where branch_type^='home_city' and branch_type^='same_province';
quit;

data bb;
set b1 b2 b3;
format group $6.;
if _n_=1 then group='all';
if _n_=2 then group='home';
if _n_=3 then group='other';
run;

/*
proc sql;
create table temp2_1_1 as select distinct a.*,a.value_abs/b.avg_vol as value_adj from temp2_1_1 a left join broker.t_0401D_4 b
on a.code=b.F3_T0401D;
create table a1 as select distinct mean(value_adj) as mean from temp2_1_1;
create table a2 as select distinct mean(value_adj) as mean from temp2_1_1
where branch_type='home_city';
create table a3 as select distinct mean(value_adj) as mean from temp2_1_1
where branch_type^='home_city';
quit;

data aa;
set a1 a2 a3;
format group $6.;
if _n_=1 then group='all';
if _n_=2 then group='home';
if _n_=3 then group='other';
run;

proc sql;
create table temp2_1_3 as select distinct a.*,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type from broker.broker_daily a, temp2_1_1 b
where a.network=b.network and a.code=b.code and a.fundacc=b.fundacc;
create table temp2_1_3 as select distinct a.*,abs(a.settlevalue)/b.avg_vol as value_adj from temp2_1_3 a left join broker.t_0401D_4 b
on a.code=b.F3_T0401D;
quit;

proc sql;
create table temp2_1_3 as select distinct a.*,b.date as date1 from temp2_1_3 a left join temp2_1_1 b
on a.network=b.network and a.code=b.code and a.fundacc=b.fundacc and a.date=b.date;
quit;

data temp2_1_4;
set temp2_1_3;
if date1=.;
drop date1;
run;

proc sql;
create table b1 as select distinct mean(value_adj) as mean from temp2_1_4;
create table b2 as select distinct mean(value_adj) as mean from temp2_1_4
where branch_type='home_city';
create table b3 as select distinct mean(value_adj) as mean from temp2_1_4
where branch_type^='home_city';
quit;

data bb;
set b1 b2 b3;
format group $6.;
if _n_=1 then group='all';
if _n_=2 then group='home';
if _n_=3 then group='other';
run;
*/
