use axdb_prod
select [TBUK] = (select sum(amountMST) from RETAILTRANSACTIONPAYMENTTRANS where transdate =  (CONVERT (date, GETDATE())) and transactionstatus in (0,2) and DATAAREAID  = 'TBUK')
