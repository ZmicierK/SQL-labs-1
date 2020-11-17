-- 1. создать базу данных.
create database lab1;
use lab1;
-- 2. создать таблицы:
create table manuf(
IDM int not null,
Name varchar(64),
city varchar(32),
primary key(IDM)
);
-- manuf : таблица, хранящая названия фирм 
-- 		ГДЕ:
-- IDM : код фирмы (первичный ключ)
-- Name: название фирмы
-- city: город, где находится фирма
create table cpu(
IDС int not null,
IDM int,
Name varchar(64),
clock decimal(6,1),
primary key(IDС)
);
-- cpu : таблица, хранящая названия и характеристики процессоров
-- 		ГДЕ:
-- IDС :  код модели процессора (первичный ключ)
-- IDM: код фирмы производителя процессора
-- Name:  название модели процессора
-- clock: частота работы процессора с точностью до одной десятой
create table hdisk(
IDD int not null,
IDM int not null,
Name varchar(64),
type varchar(16),
size int unsigned,
primary key(IDD)
);
-- hdisk : таблица, хранящая названия и характеристики дисков
-- 		ГДЕ:
-- IDD: код модели диска (первичный ключ)
-- IDM: код фирмы производителя диска
-- Name: название модели диска
-- type: тип диска 
-- size: размер диска
create table nb(
IDN int not null,
IDM int not null,
Name varchar(64),
IDC int not null,
IDD int not null,
primary key(IDN)
);
-- nb : таблица, хранящая комплектацию ноутбука
-- 		ГДЕ:
-- IDN: код модели (первичный ключ)
-- IDM: код фирмы производителя ноутбука
-- name: название модели ноутбука
-- IDC: код модели процессора 
-- IDD: код модели диска
create table Phone(
IDP int not null,
IDM int not null,
Number decimal(12,0),
NameManager varchar(64),
primary key(IDP)
);
-- Phone : таблица, хранящая телефон менеджера 
-- 		ГДЕ:
-- IDP: табельный номер сотрудники (первичный ключ)
-- IDM: код фирмы на которой работает сотрудник 
-- Number: номер телефона
-- NameManager: имя менеджера

-- 3. Выполнить запросы:

insert into manuf values 
(1, 'Intel', 'Santa Clara'), 
(2, 'AMD', 'Santa Clara'), 
(3, 'WD', 'San Jose'), 
(4, 'seagete', 'Cupertino'), 
(5, 'Asus', 'Taipei'), 
(6, 'Dell','Round Rock');

insert into CPU values 
(1, 1, 'i5', 3.2),
(2, 1, 'i7', 4.7),
(3, 2, 'Ryzen 5', 3.2),
(4, 2, 'Ryzen 7', 4.7),
(5, null, 'Power9', 3.5);

insert into hdisk values 
(1, 3, 'Green', 'hdd', 1000),
(2, 3, 'Black', 'ssd', 256),
(3, 1, '6000p', 'ssd', 256),
(4, 1, 'Optane', 'ssd', 16);

insert into nb values 
(1, 5, 'Zenbook', 2, 2),
(2, 6, 'XPS', 2, 2),
(3, 9, 'Pavilion', 2, 2),
(4, 6, 'Inspiron', 3, 4),
(5, 5, 'Vivobook', 1, 1),
(6, 6, 'XPS', 4, 1);

-- 4. Заполнить таблицу Phone произвольными данными.
insert into Phone values
(1, 5, 375294856034, "Santa Petrova"),
(2, 6, 375294856044, "Sidor Petrov"),
(3, 4, 375294856035, "Hanta Petrova"),
(4, 2, 375294856038, "Santarin Meshkov"),
(5, 3, 375294856039, "Venta Petrova"),
(6, 1, 375294856030, "Santa Klaus");
-- 5. Написать запросы чтобы вывести данные: 

-- +5.1	Название фирмы и модель диска (Список не должен содержать значений NULL)
-- ----------------------------------------------------------------------
-- Решение:
select  manuf.name as Manufacture, hdisk.name as Hdisk
from hdisk
join manuf on manuf.idm=hdisk.idm
where hdisk.name is not null and manuf.name is not null;
-- +5.2	Модель процессора и, если есть информация в БД, название фирмы;
-- ----------------------------------------------------------------------
-- Решение:
select  manuf.name as Manufacture, cpu.name as cpu
from cpu
left join manuf on manuf.idm=cpu.idm
where cpu.name is not null;
-- ----------------------------------------------------------------------
-- +5.3	Название фирмы, которая производить несколько типов товара;
-- ----------------------------------------------------------------------
-- Решение:
select DISTINCT m.idm, m.name 
from manuf m,nb n,cpu c,hdisk h
where
m.idm=n.idm and m.idm=c.idm 
or 
m.idm=h.idm and m.idm=c.idm 
or 
m.idm=n.idm and m.idm=h.idm;
-- ----------------------------------------------------------------------
-- +5.4	Модели ноутбуков без информации в базе данных о фирме изготовителе;
-- ----------------------------------------------------------------------
-- Решение:
select nb.name
from nb
left join manuf on manuf.IDM=nb.IDM 
where manuf.name is null;
-- ----------------------------------------------------------------------
-- +5.5	Модель ноутбука и название производителя ноутбука, название модели процессора, название модели диска.
-- ----------------------------------------------------------------------
-- Решение:
select m.name as Manufacture, n.name as NbName, c.name as CPU, h.name as hdisk
from nb n
left join manuf m on n.IDM=m.IDM
left join cpu c on n.IDC=c.IDС
left join hdisk h on n.IDD=h.IDD;
-- ----------------------------------------------------------------------
-- +5.6	Модель ноутбука, фирму производителя ноутбука, а также для этой модели: 
-- 				модель и название фирмы производителя процессора,
-- 				модель и название фирмы производителя диска.
-- ----------------------------------------------------------------------
-- Решение:
select m.name as ManufNb, n.name as NbName, mc.name as ManufCPU, c.name as CPU, md.name as ManufHdisk, h.name as Hdisk
from nb n
left join manuf m on n.IDM=m.IDM
left join cpu c on n.IDC=c.IDС
left join manuf mc on c.IDM=mc.IDM
left join hdisk h on n.IDD=h.IDD
left join manuf md on h.IDM=md.IDM;
-- ----------------------------------------------------------------------
-- +5.7	 Абсолютно все названия фирмы и все модели процессоров 
-- ----------------------------------------------------------------------
-- Решение:
select manuf.name as ManufName, cpu.name as CpuName
from manuf
left join cpu on cpu.IDС=manuf.IDM
union
select manuf.name as ManufName, cpu.name as CpuName
from manuf
right join cpu on cpu.IDС=manuf.IDM;