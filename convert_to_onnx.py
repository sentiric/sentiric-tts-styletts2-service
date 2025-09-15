# sentiric-tts-styletts2-service/convert_to_onnx.py
import torch
import torch.onnx
import os
import sys

# Model yapısını içe aktar (gerçek model yapınıza göre düzenleyin)
sys.path.append('/app')
from model_arch import StyleTTS2Model

def convert_to_onnx():
    # Modeli yükle
    model_path = "/app/models/styletts2_model.pth"
    if not os.path.exists(model_path):
        print("Model dosyası bulunamadı!")
        return False
    
    # Model yapılandırması (gerçek değerlerinizle değiştirin)
    model_config = {
        "num_mels": 80,
        "hidden_size": 256,
        "num_heads": 2,
        "num_layers": 4
    }
    
    model = StyleTTS2Model(**model_config)
    checkpoint = torch.load(model_path, map_location='cpu')
    model.load_state_dict(checkpoint['model'])
    model.eval()

    # Örnek girdi
    dummy_input = torch.randn(1, 80, 100)  # Örnek boyutlar
    
    # ONNX'a dönüştür
    onnx_path = "/app/models/styletts2_model.onnx"
    
    torch.onnx.export(
        model,
        dummy_input,
        onnx_path,
        input_names=["mel_input"],
        output_names=["mel_output"],
        dynamic_axes={
            "mel_input": {0: "batch_size", 2: "time_steps"},
            "mel_output": {0: "batch_size", 2: "time_steps"}
        },
        opset_version=15
    )

    print(f"ONNX modeli başarıyla kaydedildi: {onnx_path}")
    return True

if __name__ == "__main__":
    convert_to_onnx()