# ocr_card_scanner

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 📱 OCR Card Scanner – RA nas Escolas

Este é um aplicativo Flutter que utiliza **OCR (Reconhecimento Óptico de Caracteres)** com o **Google ML Kit** para detectar **frases específicas em cards físicos** impressos do projeto *RA nas Escolas*. Ao reconhecer a frase, o app abre automaticamente o **link correspondente com conteúdo de Realidade Aumentada (RA)**.

> ✅ Este app está **disponível apenas para o Kit de Mecanismo Celular**.

---

## ✨ Funcionalidades

- 📸 Captura imagens com a câmera automaticamente a cada 2 segundos
- 🧠 Detecta frases dos cards usando OCR
- 🔗 Abre o link correspondente ao conteúdo em RA no navegador
- 🔁 Retoma automaticamente a detecção ao voltar do modo minimizado
- 🖼️ Mostra a **logo personalizada**
- 🖥️ Modo **tela cheia imersiva**

---

## 🖼️ Exemplo de Card

![Card Sarcômero](assets/sarcomero.png)

> Frase reconhecida: `SARCÔMERO`  
> Link aberto: [https://web.zappar.com/?zid=z/-Rvl1c](https://web.zappar.com/?zid=z/-Rvl1c)

---

## 🔗 Acesse os Cards

Todos os cards podem ser baixados e impressos pela plataforma oficial do projeto:

📎 [https://plataforma.raescolas.ufsc.br/pt/ra](https://plataforma.raescolas.ufsc.br/pt/ra)

---

## 🚀 Como Rodar

### ✅ Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio (ou VS Code com extensões Flutter)
- Celular Android (com depuração USB ativada)
- Permissão de câmera

---

### 📱 Executar no Celular Android

1. Conecte o celular via USB e ative a **depuração USB**  
2. No terminal:
   ```bash
   flutter devices
   flutter run
   ```

---

### 🖥️ Executar no Navegador (modo de testes)

> ❗ O OCR pode não funcionar corretamente no navegador.

```bash
flutter run -d chrome
```

---

## 🛠️ Tecnologias Utilizadas

- **Flutter**
- **google_mlkit_text_recognition**
- **camera**
- **url_launcher**
- **Dart**

---

## 📁 Estrutura do Projeto

```
ocr_card_scanner/
├── assets/
│   └── logo.png         # Logo personalizada
│   └── sarcomero.png    # Imagem de exemplo
├── lib/
│   └── main.dart        # Código principal
├── pubspec.yaml         # Dependências e assets
└── README.md            # Este arquivo
```

---

## ℹ️ Observação Importante

Este aplicativo foi desenvolvido para uso com o **Kit de Mecanismo Celular** do projeto **RA nas Escolas - UFSC**.  
Para outros kits, acesse a plataforma oficial ou entre em contato com os responsáveis.

---

## 👩‍💻 Autora

**Carla de Matos**  
Engenharia de Computação  
[LabTeC / UFSC Araranguá](https://labtec.ufsc.br)
