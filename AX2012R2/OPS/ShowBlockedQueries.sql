select
      [SPID],     
      [Login],
      [Database],
      [HostName],
      AXSessionID,
      Left(
         SubString([AXSessionIDSubstr], PatIndex('%[0-9]%', [AXSessionIDSubstr]), 8000),
         PatIndex('%[^0-9]%', SubString([AXSessionIDSubstr], PatIndex('%[0-9]%', [AXSessionIDSubstr]), 8000) + 'X')-1)
              as [AXSessionIDRefined]
                   ,          
      [TaskState],
      [Command],
     -- [FullCommand],
      [Application],
      [WaitTimeMin],

      [WaitType],
      [WaitResource],
      [BlockedBy],
      [HeadBlocker],
      [TotalCpuMS],     
      [TotalIOMB],
      [MemoryUseKB],
      [OpenTransactions],
      [LoginTime],
      [LastRequestStartTime]
FROM
(
select
      [SPID],     
      [Login],
      [Database],
      [HostName],
      [AXSessionID],
       substring(
                      (LTRIM([AXSessionID])),
                      (CHARINDEX(' ', (LTRIM([AXSessionID])))), 100)
                      as [AXSessionIDSubstr],            
      [TaskState],
      [Command],
      --[FullCommand],
      [Application],
      [WaitTimeMin],     
      [WaitType],
      [WaitResource],
      [BlockedBy],
      [HeadBlocker],
      [TotalCpuMS],     
      [TotalIOMB],
      [MemoryUseKB],
      [OpenTransactions],
      [LoginTime],
      [LastRequestStartTime]
FROM
(
Select
      [SPID] = s.session_id,
      [Login] = s.login_name,
      [Database] = ISNULL(db_name(r.database_id), N''),
      [HostName] = ISNULL(s.host_name, N''),
      [AXSessionID] =
      CASE
             when dm.context_info = '0x' THEN 'BATCHJob'
             else cast(dm.context_info as varchar(128))
      END,
      [TaskState] = ISNULL(t.task_state, N''),
      [Command] = ISNULL(r.command, N''),
      --[FullCommand] = sqltext.text,
      [Application] = ISNULL(s.program_name, N''),
      [WaitTimeMin] = ISNULL(w.wait_duration_ms/60000, 0) ,
      [WaitType] = ISNULL(w.wait_type, N''),
      [WaitResource] = ISNULL(w.resource_description, N''),
      [BlockedBy] = ISNULL(CONVERT (varchar, w.blocking_session_id), ''),
      [HeadBlocker] =
      CASE
-- session has an active request, is blocked, but is blocking others
             WHEN r2.session_id IS NOT NULL AND r.blocking_session_id = 0 THEN '1'
-- session is idle but has an open tran and is blocking others
             WHEN r.session_id IS NULL THEN '1'
             ELSE ''
      END,
      [TotalCpuMS] = s.cpu_time,
      [TotalIOMB] = (s.reads + s.writes) * 8 / 1024,
      [MemoryUseKB] = s.memory_usage * 8192 / 1024,
      [OpenTransactions] = ISNULL(r.open_transaction_count,0),
      [LoginTime] = s.login_time,
      [LastRequestStartTime] = s.last_request_start_time
FROM sys.dm_exec_sessions s LEFT OUTER JOIN sys.dm_exec_connections c ON (s.session_id = c.session_id)
      LEFT OUTER JOIN sys.dm_exec_requests r ON (s.session_id = r.session_id)
      LEFT OUTER JOIN sys.dm_os_tasks t ON (r.session_id = t.session_id AND r.request_id = t.request_id)
      LEFT OUTER JOIN
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY waiting_task_address ORDER BY wait_duration_ms DESC) AS row_num
FROM sys.dm_os_waiting_tasks) w ON (t.task_address = w.waiting_task_address) AND w.row_num = 1LEFT OUTER JOIN sys.dm_exec_requests r2 ON (r.session_id = r2.blocking_session_id)
      inner join sys.dm_exec_sessions dm on (s.session_id = dm.session_id)
      --CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS sqltext
WHERE db_name(r.database_id) = 'AXDB_PROD' and s.login_name != 'sa'
) x
) x2
order by [WaitTimeMin] Desc
