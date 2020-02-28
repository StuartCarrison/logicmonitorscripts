use axdb_PROD
select [Blank] = (Select count(*) from dbo.batchjob bj inner join dbo.batch b on bj.recid = b.BATCHJOBID 
where bj.status = '1' and b.GROUPID = '' and ORIGSTARTDATETIME < DateADD(mi, -30, SYSUTCDATETIME ( ))),
[Core] = (Select count(*) from dbo.batchjob bj inner join dbo.batch b on bj.recid = b.BATCHJOBID 
where bj.status = '1' and b.GROUPID = '' and ORIGSTARTDATETIME < DateADD(mi, -30, SYSUTCDATETIME ( ))),
[INT] = (Select count(*) from dbo.batchjob bj inner join dbo.batch b on bj.recid = b.BATCHJOBID 
where bj.status = '1' and b.GROUPID = '' and ORIGSTARTDATETIME < DateADD(mi, -30, SYSUTCDATETIME ( ))),
[RET] = (Select count(*) from dbo.batchjob bj inner join dbo.batch b on bj.recid = b.BATCHJOBID 
where bj.status = '1' and b.GROUPID = '' and ORIGSTARTDATETIME < DateADD(mi, -30, SYSUTCDATETIME ( ))),
[OutsideMRP] = (Select count(*) from dbo.batchjob bj inner join dbo.batch b on bj.recid = b.BATCHJOBID 
where bj.status = '1' and b.GROUPID = '' and ORIGSTARTDATETIME < DateADD(mi, -30, SYSUTCDATETIME ( )))
