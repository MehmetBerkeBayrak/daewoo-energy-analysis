-- Aylık toplam tüketim ve takvim günü başına ortalama
SELECT
    DATE_TRUNC('month', olcum_zamani)::DATE AS ay,
    ROUND(SUM(tuketim_kwh), 2) AS toplam_kwh,
    COUNT(DISTINCT olcum_zamani::DATE) AS gun_sayisi,
    ROUND(
        SUM(tuketim_kwh)
        / NULLIF(COUNT(DISTINCT olcum_zamani::DATE), 0),
        2
    ) AS gunluk_ortalama_kwh,
    COUNT(*) AS olcum_sayisi
FROM public.enerji_analiz
GROUP BY DATE_TRUNC('month', olcum_zamani)::DATE
ORDER BY ay;