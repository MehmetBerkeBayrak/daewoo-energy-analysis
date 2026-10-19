-- Toplam enerji tüketimi en yüksek 10 gün
SELECT
    olcum_zamani::DATE AS gun,
    ROUND(SUM(tuketim_kwh), 2) AS toplam_kwh,
    COUNT(*) AS olcum_sayisi
FROM public.enerji_analiz
GROUP BY olcum_zamani::DATE
ORDER BY toplam_kwh DESC, gun
LIMIT 10;