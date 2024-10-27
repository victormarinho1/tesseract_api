# Usar uma imagem base do Python
FROM python:3.10-slim

# Definir o diretório de trabalho
WORKDIR /app

# Copiar os arquivos do projeto para o contêiner
COPY . .

# Instalar as dependências do sistema
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    libgl1-mesa-glx \    
    libglib2.0-0 \        
    libsm6 \              
    libxext6 \             
    libxrender1 \         
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar as dependências do Python usando requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Criar diretório para o tessdata e baixar os arquivos de linguagem
RUN mkdir -p tessdata && \
    wget -O ./tessdata/por.traineddata https://github.com/tesseract-ocr/tessdata/raw/main/por.traineddata && \
    wget -O ./tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata

# Definir a variável de ambiente TESSDATA_PREFIX
ENV TESSDATA_PREFIX=/app/tessdata


EXPOSE 5001


# Comando para executar o seu aplicativo
CMD ["python", "leitorplaca.py"]
