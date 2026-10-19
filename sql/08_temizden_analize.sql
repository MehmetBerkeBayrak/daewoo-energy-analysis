-- Temiz veriyi uygun veri türleriyle analiz tablosuna ekler.
-- Analiz tablosunda zaten bulunan aynı satırlar tekrar eklenmez.

INSERT INTO public.enerji_analiz
SELECT
    TO_TIMESTAMP(tarih, 'DD/MM/YYYY HH24:MI')::TIMESTAMP
        AS olcum_zamani,
    tuketim_kwh::NUMERIC,
    enduktif_reaktif_kvarh::NUMERIC,
    kapasitif_reaktif_kvarh::NUMERIC,
    co2::NUMERIC,
    enduktif_guc_faktoru::NUMERIC,
    kapasitif_guc_faktoru::NUMERIC,
    gece_yarisindan_saniye::INTEGER,
    hafta_durumu,
    haftanin_gunu,
    yuk_tipi
FROM public.enerji_temiz

EXCEPT

SELECT *
FROM public.enerji_analiz;