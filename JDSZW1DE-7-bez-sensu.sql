-- uzyskanie numerów (id) wniosków, któe pochodzą z e-maili i wrzucenie ich do tabeli tymczasowej
-- UWAGA - może się dłuugo liczyć
select distinct wnioski.id
into temp wnioski_z_maili
from m_email as email
inner join m_kampanie kamp on email.id_kampanii = kamp.id
inner join m_lead_kampania lead_kamp on kamp.id = lead_kamp.id_kampania
inner join m_lead lead on lead_kamp.id_lead = lead.id
inner join wnioski  on lead.id_wniosku = wnioski.id
where wnioski.id is not null;

--ilośc wniosków od klientów z maili
--distinct 46398
select count(wnioski_z_maili.id) from wnioski_z_maili;

-- w analizach wniosków nie ma wszystkich wniosków
-- 27132  rekordów o wnioskach z tabeli analizy wniosków
select count(ao.id_wniosku)
from wnioski_z_maili as wzm
inner join analizy_wnioskow  ao on wzm.id = ao.id_wniosku;

-- Sprawdzenie, czy status z tabeli analiza_operatora jakoś się łączy ze stanem wniosku z tabeli wnioski

select distinct wzm.id, w.stan_wniosku stan_wniosku_z_tab_wnioski, ao.status status_z_tab_analizy_wnioskow, row_number() over (partition by wzm.id order by wzm.id) as RN
from wnioski_z_maili as wzm
left join wnioski as w on wzm.id = w.id
left join analizy_wnioskow  ao on wzm.id = ao.id_wniosku;

--Statusy wniosków z obu tabel distinct (modyfikacja powyższego)
--Efektem czego nie czaję, co oznacza status z tabeli analizy wnioskow i nie wydaje mi się to szczególnie pomocną informacją

select distinct w.stan_wniosku stan_wniosku_z_tab_wnioski, ao.status status_z_tab_analizy_wnioskow
from wnioski_z_maili as wzm
left join wnioski as w on wzm.id = w.id
left join analizy_wnioskow  ao on wzm.id = ao.id_wniosku
order by stan_wniosku_z_tab_wnioski;

-- nie ma duplikatów na wnioskach (mikro modyfikacja nad powyższym ;) ) - tak tylko sprawdzałam
select * from (select distinct wzm.id, w.stan_wniosku, ao.status, row_number() over (partition by wzm.id order by wzm.id) as RN
from wnioski_z_maili as wzm
left join wnioski as w on wzm.id = w.id
left join analizy_wnioskow  ao on wzm.id = ao.id_wniosku) as Row_table
where RN >1 ;


--ogólnie bez sensu trop - nic nie widzę na razie ciekawego dla nas w tabeli analizy_wniosków, może ktoś inny tam spojrzy później ?

