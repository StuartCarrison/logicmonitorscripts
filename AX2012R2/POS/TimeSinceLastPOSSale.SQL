use axdb_prod
select [Mins] = (SELECT TOP(1) FLOOR((1.0 * DATEDIFF(SECOND, CREATEDDATETIME, GETUTCDATE())) / 60) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and dataareaid = 'tbuk' order by CREATEDDATETIME desc)
