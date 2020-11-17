use base1;
Create table prod (
ID varchar(25), 
ProdName varchar(25), 
Supplier varchar(25),
Passport varchar(25), 
Location varchar(25), 
PRIMARY KEY (ID));
-- Создать функции для:
-- 1)Проверки, что название товара в базе состоит из букв, причем первая буква - согласная
-- 2)Проверки, что код товара есть число
-- 3)Проверки паспортных данных типа MD-77889900
-- 4)Проверки, что адрес поставщика есть Минск, Москва, Киев, Петербург.
-- 5)Проверки, что фамилия поставщика кончается на  ов, ев, ий, ой, ова, ева, ин, ын, ина, ына.
-- 6)Проверки, что в названии товара встречается сочетание букв  пог, уф, баш, роч, юк.
-- 7)Проверки, что в названии товара нет английских букв.
delimiter //
create function 4f1_CheckName(IDProd varchar(25)) returns boolean
begin
return (select ProdName regexp '^(б|в|г|д|ж|з|й|к|л|м|н|п|р|с|т|ф|х|ц|ч|ш|щ)[а-я]{0,}$' from prod where ID=IDProd);
end;
//
delimiter ;
select 4f1_CheckName(1);

delimiter //
create function 4f2_CheckID(IDProd varchar(25)) returns boolean
begin
return (select ID regexp '^[0-9]{0,}$' from prod where ID=IDProd);
end;
//
delimiter ;
select 4f2_CheckID("1");

delimiter //
create function 4f3_CheckPassport(IDProd varchar(25)) returns boolean
begin
return (select Passport regexp '^[A-Z]{2}-[0-9]{8}$' from prod where ID=IDProd);
end;
//
delimiter ;
select 4f3_CheckPassport(1);

delimiter //
create function 4f5_CheckSupplier(IDProd varchar(25)) returns boolean
begin
return (select Supplier regexp '(ов|ев|ий|ой|ова|ева|ин|ын|ина|ына)$' from prod where ID=IDProd);
end;
//
delimiter ;
select 4f5_CheckSupplier(1);

delimiter //
create function 4f6_CheckProdSpell(IDProd varchar(25)) returns boolean
begin
return (select ProdName regexp '(пог|уф|баш|роч|юк)' from prod where ID=IDProd);
end;
//
delimiter ;
select 4f6_CheckProdSpell(1);

delimiter //
create function 4f7_CheckProdLang(IDProd varchar(25)) returns boolean
begin
return (select ProdName not regexp '[a-z]' from prod where ID=IDProd);
end;
//
delimiter ;
select 4f7_CheckProdLang(1);