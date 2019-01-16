-- Установка
-- Download link: https://www.microsoft.com/en-in/download/details.aspx?id=42299
-- Поставить галочки: 	
-- Express 64BIT\SQLEXPR_x64_RUS.exe
-- MgmtStudio 64BIT\SQLManagementStudio_x64_RUS.exe

-- Установка Express: новый sql сервер, везде галочки, дефолтные настройки
-- "Менеджер конфигураций" - запуск и остановка локального сервера
-- Установка Management Studio: новый sql сервер, везде галочки, дефолтные настройки


-- Examples from seminars

-- Inner join, where, group by, order by
Select top 1000
	Name, sum(s.LineTotal) sumLine
	count(*) cnt
from Sales.SalesOrderDetail s
inner join Production.Product p on s.ProductID = p.ProductID
where s.ProductID = 777
group by Name
order by sumLine desc


-- Casting formats
Select top 1000 [BusinessEntityID]
	cast(BusinessEntityID as text) BusinessEntityID_text
	,text(BusinessEntityID) BusinessEntityID_text
	,convert(varchar(10), BusinessEntityID) BusinessEntityID_text
	,[LoginId]
	,[BirthDate]
	,year(BirthDate) binfo
	,datepart(WEEKDAY, [BirthDate]) binfo
	,'1960-01-01 00:01:10' "startTime"
	,cast('1960-01-01 00:01:10' as time(0)) "time"
	,cast(cast('1960-01-01 00:01:10' as time(0)) as datetime) "dateFtime"
	,cast('1960-01-01 00:01:10' as date) "date"
from [AdventureWorks2014].[HumanResources].[Employee]
where BirthDate between '1960-01-01 00:01:10' and '1980-01-01'
and datepart(WEEKDAY, [BirthDate]) = 1
and cast([ModifiedDate] as time(0)) between '01:00:00' and '23:00:00'
and cast([ModifiedDate] as time(0)) = '00:00:00'
and BusinessEntityID like '%3%'
and Convert(varchar(10), BusinessEntityID) like '%3%'

where e.JobTitle like '%Manager%' and e.VacationHours > 10

Select datepart(month, [OrderDate])
	,[LineTotal]
from ...
order by datepart(month, [OrderDate])





-- Вложенные запросы
Select Mon
	,AVG(Summa) Average
	from (Select datepart(month, [OrderDate]) Mon
		,sum(LineTotal) Summa
	from ...
	group by OrderDate) sumMon
group by Mon
order by Mon

-- case, right join
Select top 1000 pc.Name ProductCat,
	case when month(OrderDate) = 1 then LineTotal end Jan
	case when month(OrderDate) = 2 then LineTotal end Feb
from Sales.SalesOrderDetail d
join [Sales].SalesOrderHeader h on h.SalesOrderID = d.SalesOrderID
right join Production.Product p on p.ProductID = d.ProductID
right join Production.ProductSubCategory  ps on ps.ProductSubCategoryID = p.ProductSubCategoryID
right join Production.ProductCategory  pc on ps.ProductCategoryID = p.ProductCategoryID

group by pc.Name, month(OrderDate)
order by pc.Name, month(OrderDate)

-- Создание таблиц в схемах
create schema andreySchema

create table andreySchema.withColumnsNotNull (
	ProductID int not null,
	ProductName text not null,
	OrderDate date not null
);

insert into andreySchema.withColumnsNotNull (ProductID, ProductName, OrderDate)
	values (1, 'Apple', '2018-01-01');





-- Копирование данных из таблицы бд в схему бд
Select *
into andreySchema.AdvSailesDetailCopy  -- таблица в схеме создаётся автоматически
from AdventureWorks2014.Sales.SalesOrderDetail

-- Создание столбца
alter table andreySchema.Person
add Experimental text

-- Обновление столбца
update andreySchema.Person
set Experimental = '0'
where LastName like 'X%'

update andreySchema.Person
set Experimental = ''
where LastName like 'X%'

-- Удаление столбца
alter table andreySchema.Person
drop column Experimental

-- Examples
update andreySchema.Person
set Experimental = LastName
where Experimental is null

update andreySchema.Person
set Experimental = case when BusinessEntityID like '%3' then FirstName
						when BusinessEntityID like '%4' then MiddleName
						else LastName end
where LastName like 'X%'

-- Изменение типа данных
alter table andreySchema.Person
alter column Experimental numeric

-- Удаление столбца
alter table andreySchema.Person
drop column Experimental

-- Examples
delete from andreySchema.Person where BusinessEntityID = 9264
drop table andreySchema.Person

-- 2 задание
alter table andreySchema.Person
add ExpInt int

alter table andreySchema.Person
add ExpDbl float

alter table andreySchema.Person
add ExpTxt text

-- 3 задание
update andreySchema.Person
set ExpInt = case when FirstName like '%o%' then BusinessEntityID end

update andreySchema.Person
set ExpDbl = case when BusinessEntityID < 9000 then cast(BusinessEntityID as float) / 3 end

update andreySchema.Person
set ExpTxt = coalesce(substring(LastName, 0, 1), '_') + coalesce(substring(FirstName, 0, 1), '_') + coalesce(substring(MiddleName, 0, 1), '_')

Select det.SalesOrderID Id
		,curFrom.Name
		,sum(LineTotal) TotalFrom
		,curTo.Name
		,sum(LineTotal * AverageRate) TotalTo
	from AdventureWorks2014.Sales.SalesOrderDetail as det
	inner join AdventureWorks2014.Sales.SalesOrderHeader as head on det.SalesOrderID = head.SalesOrderID
	inner join AdventureWorks2014.Sales.CurrencyRate as rate on head.CurrencyRateID = rate.CurrencyRateID
	left join AdventureWorks2014.Sales.Currency as curFrom on rate.FromCurrencyCode = curFrom.CurrencyCode
	left join AdventureWorks2014.Sales.Currency as curTo on rate.ToCurrencyCode = curTo.CurrencyCode

	group by det.SalesOrderID, curFrom.Name, curTo.Name
	order by Id





-- Процедуры
create proc test_select -- название процедуры
as
Select * from andreySchema.Person -- исполняемая команда

create proc test_select_where
as
Select * from andreySchema.Person where FirstName like '%J%'

exec test_select
exec test_select_where

-- Функции
create function andreySchema.starts_with(@letter char)
returns table
as
return (
	Select *
	from andreySchema.Person as p
	where FirstName like @letter + '%'
);
go

Select * from andreySchema.starts_with('q')


create function andreySchema.left_char(@letter nvarchar(50))
	returns nvarchar
as 
begin
	return(reverse(left(@letter, 4)))
end
go

Select FirstName
		,left(FirstName, 4) l
		,reverse(FirstName) rev
		,reverse(left(FirstName, 4)) f
		,len(FirstName) ln
		,andreySchema.left_char(FirstName) q from andreySchema.Person
	where len(FirstName) < 4


-- Триггеры
create trigger test_trigger -- название триггера
on andreySchema.Person  -- название таблицы для которой триггер вызывается
After insert, update -- условия вызова триггера (после вставки данных)
as
	if exists(select 1 from andreySchema.Person group by BusinessEntityID having count(*) > 1)
	begin
		Rollback transaction;
	end
go

select * from andreySchema.Person where BusinessEntityID > 20776

insert into andreySchema.Person(BusinessEntityID, PersonType, FirstName, MiddleName, LastName, EmailPromotion)
	values (20780, 'IN', 'Name', 'Mname', 'Lname', 0)


create trigger [andreySchema].[Person].trigger_validation
	on andreySchema.Person
	after insert, update
	as
	if exists(select * from inserted where FirstName like 'J%')
		begin
			update andreySchema.Person
			set andreySchema.Person.PersonType = 'IN', andreySchema.Person.EmailPromotion = 10
			where andreySchema.Person.BusinessEntityID = (select BusinessEntityID from inserted)
		end
	else
		begin
			Rollback transaction
		end
	go


insert into andreySchema.Person (BusinessEntityID, PersonType, FirstName, MiddleName, LastName, EmailPromotion)
	values ((select max(BusinessEntityID) + 1 from andreySchema.Person), '', 'Jackob', 'Anton', 'Andrey', 112)


-- Первое задание
Select BusinessEntityID
	,PersonType
	,FirstName
	,MiddleName
	,LastName
	,EmailPromotion
into andreySchema.Person
from AdventureWorks2014.Person.Person

-- Второе задание
drop procedure get_name

create proc get_name
as
select FirstName, count(*) name_count 
	from andreySchema.Person
group by FirstName

exec get_name

-- Третье задание
create procedure andreySchema.insert_data(@first_name nvarchar(50), @last_name nvarchar(50), @middle_name nvarchar(50))
as
begin
	insert into andreySchema.Person(BusinessEntityID, PersonType, FirstName, MiddleName, LastName, EmailPromotion)
		values ((select max(BusinessEntityID) + 1 from andreySchema.Person), '', @first_name, @middle_name, @last_name, 0)
	end
	go
	exec andreySchema.Person.insert_data 'Андрей', 'Волков', 'Андреевич'

-- Четвертое задание
create trigger [andreySchema].[Person].trigger_validation
	on andreySchema.Person
	after insert, update
	as
	if exists(select * from inserted where FirstName like 'J%')
		begin
			update andreySchema.Person
			set andreySchema.Person.PersonType = 'IN', andreySchema.Person.EmailPromotion = 10
			where andreySchema.Person.BusinessEntityID = (select BusinessEntityID from inserted)
		end
	else
		begin
		Rollback transaction
		end
	go

insert into andreySchema.Person (BusinessEntityID, PersonType, FirstName, MiddleName, LastName, EmailPromotion)
values ((select max(BusinessEntityID) + 1 from andreySchema.Person), 'SP', 'jjackob', 'Daniel', 'Max', 112)

exec andreySchema.insert_data 'Jack', 'Daniel', 'Max'





create procedure andreySchema.setExchangeByProductCount
as
begin
	select 	prodCat.Name CategoryName
			,curTo.Name ConsumerCurrency
			,AVG(rate.AverageRate) AverageCourseToDollars
	into andreySchema.ExchangeByProductCount
	from [AdventureWorks2014].[Sales].[SalesOrderDetail] as det
		inner join [AdventureWorks2014].[Production].[Product] as prod on det.ProductID = prod.ProductID
		inner join [AdventureWorks2014].[Production].[ProductSubCategory] as prodSub on prod.ProductSubCategory = prodSub.ProductSubCategoryId
		inner join [AdventureWorks2014].[Production].[ProductCategory] as prodCat on prodSub.ProductCategoryID = prodCat.ProductCategoryID

		inner join [AdventureWorks2014].[Sales].[SalesOrderHeader] as head on det.SalesOrderID = head.SalesOrderID
		inner join [AdventureWorks2014].[Sales].[CurrencyRate] as rate on head.CurrencyRateID = rate.CurrencyRateID
		left join [AdventureWorks2014].[Sales].[Currency] as curFrom on rate.FromCurrencyCode = curFrom.CurrencyCode
		left join [AdventureWorks2014].[Sales].[Currency] as curTo on rate.FromCurrencyCode = curTo.CurrencyCode

	group by curTo.Name, prodCat.Name, curFrom.Name
	order by CategoryName
end
go

exec andreySchema.setExchangeByProductCount





-- КДЗ
-- 1. Минимум 8 таблиц по выбранной предметной области
-- 2. Минимум 3 свойства на таблицу
-- 3. 3-я нормальная форма БД
-- 4. Добавить минимум 3 строки данных в каждую таблицу
-- 5. Минимум 4 процедуры, 2 функции, 2 триггера
-- 6. Главное - полнота описываемой предметной области и прописание в явном виде ограницений
-- 7. Приложить в документ название БД, всех таблиц, процедур, функций, триггеров

-- Сдавать в формате word документа, где описать созданные таблицы, их свойства, созданные ключи (Допустимо сдавать очно)
-- Дедлайн - 19.01