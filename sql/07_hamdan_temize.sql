-- Ham tablo korunur.
-- Başlık satırı dışlanır, birebir aynı satırlar tekilleştirilir.
-- Temiz tabloda zaten bulunan satırlar tekrar eklenmez.

INSERT INTO public.enerji_temiz
SELECT DISTINCT *
FROM public.enerji_ham
WHERE REPLACE(tarih, CHR(65279), '') <> 'date'

EXCEPT

SELECT *
FROM public.enerji_temiz;