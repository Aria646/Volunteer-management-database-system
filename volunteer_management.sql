-- Volunteer Management Database System

-- ==================================================
-- Q1: CHECK Constraint
-- ==================================================

-- This constraint ensures that a shift ends after it starts
-- and does not last for more than eight hours.
ALTER TABLE shifts
ADD CONSTRAINT ck_shift_times
CHECK (
    ends_at > starts_at
    AND ends_at - starts_at <= INTERVAL '8 hours'
);

-- ==================================================
-- Q2.1: Validate a new signup
-- ==================================================

-- This function checks a new signup before it is inserted.
-- It rejects the signup when the volunteer is too young for
-- the role or when a non-cancelled signup would exceed capacity.
CREATE OR REPLACE FUNCTION udf_bi_signup()
RETURNS TRIGGER
AS $$
DECLARE
    v_dob           DATE;
    v_min_age       INTEGER;
    v_starts_at     TIMESTAMP;
    v_capacity      INTEGER;
    v_signup_count  BIGINT;
BEGIN
    -- Find the volunteer's date of birth.
    SELECT dob
    INTO v_dob
    FROM volunteers
    WHERE volunteer_id = NEW.volunteer_id;

    -- Find the shift date, capacity and minimum age of its role.
    SELECT s.starts_at, s.capacity, r.min_age
    INTO v_starts_at, v_capacity, v_min_age
    FROM shifts AS s
    JOIN roles AS r
        ON r.role_code = s.role_code
    WHERE s.shift_ref = NEW.shift_ref;

    -- The volunteer must reach the minimum age by the shift date.
    IF v_dob + make_interval(years => v_min_age)
           > v_starts_at::DATE THEN
        RAISE EXCEPTION
            'The volunteer does not meet the minimum age requirement';
    END IF;

    -- Cancelled signups do not occupy a place.
    IF NEW.status <> 'Cancelled' THEN
        SELECT COUNT(*)
        INTO v_signup_count
        FROM signups
        WHERE shift_ref = NEW.shift_ref
          AND status <> 'Cancelled';

        -- The new signup would exceed capacity if the shift is full.
        IF v_signup_count >= v_capacity THEN
            RAISE EXCEPTION
                'The shift has reached its capacity';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- A BEFORE INSERT trigger is used so that an invalid signup
-- is rejected before it is stored in the signups table.
CREATE TRIGGER bi_signup
BEFORE INSERT ON signups
FOR EACH ROW
EXECUTE FUNCTION udf_bi_signup();
