use axdb_PROD
select 
	caption as caption,
	company as company,
	STARTDATETIME as StartDateTime,
	getdate() as CurrentDatetime,
	DATEDIFF(MINUTE, STARTDATETIME,getdate()) as Runtime_Minutes
from 
	batchjob where status = 2
