--ostatnia kampania dla każdego WYPŁACONEGO wniosku

--łączyć kasę po wnioskach, agregować po kampaniach

WITH rn as (
    select distinct r.id_wniosku
                  , mk.id as id_ostatniej_kampanii
              --    , mk.data_kampanii
                  , row_number() over (partition by r.id_wniosku order by data_kampanii desc) rn
    from rekompensaty r
             inner join wnioski w on r.id_wniosku = w.id
             inner join m_lead ml on w.id = ml.id_wniosku
             inner join m_lead_kampania mlk on ml.id = mlk.id_lead
             inner join m_kampanie mk on mlk.id_kampania = mk.id
 --   where r.id_wniosku = 2589
    order by r.id_wniosku
)
select distinct id_wniosku, id_ostatniej_kampanii -- count(distinct id_wniosku), count(distinct id_ostatniej_kampanii)
from rn
where rn.rn = 1;

