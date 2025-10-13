# sentiric-tts-styletts2-service/Dockerfile
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04
# Build argümanlarını build aşamasında kullanılabilir yap
ARG GIT_COMMIT="unknown"
ARG BUILD_DATE="unknown"
ARG SERVICE_VERSION="0.0.0"
# Sistem bağımlılıklarını yükle
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3.10-venv \
    git \
    wget \
    curl \
    sed \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizini oluştur
WORKDIR /app

# Gerekli Python sürümünü ayarla
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# Python bağımlılıklarını yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ONNX Runtime GPU sürümünü yükle
# Not: Bu satır requirements.txt içinde zaten onnxruntime-gpu olduğu için gereksiz.
# Eğer requirements.txt'den çıkarılırsa tekrar etkinleştirilebilir.
# RUN pip install onnxruntime-gpu

# Uygulama kodunu kopyala
COPY . .

# Model ve çıktı dizinlerini oluştur
RUN mkdir -p /app/models /app/outputs

# Türkçe modeli indirme scripti
# HATA DÜZELTME: Windows CRLF (\r\n) satır sonlarını Unix LF (\n) formatına çevir
RUN sed -i 's/\r$//' /app/download_models.sh
RUN chmod +x /app/download_models.sh
RUN /app/download_models.sh

EXPOSE 14040 14041 14042

CMD ["python3", "app.py"]