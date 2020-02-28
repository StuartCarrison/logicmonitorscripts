use axdb_prod
select [TBUK] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBUK'),
[TBIE] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBIE'),
[TBES] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBES'),
[TBFR] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBFR'),
[TBBE] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBBE'),
[TBZX] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBZX'),
[TBNL] = (select count(*) from retailtransactiontable where type = 2 and ENTRYSTATUS in (0,2) and transdate = (CONVERT (date, GETDATE())) and DATAAREAID = 'TBNL')
