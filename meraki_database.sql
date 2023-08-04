/* Create these tables based on the list provided above: TruckMake, TruckModel, Truck, Service, and Allocation. 
   Insert at least 5 records into each of the tables. */
-- CREATE TABLE TRUCKMAKE 

create table TruckMake(

TruckMakeID char(3),

TruckMakeName varchar(20),

primary key (TruckMakeID)); 


-- CREATE TABLE TRUCK MODEL 

create table TruckModel (

TruckMakeID char(3),

TruckModelID char(3),

TruckModelName varchar(20),

primary key(TruckModelID,TruckMakeID),

foreign key(TruckMakeID) references TruckMake(TruckMakeID));


-- CREATE TABLE TRUCK 

create table Truck (

TruckVINNum char(4),

TruckMakeID char(3),

TruckModelID char(3),

TruckColour varchar(6),

TruckPurchaseDate date, 

TruckCost decimal (8,2),

primary key(TruckVINNum),

foreign key(TruckMakeID) references TruckMake(TruckMakeID),

foreign key(TruckModelID) references TruckModel(TruckModelID)); 


-- CREATE TABLE SERVICE 

create table Service (

TransportID char(2),

TransportName varchar(20),

TransportCost decimal (6,2),

TransportMaxDist decimal (6,2),

primary key(TransportID)); 


-- CREATE TABLE ALLOCATION 

create table Allocation (

TruckVINNum char(4),

TransportID char(2),

FromDate date,

ToDate date, 

primary key(TransportID, TruckVINNum),

foreign key(TransportID) references Service(TransportID),

foreign key(TruckVINNum) references Truck(TruckVINNum)); 

-- CREATE TABLE CUSTOMER: 

create table Customer(

CustomerID char(4),

CustomerName varchar(20),

CustomerPhNum char(10),

primary key(CustomerID)); 

 

-- CREATE TABLE BOOKINGREQ:

create table BookingReq(

RequestID char(4),

CustomerID char(4),

RequestDate date,

RequestText varchar(50), 

primary key(RequestID),

foreign key(CustomerID) references Customer(CustomerID));


-- CREATE TABLE INVOICE :

create table Invoice(

InvoiceNum char(3),

RequestID char(4),

InvoiceDate date,

InvoiceAmount decimal(4),

primary key(InvoiceNum),

foreign key(RequestID) references BookingReq(RequestID));


-- CREATE TABLE PAYMENT:  

create table Payment(

PaymentID char(4),

InvoiceID char(3),

PaymentDate date, 

PaymentAmount decimal(4),

primary key(PaymentID),

foreign key (InvoiceID) references Invoice(InvoiceNum));

-- CREATE TABLE LOCATION: 

create table Location(

LocationID char(3),

LocationName varchar(20),

LocationState varchar(20),

LocationPostCode varchar(7),

primary key(LocationID));


-- CREATE TABLE STAFF:

create table Staff(

StaffID char(2),

Staffname varchar(30),

ManagerID char(2),

primary key(StaffID));


alter table Staff

add foreign key (ManagerID) references Staff(StaffID);


-- CREATE TABLE TRIPSCHEDULE:

create table TripSchedule(

ScheduleID char(3),

StartLoc char(3),

EndLoc char(3),

RequestID char(4),

TruckVINNum char(4),

TransportID char(2),

StaffID char(2),

TripStart datetime,

TripEnd datetime,

primary key(ScheduleID),

foreign key (StartLoc) references Location(LocationID),

foreign key (EndLoc) references Location(LocationID),

foreign key (RequestID) references BookingReq(RequestID),

foreign key (TruckVINNum) references Truck(TruckVINNum),

foreign key (TransportID) references Service(TransportID),

foreign key (StaffID) references Staff(StaffID));

-- CREATE TABLE SUPPORTSTAFF: 

create table SupportStaff(

ScheduleID char(3),

StaffID char(2),

HoursNeeded numeric(2),

primary key (ScheduleID,StaffID),

foreign key (ScheduleID) references TripSchedule(ScheduleID),

foreign key (StaffID) references Staff(StaffID));

-- Data Insertion

-- INSERT DATA TO TRUCKMAKE 

Insert into TruckMake values ('TM1','Volvo');

Insert into TruckMake values ('TM2','Vauxhall');

Insert into TruckMake values ('TM3','Volkswagen');

Insert into TruckMake values ('TM4','Honda');

Insert into TruckMake values ('TM5','Audi');


-- INSERT DATA TO TRUCKMODEL 

Insert into TruckModel values ('TM1','M01', 'FH 16');

Insert into TruckModel values ('TM1','M02', 'FH 13');

Insert into TruckModel values ('TM2','M03', 'New Corsa');

Insert into TruckModel values ('TM2','M04', 'Adam');

Insert into TruckModel values ('TM3','M05', 'Polo');

Insert into TruckModel values ('TM3','M06', 'Beetle Dune');

Insert into TruckModel values ('TM4','M07', 'City');

Insert into TruckModel values ('TM4','M08', 'Civic');

Insert into TruckModel values ('TM5','M09', 'A8');

Insert into TruckModel values ('TM5','M10', 'A6');


-- INSERT DATA TO TRUCK

Insert into Truck values ('V020','TM5','M10', 'white','2018-11-26', '464800.11');

Insert into Truck values ('V022','TM2','M03','red', '2018-05-11', '780000.45');

Insert into Truck values ('V023','TM2','M03', 'yellow', '2012-05-11', '650000.35');

Insert into Truck values ('V024','TM3','M05', 'red', '2020-05-11', '300000.12');

Insert into Truck values ('V025','TM3','M05','black','2021-05-11', '560000.32'); 

Insert into Truck values ('V026','TM1','M01','black','2021-07-11', '880000.32'); 

Insert into Truck values ('V027','TM1','M02','red','2021-03-11', '990000.32'); 


-- INSERT DATA TO SERVICE 

Insert into Service values ('T1','Alpha','1750.11','1000.56');

Insert into Service values ('T2','Beta','2000.45','1500.78');

Insert into Service values ('T5','Pro Plus','8000.22','8750.99');

Insert into Service values ('T3','Pro','6550.67','6000.56');

Insert into Service values ('T4','Pro Max','9750.22','9000.99');


-- INSERT DATA TO ALLOCATION 

Insert into Allocation values ('V020','T1','2021-07-19','2021-07-29');

Insert into Allocation values ('V025','T2','2019-01-19','2019-01-25');

Insert into Allocation values ('V023','T5','2020-05-11','2020-05-19');

Insert into Allocation values ('V022','T3','2021-07-19','2021-07-21'); 

Insert into Allocation values ('V027','T4','2020-12-26','2020-12-30');

-- INSERT DATA TO CUSTOMER: 

Insert into Customer values ('C345','Huge Jackman', '0415871256');

Insert into Customer values ('C346','Small Jasmine', '0332193218');

Insert into Customer values ('C347','Big Ason', '0907177180');

Insert into Customer values ('C348','Huynh Baron', '0903757875');

Insert into Customer values ('C349','Gram Lemon', '0415871256');

Insert into Customer values ('C350','Geo Lemam', '0915771257');

Insert into Customer values ('C351','Jeo Jemam', '0312774259');


-- INSERT DATA TO BOOKINGREQ:

Insert into BookingReq values ('R101','C345','2020-11-25', 'Request for Alpha Service');

Insert into BookingReq values ('R102','C346','2021-03-25', 'Request for Beta Service');

Insert into BookingReq values ('R103','C347','2020-05-11', 'Request for Pro Service');

Insert into BookingReq values ('R104','C348','2021-05-11', 'Request for Pro Plus Service');

Insert into BookingReq values ('R105','C349','2020-11-26', 'Request for Pro Max Service');

Insert into BookingReq values ('R106','C350','2020-12-26', 'Request for Pro Plus Service');

Insert into BookingReq values ('R107','C351','2020-10-26', 'Request for Alpha Service');


-- INSERT DATA TO INVOICE: 

Insert into Invoice values ('I35','R101','2020-11-27', '3000');

Insert into Invoice values ('I36','R102','2021-03-27', '5000');

Insert into Invoice values ('I37','R103','2020-05-14', '8000');

Insert into Invoice values ('I38','R104','2021-05-12', '9000');

Insert into Invoice values ('I39','R105','2020-11-28', '7500');

Insert into Invoice values ('I40','R106','2020-12-28', '2000');

Insert into Invoice values ('I41','R107','2020-10-28', '9000');

Insert into Invoice values ('I42','R101','2020-11-28', '2000');

Insert into Invoice values ('I43','R102','2021-03-29', '6000');


-- INSERT DATA TO PAYMENT: 

Insert into Payment values ('P300','I35','2020-11-28','3000');

Insert into Payment values ('P301','I36','2021-03-28','5000');

Insert into Payment values ('P302','I37','2020-05-15','8000');

Insert into Payment values ('P303','I38','2021-05-13','9000');

Insert into Payment values ('P304','I39','2020-11-29','7500');

Insert into Payment values ('P305','I40','2020-12-29','2000');

Insert into Payment values ('P306','I41','2020-10-29','9000');


-- INSERT DATA TO LOCATION: 

Insert into Location values ('L10','Norwood','TAS', '7250');

Insert into Location values ('L11','Sakura','TMS', '7450');

Insert into Location values ('L12','Norwest','TAM', '7650');

Insert into Location values ('L13','Southwood','MAS', '7255');

Insert into Location values ('L14','Southwest','TAC', '7355');


-- INSERT DATA TO STAFF: 

Insert into Staff values ('S1','Chirs Hemsworth',null);

Insert into Staff values ('S2','Richard Dawkins','S1');

Insert into Staff values ('S3','Niclos Lukes','S1');

Insert into Staff values ('S4','Huynh Jasmine',null);

Insert into Staff values ('S5','Chirs Anna','S4');

Insert into Staff values ('S6','Tran Jenny','S4');

Insert into Staff values ('S7','Nguyen Jennie','S4');

Insert into Staff values ('S8','Kahana Alex',null);

Insert into Staff values ('S9','Nguyen Jennie','S8');


-- INSERT DATA TO TRIPSCHEDULE: 

Insert into TripSchedule values ('S23','L11','L10','R101','V023','T5','S1','2020-12-06 13:30:00','2020-12-07 07:30:00');

Insert into TripSchedule values ('S24','L11','L13','R102','V025','T3','S2','2021-04-01 07:30:00','2021-04-07 14:30:00');

Insert into TripSchedule values ('S25','L14','L13','R103','V022','T3','S4','2020-05-20 14:45:00','2020-05-25 09:00:00');

Insert into TripSchedule values ('S26','L12','L13','R105','V027','T4','S4','2020-11-28 07:45:00','2020-11-30 09:00:00');

Insert into TripSchedule values ('S27','L14','L11','R106','V020','T1','S3','2020-12-28 15:45:00','2020-12-30 09:30:00');

Insert into TripSchedule values ('S28','L12','L11','R108','V020','T1','S3','2021-12-28 07:45:00','2021-12-30 08:30:00');

-- INSERT DATA TO SUPPORTSTAFF: 

Insert into SupportStaff values ('S01','S3',15);

Insert into SupportStaff values ('S02','S4',11);

Insert into SupportStaff values ('S03','S3',10);

Insert into SupportStaff values ('S04','S5',12);

Insert into SupportStaff values ('S05','S6',13);

Insert into SupportStaff values ('S06','S6',14);