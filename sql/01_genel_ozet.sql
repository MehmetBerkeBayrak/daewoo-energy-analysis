-- 2018 enerji tüketimi genel özeti
SELECT
    COUNT(*) AS olcum_sayisi,
    MIN(olcum_zamani) AS ilk_olcum,
    MAX(olcum_zamani) AS son_olcum,
    ROUND(SUM(tuketim_kwh), 2) AS toplam_tuketim_kwh,
    ROUND(AVG(tuketim_kwh), 2) AS ortalama_15dk_kwh,
    MIN(tuketim_kwh) AS minimum_15dk_kwh,
    MAX(tuketim_kwh) AS maksimum_15dk_kwh
FROM public.enerji_analiz;