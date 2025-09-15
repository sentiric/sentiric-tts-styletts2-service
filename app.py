# sentiric-tts-styletts2-service/app.py
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, StreamingResponse
import uvicorn
import onnxruntime as ort
import numpy as np
import torch
import io
from scipy.io.wavfile import write
import tempfile
import os
import time
from typing import Optional
from pydantic import BaseModel

# İstek modeli
class TTSRequest(BaseModel):
    text: str
    voice: Optional[str] = "default"
    speed: Optional[float] = 1.0

app = FastAPI(title="StyleTTS2 Service", version="1.0.0")

# ONNX session
ort_session = None

@app.on_event("startup")
async def startup_event():
    """Uygulama başlangıcında modeli yükle"""
    global ort_session
    try:
        onnx_path = "/app/models/styletts2_model.onnx"
        if os.path.exists(onnx_path):
            ort_session = ort.InferenceSession(
                onnx_path,
                providers=['CUDAExecutionProvider', 'CPUExecutionProvider']
            )
            print("ONNX modeli başarıyla yüklendi")
        else:
            print("ONNX modeli bulunamadı")
    except Exception as e:
        print(f"Model yüklenirken hata oluştu: {str(e)}")

@app.get("/health")
async def health_check():
    """Sağlık kontrol endpoint'i"""
    return {
        "status": "healthy",
        "model_loaded": ort_session is not None,
        "timestamp": time.time()
    }

@app.post("/synthesize")
async def synthesize_speech(request: TTSRequest):
    """Metni sese dönüştür"""
    if ort_session is None:
        raise HTTPException(status_code=503, detail="Model yüklenmedi")
    
    try:
        # Metni işle (gerçek metin işleme kodunuzu ekleyin)
        processed_text = preprocess_text(request.text)
        
        # ONNX modeli ile çıkarım yap
        # NOT: Bu kısmı kendi modelinizin girdi/çıktı formatına göre düzenleyin
        input_name = ort_session.get_inputs()[0].name
        output_name = ort_session.get_outputs()[0].name
        
        # Örnek girdi (gerçek girdi formatınıza uygun hale getirin)
        input_data = np.random.randn(1, 80, 100).astype(np.float32)
        
        result = ort_session.run([output_name], {input_name: input_data})
        audio_output = result[0]
        
        # Ses dosyasını oluştur
        sample_rate = 24000
        audio_int16 = (audio_output * 32767).astype(np.int16)
        
        # Geçici dosya yerine bellekte oluştur
        audio_bytes = io.BytesIO()
        write(audio_bytes, sample_rate, audio_int16)
        audio_bytes.seek(0)
        
        return StreamingResponse(
            audio_bytes,
            media_type="audio/wav",
            headers={"Content-Disposition": "attachment; filename=speech.wav"}
        )
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Sentez hatası: {str(e)}")

def preprocess_text(text: str):
    """Metni ön işlemeden geçir"""
    # Bu fonksiyonu kendi metin ön işleme mantığınıza göre doldurun
    return text.lower().strip()

if __name__ == "__main__":
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=14040,
        log_level="info"
    )