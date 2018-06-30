proc sql;
create table predict_return_earning_diff as select distinct a.*,
b.beijing_mean_10d as beijing_mean_10d_sell,b.shanghai_mean_10d as shanghai_mean_10d_sell,b.shenzhen_mean_10d as shenzhen_mean_10d_sell,b.other_city_mean_10d as other_city_mean_10d_sell,b.same_province_mean_10d as same_province_mean_10d_sell,b.home_mean_10d as home_mean_10d_sell,b.fund_mean_10d as fund_mean_10d_sell,
a.beijing_mean_10d-b.beijing_mean_10d as beijing_mean_10d_diff,a.shanghai_mean_10d-b.shanghai_mean_10d as shanghai_mean_10d_diff,a.shenzhen_mean_10d-b.shenzhen_mean_10d as shenzhen_mean_10d_diff,a.other_city_mean_10d-b.other_city_mean_10d as other_city_mean_10d_diff,a.same_province_mean_10d-b.same_province_mean_10d as same_province_mean_10d_diff,a.home_mean_10d-b.home_mean_10d as home_mean_10d_diff,a.fund_mean_10d-b.fund_mean_10d as fund_mean_10d_diff
from predict_return_earning_buy a left join predict_return_earning_sell b
on a.stock_code_1=b.stock_code_1 and a.release_date_1=b.release_date_1;
quit;

proc sql;
create table predict_return_earning_diff as select distinct a.*,
b.beijing_mean_5d as beijing_mean_5d_sell,b.shanghai_mean_5d as shanghai_mean_5d_sell,b.shenzhen_mean_5d as shenzhen_mean_5d_sell,b.other_city_mean_5d as other_city_mean_5d_sell,b.same_province_mean_5d as same_province_mean_5d_sell,b.home_mean_5d as home_mean_5d_sell,b.fund_mean_5d as fund_mean_5d_sell,
a.beijing_mean_5d-b.beijing_mean_5d as beijing_mean_5d_diff,a.shanghai_mean_5d-b.shanghai_mean_5d as shanghai_mean_5d_diff,a.shenzhen_mean_5d-b.shenzhen_mean_5d as shenzhen_mean_5d_diff,a.other_city_mean_5d-b.other_city_mean_5d as other_city_mean_5d_diff,a.same_province_mean_5d-b.same_province_mean_5d as same_province_mean_5d_diff,a.home_mean_5d-b.home_mean_5d as home_mean_5d_diff,a.fund_mean_5d-b.fund_mean_5d as fund_mean_5d_diff
from predict_return_earning_diff a left join predict_return_earning_sell b
on a.stock_code_1=b.stock_code_1 and a.release_date_1=b.release_date_1;
quit;

data predict_return_earning_diff;
set predict_return_earning_diff;
rename beijing_mean_10d=beijing_mean_10d_buy;
rename shanghai_mean_10d=shanghai_mean_10d_buy;
rename shenzhen_mean_10d=shenzhen_mean_10d_buy;
rename other_city_mean_10d=other_city_mean_10d_buy;
rename same_province_mean_10d=same_province_mean_10d_buy;
rename home_mean_10d=home_mean_10d_buy;
rename fund_mean_10d=fund_mean_10d_buy;

rename beijing_mean_5d=beijing_mean_5d_buy;
rename shanghai_mean_5d=shanghai_mean_5d_buy;
rename shenzhen_mean_5d=shenzhen_mean_5d_buy;
rename other_city_mean_5d=other_city_mean_5d_buy;
rename same_province_mean_5d=same_province_mean_5d_buy;
rename home_mean_5d=home_mean_5d_buy;
rename fund_mean_5d=fund_mean_5d_buy;
run;

proc sql;
create table predict_return_pricelimit_diff as select distinct a.*,
b.beijing_mean_10d as beijing_mean_10d_sell,b.shanghai_mean_10d as shanghai_mean_10d_sell,b.shenzhen_mean_10d as shenzhen_mean_10d_sell,b.other_city_mean_10d as other_city_mean_10d_sell,b.same_province_mean_10d as same_province_mean_10d_sell,b.home_mean_10d as home_mean_10d_sell,b.fund_mean_10d as fund_mean_10d_sell,
a.beijing_mean_10d-b.beijing_mean_10d as beijing_mean_10d_diff,a.shanghai_mean_10d-b.shanghai_mean_10d as shanghai_mean_10d_diff,a.shenzhen_mean_10d-b.shenzhen_mean_10d as shenzhen_mean_10d_diff,a.other_city_mean_10d-b.other_city_mean_10d as other_city_mean_10d_diff,a.same_province_mean_10d-b.same_province_mean_10d as same_province_mean_10d_diff,a.home_mean_10d-b.home_mean_10d as home_mean_10d_diff,a.fund_mean_10d-b.fund_mean_10d as fund_mean_10d_diff
from predict_return_pricelimit_buy a left join predict_return_pricelimit_sell b
on a.stock_code_1=b.stock_code_1 and a.date=b.date;
quit;

proc sql;
create table predict_return_pricelimit_diff as select distinct a.*,
b.beijing_mean_5d as beijing_mean_5d_sell,b.shanghai_mean_5d as shanghai_mean_5d_sell,b.shenzhen_mean_5d as shenzhen_mean_5d_sell,b.other_city_mean_5d as other_city_mean_5d_sell,b.same_province_mean_5d as same_province_mean_5d_sell,b.home_mean_5d as home_mean_5d_sell,b.fund_mean_5d as fund_mean_5d_sell,
a.beijing_mean_5d-b.beijing_mean_5d as beijing_mean_5d_diff,a.shanghai_mean_5d-b.shanghai_mean_5d as shanghai_mean_5d_diff,a.shenzhen_mean_5d-b.shenzhen_mean_5d as shenzhen_mean_5d_diff,a.other_city_mean_5d-b.other_city_mean_5d as other_city_mean_5d_diff,a.same_province_mean_5d-b.same_province_mean_5d as same_province_mean_5d_diff,a.home_mean_5d-b.home_mean_5d as home_mean_5d_diff,a.fund_mean_5d-b.fund_mean_5d as fund_mean_5d_diff
from predict_return_pricelimit_diff a left join predict_return_pricelimit_sell b
on a.stock_code_1=b.stock_code_1 and a.date=b.date;
quit;

data predict_return_pricelimit_diff;
set predict_return_pricelimit_diff;
rename beijing_mean_10d=beijing_mean_10d_buy;
rename shanghai_mean_10d=shanghai_mean_10d_buy;
rename shenzhen_mean_10d=shenzhen_mean_10d_buy;
rename other_city_mean_10d=other_city_mean_10d_buy;
rename same_province_mean_10d=same_province_mean_10d_buy;
rename home_mean_10d=home_mean_10d_buy;
rename fund_mean_10d=fund_mean_10d_buy;

rename beijing_mean_5d=beijing_mean_5d_buy;
rename shanghai_mean_5d=shanghai_mean_5d_buy;
rename shenzhen_mean_5d=shenzhen_mean_5d_buy;
rename other_city_mean_5d=other_city_mean_5d_buy;
rename same_province_mean_5d=same_province_mean_5d_buy;
rename home_mean_5d=home_mean_5d_buy;
rename fund_mean_5d=fund_mean_5d_buy;
run;


