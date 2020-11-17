-- B3
use b1
-- ??? Таблица "Supply" требует исправлений (по какой причине?).
-- Не находится в 3 нормальной форме(есть функцинальная зависимость неключевых атрибутов [Firm],[Address])
/* +1. Создать таблицу "Firm" с полями: 
	IDF – первичный ключ, целочисленное, авто инкремент; 
	FirmName – текстовое поле;
	Address – текстовое поле; 
	Rate – числовое поле с хранением двух знаков после запятой. */
-- ----------------------------------------------------------------------
-- Решение:
CREATE TABLE Firm (
    IDF INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    FirmName varchar(55) not null,
    Address varchar(55),
    Rate decimal(3,2),
);
-- ----------------------------------------------------------------------
/* +2. Теперь ее нужно заполнить соответствующими данными из таблицы "Supply". 
Cтавка “Rate” будет считаться: находим среднее значение “Rate,%”  
для каждой фирмы и если оно будет до 10, то новое значение – 0,1; 
				   если от 10 до 20 – 0,2; 
				   если от 20 до 30 – 0,3; 
				   в остальных случаях – 0,4. */
-- ----------------------------------------------------------------------
-- Решение:
insert into Firm (FirmName, Address, Rate) 
select s.Firm, s.Address, (case when avg(s.[Rate,%])<10 then 0.1 when avg(s.[Rate,%])<20 then 0.2
when avg(s.[Rate,%])<30 then 0.3 else 0.4 end) 
from Supply s
group by s.Firm, s.Address;

-- ----------------------------------------------------------------------
/* +3. После того как данные были перенесены в новую таблицу, можно удалить ненужные колонки “Address”, “Rate,%”.*/
-- ----------------------------------------------------------------------
-- Решение:
alter table Supply drop CONSTRAINT check_Rate, column Address, [Rate,%];
-- ----------------------------------------------------------------------
/* +4. Для хранения текущего количества альбомов от каждого поставщика создадим таблицу “Store” с полями: 
IDST – первичный ключ, целочисленное, авто инкремент; 
IDFi – целочисленное (хранит код фирмы); 
IDAl – целочисленное (хранит код альбома); 
Amount – целочисленное (хранит количество альбомов).*/
-- ----------------------------------------------------------------------
-- Решение:
CREATE TABLE Store (
    IDST INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    IDFi INT NOT NULL,
    IDAl INT NOT NULL,
    Amount INT NOT NULL,
	CONSTRAINT check_Amount CHECK (Amount BETWEEN 0 and 2147483647)
);
-- ----------------------------------------------------------------------
/* +5. Заполнить таблицу “Store”, данные для заполнения брать из таблицы “Supply”. */
-- ----------------------------------------------------------------------
-- Решение №1 (использовать view/cursor):
declare @IDF INT, @AlbumID INT, @Amount INT
declare cur cursor for
select f.IDF, al.AlbumID, sum(s.Amount)  from Supply s
join Firm f on f.FirmName=s.Firm
join Albums al on al.AlbumTitle=s.AlbumTitle
group by f.IDF, al.AlbumID
open cur
fetch next from cur into @IDF, @AlbumID, @Amount
while @@FETCH_STATUS=0
begin
insert into Store (IDFi, IDAl, Amount) 
values (@IDF, @AlbumID, @Amount)
fetch next from cur into @IDF, @AlbumID, @Amount
end
close cur
deallocate cur
-- Решение №2 (не использовать view/cursor):
insert into Store (IDFi, IDAl, Amount) 
select f.IDF, al.AlbumID, sum(s.Amount)  from Supply s
join Firm f on f.FirmName=s.Firm
join Albums al on al.AlbumTitle=s.AlbumTitle
group by f.IDF, al.AlbumID;
-- ----------------------------------------------------------------------
/* +6. Создадим таблицу “Purchases”, в ней будем хранить: 
IDP – первичный ключ, целочисленное, авто инкремент; 
IDST – целочисленное (хранит код альбома); 
IDF – целочисленное (хранит код фирмы); 
Amount – целочисленное (хранит количество приобретённых альбомов); 
PriceP – числовое поле с двумя знаками после запятой (стоимость альбома); 
DateP – хранит дату (день, месяц, год) покупки. */
-- ----------------------------------------------------------------------
-- Решение:
CREATE TABLE Purchases (
    IDP INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    IDST INT NOT NULL,
	IDF INT NOT NULL,
    Amount INT NOT NULL,
	PriceP decimal (8,2) NOT NULL,
	DateP DATE NOT NULL,
);
-- ----------------------------------------------------------------------
/* +7. Создадим процедуру для одновременного добавления информации о покупке в таблицу "Purchases" 
и редактирования актуального числа альбомов в таблице “Store”.
 Неплохо бы учесть, что продать то, чего нет – невозможно.  
 PriceP считаем как:  Price * (1 + firm.Rate + 0.18)*/
-- ----------------------------------------------------------------------
-- Решение №1:
GO  
CREATE PROCEDURE PurchasesAddRec1   
    @Firm varchar(55),   
    @AlbumTitle varchar(55),
	@Amount int
AS   
begin  
	DECLARE @FirmID int, @AlbumID int, @ArtistID int, @Price decimal (8,2);
	set @FirmID=(select f.IDF from Firm f where f.FirmName=@Firm);
	set @AlbumID=(select al.AlbumID from Albums al where al.AlbumTitle=@AlbumTitle);
	set @Price=(select SumByAlbum*(1+f.rate+0.18) as Price_Shop from 
		(select al.AlbumID AlID, sum(r.price) SumByAlbum
		from Recordings r
		join Albums al on al.AlbumID=r.AlbumID
		where al.AlbumTitle=@AlbumTitle
		group by al.AlbumID) x
		join Store s on s.IDAl=x.AlID
		join Firm f on f.IDF=s.IDFi
		where f.FirmName=@Firm
		);
	BEGIN TRANSACTION;
	update Store set Amount=Amount-@Amount where IDFi=@FirmID and IDAl=@AlbumID
	if @@ERROR=0 insert into Purchases (IDST, IDF, Amount, PriceP, DateP) values 
	(@AlbumID, @FirmID, @Amount, @Price, GETDATE());
	if not (@@ERROR=0) ROLLBACK;
    else COMMIT;     
end
GO
-- Решение №2:
GO  
CREATE PROCEDURE PurchasesAddRec2   
    @Firm varchar(55),   
    @AlbumTitle varchar(55),
	@Amount int
AS   
begin
	DECLARE @FirmID int, @AlbumID int, @Price decimal (8,2);
	set @FirmID=(select f.IDF from Firm f where f.FirmName=@Firm);
	set @AlbumID=(select al.AlbumID from Albums al where al.AlbumTitle=@AlbumTitle);
	set @Price=(select SumByAlbum*(1+f.rate+0.18) as Price_Shop from 
		(select al.AlbumID AlID, sum(r.price) SumByAlbum
		from Recordings r
		join Albums al on al.AlbumID=r.AlbumID
		where al.AlbumTitle=@AlbumTitle 
		group by al.AlbumID) x
		join Store s on s.IDAl=x.AlID
		join Firm f on f.IDF=s.IDFi
		where f.FirmName=@Firm
		);
	update Store set Amount=Amount-@Amount where IDFi=@FirmID and IDAl=@AlbumID
	if @@ERROR=0 insert into Purchases (IDST, IDF, Amount, PriceP, DateP) values 
	(@AlbumID, @FirmID, @Amount, @Price, GETDATE());
end
GO
-- ----------------------------------------------------------------------
/* +8. Добавить несколько записей о покупках.*/
-- ----------------------------------------------------------------------
-- Решение:
EXECUTE PurchasesAddRec1 'Vesta', 'Runway', 8
EXECUTE PurchasesAddRec2 'Vesta', 'Runway', 10
EXECUTE PurchasesAddRec1 'Atlant', 'The Greatest', 3
EXECUTE PurchasesAddRec2 'Diana', 'My Way', 2
EXECUTE PurchasesAddRec1 'Lyutsina', 'The Christmas', 12
EXECUTE PurchasesAddRec2 'Minerva', 'Runway', 7
-- ----------------------------------------------------------------------
/* +9. Вывести название фирмы, название купленного альбома, количество и стоимость покупки, 
одновременно вывести общий итог и итог по фирме-поставщике.  */
-- ----------------------------------------------------------------------
-- Решение:
select f.FirmName, al.AlbumTitle, p.Amount, p.PriceP*p.Amount TotalSum from Purchases p
join Albums al on al.AlbumID=p.IDST
join Firm f on f.IDF=p.IDF;
-- ----------------------------------------------------------------------
/* +10. Посчитать число альбомов, которые имеют несколько фирм-поставщиков.*/
-- ----------------------------------------------------------------------
-- Решение:
select count(r) from 
(select count(s.IDFi) r
from Store s
group by s.IDAl having count(s.IDFi)>1) x
-- ----------------------------------------------------------------------
/* +11. Вывести название треков, исполнителей и название альбомов, 
которые были куплены в этом месяце, также вывести название фирмы, стоимость альбома и цену, дату покупки.*/
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, ar.ArtistName, al.AlbumTitle, f.FirmName, p.PriceP, round(p.PriceP/(1 + f.Rate + 0.18),2) AlbPrice, p.DateP, count(p.IDP) as Selled from Purchases p
join Albums al on al.AlbumID=p.IDST
join Firm f on f.IDF=p.IDF
join Recordings r on r.AlbumID=p.IDST
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
where MONTH(p.DateP)=MONTH(GETDATE()) and YEAR(p.DateP)=YEAR(GETDATE())
group by s.SongTitle, ar.ArtistName, al.AlbumTitle, f.FirmName, p.PriceP, p.PriceP/(1 + f.Rate + 0.18), p.DateP
order by s.SongTitle, f.FirmName;
/*  +12* Продолжить исправление таблицы “Supply”. Теперь нужно заменить 
название фирмы на код фирмы, а название альбома и исполнителя заменить на код альбома.*/
-- ----------------------------------------------------------------------
-- Решение:
alter table Supply add FID int, AlID int
alter table Supply drop column ArtistName
BEGIN TRANSACTION;
insert into Albums(AlbumTitle)
select distinct s.AlbumTitle from Supply s
left join Albums al on al.AlbumTitle=s.AlbumTitle
where al.AlbumID is null
insert into Firm(FirmName)
select distinct s.Firm from Supply s
left join Firm f on f.FirmName=s.Firm
where f.IDF is null
update Supply set FID=f.IDF, AlID=Al.AlbumID
from Supply s
left join Firm f on f.FirmName=s.Firm
left join Albums Al on Al.AlbumTitle=s.AlbumTitle
alter table Supply drop column Firm, AlbumTitle
commit
-- ----------------------------------------------------------------------
/*  +13 Добавить constraint foreign key для таблиц: “Supply”, “Purchases”, “Store”.*/
-- ----------------------------------------------------------------------
-- Решение:
ALTER TABLE Supply ADD  FOREIGN KEY (FID) REFERENCES Firm (IDF), 
FOREIGN KEY (AlID) REFERENCES Albums (AlbumID); 
ALTER TABLE Purchases ADD  FOREIGN KEY (IDST) REFERENCES Albums (AlbumID),
FOREIGN KEY (IDF) REFERENCES Firm (IDF);
ALTER TABLE Store ADD  FOREIGN KEY (IDFi) REFERENCES Firm (IDF), 
FOREIGN KEY (IDAl) REFERENCES Albums (AlbumID);
-- ----------------------------------------------------------------------