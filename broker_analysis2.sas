data investors;
set broker.investors_all;
if age^=.;
if substr(idcardno,1,2)='11' or substr(idcardno,1,2)='12' or substr(idcardno,1,2)='31' or substr(idcardno,1,2)='50' then city_code=input(substr(idcardno,1,2),6.)*100;
else city_code=substr(idcardno,1,4);
run;

proc sql;
create table investors as select distinct a.*,substr(b._col1,1,4) as province,substr(b._col2,1,4) as city from investors a left join broker.city_code b
on a.city_code=b._col4;
create table investors as select distinct a.*,b.province as branch_province,b.branch_city from investors a left join broker.minzu_code b
on a.network=b.branch_code;
quit;

data investors;
set investors;
if city=branch_city then local_city=1;
else local_city=0;
if province=branch_province then local_province=1;
else local_province=0;
run;

proc sql;
create table local_ratio as select distinct network,mean(local_province) as local_ratio from investors
group by network;
quit;

proc sort;
by descending local_ratio;
run;

proc sql;
create table first as select distinct a.*,b.local_city from temp2_1_1 a left join investors b
on a.network=b.network and a.fundacc=b.fundacc;
create table first as select distinct a.*,b.local_city from temp3_1 a left join first b
on a.network=b.network and a.code=b.code and a.date=b.date;
quit;

proc sql;
create table local_ratio_first as select distinct local_city,count(code) as count,mean(ratio_1st) as ratio_1st,mean(imb_1st) as imb_1st,mean(abs(imb_1st)) as imb_1st_abs from first
where network not in (select distinct branch_code from broker.minzu_code where branch_city='北京' or branch_city='上海' or branch_city='深圳' or branch_city='广州') 
group by local_city;
create table local_ratio_first_home as select distinct local_city,count(code) as count,mean(ratio_1st) as ratio_1st,mean(imb_1st) as imb_1st,mean(abs(imb_1st)) as imb_1st_abs from first
where branch_type='home_city' and network not in (select distinct branch_code from broker.minzu_code where branch_city='北京' or branch_city='上海' or branch_city='深圳' or branch_city='广州') 
group by local_city;
quit;


