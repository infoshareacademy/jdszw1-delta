select me.id as email_id, mk.typ_kampanii as typ_kampanii, ml.id as "id_leadow"
from m_email as me
    left join m_kampanie mk on mk.id = me.id_kampanii
    left join m_lead_kampania mlk on mk.id = mlk.id_kampania
    left join m_lead ml on mlk.id_lead = ml.id_wniosku
where ml.id is not null
