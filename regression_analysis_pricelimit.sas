proc reg data=predict_pricechange_buy_sdd20 outest=ab_a0_a1d_sdd20_b5_b1_buy tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b5_b1 home_sdd20_mean_b5_b1 fund_sdd20_mean_b5_b1 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_a0_a1d_sdd20_b5_b1_buy out=ab_a0_a1d_sdd20_b5_b1_buy;
run;

data ab_a0_a1d_sdd20_b5_b1_buy;
set ab_a0_a1d_sdd20_b5_b1_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_pricechange_sell_sdd20 outest=ab_a0_a1d_sdd20_b5_b1_sell tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b5_b1 home_sdd20_mean_b5_b1 fund_sdd20_mean_b5_b1 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_a0_a1d_sdd20_b5_b1_sell out=ab_a0_a1d_sdd20_b5_b1_sell;
run;

data ab_a0_a1d_sdd20_b5_b1_sell;
set ab_a0_a1d_sdd20_b5_b1_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc export data=ab_a0_a1d_sdd20_b5_b1_buy
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b5_b1_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_a0_a1d_sdd20_b5_b1_sell
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b5_b1_sell'
   dbms=excel
   replace;
 run;

proc reg data=predict_pricechange_buy_sdd20 outest=ab_a0_a1d_sdd20_b10_b6_buy tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
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

proc reg data=predict_pricechange_sell_sdd20 outest=ab_a0_a1d_sdd20_b10_b6_sell tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b10_b6 home_sdd20_mean_b10_b6 fund_sdd20_mean_b10_b6 abreturn_b6_b20d MarCap BM;
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
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b10_b6_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_a0_a1d_sdd20_b10_b6_sell
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b10_b6_sell'
   dbms=excel
   replace;
 run;

proc reg data=predict_pricechange_buy_sdd20 outest=ab_a0_a1d_sdd20_b15_b11_buy tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b15_b11 home_sdd20_mean_b15_b11 fund_sdd20_mean_b15_b11 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_a0_a1d_sdd20_b15_b11_buy out=ab_a0_a1d_sdd20_b15_b11_buy;
run;

data ab_a0_a1d_sdd20_b15_b11_buy;
set ab_a0_a1d_sdd20_b15_b11_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_pricechange_sell_sdd20 outest=ab_a0_a1d_sdd20_b15_b11_sell tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b15_b11 home_sdd20_mean_b15_b11 fund_sdd20_mean_b15_b11 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_a0_a1d_sdd20_b15_b11_sell out=ab_a0_a1d_sdd20_b15_b11_sell;
run;

data ab_a0_a1d_sdd20_b15_b11_sell;
set ab_a0_a1d_sdd20_b15_b11_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_a0_a1d_sdd20_b15_b11_buy
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b15_b11_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_a0_a1d_sdd20_b15_b11_sell
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b15_b11_sell'
   dbms=excel
   replace;
 run;

 proc reg data=predict_pricechange_buy_sdd20 outest=ab_a0_a1d_sdd20_b20_b16_buy tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b20_b16 home_sdd20_mean_b20_b16 fund_sdd20_mean_b20_b16 abreturn_b6_b20d MarCap BM;
run;
quit; 

proc transpose data=ab_a0_a1d_sdd20_b20_b16_buy out=ab_a0_a1d_sdd20_b20_b16_buy;
run;

data ab_a0_a1d_sdd20_b20_b16_buy;
set ab_a0_a1d_sdd20_b20_b16_buy;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;

proc reg data=predict_pricechange_sell_sdd20 outest=ab_a0_a1d_sdd20_b20_b16_sell tableout;
where abs(abreturn_a0_a1d)>0.04;model abreturn_a0_a1d=nothome_sdd20_mean_b20_b16 home_sdd20_mean_b20_b16 fund_sdd20_mean_b20_b16 abreturn_b6_b20d MarCap BM;
run;
quit;

proc transpose data=ab_a0_a1d_sdd20_b20_b16_sell out=ab_a0_a1d_sdd20_b20_b16_sell;
run;

data ab_a0_a1d_sdd20_b20_b16_sell;
set ab_a0_a1d_sdd20_b20_b16_sell;
rename col1=parms col2=stderr col3=t col4=P col5=L95B col6=U95B;
format col1 best6. col4 best6.;
if _NAME_='_RMSE_' then delete;  
keep _NAME_ col1 col4;
run;


proc export data=ab_a0_a1d_sdd20_b20_b16_buy
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b20_b16_buy'
   dbms=excel
   replace;
 run;

 proc export data=ab_a0_a1d_sdd20_b20_b16_sell
   outfile='F:\交易所数据\Regression Results\区分home\pricechange\ab_a0_a1d_sdd20_b20_b16_sell'
   dbms=excel
   replace;
 run;
 

