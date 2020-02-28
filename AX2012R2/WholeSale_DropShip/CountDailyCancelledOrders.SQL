use AXDB_PROD
	select count(distinct St.RecID) as "CancelledOrds24Hrs"
    from	dbo.SalesTable                    as St
    join	dbo.KRFSalesTableExtended         as K3Ste    on K3Ste.SalesTable            = St.RecID
                                                        and K3Ste.DataAreaID            = St.DataAreaID
                                                        and K3Ste.Partition             = St.Partition
    join	dbo.KRFSalesOrderCategoryTable    as K3Soct   on K3Soct.SalesOrderCategory   = K3Ste.SalesOrderCategory
                                                        and K3Soct.DataAreaID           = K3Ste.DataAreaID
                                                        and K3Soct.Partition            = K3Ste.Partition
    where	St.SalesStatus                    =  4                                      -- SalesStatus::Cancelled
	and		cast(SWITCHOFFSET(ToDateTimeOffset(St.CREATEDDATETIME,'+00:00'),'-04:00') as date)                = cast(SWITCHOFFSET(SYSDATETIMEOFFSET(),'-04:00') as date)
    and		cast(SWITCHOFFSET(ToDateTimeOffset(St.MODIFIEDDATETIME,'+00:00'),'-04:00') as date)                = cast(SWITCHOFFSET(SYSDATETIMEOFFSET(),'-04:00') as date)
    and		K3Soct.Ted3PLSalesScenario        =  0                                      -- TED3PLSalesScenario::Wholesale
	and		K3soct.SALESORDERCATEGORY		 =  'DROPSHIP'
    and		St.DataAreaID                     =  'TBUS'
    ;
