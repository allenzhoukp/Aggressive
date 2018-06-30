/* identify upper price limit and lower price limit*/
/*
data stock_daily_0_1;
set broker.stock_daily;
if ST=0 and return_raw>0.095 and return_raw<0.105 then price_limit=1;
else if ST=0 and return_raw<-0.095 and return_raw>-0.105 then price_limit=-1;
else if ST=1 and return_raw>0.045 and return_raw<0.055 then price_limit=1;
else if ST=1 and return_raw<-0.045 and return_raw>-0.055 then price_limit=-1;
else price_limit=0;
run;

proc sort;
by stock_code date;
run;

/* identify positive consecutive return sequences and negative ones*/
/*
data stock_daily_0_2;
set stock_daily_0_1;
lagcode=lag(stock_code);
lagreturn=lag(return_raw);
if _n_=1 then No1=1 and No=0;
if lagcode^=stock_code then No1=1;
else if sign(return_raw)^=sign(lagreturn) then No1=1;
else No1=0;
No+No1;
drop No1 lagcode lagreturn;
run;
*/

/* The remaining part is to calucate abnormal return adjusted by size which is 
measured by market capitalization at the very begining of each month*/
data marcap_month;
set broker.marcap_month;
if VAR1>=600000;
if VAR2='01jan09'd;
run;

proc sql;
create table marcap_month as select distinct * from marcap_month
where stock_code_1 in (select F3_T0401D from broker.T_0401D_4);
quit;

proc sort data=marcap_month out=marcap_month;
by VAR10;
run;

proc univariate data=marcap_month;
var VAR10;
output out=marcap_month_decile pctlpre=p_ pctlpts=0 to 100 by 10;
run;
data marcap_month_decile;
set marcap_month_decile;
p_0_lag=	 (p_0);
p_10_lag=	 (p_10);
p_20_lag=	 (p_20);
p_30_lag=	 (p_30);
p_40_lag=	 (p_40);
p_50_lag=	 (p_50);
p_60_lag=	 (p_60);
p_70_lag=	 (p_70);
p_80_lag=	 (p_80);
p_90_lag=	 (p_90);
p_100_lag=	 (p_100);
run;

data marcap_month_decile;
set marcap_month_decile;
drop p_0 p_10 p_20 p_30 p_40 p_50 p_60 p_70 p_80 p_90 p_100;
if p_0_lag ne .;
run;

proc sql;
create table marcap_month_1 as select distinct a.*,b.* from marcap_month a,marcap_month_decile b;
quit;

data marcap_month_1;
set marcap_month_1;
if VAR10 LE p_10_lag then  decile_VAR10=1;
if VAR10 LE p_20_lag & VAR10>p_10_lag then  decile_VAR10=1;
if VAR10 LE p_30_lag & VAR10>p_20_lag then  decile_VAR10=2;
if VAR10 LE p_40_lag & VAR10>p_30_lag then  decile_VAR10=2;
if VAR10 LE p_50_lag & VAR10>p_40_lag then  decile_VAR10=3;
if VAR10 LE p_60_lag & VAR10>p_50_lag then  decile_VAR10=3;
if VAR10 LE p_70_lag & VAR10>p_60_lag then  decile_VAR10=4;
if VAR10 LE p_80_lag & VAR10>p_70_lag then  decile_VAR10=4;
if VAR10 LE p_90_lag & VAR10>p_80_lag then  decile_VAR10=5;
if  VAR10>p_90_lag then  decile_VAR10=5;
run; 
data marcap_month_1;
set marcap_month_1;
drop    p_10_lag p_20_lag p_30_lag p_40_lag p_50_lag p_60_lag p_70_lag p_80_lag p_90_lag p_100_lag p_0_lag;
run; 

proc sql;
create table stock_daily_0_3 as select a.*,b.decile_VAR10 from broker.stock_daily a left join Marcap_month_1 b
on a.stock_code=b.stock_code_1;
create table size_mean as select date,decile_VAR10,mean(return_raw) as size_mean from stock_daily_0_3
group by date,decile_VAR10;
create table stock_daily_1 as select a.*,b.size_mean,a.return_raw-b.size_mean as AbRet_month from stock_daily_0_3 a left join size_mean b
on a.date=b.date and a.decile_VAR10=b.decile_VAR10 and stock_code>'599999';
quit;


proc sort;
by stock_code date;
run;
/*
data stock_daily_1;
set stock_daily_1;
by stock_code date;
lagclose=lag(closeprc);
if not first.stock_code;
run;

data stock_daily_1;
set stock_daily_1;
if ST=0 and return_raw>=0.1 and (closeprc-0.01)/lagclose<1.1 and (closeprc+closeprc-0.01)/2<=1.1*lagclose then price_limit_1=1;
else if ST=0 and return_raw<0.1 and (closeprc+0.01)/lagclose>1.1 and (closeprc+closeprc+0.01)/2>=1.1*lagclose then price_limit_1=1;
else if ST=1 and return_raw>=0.05 and (closeprc-0.01)/lagclose<1.05 and (closeprc+closeprc-0.01)/2<=1.05*lagclose then price_limit_1=1;
else if ST=1 and return_raw<0.05 and (closeprc+0.01)/lagclose>1.05 and (closeprc+closeprc+0.01)/2>=1.05*lagclose then price_limit_1=1;
else if ST=0 and return_raw<=-0.1 and (closeprc+0.01)/lagclose>0.9 and (closeprc+closeprc+0.01)/2>=0.9*lagclose then price_limit_1=-1;
else if ST=0 and return_raw>-0.1 and (closeprc-0.01)/lagclose<0.9 and (closeprc+closeprc-0.01)/2<=0.9*lagclose then price_limit_1=-1;
else if ST=1 and return_raw<=-0.05 and (closeprc+0.01)/lagclose>0.95 and (closeprc+closeprc+0.01)/2>=0.95*lagclose then price_limit_1=-1;
else if ST=1 and return_raw>-0.05 and (closeprc-0.01)/lagclose<0.95 and (closeprc+closeprc-0.01)/2<=0.95*lagclose then price_limit_1=-1;
else price_limit_1=0;
run;
*/
proc sql;
create table stock_daily_1 as select distinct a.*,b.market_return,a.return_raw-b.market_return as abreturn_index from stock_daily_1 a left join broker.shanghai_index b
on a.date=b.date;
quit;

data stock_daily_1;
set stock_daily_1;
if stock_code>'599999';
rename stock_code=stock_code_1;
run;
