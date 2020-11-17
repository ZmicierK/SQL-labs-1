create database base1;
use base1;
create table sklad(
Tovar varchar(25),
price int, 
kol int,
postavka Date,
Primary KEY(tovar)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/load.txt' INTO TABLE sklad;
-- Создать хранимые процедуры для
-- 1)Вставки записи и ее обновления.
-- 2)Подсчета налога со всех товаров.
-- 3)Получения точного названия товара по первым буквам.
-- 4)Работы с курсором (подсчитать число  записей с одинаковым названием товара).
-- Создать функции для:
-- 1)Вычисления налога в зависимости от цены и количества товара
-- 2)Вычисления средней цены товара по таблице
delimiter //
create procedure 1_Add(IN tov varchar(25), pr int, k int, post date)
begin
insert into sklad (Tovar, price, kol, postavka) 
values(tov, pr, k, post);
end;
//
delimiter ;
call 1_Add("lemon", 2000, 600, "2011-01-18");

delimiter //
create procedure 1_Upd(IN tov varchar(25), pr int, k int, post date)
begin
update sklad set price=pr, kol=k, postavka=post 
where (Tovar=tov);
end;
//
delimiter ;
call 1_Upd("lemon", 2100, 600, "2011-01-18");

delimiter //
create procedure 2_TaxSum(IN tax float, OUT TS float)
begin
Select sum(price * kol * tax) into TS from sklad;  
end;
//
delimiter ;
call 2_TaxSum(0.001,@x);
select @x;

delimiter //
create procedure 3_GetItemName(IN tovAbr varchar(25), OUT tovFull varchar(25))
begin
Select group_concat(tovar) into tovFull from sklad where tovar like concat(tovAbr, '%'); 
end;
//
delimiter ;
call 3_GetItemName("lem",@x);
select @x;

delimiter //
create procedure 4_SameNameCount(OUT o int)
begin
Declare cur cursor for select count(tovar) from (select tovar from sklad group by tovar having count(tovar)>1) as Grouped;
open cur;
fetch cur into o;
close cur;
end;
//
delimiter ;
call 4_SameNameCount(@x);
select @x;

set global log_bin_trust_function_creators=1;

delimiter //
create function f1_TaxCount(ItemName varchar(25)) returns float
begin
declare pr,k float;
select price, kol into pr, k from sklad where tovar=ItemName;
if pr*k>1300000 then return pr*k*0.01; else return pr*k*0.001; end if;
end;
//
delimiter ;
select f1_TaxCount("lemon");

delimiter //
create function f2_AvgPrice() returns float
begin
return (select avg(price) from sklad);
end;
//
delimiter ;
select f2_AvgPrice();