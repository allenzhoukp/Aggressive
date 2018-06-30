/* This looks like a deprecated code. Last edited 2012-10-22.
Cannot find library broker.earnings_2_2_7 or so now. */
proc sql;

create table clean_return_1 as select distinct stock_code_1,release_date_1 from broker.earnings_2_2_7
where (time_trade >-31 and time_trade<-28);
create table clean_return_2 as select distinct stock_code_1,release_date_1 from broker.earnings_2_2_7
where (time_trade<31 and time_trade>28);
create table clean_return as select distinct a.stock_code_1,a.release_date_1 from clean_return_2 a, clean_return_1 b
where a.stock_code_1=b.stock_code_1 and a.release_date_1=b.release_date_1;


create table earnings_clean as select a.* from broker.earnings_2_2_7 a join clean_return b
on time_trade<3 and time_trade>=-2 and a.stock_code_1=b.stock_code_1 and a.release_date_1=b.release_date_1;
create table abret_mean as select decile_ear_1,time_trade,mean(abret_month) as abret_mean from earnings_clean
group by decile_ear_1,time_trade;
quit;

proc sort;
by decile_ear_1 time_trade;
run;

data CAR;
set abret_mean;
by decile_ear_1 time_trade;
if first.decile_ear_1 then CAR=0;
CAR+Abret_mean;
run;

goptions reset=all;
symbol value=dot interpol=join;
proc gplot data=CAR;
plot CAR*time_trade=decile_ear_1;
title "Abnormal Return";
run;
quit;
