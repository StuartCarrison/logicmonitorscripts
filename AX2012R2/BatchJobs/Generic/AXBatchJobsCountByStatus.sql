USE AXDB_PROD
select sum(hist.Withhold) as Withhold,
      sum(hist.Waiting) as Waiting,
      sum(hist.Executing) as Executing,
      sum(hist.Error) as Error,
      sum(hist.Ended) as Ended,
      sum(hist.Ready) as Ready,
      sum(hist.DidntRun) as DidntRun,
      sum(hist.Cancelling) as Cancelling,
      sum(hist.Cancelled) as Cancelled
from  (select case when Bh.Status = 0 then 1 else 0 end as Withhold,
              case when Bh.Status = 1 then 1 else 0 end as Waiting,
              case when Bh.Status = 2 then 1 else 0 end as Executing,
              case when Bh.Status = 3 then 1 else 0 end as Error,
              case when Bh.Status = 4 then 1 else 0 end as Ended,
              case when Bh.Status = 5 then 1 else 0 end as Ready,
              case when Bh.Status = 6 then 1 else 0 end as DidntRun,
              case when Bh.Status = 7 then 1 else 0 end as Cancelling,
              case when Bh.Status = 8 then 1 else 0 end as Cancelled
        from  dbo.BatchHistory    as Bh
        join  dbo.Batch          as B    on B.RecID = Bh.BATCHID
        where    Bh.EndDateTime > DateAdd(DD, -7, getdate())) as hist;
