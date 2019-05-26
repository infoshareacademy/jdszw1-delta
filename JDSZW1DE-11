--zmieniona wersja, poprawionej przez Tomka i Magdę kwerendy, liczenie czasu trwania odrzucomnych i zaakceptowanych wniosków
select aw.id_wniosku,
(case when status like '%zaakceptowany%'
   then age(aw.data_utworzenia, r.data_zakonczenia)
   else '0'::interval end) as czas_zaakceptowane,
(case when status like '%odrzucony%'
  then age (aw.data_utworzenia, aw.data_zakonczenia)
  else '0'::interval end) as "czas_odrzucone"
from wnioski w
full outer join analizy_wnioskow aw on w.id = aw.id_wniosku
inner join rekompensaty r on w.id = r.id_wniosku
--where age(r.data_zakonczenia, aw.data_utworzenia) > '0.00'
order by 1

with max_min as(
select  max(data_kampanii), min(data_kampanii) from m_kampanie mk)

select age (max, min ) from max_min

