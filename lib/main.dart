import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:url_launcher/url_launcher.dart';

Timer? _ocrTimer;

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR em Tempo Real',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  bool _isInitialized = false;

  final Map<String, String> frasesComLinks = {
    "SARCÔMERO": "https://web.zappar.com/?zid=z/-Rvl1c&rs=&menu=&toolbar=",
    "MECANISMO DE CONTRAÇÃO":
        "https://web.zappar.com/?zid=z/bBxo1c&rs=&menu=&toolbar=",
    "IMPULSO NERVOSO CHEGA NO TERMINAL DO AXÔNIO":
        "https://web.zappar.com/?zid=z/pu1j1c&rs=&menu=&toolbar=",
    "LIBERAÇÃO DE NEUROTRANSMISSORES":
        "https://web.zappar.com/?zid=z/N5fl1c&rs=&menu=&toolbar=",
    "INTERAÇÃO DOS NEUROTRANSMISSORES COM OS RECEPTORES":
        "https://web.zappar.com/?zid=z/PXEl1c&rs=&menu=&toolbar=",
    "VISÃO MACROSCÓPICA DA RESPIRAÇÃO":
        "https://web.zappar.com/?zid=z/Sjcl1c&rs=&menu=&toolbar=",
    "ALVÉOLOS REVESTIDOS COM CAPILARES":
        "https://web.zappar.com/?zid=z/mZoo1c&rs=&menu=&toolbar=",
    "TROCAS GASOSAS": "https://web.zappar.com/?zid=z/SXYn1c&rs=&menu=&toolbar=",
    "LIGAÇÃO DO SÓDIO NA BOMBA":
        "https://web.zappar.com/?zid=z/ZAjn1c&rs=&menu=&toolbar=",
    "ATIVAÇÃO DA BOMBA PELO ATP":
        "https://web.zappar.com/?zid=z/XnMk1c&rs=&menu=&toolbar=",
    "SAÍDA DO SÓDIO PARA O MEIO EXTRACELULAR":
        "https://web.zappar.com/?zid=z/hcvl1c&rs=&menu=&toolbar=",
    "ENTRADA DO POTÁSSIO NA CÉLULA":
        "https://web.zappar.com/?zid=z/9kml1c&rs=&menu=&toolbar=",
    "DIFUSÃO SIMPLES ATRAVÉS DA MEMBRANA":
        "https://web.zappar.com/?zid=z/-y4l1c&rs=&menu=&toolbar=",
    "OSMOSE EM MEIO HIPERTÔNICO":
        "https://web.zappar.com/?zid=z/pM6o1c&rs=&menu=&toolbar=",
    "OSMOSE EM MEIO HIPOTÔNICO":
        "https://web.zappar.com/?zid=z/u6ii1c&rs=1&menu=1&toolbar=1",
    "DIFUSÃO FACILITADA DA GLICOSE":
        "https://web.zappar.com/?zid=z/2-0l1c&rs=&menu=&toolbar=",
    "VISÃO MACROSCÓPICA DO TRATO GASTROINTESTINAL":
        "https://web.zappar.com/?zid=z/qCzn1c&rs=&menu=&toolbar=",
    "MICROVILOSIDADES DOS ENTERÓCITOS":
        "https://web.zappar.com/?zid=z/nEUk1c&rs=&menu=&toolbar=",
    "DEGRADAÇÃO DE CARBOIDRATOS":
        "https://web.zappar.com/?zid=z/7Kgi1c&rs=&menu=&toolbar=",
    "DEGRADAÇÃO DE PROTEÍNAS":
        "https://web.zappar.com/?zid=z/qWEp1c&rs=&menu=&toolbar=",
    "DEGRADAÇÃO DE GORDURAS":
        "https://web.zappar.com/?zid=z/EZKi1c&rs=&menu=&toolbar=",
  };
  bool linkAberto = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _controller.initialize();
    setState(() => _isInitialized = true);
    _startOcrLoop();
  }

  Future<void> _startOcrLoop() async {
    _ocrTimer?.cancel(); // <- adicione isso no início da função
    _ocrTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted || linkAberto) {
        timer.cancel();
        return;
      }

      try {
        final file = await _controller.takePicture();
        await _processImage(File(file.path));
      } catch (e) {
        print('Erro ao capturar imagem: $e');
      }
    });
  }

  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    String textoCompleto = '';
    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        textoCompleto += '${line.text} ';
      }
    }
    textoCompleto = textoCompleto.trim().toUpperCase();

    print('📝 Texto detectado: $textoCompleto');

    for (var entrada in frasesComLinks.entries) {
      final frase = entrada.key;
      final link = entrada.value;

      if (textoCompleto.contains(frase)) {
        print('🔗 Frase reconhecida: $frase');
        _abrirLink(link);
        break;
      }
    }

    textRecognizer.close();
  }

  /// 🔍 Função de similaridade simples, baseada nas palavras em comum
  int _similaridade(String a, String b) {
    List<String> listaA = a.split(RegExp(r'\s+'));
    List<String> listaB = b.split(RegExp(r'\s+'));

    int iguais = listaB.where((palavra) => listaA.contains(palavra)).length;
    int total = listaB.length;

    return ((iguais / total) * 100).toInt();
  }

  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('❌ Não foi possível abrir o link: $url');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      linkAberto = false;
      _startOcrLoop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', width: 40, height: 40),
                  const SizedBox(width: 10),
                  const Text(
                    '🔍 Buscando card...',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
