--szybki check JDSZW1DE-12.sql

--na id_kampanii 808 (bo jest małe i trudno się pomylić ;) )

--z oryginalnej kwerendy
WITH aaa as (
select distinct mlk.id_kampania --, mk.typ_kampanii
                , count(mlk.id_lead) liczba_leadow
                , count(ml.id_wniosku) liczba_wnioskow
                , sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) as oplata_usluga,
            sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_prawnicza_procent)/100) as oplata_usluga_prawnicza,
            (sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) + sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_prawnicza_procent)/100))  as suma
from m_lead_kampania mlk
left join m_lead ml on mlk.id_lead = ml.id
right join m_kampanie mk on mlk.id_kampania = mk.id
left join wnioski w on ml.id_wniosku = w.id
inner join rekompensaty r on r.id_wniosku =  w.id -- ml.id_wniosku --(dla ml.id_wniosku ten sam wynik) ---> ma być r.id_wniosku a nie r.id !!!!

where id_kampania = 808

group by 1 --, 2
having sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) is not null
order by sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) desc
    )

select sum (liczba_wnioskow) as wnioski,  sum(oplata_usluga) oplaty_usługa , sum(oplata_usluga_prawnicza) oplaty_prawnicze
from aaa;


--and sprawdzenie:
-- 26 wniosków dla kampanii 808
select w.*
into temp k808
from m_kampanie mk
inner join m_lead_kampania mlk on mk.id = mlk.id_kampania
inner join m_lead ml on mlk.id_lead = ml.id
inner join wnioski w on w.id = ml.id_wniosku
where id_kampania = 808;

with reko808 as  ( -- 8 wniosków z rekompensatami
    select k8.*
    from k808 k8
             inner join rekompensaty r on r.id_wniosku = k8.id
)
select count(id) , sum((kwota_rekompensaty*oplata_za_usluge_procent)/100), sum(kwota_rekompensaty_oryginalna * (oplata_za_usluge_prawnicza_procent)/100) as oplata_usluga_prawnicza
from reko808 --czyli ten sam wynik :-)
