-- liczba pozytywnych wniosków per kampania

WITH rn as (
    select distinct r.id_wniosku
                  , mk.id as id_ostatniej_kampanii
              --    , mk.data_kampanii
                  , w.kwota_rekompensaty * oplata_za_usluge_procent/100 as oplata1
                  , row_number() over (partition by r.id_wniosku order by data_kampanii desc) rn
    from rekompensaty r
             inner join wnioski w on r.id_wniosku = w.id
             inner join m_lead ml on w.id = ml.id_wniosku
             inner join m_lead_kampania mlk on ml.id = mlk.id_lead
             inner join m_kampanie mk on mlk.id_kampania = mk.id
 --   where r.id_wniosku = 2589
    order by r.id_wniosku
)
select distinct id_ostatniej_kampanii, count(id_wniosku)
-- count(distinct id_wniosku) as ilość_wnioskow, count(distinct id_ostatniej_kampanii) as ilość_kampanii, sum(oplata1)
-- count(distinct id_wniosku), count(distinct id_ostatniej_kampanii)
from rn
where rn.rn = 1
group by id_ostatniej_kampanii

-- liczba wszytskich wniosków per kampania
WITH rn as (
    select distinct w.id
                  , mk.id as id_ostatniej_kampanii
              --    , mk.data_kampanii
                  , row_number() over (partition by w.id order by data_kampanii desc) rn
    from wnioski w
             inner join m_lead ml on w.id = ml.id_wniosku
             inner join m_lead_kampania mlk on ml.id = mlk.id_lead
             inner join m_kampanie mk on mlk.id_kampania = mk.id
 --   where r.id_wniosku = 2589
    order by w.id
)
select id_ostatniej_kampanii, count(id) -- count(distinct id_wniosku), count(distinct id_ostatniej_kampanii)
from rn
where rn.rn = 1
group by id_ostatniej_kampanii
order by id_ostatniej_kampanii;
