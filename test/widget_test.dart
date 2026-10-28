import 'package:cadastro_usuario_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> preencher(
    WidgetTester tester,
    String rotulo,
    String valor,
  ) async {
    final campo = find.widgetWithText(TextFormField, rotulo);
    await tester.ensureVisible(campo);
    await tester.enterText(campo, valor);
  }

  Future<void> tocarCadastrar(WidgetTester tester) async {
    final botao = find.text('CADASTRAR');
    await tester.ensureVisible(botao);
    await tester.tap(botao);
    await tester.pump();
  }

  testWidgets('formulário vazio exibe erros e SnackBar vermelho', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());

    await tocarCadastrar(tester);

    expect(find.text('Informe o nome completo.'), findsOneWidget);
    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Informe o CPF.'), findsOneWidget);
    expect(find.text('Informe o telefone.'), findsOneWidget);
    expect(find.text('Informe a senha.'), findsOneWidget);
    expect(find.text('Confirme a senha.'), findsOneWidget);
    expect(find.text('Preencha os campos corretamente.'), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);
  });

  testWidgets('e-mail, senhas e CPF inválidos mostram a mensagem certa', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());

    await preencher(tester, 'Nome completo', 'Maria da Silva');
    await preencher(tester, 'E-mail', 'mariaemail.com');
    await preencher(tester, 'CPF', '12a345678901234');

    final cpf = tester.widget<TextFormField>(
      find.widgetWithText(TextFormField, 'CPF'),
    );
    // Letras são ignoradas e o texto para em 11 dígitos.
    expect(cpf.controller?.text, '12345678901');

    await preencher(tester, 'CPF', '1234567890');
    await preencher(tester, 'Telefone', '119999');
    await preencher(tester, 'Senha', '123');
    await preencher(tester, 'Confirmar senha', '123456');
    await tocarCadastrar(tester);

    expect(find.text('O e-mail deve conter @.'), findsOneWidget);
    expect(find.text('O CPF deve ter 11 dígitos.'), findsOneWidget);
    expect(find.text('O telefone deve ter 10 ou 11 dígitos.'), findsOneWidget);
    expect(
      find.text('A senha deve ter no mínimo 6 caracteres.'),
      findsOneWidget,
    );
    expect(find.text('As senhas não coincidem.'), findsOneWidget);
  });

  testWidgets('e-mail com @ e formato inválido é recusado pela RegExp', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());

    await preencher(tester, 'E-mail', 'maria@email');
    await tocarCadastrar(tester);

    expect(find.text('Informe um e-mail válido.'), findsOneWidget);
    expect(find.text('O e-mail deve conter @.'), findsNothing);
  });

  testWidgets('cadastro válido mostra SnackBar verde de sucesso', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());

    await preencher(tester, 'Nome completo', 'Maria da Silva');
    await preencher(tester, 'E-mail', 'maria@email.com');
    await preencher(tester, 'CPF', '12345678901');
    await preencher(tester, 'Telefone', '11987654321');
    await preencher(tester, 'Senha', 'senha123');
    await preencher(tester, 'Confirmar senha', 'senha123');
    await tocarCadastrar(tester);

    expect(find.text('Cadastro realizado com sucesso!'), findsOneWidget);
    expect(find.text('Informe o nome completo.'), findsNothing);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.green);
  });
}
