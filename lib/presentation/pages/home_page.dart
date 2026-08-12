import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../application/services/history_service.dart';
import '../../application/usecases/generate_password_use_case.dart';
import '../../core/app_release.dart';
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
  final _masterPasswordFocus = FocusNode();
  final _parameterFocus = FocusNode();
  final _parameterController = TextEditingController();
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
    _masterPasswordFocus.dispose();
    _parameterFocus.dispose();
    _parameterController.dispose();
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
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: CyberTheme.pageBackground,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = math.max(0.0, constraints.maxHeight - 32);
              final frameHeight =
                  kIsWeb ? math.min(availableHeight, 1024.0) : availableHeight;

              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: SizedBox(
                      height: frameHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: GlassContainer(
                              padding: const EdgeInsets.all(20),
                              borderRadius: 24,
                              child: LayoutBuilder(
                                builder: (context, contentConstraints) {
                                  final compactHeight =
                                      contentConstraints.maxHeight < 560;
                                  final sectionGap =
                                      compactHeight ? 12.0 : 16.0;
                                  final content = Column(
                                    mainAxisAlignment: compactHeight
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: _buildContentSections(
                                      sectionGap: sectionGap,
                                      compactHeight: compactHeight,
                                    ),
                                  );

                                  return SingleChildScrollView(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .manual,
                                    child: SizedBox(
                                      height: compactHeight
                                          ? null
                                          : contentConstraints.maxHeight,
                                      child: Form(
                                        key: _formKey,
                                        child: content,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 28,
                            right: 28,
                            child: IgnorePointer(
                              child: Container(
                                height: 2,
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
                          ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 320;
        final identity = Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: CyberTheme.emeraldPrimary.withValues(alpha: 0.3),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
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
                  Text(
                    'CYBER_KEY',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.title,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Modern Password Vault',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      color: const Color(0xFF6EE7B7).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        final controls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: CyberTheme.emeraldPrimary.withValues(alpha: 0.4),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(appReleaseVersion, style: AppTypography.badge),
            ),
            IconButton(
              tooltip: 'Configurações',
              onPressed: _showSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              identity,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: controls),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: identity),
            const SizedBox(width: 8),
            controls,
          ],
        );
      },
    );
  }

  List<Widget> _buildContentSections({
    required double sectionGap,
    required bool compactHeight,
  }) {
    final sections = <Widget>[
      _buildHeader(),
      _buildPasswordOutput(),
      _buildStrengthSection(),
      _buildMasterPasswordField(),
      _buildParameterField(),
      _buildGenerateButton(),
    ];

    return [
      for (var index = 0; index < sections.length; index++) ...[
        sections[index],
        if (index < sections.length - 1)
          SizedBox(height: compactHeight ? sectionGap : 0),
      ],
    ];
  }

  Widget _buildMasterPasswordField() {
    return _buildInputSurface(
      child: TextFormField(
        controller: _masterPasswordController,
        focusNode: _masterPasswordFocus,
        obscureText: _obscureMasterPassword,
        style: AppTypography.label,
        decoration: InputDecoration(
          filled: false,
          hintText: 'Senha Mestra',
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
    );
  }

  Widget _buildParameterField() {
    return _buildInputSurface(
      child: RawAutocomplete<String>(
        textEditingController: _parameterController,
        focusNode: _parameterFocus,
        displayStringForOption: (option) => option,
        optionsBuilder: (value) {
          final query = value.text.trim().toLowerCase();
          return _recentParameters.where(
            (parameter) =>
                query.isEmpty || parameter.toLowerCase().contains(query),
          );
        },
        onSelected: (parameter) {
          _parameterController.text = parameter;
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: AppTypography.label,
            decoration: InputDecoration(
              filled: false,
              hintText: 'Parâmetro',
              suffixIcon: IconButton(
                tooltip: 'Mostrar parâmetros recentes',
                onPressed: () {
                  if (focusNode.hasFocus) {
                    focusNode.unfocus();
                  } else {
                    focusNode.requestFocus();
                  }
                },
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _generatePassword(),
            validator: (value) =>
                (value?.trim().isEmpty ?? true) ? 'Informe o parâmetro.' : null,
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: CyberTheme.glassSurfaceDecoration,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: options
                      .map(
                        (parameter) => Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              parameter,
                              style: AppTypography.label,
                            ),
                            onTap: () => onSelected(parameter),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StrengthMeter(score: _strengthScore),
        if (_isProcessing) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
      ],
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

  Widget _buildInputSurface({
    required Widget child,
  }) {
    return Container(
      decoration: CyberTheme.glassSurfaceDecoration,
      child: child,
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

  Future<void> _showSettings() {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void updateSettings(void Function() update) {
              setState(update);
              setModalState(() {});
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: GlassContainer(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  borderRadius: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Configurações', style: AppTypography.title),
                      const SizedBox(height: 20),
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
                                onChanged: (value) => updateSettings(
                                  () => _selectedLength = value.round(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('$_selectedLength',
                                style: AppTypography.badge),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchItem(
                        label: 'Maiúsculas',
                        value: _includeUppercase,
                        onChanged: (value) => updateSettings(
                          () => _includeUppercase = value,
                        ),
                      ),
                      _buildSwitchItem(
                        label: 'Minúsculas',
                        value: _includeLowercase,
                        onChanged: (value) => updateSettings(
                          () => _includeLowercase = value,
                        ),
                      ),
                      _buildSwitchItem(
                        label: 'Números',
                        value: _includeNumbers,
                        onChanged: (value) => updateSettings(
                          () => _includeNumbers = value,
                        ),
                      ),
                      _buildSwitchItem(
                        label: 'Símbolos',
                        value: _includeSymbols,
                        onChanged: (value) => updateSettings(
                          () => _includeSymbols = value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
