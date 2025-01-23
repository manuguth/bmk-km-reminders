WITH leaders AS (
  SELECT
    km_roles.*,
    km_members.name,
    km_members.mail,
    km_orgs.name as Register
  from
    bronze.km_roles
    left JOIN bronze.km_members ON km_roles.kmUserId = km_members.id
    LEFT JOIN silver.km_orgusermapping as km_orgusermapping ON km_orgusermapping.kmUserId = km_roles.kmUserId
    and km_orgusermapping.active = 1
    LEFT JOIN silver.km_orgs as km_orgs ON km_orgusermapping.orgId = km_orgs.id
    and km_orgs.parentId is not null
  where
    1 = 1
    AND km_members.active is TRUE
    AND km_orgs.id is NOT NULL
),
appointments_no_attendance AS (
  select
    *,
    datediff(current_date, appointment_date) AS days_since_appointment
  from
    bmk_prod.gold.v_km_appointments_summary
  where
    year(appointment_date) = 2025
    and attending = 0
    -- and invited < 10 -- temporary for testing
    and datediff(current_date, appointment_date) > 0
)
select
  mtrx.appointmentId,
  mtrx.kmUserId,
  aptmt.aptmt_type,
  aptmt.appointment_name,
  aptmt.appointment_date,
  aptmt.invited,
  aptmt.negative,
  aptmt.positive,
  aptmt.maybe,
  aptmt.attending,
  aptmt.days_since_appointment,
  leaders.name,
  leaders.mail,
  leaders.Register
from
  bmk_prod.silver.km_matrix as mtrx
  INNER JOIN appointments_no_attendance AS aptmt ON aptmt.id = mtrx.appointmentId
  INNER JOIN leaders ON leaders.kmUserId = mtrx.kmUserId
  AND mtrx.positive IS TRUE

where
1=1 
  -- AND appointmentId = 2530399