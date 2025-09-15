# sentiric-tts-styletts2-service/download_models.sh
#!/bin/bash

echo "Model indirme işlemi başlatılıyor..."

# Model dizinini oluştur
mkdir -p /app/models

# Varsayılan StyleTTS2 modelini indir (Türkçe için fine-tune edilmiş model eklenmeli)
if [ ! -f "/app/models/styletts2_model.pth" ]; then
    echo "StyleTTS2 modeli indiriliyor..."
    wget -O /app/models/styletts2_model.pth https://huggingface.co/your-username/styletts2-turkish/resolve/main/model.pth
fi

# ONNX modeli dönüştürme (eğer mevcut değilse)
if [ ! -f "/app/models/styletts2_model.onnx" ]; then
    echo "ONNX model dönüştürülüyor..."
    python3 convert_to_onnx.py
fi

echo "Model hazırlığı tamamlandı."