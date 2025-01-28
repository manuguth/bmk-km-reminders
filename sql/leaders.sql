SELECT
  km_roles.*,
  km_members.name,
  km_members.mail,
  km_orgs.name as Register
from
  silver.km_roles
  left JOIN silver.km_members ON km_roles.kmUserId = km_members.id
  LEFT JOIN silver.km_orgusermapping as km_orgusermapping ON km_orgusermapping.kmUserId=km_roles.kmUserId and km_orgusermapping.active=1
  LEFT JOIN silver.km_orgs as km_orgs ON km_orgusermapping.orgId=km_orgs.id and km_orgs.parentId is not null
where 1=1
  AND km_members.active is TRUE
  AND km_orgs.id is NOT NULL