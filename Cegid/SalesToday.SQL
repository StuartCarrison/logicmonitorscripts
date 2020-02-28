USE TB_US
declare @whofor varchar(3)
set @whofor = 'USA'
declare @date datetime
set @date = (select dateadd(day,datediff(day,0,(SELECT DATEADD(HH, 8,GETDATE()) )),0)) 

BEGIN
EXEC
('
SELECT CAST(ISNULL(OUTERRESULTS.ITEMS, 0) AS INT) ITEMS, 
CAST(ISNULL(OUTERRESULTS.VALUE, 0) AS DECIMAL(19,2)) VALUE,
ISNULL(OUTERRESULTS.TRANSACTIONS, 0) TRANSACTIONS, '''+@WHOFOR+''' COUNTRYCODE
from
(
select '''+@date+''' today
) today 
left join 
(select DATE, count(x.cegidnum) TRANSACTIONS, sum(x.qty) ITEMS, sum(x.inclvat) VALUE
FROM 
(
select e.et_charlibre1 as AxStore,     
       p.gp_souche as CegidStore,
       cast(p.gp_numero as varchar) as CegidNum,                  
                   p.gp_caisse Register ,                      
				   sum(gl_qtefact)  qty, 
                   p.gp_totalttc as InclVAT,              
                   p.gp_totalhtdev as ExclVAT,       
                p.GP_DATEPIECE Date  
from  piece p 
inner join etabliss e on  e.et_etablissement = p.GP_ETABLISSEMENT 
inner join ligne l    on  l.gl_souche = p.gp_souche                        
                     and l.gl_numero = p.gp_numero                                                                           
                                                                                 and l.gl_caisse = p.gp_caisse 
                                                                                 LEFT JOIN                           ARTICLE A
ON                                                         A.GA_ARTICLE = L.GL_ARTICLE
LEFT JOIN               (SELECT                             OC.GOC_NATUREPIECEG,
                                                                                                                OC.GOC_SOUCHE,
                                                                                                                OC.GOC_NUMERO,
                                                                                                                OC.GOC_INDICEG,
                                                                                                                OC.GOC_NUMLIGNE,
                                                                                                                OC2.GOC_NUMBON                                                                                      
                                                                FROM                   OPERCAISSE OC WITH (NOLOCK)
                                                                LEFT JOIN            OPERCAISSE OC2              WITH (NOLOCK)
                                                                ON                                         OC2.GOC_NATUREPIECEG = OC.GOC_NATUREPIECEG
                                                                AND                                       OC2.GOC_SOUCHE = OC.GOC_SOUCHE
                                                                AND                                       OC2.GOC_NUMERO = OC.GOC_NUMERO
                                                                AND                                       OC2.GOC_INDICEG = OC.GOC_INDICEG
                                                                AND                                       OC2.GOC_NUMBON = OC.GOC_NUMBON
                                                                AND                                       OC2.GOC_PREFIXE = ''GPE''
                                                                WHERE OC.GOC_PREFIXE = ''GL'') OC  
																ON    OC.GOC_NATUREPIECEG = L.GL_NATUREPIECEG
AND                                                       OC.GOC_SOUCHE = L.GL_SOUCHE
AND                                                       OC.GOC_NUMERO = L.GL_NUMERO
AND                                                       OC.GOC_INDICEG = L.GL_INDICEG
AND                                                       OC.GOC_NUMLIGNE = L.GL_NUMLIGNE
where p.gp_naturepieceg = ''FFO''
AND                                                       P.GP_SUPPRIME <> ''X''
AND                                                       P.GP_TICKETANNULE <> ''X''
AND                                                       L.GL_TYPELIGNE = ''ART''
AND                                                       (L.GL_TYPEARTICLE IN (''MAR'',''PRE'')
OR                                                          (L.GL_TYPEARTICLE = ''FI'' 
AND                                                       A.GA_TYPEARTFINAN = ''ABA''
AND                                                       OC.GOC_NUMBON IS NULL
))
AND                                                       ISNULL(L.GL_QTEFACT,0) <> 0 
 AND SUBSTRING(e.et_charlibre1,1,2) = SUBSTRING('''+@WHOFOR+''',1,2)
AND p.GP_DATEPIECE = '''+@date+''' 
and   p.gp_creepar not in  (''GEN'', ''GEF'')
group by p.gp_souche,e.et_charlibre1, p.gp_numero, p.gp_caisse,
         p.gp_totalttc,p.gp_totalhtdev,p.GP_DATEPIECE
) X

GROUP BY DATE
) OUTERRESULTS 
ON OUTERRESULTS.DATE = TODAY.TODAY
'
)
END
