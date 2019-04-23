-- zsumowanie maili z kampanii
select mk.id as ID_kampanii, mk.typ_kampanii as typ_kampanii, sum(me.id) as suma_emailów
from m_kampanie mk
    right join m_email me on mk.id = me.id_kampanii
group by mk.id
order by suma_emailów desc

-- przydzielnie maili do kampanii
select mk.id as ID_kampanii, mk.typ_kampanii as typ_kampanii, me.id as ID_emaila, me.ile_otwarto as otwarto, me.ile_kliknieto
from m_kampanie mk
    right join m_email me on mk.id = me.id_kampanii
order by mk.id

-- która najlepiej klikana
select mk.id as ID_kampanii, mk.typ_kampanii as typ_kampanii, me.id as ID_emaila, me.ile_otwarto as otwarto, me.ile_kliknieto
from m_kampanie mk
    right join m_email me on mk.id = me.id_kampanii
order by me.ile_kliknieto desc

-- która najlepiej otiwerana
select mk.id as ID_kampanii, mk.typ_kampanii as typ_kampanii, me.id as ID_emaila, me.ile_otwarto as otwarto, me.ile_kliknieto
from m_kampanie mk
    right join m_email me on mk.id = me.id_kampanii
order by me.ile_otwarto desc

-- która najlepiej otwierana i klikana
select mk.id as ID_kampanii, mk.typ_kampanii as typ_kampanii, me.id as ID_emaila, me.ile_otwarto as otwarto, me.ile_kliknieto
from m_kampanie mk
    right join m_email me on mk.id = me.id_kampanii
order by me.ile_otwarto desc, me.ile_kliknieto desc

-- średnia ilość kliknieć/otwarć na kampanie
select mk.id as ID_kampanii, mk.typ_kampanii as typ_kampanii, round(avg(me.ile_otwarto),2) as otwarto, round(avg(me.ile_kliknieto),2) kliknieto
from m_kampanie mk
    inner join m_email me on mk.id = me.id_kampanii
group by mk.id
order by kliknieto desc
