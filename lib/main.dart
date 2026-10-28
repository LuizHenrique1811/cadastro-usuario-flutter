import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CadastroApp());
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Chave usada para validar todos os campos de uma só vez.
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // true = senha escondida; o ícone alterna esse valor.
  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  // Conferida somente depois da checagem de "@".
  static final RegExp _emailRegExp = RegExp(
    r'^[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    final formularioValido = _formKey.currentState!.validate();

    if (!formularioValido) {
      _mostrarSnackBar('Preencha os campos corretamente.', Colors.red);
      return;
    }

    _mostrarSnackBar('Cadastro realizado com sucesso!', Colors.green);
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem, style: const TextStyle(color: Colors.white)),
          backgroundColor: cor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String? _validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome completo.';
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) {
      return 'Informe o e-mail.';
    }
    if (!email.contains('@')) {
      return 'O e-mail deve conter @.';
    }
    if (!_emailRegExp.hasMatch(email)) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  String? _validarCpf(String? valor) {
    final cpf = valor ?? '';
    if (cpf.isEmpty) {
      return 'Informe o CPF.';
    }
    if (cpf.length != 11) {
      return 'O CPF deve ter 11 dígitos.';
    }
    return null;
  }

  String? _validarTelefone(String? valor) {
    final telefone = valor ?? '';
    if (telefone.isEmpty) {
      return 'Informe o telefone.';
    }
    if (telefone.length < 10 || telefone.length > 11) {
      return 'O telefone deve ter 10 ou 11 dígitos.';
    }
    return null;
  }

  String? _validarSenha(String? valor) {
    final senha = valor ?? '';
    if (senha.isEmpty) {
      return 'Informe a senha.';
    }
    if (senha.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }
    return null;
  }

  String? _validarConfirmacao(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme a senha.';
    }
    if (valor != _senhaController.text) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  InputDecoration _decoracao({
    required String label,
    required String hint,
    required IconData icone,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icone),
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(),
    );
  }

  Widget _botaoVisibilidade({
    required bool oculto,
    required VoidCallback aoPressionar,
  }) {
    return IconButton(
      tooltip: oculto ? 'Mostrar senha' : 'Ocultar senha',
      onPressed: aoPressionar,
      icon: Icon(oculto ? Icons.visibility_off : Icons.visibility),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: _decoracao(
                  label: 'Nome completo',
                  hint: 'Ex.: Maria da Silva',
                  icone: Icons.person,
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validarNome,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: _decoracao(
                  label: 'E-mail',
                  hint: 'Ex.: maria@email.com',
                  icone: Icons.email,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                validator: _validarEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cpfController,
                decoration: _decoracao(
                  label: 'CPF',
                  hint: 'Somente números',
                  icone: Icons.badge,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: _validarCpf,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: _decoracao(
                  label: 'Telefone',
                  hint: 'DDD + número',
                  icone: Icons.phone,
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: _validarTelefone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                decoration: _decoracao(
                  label: 'Senha',
                  hint: 'Mínimo de 6 caracteres',
                  icone: Icons.lock,
                  suffixIcon: _botaoVisibilidade(
                    oculto: _ocultarSenha,
                    aoPressionar: () {
                      setState(() => _ocultarSenha = !_ocultarSenha);
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: _ocultarSenha,
                autocorrect: false,
                enableSuggestions: false,
                validator: _validarSenha,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmarSenhaController,
                decoration: _decoracao(
                  label: 'Confirmar senha',
                  hint: 'Repita a senha',
                  icone: Icons.lock_outline,
                  suffixIcon: _botaoVisibilidade(
                    oculto: _ocultarConfirmacao,
                    aoPressionar: () {
                      setState(
                        () => _ocultarConfirmacao = !_ocultarConfirmacao,
                      );
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: _ocultarConfirmacao,
                autocorrect: false,
                enableSuggestions: false,
                validator: _validarConfirmacao,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('CADASTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
