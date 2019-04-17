



-- liczenie ile kampanii przypada na leada
select id_lead, count(id_kampania) as kl from m_lead_kampania group by id_lead order by kl desc

-- tworzenie tabeli
select id_lead, count(id_kampania) as kl into lead_kamp from m_lead_kampania group by id_lead order by kl desc

--liczenie ile śrenio przypada kampanii na leada/round
select avg(kl) akl from lead_kamp

select round(avg(kl)) akl from lead_kamp

-- ile leadow kampanii przerodziło się we wnioski
select mlk.id_kampania, mk.typ_kampanii, count(mlk.id_lead) liczba_leadow, count(ml.id_wniosku) liczba_wnioskow
from m_lead_kampania mlk
left join m_lead ml on mlk.id_lead = ml.id
right join m_kampanie mk on mlk.id_kampania = mk.id
group by 1, 2
order by liczba_wnioskow desc

-- tworzenie tabeli aby móc policzyć procent wnioski/leady
select mlk.id_kampania, mk.typ_kampanii, count(mlk.id_lead) liczba_leadow, count(ml.id_wniosku) liczba_wnioskow
into skutecznosc
from m_lead_kampania mlk
left join m_lead ml on mlk.id_lead = ml.id
right join m_kampanie mk on mlk.id_kampania = mk.id
group by 1, 2
order by liczba_wnioskow desc
-- liczenie ile liczby wnioski/leady w procentach (nie udało mi się łądnie zaokroąglić bez tworzenia nowej tabeli)
select id_kampania, typ_kampanii,
((cast(liczba_wnioskow as float))/(cast(liczba_leadow as float)))*100 as procent
from skutecznosc
order by procent desc


select mk.id nr_kamp, data_kampanii data_kamp, id_lead, data_wysylki data_wys, w.id nr_wniosku, w.data_utworzenia from m_kampanie mk
right join m_lead_kampania mlk on mk.id = mlk.id_kampania
right join m_lead ml on mlk.id_lead = ml.id
right join wnioski w on ml.id_wniosku = w.id
where mk.id is not null and mk.data_kampanii is not null and mlk.id_lead is not null and ml.data_wysylki is not null
order by data_wys desc

-- data wysyłki w  leadach ma dane typu 2998-01-01, co to znaczy?

--ile czasu minęło od rozpoczęcia kampani do utworzenia wniosku
select mk.id nr_kamp, data_kampanii data_kamp, id_lead, w.id nr_wniosku, w.data_utworzenia,
age(data_utworzenia,data_kampanii) as ile_minelo_czasu
from m_kampanie mk
right join m_lead_kampania mlk on mk.id = mlk.id_kampania
right join m_lead ml on mlk.id_lead = ml.id
right join wnioski w on ml.id_wniosku = w.id
where mk.id is not null and mk.data_kampanii is not null and mlk.id_lead is not null and ml.data_wysylki is not null
group by nr_wniosku
order by nr_wniosku, ile_minelo_czasu desc


-- trochę inne
select mk.id nr_kamp, id_lead, w.id nr_wniosku,
age(data_utworzenia,data_kampanii) as ile_minelo_czasu
from m_kampanie mk
right join m_lead_kampania mlk on mk.id = mlk.id_kampania
right join m_lead ml on mlk.id_lead = ml.id
right join wnioski w on ml.id_wniosku = w.id
where mk.id is not null and mk.data_kampanii is not null and mlk.id_lead is not null and ml.data_wysylki is not null
group by nr_kamp, id_lead, nr_wniosku

--tworzenie tabeli z czasem  której kampanii pochodzi wniosek
select w.id nr_wniosku, mk.id nr_kamp, id_lead,
age(data_kampanii, data_utworzenia) as ile_minelo_czasu
into wnioski_kamp_leady_czas
from m_kampanie mk
right join m_lead_kampania mlk on mk.id = mlk.id_kampania
right join m_lead ml on mlk.id_lead = ml.id
right join wnioski w on ml.id_wniosku = w.id
where mk.id is not null and mk.data_kampanii is not null and mlk.id_lead is not null and ml.data_wysylki is not null
group by nr_wniosku, nr_kamp, id_lead
order by nr_wniosku

-- konkluzje: do jednego wniosku przypisanych jest wiele kampanii,
-- nr wniosku ma chyba zawsze te same  nr leada
-- bardzo małe różnice w odstępach czasu od zakończenia kampanii utworzenia wniosku
-- niestety nie wiem jak wybrać tylko najniższy czas spośród wielu czasów róznicy (data rozpoczęcia kampanii - data złożenia wniosku)

select distinct nr_wniosku, min(ile_minelo_czasu), nr_kamp from wnioski_kamp_leady_czas
group by nr_wniosku, nr_kamp
order by nr_wniosku asc