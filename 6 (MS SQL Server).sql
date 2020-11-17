-- B2
-- +1.	К созданной ранее базе данных, применяя только SQL, добавить таблицу «Supply» (поставки), состоящую из полей: 
-- IDSU – int, Firm – varchar, Address – varchar, Amount – int, Rate,% – int, ArtistName  – varchar, AlbumTitle – varchar. 
-- ----------------------------------------------------------------------
-- Решение:
use b1;
CREATE TABLE Supply (
    IDSU int not null PRIMARY KEY,
    Firm varchar(55) not null,
    Address varchar(55),
    Amount int,
    [Rate,%] TinyInt, 
    ArtistName varchar(35),
    AlbumTitle varchar(35),
	CONSTRAINT check_Rate CHECK ([Rate,%] BETWEEN 0 and 100)
    );
-- ----------------------------------------------------------------------
-- +2.	Выпольнить запросы:
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (1, 'Akvilon', 'Bereza', 66, 24, 'Sia', 'The Greatest');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (2, 'Atlant', 'Nesvizh', 23, 11, 'Sia', 'The Greatest');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (3, 'Venera', 'Myadel', 6, 14, 'Nathan Goshen', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (4, 'Vesta', 'Slavgorod', 27, 18, 'Jp Cooper', 'Runway');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (5, 'Vulkan', 'Zhabinka', 87, 5, 'Wiz Khalifa', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (6, 'Gerkules', 'Pinsk', 42, 12, 'Calvin Harris', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (7, 'Diana', 'Malorita', 55, 8, 'Frank Sinatra', 'My Way');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (8, 'Lyutsina', 'Svetlogorsk', 21, 6, 'Frank Sinatra', 'The Christmas');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (9, 'Mars', 'Borisov', 58, 21, 'Frank Sinatra', 'World On A String');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (10, 'Merkuriy', 'Minsk', 76, 4, 'Sia', 'The Greatest');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (11, 'Minerva', 'Skidel', 22, 14, 'Jp Cooper', 'Runway');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (12, 'Salyus', 'Kalinkovichi', 59, 10, 'Jonas Blue', 'Runway');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (13, 'Talassiy', 'Ivanovo', 94, 7, 'Lil Wayne', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (14, 'Tellus', 'Cherven', 29, 10, 'Nathan Goshen', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (15, 'Triviya', 'Kossovo', 3, 9, 'Jp Cooper', 'Runway');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (16, 'Favoniy', 'Dzerzhinsk', 59, 24, 'Wiz Khalifa', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (17, 'Feb', 'Gomel', 20, 25, 'Calvin Harris', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (18, 'Elissa', 'Mogilev', 79, 20, 'Frank Sinatra', 'My Way');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (19, 'Yuventa', 'Slonim', 76, 12, 'Frank Sinatra', 'The Christmas');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (20, 'Yunona', 'Krichev', 59, 22, 'Frank Sinatra', 'World On A String');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (21, 'Yupiter', 'Molodechno', 87, 3, 'Sia', 'The Greatest');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (22, 'Diana', 'Malorita', 42, 12, 'Frank Sinatra', 'My Way');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (23, 'Lyutsina', 'Svetlogorsk', 55, 8, 'Jonas Blue', 'Runway');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (24, 'Mars', 'Borisov', 21, 6, 'Lil Wayne', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (25, 'Merkuriy', 'Minsk', 58, 21, 'Nathan Goshen', ' In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (26, 'Minerva', 'Skidel', 76, 4, 'Sia', 'The Greatest');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (27, 'Triviya', 'Kossovo', 22, 14, 'Sia', 'The Greatest');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (28, 'Favoniy', 'Dzerzhinsk', 59, 10, 'Nathan Goshen', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (29, 'Feb', 'Gomel', 94, 7, 'Jp Cooper', 'Runway');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (30, 'Elissa', 'Mogilev', 29, 10, 'Wiz Khalifa', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (31, 'Lyutsina', 'Svetlogorsk', 3, 9, 'Calvin Harris', 'In The Lonely Hour');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (32, 'Mars', 'Borisov', 42, 24, 'Frank Sinatra', 'My Way');
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values (33, 'Merkuriy', 'Minsk', 55, 25, 'Frank Sinatra', 'The Christmas');
-- +3.	Добавить записи в таблицу supply используя многоуровневый insert:
-- 			'Minerva', 'Skidel'',	21, 20,	'Frank Sinatra', 'World On A String'
-- 			'Triviya', 'Kossovo',	58,	12,	'Sia',	'The Greatest'
-- 			'Favoniy', 'Dzerzhinsk',	76,	8,	'Sia',	'The Greatest'
-- ----------------------------------------------------------------------
-- Решение:
insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values 
(34, 'Minerva', 'Skidel', 21, 20, 'Frank Sinatra', 'World On A String'),
(35, 'Triviya', 'Kossovo', 58, 12, 'Sia', 'The Greatest'),
(36, 'Favoniy', 'Dzerzhinsk', 76, 8, 'Sia', 'The Greatest');
-- ----------------------------------------------------------------------
-- +4.	Написать хранимую процедуру для добавления записи в таблицу «Supply».
-- ----------------------------------------------------------------------
-- Решение:
GO  
CREATE PROCEDURE SupplyAddRec   
    @Firm varchar(55),   
    @Address varchar(55),
	@Amount int,
	@Rate TinyInt, 
    @ArtistName varchar(35),
    @AlbumTitle varchar(35)
AS   
begin
	DECLARE @LastID int;
	set @LastID=(select max(s.IDSU) from supply s)+1;
	insert into supply (IDSU, Firm, Address, Amount, [Rate,%], ArtistName, AlbumTitle) values 
	(@LastID, @Firm, @Address, @Amount, @Rate, @ArtistName, @AlbumTitle);
end
GO  
-- ----------------------------------------------------------------------
-- +5.	Добавить запись, используя хранимую процедуру из задания 4:
-- 			'Feb', 'Gomel'',	22,	6,	'Jonas Blue',	'Runway'
-- ----------------------------------------------------------------------
-- Решение:
EXECUTE SupplyAddRec 'Feb', 'Gomel', 22, 6,	'Jonas Blue', 'Runway';  
-- ----------------------------------------------------------------------
-- +6.	Вывести название и качество записи трека отсортировав 
--сначала по качеству, затем по названию (обратный порядок), не включая плохие записи.
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, r.Quality from Recordings r
join Songs s on s.SongID=r.SongID
where not r.Quality='L'
order by r.Quality, s.SongTitle desc;
-- ----------------------------------------------------------------------
-- +7.	Вывести название и цену трех самых дешевых альбомов.
-- ----------------------------------------------------------------------
-- Решение:
select top (3) al.AlbumTitle, sum(r.price) as AlbumPrice
from Recordings r
join Songs s on s.SongID=r.SongID
join Albums al on al.AlbumID=r.AlbumID
group by al.AlbumTitle
order by AlbumPrice;
-- ----------------------------------------------------------------------
-- +8.	Вывести альбом второй по стоимости после самого дорогого альбома.
-- ----------------------------------------------------------------------
-- Решение:
select al.AlbumTitle, sum(r.price) as AlbumPrice
from Recordings r
join Songs s on s.SongID=r.SongID
join Albums al on al.AlbumID=r.AlbumID
group by al.AlbumTitle
order by AlbumPrice desc offset 1 rows fetch next 1 rows only;
-- ----------------------------------------------------------------------
-- +9.	Найти альбом, у которого нет исполнителя.
-- ----------------------------------------------------------------------
-- Решение №1:(В альбоме есть песни у которых нет исполнителя)
select distinct al.AlbumTitle
from Albums al
left join Recordings r on r.AlbumID=al.AlbumID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
where ar.ArtistName is null;
-- Решение №2:(У всех песен в альбоме нет исполнителей)
select distinct al.AlbumTitle
from Albums al
left join Recordings r on r.AlbumID=al.AlbumID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
group by al.AlbumTitle having count(ar.ArtistName)=0;
-- ----------------------------------------------------------------------
-- +11.	Найти треки, у которых название начинается не с букв.
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, ar.ArtistName
from Recordings r
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
where s.SongTitle like '[^a-z]%';
-- ----------------------------------------------------------------------
-- +12.	Найти все треки, которые начинаются на гласные буквы.
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, ar.ArtistName
from Recordings r
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
where s.SongTitle like '[aoeyiu]%';
-- ----------------------------------------------------------------------
-- +13.	Посчитать отпускную цену альбомов по формуле: 
-- Price_Shop = Price*(1+ Rate, %/100+w); 
--		 где: Price – цена альбома из таблицы Album; 
-- Rate,% – из таблицы «Supply» ; 
-- w=10% при Amount < 50,
-- w=20% при Amount = 50, 
-- w=30% при Amount > 50
-- Результат отсортировать сначала по названию в алфавитном порядке, затем по убыванию цены. 
-- ----------------------------------------------------------------------
-- Решение:
select s.Firm,s.AlbumTitle,s.ArtistName, 
SumByAlbum*(1+(s.[Rate,%]/100.0)+(case when s.Amount<50 then 0.1 when s.Amount=50 then 0.2 else 0.3 end)) as Price_Shop from 
(select al.AlbumTitle AlT,ar.ArtistName ArN, sum(r.price) SumByAlbum
from Recordings r
join Albums al on al.AlbumID=r.AlbumID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
group by al.AlbumTitle, ar.ArtistName) x
join Supply s on s.ArtistName=x.ArN and s.AlbumTitle=x.AlT
order by s.AlbumTitle, Price_Shop desc;
-- ----------------------------------------------------------------------