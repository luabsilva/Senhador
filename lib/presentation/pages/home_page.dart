import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../application/services/history_service.dart';
import '../../application/usecases/generate_password_use_case.dart';
import '../../domain/entities/generated_password.dart';
import '../../domain/entities/password_request.dart';

class HomePage extends StatefulWidget {
  final Future<GeneratedPassword> Function(PasswordRequest request)?
      generatePassword;

  const HomePage({
    super.key,
    this.generatePassword,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _masterPasswordController = TextEditingController();
  final _parameterController = TextEditingController();
  final _masterPasswordFocus = FocusNode();
  final _parameterFocus = FocusNode();
  final _historyService = HistoryService();

  static const _lengthOptions = [12, 16, 20, 24, 32];

  int _selectedLength = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';
  int _strengthScore = 0;
  bool _isProcessing = false;
  List<String> _recentParameters = const <String>[];

  @override
  void initState() {
    super.initState();
    _loadRecentParameters();
  }

  @override
  void dispose() {
    _masterPasswordController.dispose();
    _parameterController.dispose();
    _masterPasswordFocus.dispose();
    _parameterFocus.dispose();
    super.dispose();
  }

  Future<void> _loadRecentParameters() async {
    final recentParameters = await _historyService.getRecentParameters();
    if (!mounted) {
      return;
    }

    setState(() {
      _recentParameters = recentParameters;
    });
  }

  Future<void> _generatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = PasswordRequest(
      masterPassword: _masterPasswordController.text,
      parameter: _parameterController.text,
      length: _selectedLength,
      includeUppercase: _includeUppercase,
      includeLowercase: _includeLowercase,
      includeNumbers: _includeNumbers,
      includeSymbols: _includeSymbols,
    );

    final generatePassword =
        widget.generatePassword ?? const GeneratePasswordUseCase().execute;

    setState(() {
      _isProcessing = true;
      _generatedPassword = '';
      _strengthScore = 0;
    });

    await Future<void>.delayed(Duration.zero);

    late final GeneratedPassword result;
    try {
      result = await generatePassword(request);
      if (!mounted) {
        return;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }

    await _historyService.addParameter(_parameterController.text);
    final recentParameters = await _historyService.getRecentParameters();

    setState(() {
      _generatedPassword = result.value;
      _strengthScore = result.strengthScore;
      _recentParameters = recentParameters;
    });
  }

  void _copyPassword() {
    if (_generatedPassword.isEmpty) {
      return;
    }

    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Senha copiada para a área de transferência.')),
    );
  }

  String get _strengthLabel {
    switch (_strengthScore) {
      case 4:
        return 'Muito Forte';
      case 3:
        return 'Forte';
      case 2:
        return 'Média';
      default:
        return 'Fraca';
    }
  }

  Color get _strengthColor {
    switch (_strengthScore) {
      case 4:
        return Colors.green;
      case 3:
        return Colors.lightGreen;
      case 2:
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senhador'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Gerador de senha determinística',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _parameterController,
                      focusNode: _parameterFocus,
                      decoration: const InputDecoration(
                        labelText: 'Parâmetro',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _masterPasswordFocus.requestFocus();
                      },
                      validator: (value) => (value?.isEmpty ?? true)
                          ? 'Informe o parâmetro.'
                          : null,
                    ),
                    if (_recentParameters.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recentes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _recentParameters
                            .map(
                              (parameter) => ActionChip(
                                label: Text(parameter),
                                onPressed: () {
                                  _parameterController.text = parameter;
                                  _parameterFocus.requestFocus();
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _masterPasswordController,
                      focusNode: _masterPasswordFocus,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha Mestra',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _generatePassword();
                      },
                      validator: (value) => (value?.isEmpty ?? true)
                          ? 'Informe a senha mestra.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedLength,
                      decoration: const InputDecoration(
                        labelText: 'Tamanho da senha',
                        border: OutlineInputBorder(),
                      ),
                      items: _lengthOptions
                          .map(
                            (value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value caracteres'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedLength = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Incluir letras maiúsculas'),
                      value: _includeUppercase,
                      onChanged: (value) =>
                          setState(() => _includeUppercase = value),
                    ),
                    SwitchListTile(
                      title: const Text('Incluir letras minúsculas'),
                      value: _includeLowercase,
                      onChanged: (value) =>
                          setState(() => _includeLowercase = value),
                    ),
                    SwitchListTile(
                      title: const Text('Incluir números'),
                      value: _includeNumbers,
                      onChanged: (value) =>
                          setState(() => _includeNumbers = value),
                    ),
                    SwitchListTile(
                      title: const Text('Incluir símbolos'),
                      value: _includeSymbols,
                      onChanged: (value) =>
                          setState(() => _includeSymbols = value),
                    ),
                    const SizedBox(height: 16),
                    if (_isProcessing) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 8),
                      const Text('Processando...'),
                      const SizedBox(height: 16),
                    ],
                    FilledButton.tonal(
                      onPressed: _isProcessing ? null : _generatePassword,
                      child: const Text('Gerar senha'),
                    ),
                    const SizedBox(height: 24),
                    if (_generatedPassword.isNotEmpty) ...[
                      const Text(
                        'Senha gerada',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _generatedPassword,
                        style:
                            const TextStyle(fontSize: 18, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: _copyPassword,
                              child: const Text('Copiar senha'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _strengthColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: _strengthColor.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.shield_outlined, color: _strengthColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Força estimada: $_strengthLabel',
                                style: TextStyle(
                                  color: _strengthColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
