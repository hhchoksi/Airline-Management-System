 DELIMITER //
  CREATE TRIGGER DELAY_AIRLINE 
  AFTER INSERT ON flightdelay 
  FOR EACH ROW 
  BEGIN
      UPDATE flight 
      SET FlightStatus = 'Delayed' 
      WHERE flight.FlightNumber = flight_delay.FlightNumber;
  END //
  DELIMITER ;
  
DELIMITER //
CREATE TRIGGER D_AIRLINE 
BEFORE INSERT ON flightschedule
FOR EACH ROW
BEGIN
    IF NEW.DepartureDate = CURDATE() AND NEW.DepartureTime = CURTIME() THEN
        UPDATE Flight 
        SET FlightStatus = 'Departed' 
        WHERE Flight.FlightNumber = NEW.FlightNumber;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER PREVENT_DUPLICATE_RESERVATION 
BEFORE INSERT ON reservation 
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * 
        FROM reservation 
        JOIN flight ON reservation.FlightNumber = flight.FlightNumber 
        WHERE reservation.SeatID = NEW.SeatID 
        AND Reservation.FlightNumber = NEW.FlightNumber 
        AND Flight.FlightStatus != 'Cancelled'
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This seat has already been reserved for this flight and the flight status is not cancelled.';
    END IF;
END//

DELIMITER ;

DELIMITER //
CREATE TRIGGER CANCEL_RESERVATION 
AFTER UPDATE ON flight 
FOR EACH ROW
BEGIN
    IF OLD.FlightStatus != 'Cancelled' AND NEW.FlightStatus = 'Cancelled' THEN
        UPDATE Reservation
        SET ReservationStatus = 'Cancelled'
        WHERE FlightNumber = NEW.FlightNumber;
    END IF;
END//
DELIMITER ;

DELIMITER //
  
  