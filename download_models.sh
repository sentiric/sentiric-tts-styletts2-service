#!/bin/bash

echo "Türkçe StyleTTS2 model indirme işlemi başlatılıyor..."

# Model dizinini oluştur
mkdir -p /app/models

# Türkçe için fine-tune edilmiş StyleTTS2 modelini indir
if [ ! -f "/app/models/styletts2_tr_model.pth" ]; then
    echo "Türkçe StyleTTS2 modeli indiriliyor..."
    
    # Hugging Face'den model indirme (alternatif linkler)
    if wget -O /app/models/styletts2_tr_model.pth "https://huggingface.co/serkans/styletts2-turkish/resolve/main/styletts2_tr_model.pth"; then
        echo "Model başarıyla indirildi."
    else
        echo "İlk link başarısız, alternatif link deneniyor..."
        # Alternatif model linki
        wget -O /app/models/styletts2_tr_model.pth "https://github.com/serkans/styletts2-turkish/releases/download/v1.0/styletts2_tr_model.pth"
    fi
    
    # Model kontrolü
    if [ -f "/app/models/styletts2_tr_model.pth" ]; then
        echo "Türkçe model indirme başarılı."
    else
        echo "Model indirilemedi. Demo model oluşturuluyor..."
        # Örnek model oluşturma kodu (gerçek model yerine geçmez, test amaçlı)
        python3 -c "
import torch
from model_arch import StyleTTS2Model

# Basit bir model oluştur ve kaydet
model = StyleTTS2Model(num_mels=80, hidden_size=256)
torch.save({'model': model.state_dict()}, '/app/models/styletts2_tr_model.pth')
print('Demo model oluşturuldu.')
        "
    fi
fi

# Vocoder modelini indir (LJSpeech vocoder)
if [ ! -f "/app/models/vocoder_model.pth" ]; then
    echo "Vocoder modeli indiriliyor..."
    wget -O /app/models/vocoder_model.pth "https://drive.google.com/uc?export=download&id=1q8o6pW6JkUqHm0oYdTlK+vS7kZQT+QyN"
fi

# ONNX modeli dönüştürme (eğer mevcut değilse)
if [ ! -f "/app/models/styletts2_tr_model.onnx" ] && [ -f "/app/models/styletts2_tr_model.pth" ]; then
    echo "ONNX model dönüştürülüyor..."
    python3 convert_to_onnx.py
fi

# Gerekli dosyaları kontrol et
echo "Gerekli dosyalar kontrol ediliyor..."
if [ -f "/app/models/styletts2_tr_model.onnx" ]; then
    echo "✓ ONNX model hazır"
else
    echo "✗ ONNX model bulunamadı"
fi

if [ -f "/app/models/vocoder_model.pth" ]; then
    echo "✓ Vocoder model hazır"
else
    echo "✗ Vocoder model bulunamadı"
fi

echo "Model hazırlığı tamamlandı."