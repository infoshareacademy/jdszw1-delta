-- ile maili przypadło na leada
select count(me.id) as email_count, ml.id as "id_leadu", w.id as id_wniosku
from m_email as me
    inner join m_kampanie mk on mk.id = me.id_kampanii
    inner join m_lead_kampania mlk on mk.id = mlk.id_kampania
    inner join m_lead ml on mlk.id_lead = ml.id_wniosku
    inner join wnioski w on ml.id_wniosku = w.id
group by ml.id, w.id
order by count(me.id) desc;

-- ile kampanii przypadło na jednego leada
select ml.id as lead_id, count(mk.id) as liczba_kampani
from m_lead ml
    left join m_lead_kampania mlk on ml.id = mlk.id_lead
    left join m_kampanie mk on mlk.id_kampania = mk.id
group by ml.id
having count(mk.id) <> 1

-- ile leadow przypadlo na jeden wniosek, tu jest relacja 1 do 1
select count(m_lead.id), w.id
from m_lead
    left join wnioski w on m_lead.id_wniosku = w.id
group by w.id
