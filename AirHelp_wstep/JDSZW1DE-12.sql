-- po wspólnych wysiłkach

-- zarobki na kampanie po dodadniu prawnika i sumy oraz zawężenie do wniosków które są powiazane z rekompensatami
select distinct mlk.id_kampania, mk.typ_kampanii, count(mlk.id_lead) liczba_leadow, count(ml.id_wniosku) liczba_wnioskow,
            sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) as oplata_usluga,
            sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_prawnicza_procent)/100) as oplata_usluga_prawnicza,
            (sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) + sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_prawnicza_procent)/100))  as suma
from m_lead_kampania mlk
left join m_lead ml on mlk.id_lead = ml.id
right join m_kampanie mk on mlk.id_kampania = mk.id
left join wnioski w on ml.id_wniosku = w.id
inner join rekompensaty r on r.id = ml.id_wniosku -- zawęznie wyników
group by 1, 2
having sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) is not null
order by sum(w.kwota_rekompensaty_oryginalna * (w.oplata_za_usluge_procent)/100) desc;
