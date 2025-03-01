from fastapi import FastAPI, File, UploadFile, HTTPException, Depends
from fastapi.security.api_key import APIKeyHeader
from pdf2image import convert_from_bytes
from io import BytesIO
from PIL import Image
import base64

# Configuración de API Key para seguridad
API_KEY = "secret here"  # Cambia esto por una clave más segura
api_key_header = APIKeyHeader(name="X-API-Key")

def verify_api_key(api_key: str = Depends(api_key_header)):
    if api_key != API_KEY:
        raise HTTPException(status_code=403, detail="Invalid API Key")
    return api_key

app = FastAPI()

@app.post("/convert_pdf_to_image/")
def convert_pdf(file: UploadFile = File(...), api_key: str = Depends(verify_api_key)):
    try:
        # Leer el PDF en memoria
        pdf_bytes = file.file.read()
        images = convert_from_bytes(pdf_bytes)
        
        # Convertir la primera página a PNG
        img_io = BytesIO()
        images[0].save(img_io, format="PNG")
        img_io.seek(0)
        
        # Convertir la imagen a base64
        encoded_image = base64.b64encode(img_io.getvalue()).decode("utf-8")
        
        return {"filename": file.filename, "image_base64": encoded_image}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
