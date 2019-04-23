select me.id as email_id, mk.typ_kampanii as typ_kampanii, ml.id as "id_leadu", w.id as id_wniosku
from m_email as me
    left join m_kampanie mk on mk.id = me.id_kampanii
    inner join m_lead_kampania mlk on mk.id = mlk.id_kampania
    inner join m_lead ml on mlk.id_lead = ml.id_wniosku
    inner join wnioski w on ml.id_wniosku = w.id

select count(me.id) as email_count, ml.id as "id_leadu", w.id as id_wniosku
from m_email as me
    left join m_kampanie mk on mk.id = me.id_kampanii
    inner join m_lead_kampania mlk on mk.id = mlk.id_kampania
    inner join m_lead ml on mlk.id_lead = ml.id_wniosku
    inner join wnioski w on ml.id_wniosku = w.id
group by ml.id, w.id
order by id_leadu asc
