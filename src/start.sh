#!/usr/bin/env bash

# Use libtcmalloc for better memory management
TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"
[ ! -f /comfyui/models/text_encoders/clip_l.safetensors ] && wget -P /comfyui/models/text_encoders https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
[ ! -f /comfyui/models/text_encoders/t5xxl_fp8_e4m3fn_scaled.safetensors ] && wget -P /comfyui/models/text_encoders https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors
[ ! -f /comfyui/models/vae/ae.safetensors ] && wget -P /comfyui/models/vae https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors
[ ! -f /comfyui/models/diffusion_models/flux1-krea-dev_fp8_scaled.safetensors ] && wget -P /comfyui/models/diffusion_models https://huggingface.co/Comfy-Org/FLUX.1-Krea-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-krea-dev_fp8_scaled.safetensors
[ ! -f /comfyui/models/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors ] && wget -P /comfyui/models/diffusion_models https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors
[ ! -f /comfyui/models/upscale_models/RealESRGAN_x2.pth ] && wget -P /comfyui/models/upscale_models https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth

# Serve the API and don't shutdown the container
if [ "$SERVE_API_LOCALLY" == "true" ]; then
    echo "runpod-worker-comfy: Starting ComfyUI"
    python3 /comfyui/main.py --disable-auto-launch --disable-metadata --listen &

    echo "runpod-worker-comfy: Starting RunPod Handler"
    python3 -u /rp_handler.py --rp_serve_api --rp_api_host=0.0.0.0
else
    echo "runpod-worker-comfy: Starting ComfyUI"
    python3 /comfyui/main.py --disable-auto-launch --disable-metadata &

    echo "runpod-worker-comfy: Starting RunPod Handler"
    python3 -u /rp_handler.py
fi