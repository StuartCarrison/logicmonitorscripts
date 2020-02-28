use axdb_PROD
select sum(sq.Items) as Items, sum(sq.PaymentAmount) as Value, count(sq.RecID) as Transactions, sq.CountryRegionID as CountryCode
from   (select distinct Rtt.Store,
               Rtt.PaymentAmount,
                  Rtt.RecID,
                  Rtt.NumberOfItems * sign(Rtt.PaymentAmount) as Items,
                  Lpa.CountryRegionID
        from   dbo.RetailTransactionTable    as Rtt
        join   dbo.RetailChannelTable        as Rct   on Rct.StoreNumber = Rtt.Store
        join   dbo.DirPartyTable             as Dpt   on Dpt.RecID = Rct.OMOperatingUnitID
        join   dbo.LogisticsPostalAddress    as Lpa   on Lpa.Location = Dpt.PrimaryAddressLocation
        where  dateAdd(s,Rtt.TransTime,Rtt.TransDate) > dateAdd(HH,-1,getdate())
        and    Rtt.NumberOfItems > 0
        and    Rtt.Type in (2,3)) as sq
where  sq.CountryRegionID = 'GBR' --<< Change country code here
group  by sq.CountryRegionID;
