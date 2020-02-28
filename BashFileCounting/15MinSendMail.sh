# find files in a given folder older than 14 minutes, log and send a mail

# clean up after last run

rm /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt

# INBOUND search the folder we're interested in for files older than 14 mins, save the results to a temporary local file
# find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD01_SKU_SupplierSKU/3_Error/* -mmin +14 | grep -iv archive > /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD04_Shipment_Confirmation/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD05_Stock_Adjustment/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD07_Receipts_Confirmation/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD07_Receipts_Confirmation_EC/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD07_Receipts_Confirmation_WS/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD08-Carton-Receipt/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/IDD15-Blind_Returns/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
find /SMB/TBAPP04-D/AX_Integration/AX_Int_Prod/AX_Inbound/Warehouse/TBUK_Derby/Stock_Snapshot/3_Error/* -mmin +14 | grep -iv archive >> /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt

# send a mail if the result file is greater than 0
file=/root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt
minimumsize=1
actualsize=$(wc -c <"$file")
if [ $actualsize -ge $minimumsize ]; then
        echo "ALERT: Mulesoft integration ERROR FOLDER - one or more integration folders contains files 15 minutes or older. Please check the attached file for the exact location and files that are aged. " | mail -A /root/Mule/Inbound.Warehouse.TBUKDerby/inboundfiles/errorlog.txt -s "WARNING: FILES IN AX INTEGRATION MULESOFT ERROR FOLDER(S) - SEE ATTACHED" mulesoft.alert@TedBaker.com
else
    echo size is under $minimumsize bytes
fi
