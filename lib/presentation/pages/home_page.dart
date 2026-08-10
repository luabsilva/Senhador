import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../application/services/history_service.dart';
import '../../application/usecases/generate_password_use_case.dart';
import '../../domain/entities/generated_password.dart';
import '../../domain/entities/password_request.dart';
import '../themes/app_typography.dart';
import '../themes/cyber_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/password_output_box.dart';
import '../widgets/strength_meter.dart';

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

  int _selectedLength = 16;
  bool _obscureMasterPassword = true;
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
    if (!mounted) return;

    setState(() {
      _recentParameters = recentParameters;
    });
  }

  Future<void> _generatePassword() async {
    if (!_formKey.currentState!.validate()) return;

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
      if (!mounted) return;
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
    if (_generatedPassword.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Senha copiada para a área de transferência.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      body: Container(
        decoration: CyberTheme.pageBackground,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                      maxWidth: 420,
                    ),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 24,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 16),
                          _buildPasswordOutput(),
                          const SizedBox(height: 14),
                          _buildStrengthSection(),
                          const SizedBox(height: 16),
                          _buildInputSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  CyberTheme.emeraldPrimary,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: CyberTheme.emeraldPrimary.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.lock,
                color: CyberTheme.emeraldPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CYBER_KEY', style: AppTypography.title),
                  const SizedBox(height: 3),
                  Text(
                    'Modern Password Vault',
                    style: AppTypography.label.copyWith(
                      color: const Color(0xFF6EE7B7).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: CyberTheme.emeraldPrimary.withValues(alpha: 0.4),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text('v2.1', style: AppTypography.badge),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildGlassField(
            label: 'Senha Mestra',
            child: TextFormField(
              controller: _masterPasswordController,
              focusNode: _masterPasswordFocus,
              obscureText: _obscureMasterPassword,
              style: AppTypography.label,
              decoration: InputDecoration(
                hintText: 'Digite sua senha mestra',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureMasterPassword = !_obscureMasterPassword;
                    });
                  },
                  icon: Icon(
                    _obscureMasterPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: CyberTheme.accentText.withValues(alpha: 0.75),
                  ),
                ),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _parameterFocus.requestFocus(),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Informe a senha mestra.' : null,
            ),
          ),
          const SizedBox(height: 14),
          _buildGlassField(
            label: 'Parâmetro',
            child: TextFormField(
              controller: _parameterController,
              focusNode: _parameterFocus,
              style: AppTypography.label,
              decoration: const InputDecoration(
                hintText: 'gmail.com, github.com, banco',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _generatePassword(),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Informe o parâmetro.' : null,
            ),
          ),
          if (_recentParameters.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Parâmetros recentes', style: AppTypography.label),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentParameters.map((parameter) {
                return ActionChip(
                  label: Text(parameter, style: AppTypography.caption),
                  backgroundColor: const Color(0xFF0A1710),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () {
                    _parameterController.text = parameter;
                    _parameterFocus.requestFocus();
                  },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 12),
          _buildGlassField(
            label: 'Comprimento da senha',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _selectedLength.toDouble(),
                    min: 5,
                    max: 32,
                    divisions: 27,
                    label: '$_selectedLength',
                    onChanged: (value) {
                      setState(() => _selectedLength = value.round());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1A14).withValues(alpha: 224),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    '$_selectedLength',
                    style: AppTypography.badge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildGenerateButton(),
          const SizedBox(height: 12),
          _buildOptionsCollapse(),
        ],
      ),
    );
  }

  Widget _buildPasswordOutput() {
    return PasswordOutputBox(
      password: _generatedPassword,
      isEmpty: _generatedPassword.isEmpty,
      onCopy: _copyPassword,
    );
  }

  Widget _buildStrengthSection() {
    return GlassContainer(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StrengthMeter(score: _strengthScore),
          if (_isProcessing) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _generatePassword,
        child: Text('Gerar senha', style: AppTypography.button),
      ),
    );
  }

  Widget _buildGlassField({
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildOptionsCollapse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(0),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            collapsedBackgroundColor:
                const Color(0xFF050C08).withValues(alpha: 204),
            backgroundColor: const Color(0xFF050C08).withValues(alpha: 204),
            title: Text('Opções de caracteres', style: AppTypography.label),
            iconColor: CyberTheme.emeraldPrimary,
            collapsedIconColor: CyberTheme.emeraldPrimary,
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              _buildSwitchItem(
                label: 'Maiúsculas',
                value: _includeUppercase,
                onChanged: (value) => setState(() => _includeUppercase = value),
              ),
              _buildSwitchItem(
                label: 'Minúsculas',
                value: _includeLowercase,
                onChanged: (value) => setState(() => _includeLowercase = value),
              ),
              _buildSwitchItem(
                label: 'Números',
                value: _includeNumbers,
                onChanged: (value) => setState(() => _includeNumbers = value),
              ),
              _buildSwitchItem(
                label: 'Símbolos',
                value: _includeSymbols,
                onChanged: (value) => setState(() => _includeSymbols = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    required String label,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF050C08).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CyberTheme.borderDark),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.label)),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
