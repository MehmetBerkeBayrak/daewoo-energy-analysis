SELECT
    olcum_zamani::DATE AS gun,
    COUNT(*) AS olcum_sayisi,
    COUNT(DISTINCT olcum_zamani) AS benzersiz_zaman
FROM public.enerji_analiz
WHERE olcum_zamani IS NOT NULL
GROUP BY olcum_zamani::DATE
HAVING COUNT(*) <> 96
    OR COUNT(DISTINCT olcum_zamani) <> 96
ORDER BY gun;
-- 3. Ardışık ölçümler arasındaki süre kontrolü
WITH zaman_kontrolu AS (
    SELECT
        olcum_zamani,
        LAG(olcum_zamani) OVER (
            ORDER BY olcum_zamani
        ) AS onceki_olcum
    FROM public.enerji_analiz
)
SELECT
    onceki_olcum,
    olcum_zamani,
    olcum_zamani - onceki_olcum AS zaman_farki
FROM zaman_kontrolu
WHERE onceki_olcum IS NOT NULL
  AND olcum_zamani - onceki_olcum <> INTERVAL '15 minutes'
ORDER BY olcum_zamani;