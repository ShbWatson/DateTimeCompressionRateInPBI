use AdventureWorks

/*
----Create dbo.FactInternetSalesBig based off of dbo.FactInternetSales 

/*
Select top 0 
[ProductKey],
[CustomerKey],
[SalesOrderNumber], 
[SalesOrderLineNumber], 
[OrderQuantity],
[ExtendedAmount],
[SalesAmount],
[OrderDate], 
[DueDate], 
[ShipDate]
into dbo.FactInternetSalesBig
from dbo.FactInternetSales
*/
----Drop table dbo.FactInternetSalesBig
----truncate table dbo.FactInternetSalesBig
*/

set nocount on 

declare 

@ProductKey int,
@CustomerKey int,
@SalesOrderNumber nvarchar(20), 
@SalesOrderLineNumber tinyint, 
@OrderQuantity smallint,
@ExtendedAmount money,
@SalesAmount money,
@OrderDate datetime, 
@DueDate datetime, 
@ShipDate datetime,
@time1 int,
@time2 int,
@time3 int,
@i int

set @i = 50

while @i > 0
begin
 print @i


declare YesIAmUsingACursor cursor for
select 
[ProductKey],
[CustomerKey],
[SalesOrderNumber], 
[SalesOrderLineNumber], 
[OrderQuantity],
[ExtendedAmount],
[SalesAmount],
[OrderDate], 
[DueDate], 
[ShipDate]

from dbo.FactInternetSales --60,000

open YesIAmUsingACursor
fetch next from YesIAmUsingACursor
into @ProductKey ,
@CustomerKey ,
@SalesOrderNumber, 
@SalesOrderLineNumber, 
@OrderQuantity,
@ExtendedAmount,
@SalesAmount,
@OrderDate , 
@DueDate , 
@ShipDate

WHILE @@FETCH_STATUS = 0  
Begin

--print @productkey 
set @time1 = rand()*10000
set @time2 = rand()*100
set @time3 = rand()*10

insert into dbo.FactInternetSalesBig
(
[ProductKey],
[CustomerKey],
[SalesOrderNumber], 
[SalesOrderLineNumber], 
[OrderQuantity],
[ExtendedAmount],
[SalesAmount],
[OrderDate], 
[DueDate], 
[ShipDate]
)
select 
@ProductKey ,
@CustomerKey ,
@SalesOrderNumber, 
@SalesOrderLineNumber, 
@OrderQuantity,
@ExtendedAmount,
@SalesAmount,
--All three datetimes are shifted the same amount of time for simplicity
DATEADD(d,@time3,DATEADD(m,@time2,DATEADD(millisecond,@time1,@OrderDate))), 
DATEADD(d,@time3,DATEADD(m,@time2,DATEADD(millisecond,@time1,@DueDate))), 
DATEADD(d,@time3,DATEADD(m,@time2,DATEADD(millisecond,@time1,@ShipDate)))

fetch next from YesIAmUsingACursor
into @ProductKey ,
@CustomerKey ,
@SalesOrderNumber, 
@SalesOrderLineNumber, 
@OrderQuantity,
@ExtendedAmount,
@SalesAmount,
@OrderDate , 
@DueDate , 
@ShipDate

end 


close YesIAmUsingACursor
deallocate YesIAmUsingACursor


set @i = @i-1
end 

--------------------------------------------------------
/* 
--Row count checks:

select count(*) from dbo.FactInternetSales  --60,398
select count(*) from dbo.FactInternetSalesBig  --1,270,517
select count(distinct orderdate) from dbo.FactInternetSalesBig --1,187,415

select count(distinct orderdate), --1,124
	   count(distinct Duedate),--1,124
	   count(distinct Shipdate) --1,124
from dbo.FactInternetSales 

-------------------------------------------------------


select count(distinct cast(orderdate as smalldatetime)), --4,129
	   count(distinct cast(Duedate as smalldatetime)), --4,129
	   count(distinct cast(Shipdate as smalldatetime))  --4,129
from dbo.FactInternetSalesBig 



select count(distinct orderdate ), --1,189,477
	   count(distinct Duedate ), --1,189,579
	   count(distinct Shipdate )  --1,189,400
from dbo.FactInternetSalesBig 

*/