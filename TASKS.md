# 🔬 Sentiric StyleTTS2 Service - Görev Listesi

Bu belge, `styletts2-tts-service`'in geliştirme yol haritasını ve vizyonunu tanımlar.

---

### Faz 1: Araştırma ve Kavram Kanıtlama (Proof of Concept) (Sıradaki Öncelik)

Bu faz, StyleTTS2 modelinin platformumuz için uygunluğunu ve potansiyelini doğrulamayı hedefler.

-   [ ] **Görev ID: TTS-ST2-001 - Model Araştırması ve Kurulumu**
    -   **Açıklama:** StyleTTS2'nin en stabil ve en iyi performans gösteren Python implementasyonunu araştır. Modeli yerel bir ortamda kur ve temel sentezleme yeteneklerini test et.
    -   **Durum:** ⬜ Planlandı.

-   [ ] **Görev ID: TTS-ST2-002 - Temel FastAPI Sarmalayıcısı**
    -   **Açıklama:** Modelin `synthesize` fonksiyonunu çağıran basit bir FastAPI endpoint'i oluştur.
    -   **Durum:** ⬜ Planlandı.

---

### Faz 2: Platform Entegrasyonu

Bu faz, başarılı PoC'yi, platformun geri kalanıyla konuşabilen bir mikroservise dönüştürmeyi hedefler.

-   [ ] **Görev ID: TTS-ST2-003 - `tts-gateway` Entegrasyonu**
    -   **Açıklama:** Servisi `sentiric-infrastructure`'a ekle ve `tts-gateway`'in bu yeni uzman motoru bir seçenek olarak kullanabilmesini sağla.
    -   **Durum:** ⬜ Planlandı.

-   [ ] **Görev ID: TTS-ST2-004 - Gelişmiş Stil Kontrol API'si**
    -   **Açıklama:** API'ye, sesin stilini (emotion, prosody vb.) kontrol etmeyi sağlayan ek parametreler ekle.
    -   **Durum:** ⬜ Planlandı.