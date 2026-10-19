-- Aynı ayın aynı haftanın günleriyle tüketim karşılaştırması
-- İncelenen gün referans ortalamasına dahildir.
WITH gunluk_tuketim AS (
    SELECT
        olcum_zamani::DATE AS gun,
        haftanin_gunu,
        SUM(tuketim_kwh) AS toplam_kwh
    FROM public.enerji_analiz
    GROUP BY olcum_zamani::DATE, haftanin_gunu
),
karsilastirma AS (
    SELECT
        gun,
        haftanin_gunu,
        toplam_kwh,
        AVG(toplam_kwh) OVER (
            PARTITION BY DATE_TRUNC('month', gun), haftanin_gunu
        ) AS referans_ortalama_kwh,
        COUNT(*) OVER (
            PARTITION BY DATE_TRUNC('month', gun), haftanin_gunu
        ) AS referans_gun_sayisi
    FROM gunluk_tuketim
)
SELECT
    gun,
    haftanin_gunu,
    ROUND(toplam_kwh, 2) AS toplam_kwh,
    ROUND(referans_ortalama_kwh, 2) AS referans_ortalama_kwh,
    referans_gun_sayisi,
    ROUND(
        100.0 * (toplam_kwh - referans_ortalama_kwh)
        / NULLIF(referans_ortalama_kwh, 0),
        2
    ) AS fark_yuzde
FROM karsilastirma
ORDER BY fark_yuzde DESC NULLS LAST, gun;