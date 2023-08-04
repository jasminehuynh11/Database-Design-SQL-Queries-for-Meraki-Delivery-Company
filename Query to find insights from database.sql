use meraki_database;
/*1. Write a query to print the details (VIN Number, Colour, Cost) of the truck. 
Note that the cost must be prefixed with a '$' sign. 
Sort the records in the order of the most expensive truck at the top of the list.*/

select TruckVINNum, TruckColour, concat("$", TruckCost) "TruckCost"
from Truck
order by(TruckCost)desc;

/*2. Write a query to print the allocation details (VIN Number, Transport ID, from and to date, along with the number of days) 
each of the trucks is allocated/reserved for.*/

select TruckVINNum, TransportID,date_format(FromDate, "%D of %M %Y")"FromDate",date_format(ToDate,"%D of %M %Y")"ToDate", datediff(ToDate,FromDate)"Number of Days"
from Allocation;

/*3. Write a query to print the truck details (VIN Number, name of the model), if the make of the truck is “Volvo”. 
Use equi-join to answer this question.*/

select t.TruckVINNum, tm.TruckModelName
from truck t, truckmodel tm, truckmake tk 
where t.TruckModelID = tm.TruckModelID
and t.TruckMakeID = tk.TruckMakeID 
and tk.TruckMakeName = 'Volvo';

/*4.Write a query to print the VIN Numbers of the trucks if they have been allocated for 3 days or above for a transport that costs between $1500 and $2500. 
Please ensure no duplicate results are included. Use “join using” to answer this question.*/

select distinct a.TruckVINNum
from allocation a join service s 
using (TransportID)
where datediff(a.ToDate,a.FromDate)>=3
and s.TransportCost between 1500 and 2500;

/*5. Using a subquery, print name, cost and the maximum distance of the transport if the transport has been allocated (use the start date of the allocation here) within the last 6 months calculated from today (Today here implies the date the query is run. 
Must not hardcode the date) */

select TransportName,TransportCost,TransportMaxDist
from service
where TransportID in (
select TransportID
from allocation
where year(curdate())-year(FromDate)=0
and month(curdate())-month(FromDate)<=6);

-- 6.Rewrite Task 5 using a Join on

select s.TransportName,s.TransportCost,s.TransportMaxDist
from service s join allocation a
on s.TransportID=a.TransportID
where year(curdate())-year(a.FromDate)=0
and month(curdate())-month(a.FromDate)<=6;

/* 7. Write a query to print the names of transport, the maximum distance in kilometres, the maximum distance in miles that have used a red truck. 
Please ensure no duplicate results are included in the result. 
Please rename the column names and ensure the numerical columns have 2 decimal places only. You must use join on to write your answer. */

select distinct s.TransportName,s.TransportMaxDist 'Kilometeres', round(s.TransportMaxDist* 0.621371 ,2) as Miles 
from Service s join Allocation a join Truck t
on s.TransportID=a.TransportID
join Truck t 
on a.TruckVINNum = t.TruckVINNum
where t.TruckColour = 'red';

/* 8. Write a query to print the number of trucks at Meraki in every colour. 
Sort the records in order of the number of trucks with the highest number at the top of the list. */

select TruckColour, count(TruckColour) 'Number of colours'
from truck
group by(TruckColour)
order by count(TruckColour)desc; 

/* 9. Show the make of the truck along with the number of models, if the number of models is more than one. */
select tk.TruckMakeName, count(TruckModelID) 'Number of models'
from truckmake tk join truckmodel tm 
on tk.TruckMakeID = tm.TruckMakeID
group by tk.TruckMakeName
having count(TruckModelID)>1; 

/* 10. Write a query to print the details of all trucks which have never been booked. */

select t.*
from truck t left join allocation a 
on t.TruckVINNum = a.TruckVINNum 
where a.TransportID is null; 

/* 11. Write a query to print the details of any transport that is more than $5000. 
Only include the allocation (both to and from dates) that have been made in either January of any year or any month in the years - 2020 or 2021. 
Sort the results by the cost of transport in descending order.*/

select *
from service
where TransportCost>5000
and TransportID in (
select TransportID
from allocation
where month(FromDate)=01
and month(ToDate)=01 
or year(ToDate)=2020 or year(ToDate)=2021)
order by(TransportCost)desc; 

/* 12. Write a query to print the names of make & model of all red trucks that have had at least one allocation.*/
select tk.TruckMakeName, tm.TruckModelName
from truckmake tk, truckmodel tm
where tk.TruckMakeID = tm.TruckMakeID
and tm.TruckModelID in (
 select TruckModelID
 from truck
 where TruckColour = 'red'
 and TruckVINNum in (
 select TruckVINNum 
 from allocation 
 where TransportID is not null));

/* 13. Write a query to print all the details of the booking request and the total amount that it has been invoiced for. 
The data saved in the table are exclusive of taxes. 
Your query should include the 10% tax. 
Only include reservations that exceed the total amount of $7,000. */

select b.*,sum(i.InvoiceAmount)*1.10  'TotalInvoice including tax'
from BookingReq b join Invoice i
using(RequestID)
group by b.RequestID
having sum(i.InvoiceAmount)*1.10 > 7000;

/* 14.Write a query to print the names of the customers who have made payments in the fourth quarter of 2020 that is lesser than 
the average cost of payments made in the fourth quarter of 2020. */

select c.CustomerName
from Customer c, Payment p, Invoice i, BookingReq b
where c.CustomerID = b.CustomerID 
and i.RequestID = b.RequestID
and p.InvoiceID = i.InvoiceNum
and p.PaymentDate between '2020-10-01' and '2020-12-31'
and p.PaymentAmount < (select avg(p.PaymentAmount)
from Payment p
where p.PaymentDate between '2020-10-01' and '2020-12-31');

/* 15. Write a query to print the names of Staff and their managers, only if the managers manage 2 staff or more.*/
select s1.StaffName, s2.StaffName 'ManagerName' 
from Staff s1 left join Staff s2 
on s1.ManagerID = s2.StaffID 
where s2.StaffID in (
select s2.StaffID
from Staff s1 join Staff s2
on s1.ManagerID = s2.StaffID 
group by s2.StaffID 
having count(s1.StaffID) >=2)
order by s2.StaffName;

 /*16.Write a query to print the names of the customers who have a schedule booked by a manager with the trips that start in the afternoon (between 12 pm -3 pm) 
 and end before midday (between 6 am – 12 pm) along with the names of the staff who created the schedule.*/

select c.CustomerName
from Customer c, TripSchedule ts, BookingReq b, Staff s
where c.CustomerID = b.CustomerID
and  b.RequestID = ts.RequestID 
and ts.StaffID = s.StaffID
and s.ManagerID is null
and time(ts.TripStart) between '12:00:00' and '15:00:00'
and time(ts.TripEnd) between '06:00:00' and '12:00:00';

/*17. Write a query to print the details of the schedule (Start Location Name, Name of the Service/Transport) 
and the staff involved in the activities. 
This should involve the staff who created the schedule and all the support staff involved. 
Please note you will have to display the data in multiple rows.*/

select a.LocationName,sf.StaffName,s.TransportName
from TripSchedule t left join Staff sf 
on sf.StaffID =  t.StaffID 
join Location a on a.LocationID=t.StartLoc
join Service  s on s.TransportID=t.TransportID
union all
select a.LocationName,s.TransportName,sf.StaffName
from SupportStaff spf right join Staff sf
on sf.StaffID = spf.StaffID
join TripSchedule t on t.ScheduleID=spf.ScheduleID
left join Location a on t.StartLoc = a.LocationID
join Service s
using(TransportID);

/*18. List the name of the start and end location, for every schedule along with the name of the customer the schedule is for. 
Only include Customers whose surnames start with J. 
Also, this schedule must have at least 2 invoices generated for it.*/

select distinct ls.LocationName 'StartLocation', le.LocationName 'EndLocation', c.CustomerName
from Location ls, Location le, Customer c, BookingReq b, Invoice i, TripSchedule t
where t.StartLoc=ls.LocationID
and t.EndLoc=le.LocationID
and c.CustomerID=b.CustomerID
and b.RequestID = t.RequestID
and c.CustomerName like '% J%'
and t.RequestID = i.RequestID
and (select count(i.InvoiceNum)
from Invoice i
where t.RequestID = i.RequestID) >= 2;

/* 19. Write a query to list the details of the schedule (id) along with the total cost (in currency format) of both invoice amount and payment amount for every schedule. If the schedule doesn't involve invoice/payment, 0 must be displayed as the cost.*/
Select s.ScheduleID, concat('$',IFNULL(Cost1,0)) "Invoice Amount", concat('$',IFNULL(Cost2,0)) "Paid Amount"
from TripSchedule s left join
(select q.RequestID as ReqID1, sum(InvoiceAmount) as Cost1
from BookingReq q left join Invoice i
on q.RequestID = i.RequestID
group by q.RequestID) table1
on ReqID1 = s.RequestID
left join
(select q.RequestID as ReqID2, sum(p.PaymentAmount) as Cost2
from BookingReq q, Invoice i, Payment p
where q.RequestID = i.RequestID
and p.InvoiceID = i.InvoiceNum
group by q.RequestID) table2
on ReqID2 = s.RequestID;

