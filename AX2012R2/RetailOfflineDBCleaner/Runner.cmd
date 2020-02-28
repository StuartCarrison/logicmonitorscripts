

if not exist s:\. net use s: \\tbfp01\proshare

S:
cd\it\scripts\AXTillAutoClean

Echo NEW RUN > log.txt

if exist till-list.txt del till-list.txt

dsquery computer "ou=5-EPOS-Workstations,ou=TedShare_Retail,ou=T[snipped]" -o rdn -limit 20000 > till-list.txt
dsquery computer "ou=Epos Tills,ou=Stores,ou=Europe,ou=0.T[snipped]" -o rdn -limit 20000 >> till-list2.txt
cscript removequotes.vbs till-list.txt

for /f %%X in (till-list.txt) do call CleanTill-NoPrompt.cmd %%X >> s:\it\scripts\AXTillAutoClean\log.txt
