--
-- PostgreSQL database dump
--

\restrict q5PPbE2J02UJiqeyQzB5CVuSxnZHjRcxz5oQwr2IFmfqRoQM5h4n7htGroaBGoK

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-19 20:21:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16419)
-- Name: enerji_analiz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enerji_analiz (
    olcum_zamani timestamp without time zone,
    tuketim_kwh numeric,
    enduktif_reaktif_kvarh numeric,
    kapasitif_reaktif_kvarh numeric,
    co2 numeric,
    enduktif_guc_faktoru numeric,
    kapasitif_guc_faktoru numeric,
    gece_yarisindan_saniye integer,
    hafta_durumu text,
    haftanin_gunu text,
    yuk_tipi text
);


ALTER TABLE public.enerji_analiz OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: enerji_ham; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enerji_ham (
    tarih text,
    tuketim_kwh text,
    enduktif_reaktif_kvarh text,
    kapasitif_reaktif_kvarh text,
    co2 text,
    enduktif_guc_faktoru text,
    kapasitif_guc_faktoru text,
    gece_yarisindan_saniye text,
    hafta_durumu text,
    haftanin_gunu text,
    yuk_tipi text
);


ALTER TABLE public.enerji_ham OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16394)
-- Name: enerji_temiz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enerji_temiz (
    tarih text,
    tuketim_kwh text,
    enduktif_reaktif_kvarh text,
    kapasitif_reaktif_kvarh text,
    co2 text,
    enduktif_guc_faktoru text,
    kapasitif_guc_faktoru text,
    gece_yarisindan_saniye text,
    hafta_durumu text,
    haftanin_gunu text,
    yuk_tipi text
);


ALTER TABLE public.enerji_temiz OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16424)
-- Name: rapor_aylik_tuketim; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rapor_aylik_tuketim AS
 SELECT (date_trunc('month'::text, olcum_zamani))::date AS ay,
    sum(tuketim_kwh) AS toplam_kwh,
    count(DISTINCT (olcum_zamani)::date) AS gun_sayisi,
    round((sum(tuketim_kwh) / (NULLIF(count(DISTINCT (olcum_zamani)::date), 0))::numeric), 2) AS gunluk_ortalama_kwh,
    count(*) AS olcum_sayisi
   FROM public.enerji_analiz
  GROUP BY ((date_trunc('month'::text, olcum_zamani))::date);


ALTER VIEW public.rapor_aylik_tuketim OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16433)
-- Name: rapor_benzer_gun_karsilastirmasi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rapor_benzer_gun_karsilastirmasi AS
 WITH gunluk_tuketim AS (
         SELECT enerji_analiz.haftanin_gunu,
            (enerji_analiz.olcum_zamani)::date AS gun,
            sum(enerji_analiz.tuketim_kwh) AS toplam_kwh
           FROM public.enerji_analiz
          GROUP BY ((enerji_analiz.olcum_zamani)::date), enerji_analiz.haftanin_gunu
        ), karsilastirma AS (
         SELECT gunluk_tuketim.haftanin_gunu,
            gunluk_tuketim.gun,
            gunluk_tuketim.toplam_kwh,
            avg(gunluk_tuketim.toplam_kwh) OVER (PARTITION BY (date_trunc('month'::text, (gunluk_tuketim.gun)::timestamp with time zone)), gunluk_tuketim.haftanin_gunu) AS referans_ortalama_kwh,
            count(*) OVER (PARTITION BY (date_trunc('month'::text, (gunluk_tuketim.gun)::timestamp with time zone)), gunluk_tuketim.haftanin_gunu) AS referans_gun_sayisi
           FROM gunluk_tuketim
        )
 SELECT haftanin_gunu,
    gun,
    toplam_kwh,
    referans_ortalama_kwh,
    referans_gun_sayisi,
    ((100.0 * (toplam_kwh - referans_ortalama_kwh)) / NULLIF(referans_ortalama_kwh, (0)::numeric)) AS fark_yuzde
   FROM karsilastirma;


ALTER VIEW public.rapor_benzer_gun_karsilastirmasi OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16429)
-- Name: rapor_saatlik_tuketim; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rapor_saatlik_tuketim AS
 SELECT hafta_durumu,
    (EXTRACT(hour FROM olcum_zamani))::integer AS olcum_saati,
    avg(tuketim_kwh) AS ortalama_15dk_kwh,
    count(*) AS olcum_sayisi
   FROM public.enerji_analiz
  GROUP BY hafta_durumu, ((EXTRACT(hour FROM olcum_zamani))::integer);


ALTER VIEW public.rapor_saatlik_tuketim OWNER TO postgres;

-- Completed on 2026-10-19 20:21:09

--
-- PostgreSQL database dump complete
--

\unrestrict q5PPbE2J02UJiqeyQzB5CVuSxnZHjRcxz5oQwr2IFmfqRoQM5h4n7htGroaBGoK

