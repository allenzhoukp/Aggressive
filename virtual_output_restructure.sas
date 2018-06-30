data virtual_restruc_car_BS_pos;
set
virtual_S3001_car_full_30  virtual_S3001_car_full_20  virtual_S3001_car_full_10
virtual_S3001_car_part_30  virtual_S3001_car_part_20  virtual_S3001_car_part_10
virtual_S3002_car_full_30  virtual_S3002_car_full_20  virtual_S3002_car_full_10
virtual_S3002_car_part_30  virtual_S3002_car_part_20  virtual_S3002_car_part_10
virtual_S3003_car_full_30  virtual_S3003_car_full_20  virtual_S3003_car_full_10
virtual_S3003_car_part_30  virtual_S3003_car_part_20  virtual_S3003_car_part_10
virtual_S3004_car_full_30  virtual_S3004_car_full_20  virtual_S3004_car_full_10
virtual_S3004_car_part_30  virtual_S3004_car_part_20  virtual_S3004_car_part_10
virtual_S3005_car_full_30  virtual_S3005_car_full_20  virtual_S3005_car_full_10
virtual_S3005_car_part_30  virtual_S3005_car_part_20  virtual_S3005_car_part_10
virtual_S3008_car_full_30  virtual_S3008_car_full_20  virtual_S3008_car_full_10
virtual_S3008_car_part_30  virtual_S3008_car_part_20  virtual_S3008_car_part_10;
length Type $20.;
if _n_=1 then Type='S3001_full_30';
if _n_=2 then Type='S3001_full_20';
if _n_=3 then Type='S3001_full_10';
if _n_=4 then Type='S3001_part_30';
if _n_=5 then Type='S3001_part_20';
if _n_=6 then Type='S3001_part_10';
if _n_=7 then Type='S3002_full_30';
if _n_=8 then Type='S3002_full_20';
if _n_=9 then Type='S3002_full_10';
if _n_=10 then Type='S3002_part_30';
if _n_=11 then Type='S3002_part_20';
if _n_=12 then Type='S3002_part_10';
if _n_=13 then Type='S3003_full_30';
if _n_=14 then Type='S3003_full_20';
if _n_=15 then Type='S3003_full_10';
if _n_=16 then Type='S3003_part_30';
if _n_=17 then Type='S3003_part_20';
if _n_=18 then Type='S3003_part_10';
if _n_=19 then Type='S3004_full_30';
if _n_=20 then Type='S3004_full_20';
if _n_=21 then Type='S3004_full_10';
if _n_=22 then Type='S3004_part_30';
if _n_=23 then Type='S3004_part_20';
if _n_=24 then Type='S3004_part_10';
if _n_=25 then Type='S3005_full_30';
if _n_=26 then Type='S3005_full_20';
if _n_=27 then Type='S3005_full_10';
if _n_=28 then Type='S3005_part_30';
if _n_=29 then Type='S3005_part_20';
if _n_=30 then Type='S3005_part_10';
if _n_=31 then Type='S3008_full_30';
if _n_=32 then Type='S3008_full_20';
if _n_=33 then Type='S3008_full_10';
if _n_=34 then Type='S3008_part_30';
if _n_=35 then Type='S3008_part_20';
if _n_=36 then Type='S3008_part_10';
drop _type_ _page_ _table_;
run;


proc export data=virtual_restruc_car_BS_pos
   outfile='F:\交易所数据\Virtual\virtual_restruc_car_BS_pos'
   dbms=excel
   replace;
 run;

