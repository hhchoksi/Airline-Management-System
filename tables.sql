-- Create the user table with columns for name, email, and phone number
CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50),
    Password VARCHAR(50),
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);


CREATE TABLE Passenger (
  PassengerID INT NOT NULL AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender ENUM('M', 'F', 'O') NOT NULL,
  PhoneNumber VARCHAR(15) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  PRIMARY KEY (PassengerID)
);



CREATE TABLE Flight (
  FlightNumber VARCHAR(10) PRIMARY KEY,
  DepartureAirportCode VARCHAR(10),
  ArrivalAirportCode VARCHAR(10),
  DepartureDate DATE,
  DepartureTime TIME,
  ArrivalDate DATE,
  ArrivalTime TIME,
  AircraftType VARCHAR(50),
  FlightStatus VARCHAR(20),
  SeatsAvailable INT
);


CREATE TABLE Seat (
    Seat_ID INT NOT NULL AUTO_INCREMENT,
    FlightNumber VARCHAR(10) NOT NULL,
    Seat_Number VARCHAR(10) NOT NULL,
    Seat_Class VARCHAR(20) NOT NULL,
    PRIMARY KEY (Seat_ID),
    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
);

CREATE TABLE Passenger (
  PassengerID INT,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  DateOfBirth DATE,
  Gender CHAR(1),
  PhoneNumber VARCHAR(20),
  Email VARCHAR(100),
  CONSTRAINT PK_PID PRIMARY KEY (PassengerID)
);

CREATE TABLE Flight (
  FlightNumber VARCHAR(10),
  DepartureAirportCode VARCHAR(3),
  ArrivalAirportCode VARCHAR(3),
  DepartureDate DATE,
  DepartureTime TIME,
  ArrivalDate DATE,
  ArrivalTime TIME,
  AircraftType VARCHAR(50),
  FlightStatus VARCHAR(20),
  CONSTRAINT PK_FNO PRIMARY KEY (FlightNumber),
  CONSTRAINT FK_DAPC FOREIGN KEY (DepartureAirportCode) REFERENCES Airport(AirportCode),
  CONSTRAINT FK_AAPC FOREIGN KEY (ArrivalAirportCode) REFERENCES Airport(AirportCode)
);

CREATE TABLE Seat (
  SeatID INT,
  FlightNumber VARCHAR(10),
  SeatNumber VARCHAR(10),
  SeatClass VARCHAR(20),
  CONSTRAINT FK_SFN FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber),
  CONSTRAINT PK_SID PRIMARY KEY (SeatID),
  INDEX (SeatClass) 
);

CREATE TABLE Reservation (
  ReservationID INT,
  PassengerID INT,
  FlightNumber VARCHAR(10),
  SeatID INT REFERENCES Seat(SeatID),
  ReservationDate DATE,
  ReservationStatus VARCHAR(20),
  CONSTRAINT PK_RESID P`RIMARY KEY (ReservationID),
  CONSTRAINT FK_RFN FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber),
  CONSTRAINT FK_RSID FOREIGN KEY (SeatID) REFERENCES Seat(SeatID),
  CONSTRAINT FK_RPID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID)
);

CREATE TABLE Payment (
  PaymentID INT,
  ReservationID INT,
  PaymentAmount DECIMAL(10,2),
  PaymentDate DATE,
  PaymentStatus VARCHAR(20),
  CONSTRAINT PK_PAYID PRIMARY KEY (PaymentID),
  CONSTRAINT FK_PRID FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)
);

CREATE TABLE Airport (
  AirportCode VARCHAR(3),
  AirportName VARCHAR(100),
  City VARCHAR(50),
  State VARCHAR(50),
  Country VARCHAR(50),
  CONSTRAINT PK_APC PRIMARY KEY (AirportCode)
);

CREATE TABLE Aircraft (
  AircraftID INT,
  AircraftType VARCHAR(50),
  Manufacturer VARCHAR(50),
  Capacity INT,
  CONSTRAINT PK_ACPC PRIMARY KEY (AircraftID)
);

CREATE TABLE Staff (
  StaffID INT,
  FlightNumber VARCHAR(10),
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Role VARCHAR(50),
  PhoneNumber VARCHAR(20),
  CONSTRAINT PK_STID PRIMARY KEY (StaffID),
  CONSTRAINT FK_STFN FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
);

CREATE TABLE Baggage (
  BaggageID INT,
  PassengerID INT,
  FlightNumber VARCHAR(10) ,
  Weight DECIMAL(5,2),
  BaggageStatus VARCHAR(20),
  CONSTRAINT PK_BAGID PRIMARY KEY (BaggageID),
  CONSTRAINT FK_BPID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID),
  CONSTRAINT FK_BFN FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
);

CREATE TABLE FlightSchedule (
  ScheduleID INT,
  FlightNumber VARCHAR(10),
  DepartureDate DATE,
  DepartureTime TIME,
  ArrivalDate DATE,
  ArrivalTime TIME,
  AircraftID INT,
  CONSTRAINT PK_FSID PRIMARY KEY (ScheduleID),
  CONSTRAINT FK_FSFN FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber),
  CONSTRAINT FK_FSAC FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID)
);

CREATE TABLE Route (
  RouteID INT,
  DepartureAirportCode VARCHAR(3),
  ArrivalAirportCode VARCHAR(3),
  Distance INT,
  TravelTime TIME,
  CONSTRAINT PK_RID PRIMARY KEY (RouteID),
  CONSTRAINT FK_RAPC FOREIGN KEY (ArrivalAirportCode) REFERENCES Airport(AirportCode),
  CONSTRAINT FK_RDPC FOREIGN KEY (DepartureAirportCode) REFERENCES Airport(AirportCode)
);

CREATE TABLE Fare (
  FareID INT,
  FlightNumber VARCHAR(10),
  SeatClass VARCHAR(20),
  FareAmount DECIMAL(10,2),
  CONSTRAINT PK_FID PRIMARY KEY (FareID),
  CONSTRAINT FK_FFN FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber),
  CONSTRAINT FK_FSC FOREIGN KEY (SeatClass) REFERENCES Seat(SeatClass)
);

CREATE TABLE FlightDelay (
  DelayID INT,
  FlightNumber VARCHAR(10) REFERENCES Flight(FlightNumber),
  DepartureDate DATE,
  DepartureTime TIME,
  ArrivalDate DATE,
  ArrivalTime TIME,
  CONSTRAINT PK_DID PRIMARY KEY (DelayID),
  CONSTRAINT FK_FK FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
);

