proc reg data=predict_earning_buy_adj20 outest=ab_b2_a2d_adj20_b10_b6_buy tableout;
model abreturn_b2_a2d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_b2_a2d_adj20_b10_b6_buy out=ab_b2_a2d_adj20_b10_b6_buy;
run;

data ab_b2_a2d_adj20_b10_b6_buy;
set ab_b2_a2d_adj20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_adj20 outest=ab_b2_a2d_adj20_b10_b6_sell tableout;
model abreturn_b2_a2d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_b2_a2d_adj20_b10_b6_sell out=ab_b2_a2d_adj20_b10_b6_sell;
run;

data ab_b2_a2d_adj20_b10_b6_sell;
set ab_b2_a2d_adj20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_b2_a2d_adj20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_b2_a2d_adj20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_b2_a2d_adj20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_b2_a2d_adj20_b10_b6_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_earning_buy_adj20 outest=ab_b1_b5d_adj20_b10_b6_buy tableout;
model abreturn_b1_b5d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_b1_b5d_adj20_b10_b6_buy out=ab_b1_b5d_adj20_b10_b6_buy;
run;

data ab_b1_b5d_adj20_b10_b6_buy;
set ab_b1_b5d_adj20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_adj20 outest=ab_b1_b5d_adj20_b10_b6_sell tableout;
model abreturn_b1_b5d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_b1_b5d_adj20_b10_b6_sell out=ab_b1_b5d_adj20_b10_b6_sell;
run;

data ab_b1_b5d_adj20_b10_b6_sell;
set ab_b1_b5d_adj20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_b1_b5d_adj20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_b1_b5d_adj20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_b1_b5d_adj20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_b1_b5d_adj20_b10_b6_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_earning_buy_adj20 outest=ab_a0_a1d_adj20_b10_b6_buy tableout;
model abreturn_a0_a1d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_a0_a1d_adj20_b10_b6_buy out=ab_a0_a1d_adj20_b10_b6_buy;
run;

data ab_a0_a1d_adj20_b10_b6_buy;
set ab_a0_a1d_adj20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_adj20 outest=ab_a0_a1d_adj20_b10_b6_sell tableout;
model abreturn_a0_a1d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_a0_a1d_adj20_b10_b6_sell out=ab_a0_a1d_adj20_b10_b6_sell;
run;

data ab_a0_a1d_adj20_b10_b6_sell;
set ab_a0_a1d_adj20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_a0_a1d_adj20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_a0_a1d_adj20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_a0_a1d_adj20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_a0_a1d_adj20_b10_b6_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_earning_buy_adj20 outest=ab_b5_a1d_adj20_b10_b6_buy tableout;
model abreturn_b5_a1d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_b5_a1d_adj20_b10_b6_buy out=ab_b5_a1d_adj20_b10_b6_buy;
run;

data ab_b5_a1d_adj20_b10_b6_buy;
set ab_b5_a1d_adj20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_adj20 outest=ab_b5_a1d_adj20_b10_b6_sell tableout;
model abreturn_b5_a1d=nothome_adj20_mean_b10_b6 home_adj20_mean_b10_b6 fund_adj20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_b5_a1d_adj20_b10_b6_sell out=ab_b5_a1d_adj20_b10_b6_sell;
run;

data ab_b5_a1d_adj20_b10_b6_sell;
set ab_b5_a1d_adj20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_b5_a1d_adj20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_b5_a1d_adj20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_b5_a1d_adj20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_b5_a1d_adj20_b10_b6_sell'
   dbms=excel
   replace;
 run;

proc reg data=predict_earning_buy_sdd20 outest=ab_b2_a2d_sdd20_b10_b6_buy tableout;
model abreturn_b2_a2d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_b2_a2d_sdd20_b10_b6_buy out=ab_b2_a2d_sdd20_b10_b6_buy;
run;

data ab_b2_a2d_sdd20_b10_b6_buy;
set ab_b2_a2d_sdd20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_sdd20 outest=ab_b2_a2d_sdd20_b10_b6_sell tableout;
model abreturn_b2_a2d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_b2_a2d_sdd20_b10_b6_sell out=ab_b2_a2d_sdd20_b10_b6_sell;
run;

data ab_b2_a2d_sdd20_b10_b6_sell;
set ab_b2_a2d_sdd20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_b2_a2d_sdd20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_b2_a2d_sdd20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_b2_a2d_sdd20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_b2_a2d_sdd20_b10_b6_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_earning_buy_sdd20 outest=ab_b1_b5d_sdd20_b10_b6_buy tableout;
model abreturn_b1_b5d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_b1_b5d_sdd20_b10_b6_buy out=ab_b1_b5d_sdd20_b10_b6_buy;
run;

data ab_b1_b5d_sdd20_b10_b6_buy;
set ab_b1_b5d_sdd20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_sdd20 outest=ab_b1_b5d_sdd20_b10_b6_sell tableout;
model abreturn_b1_b5d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_b1_b5d_sdd20_b10_b6_sell out=ab_b1_b5d_sdd20_b10_b6_sell;
run;

data ab_b1_b5d_sdd20_b10_b6_sell;
set ab_b1_b5d_sdd20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_b1_b5d_sdd20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_b1_b5d_sdd20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_b1_b5d_sdd20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_b1_b5d_sdd20_b10_b6_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_earning_buy_sdd20 outest=ab_a0_a1d_sdd20_b10_b6_buy tableout;
model abreturn_a0_a1d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_a0_a1d_sdd20_b10_b6_buy out=ab_a0_a1d_sdd20_b10_b6_buy;
run;

data ab_a0_a1d_sdd20_b10_b6_buy;
set ab_a0_a1d_sdd20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_sdd20 outest=ab_a0_a1d_sdd20_b10_b6_sell tableout;
model abreturn_a0_a1d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_a0_a1d_sdd20_b10_b6_sell out=ab_a0_a1d_sdd20_b10_b6_sell;
run;

data ab_a0_a1d_sdd20_b10_b6_sell;
set ab_a0_a1d_sdd20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_a0_a1d_sdd20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_a0_a1d_sdd20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_a0_a1d_sdd20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_a0_a1d_sdd20_b10_b6_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_earning_buy_sdd20 outest=ab_b5_a1d_sdd20_b10_b6_buy tableout;
model abreturn_b5_a1d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_b5_a1d_sdd20_b10_b6_buy out=ab_b5_a1d_sdd20_b10_b6_buy;
run;

data ab_b5_a1d_sdd20_b10_b6_buy;
set ab_b5_a1d_sdd20_b10_b6_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_earning_sell_sdd20 outest=ab_b5_a1d_sdd20_b10_b6_sell tableout;
model abreturn_b5_a1d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_b5_a1d_sdd20_b10_b6_sell out=ab_b5_a1d_sdd20_b10_b6_sell;
run;

data ab_b5_a1d_sdd20_b10_b6_sell;
set ab_b5_a1d_sdd20_b10_b6_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_b5_a1d_sdd20_b10_b6_buy
   outfile='F:\交易所数据\Regression Results\区分home\ab_b5_a1d_sdd20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_b5_a1d_sdd20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\ab_b5_a1d_sdd20_b10_b6_sell'
   dbms=excel
   replace;
 run;



