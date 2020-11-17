Create database B1;
use b1;
CREATE TABLE Basic (
    SongTitle VARCHAR(35),
    Quality varchar(1),
    Duration INT,
    DateRecord DATE,
    AlbumTitle varchar(35), 
    price decimal (5,2),
    ArtistName varchar(35),
    [e-mail] varchar(35)
    );
insert into Basic (SongTitle, Quality, Duration, DateRecord, AlbumTitle, price, ArtistName, [e-mail]) values 
('Sing Me To Sleep', 'H', 176, '2019-08-29',null, null, 'Alan Walke', 'AlanWalker@mail.com'),
('The Greatest', 'L', 88, '2020-10-24', 'The Greatest', 2.38, 'Sia', null),
('Cheap Thrills', 'M', 115, '2017-07-16', 'The Greatest', 2.38, 'Sia', null),
('Ocean Drive', 'M', 101,	'2019-12-04', null, null, 'Duke Dumont', null),
('No Money', 'M',	126, '2019-05-11', 'In The Lonely Hour', 3.63, null, null),
('Thinking About It', 'L', 170, '2020-01-14', 'Evolution', 1.88, 'Nathan Goshen', null),
('Perfect Strangers', 'L', 189, '2019-09-06', 'Runway', 2.75, 'Jonas Blue', null),
('Perfect Strangers', 'L', 189, '2019-09-06', 'Runway', 2.75, 'Jp Cooper', null),
('Thinking About It', 'M', 179, '2018-10-25','In The Lonely Hour',3.25, 'Alan Walke', 'AlanWalker@mail.com'),
('Thinking About It', 'M', 179, '2018-10-25','In The Lonely Hour',3.25, 'Jp Cooper', null),
('My Way', 'H', 163, '2020-07-26','My Way', 1.63, 'Frank Sinatra', null),	
('My Way', 'H', 157,	'1985-01-11','The Christmas', 3.63, 'Frank Sinatra', null),
('Let It Snow!', 'M', 158, '1984-03-05','World On A String', 3.38, 'Frank Sinatra', null);

-- Выполнить представленные выше запросы.
-- Нормальзвать базу данных. 
-- Создать новые таблицы (назания полей взять из таблицы Basic),
drop table Recordings, Albums, Songs,Artists;
CREATE TABLE Artists (
    ArtistID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ArtistName varchar(35) UNIQUE NOT NULL,
    [e-mail] varchar(35)
    );
CREATE TABLE Albums (
	AlbumID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    AlbumTitle varchar(35) UNIQUE NOT NULL, 
    );
CREATE TABLE Songs (
	SongID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    SongTitle VARCHAR(35) UNIQUE NOT NULL,
    );
CREATE TABLE Recordings(
	RecordingID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Quality char(1),
    Duration INT,
    DateRecord DATE, 
    price decimal (5,2),
	SongID INT NOT NULL FOREIGN KEY REFERENCES Songs(SongID),
	AlbumID INT FOREIGN KEY REFERENCES Albums(AlbumID),
    );
CREATE TABLE RecBands (
	RecID INT NOT NULL FOREIGN KEY REFERENCES Recordings(RecordingID) ON DELETE CASCADE,
    ArtistID INT NOT NULL FOREIGN KEY REFERENCES Artists(ArtistID)
    );
-- заполнить их с помощью запросов из таблицы Basic
insert into Artists (ArtistName, [e-mail]) 
select distinct b.ArtistName, b.[e-mail] from Basic b
where b.ArtistName is not null;

insert into Albums (AlbumTitle) 
select distinct b.AlbumTitle from Basic b
where b.AlbumTitle is not null;

insert into Songs (SongTitle) 
select distinct b.SongTitle from Basic b
where b.SongTitle is not null;

insert into Recordings (Quality, Duration, DateRecord, price, SongID, AlbumID) 
select distinct b.Quality, b.Duration, b.DateRecord, b.price, s.SongID, al.AlbumID  from Basic b
join Songs s on s.SongTitle=b.SongTitle
left join Albums al on al.AlbumTitle=b.AlbumTitle;

insert into RecBands(RecID, ArtistID)
select r.RecordingID, ar.ArtistID from Basic b
left join Artists ar on ar.ArtistName=b.ArtistName
left join Albums al on al.AlbumTitle=b.AlbumTitle
left join Songs s on s.SongTitle=b.SongTitle
right join Recordings r on r.DateRecord=b.DateRecord and r.Duration=b.Duration and r.Quality=b.Quality and r.SongID=s.SongID
where ar.ArtistID is not null
-- Создать запросы (таблицу basic использовать не допускается):
-- +1. Вывести поля: SongTitle, Quality, Duration, DateRecord, AlbumTitle, 
-- price, ArtistName, [e-mail] из полученных в ходе нормализации таблиц
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, r.Quality, r.Duration, r.DateRecord, al.AlbumTitle, r.price, ar.ArtistName --, ar.[e-mail]
from Recordings r
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
left join Albums al on al.AlbumID=r.AlbumID;
-- ----------------------------------------------------------------------
-- +2. Добавить новую компазицию - назание: "Can't Stop The Feeling", исполнителя: "Jonas Blue", 
-- продолжительностью 253 секунды, качество - "M", в "DateRecord" указать текущию дату.
-- ----------------------------------------------------------------------
-- Решение:
DECLARE @ArID int, @SongID int, @RecID int;
set @ArID=(select a.ArtistID from Artists a where a.ArtistName='Jonas Blue');
if @ArID is null 
begin
	insert into Artists(ArtistName) values('Jonas Blue')
	set @ArID=SCOPE_IDENTITY()
end;
set @SongID=(select s.SongID from Songs s where s.SongTitle='Can''t Stop The Feeling');
if @SongID is NULL
begin
select @SongID
	insert into Songs(SongTitle) values ('Can''t Stop The Feeling')
	set @SongID=SCOPE_IDENTITY()
end;
insert into Recordings (Quality, Duration, DateRecord, price, SongID, AlbumID) values 
('M', 253, GETDATE(), null, @SongID, null);
set @RecID=SCOPE_IDENTITY()
insert into RecBands(RecID, ArtistID) values(@RecID, @ArID)
-- ----------------------------------------------------------------------
-- +3. Переименовать аудио запасись "Thinking About It" в "Let It Go"
-- ----------------------------------------------------------------------
-- Решение:
update Songs
set SongTitle='Let It Go'
where SongTitle='Thinking About It'
-- ----------------------------------------------------------------------
-- +4. Удалить колонку "e-mail", создать колонку "WebSite", задав по умолчанию значение «нет»
-- ----------------------------------------------------------------------
-- Решение:
alter table Artists drop column [e-mail]
alter table Artists add WebSite varchar(55) default 'нет'
-- ----------------------------------------------------------------------
-- +5. Вывести все аудио запасиси, отобразив, если имеется, имя исполнится и альбом
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, al.AlbumTitle, ar.ArtistName
from Recordings r
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
left join Albums al on al.AlbumID=r.AlbumID;
-- ----------------------------------------------------------------------
-- +6. Вывести все аудио запасиси, у которых в названии альбома есть «way» 
-- ----------------------------------------------------------------------
-- Решение:
select s.SongTitle, al.AlbumTitle, ar.ArtistName
from Recordings r
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
left join Albums al on al.AlbumID=r.AlbumID
where al.AlbumTitle like '%way%';
-- ----------------------------------------------------------------------
-- +7. Вывести: название, стоимость альбома и его исполнителя при условии, 
-- что он будет самым дорогим для каждого исполнителя.
-- ----------------------------------------------------------------------
-- Решение:
select x.ArN ArtistName, x.AlT AlbumTitle, x.MaxPriceAlb from(
select ar.ArtistName ArN, al.AlbumTitle AlT,sum(r.price) srp, max(sum(r.price)) OVER (PARTITION BY ar.ArtistName) MaxPriceAlb
from Recordings r
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
join Albums al on al.AlbumID=r.AlbumID
group by ar.ArtistName, al.AlbumTitle) x
where x.srp=x.MaxPriceAlb and x.ArN is not null;
-- ----------------------------------------------------------------------
-- +8. Удалить запись "Can't Stop The Feeling" исполнителя "Jonas Blue".
-- ----------------------------------------------------------------------
-- Решение:
delete from Recordings 
from Recordings r
join Songs s on s.SongID=r.SongID
left join RecBands rb on rb.RecID=r.RecordingID
left join Artists ar on ar.ArtistID=rb.ArtistID
where s.SongTitle  = 'Can''t Stop The Feeling' AND
ar.ArtistName = 'Jonas Blue';
-- ---------------------------------------------------------------------