class AuthException implements Exception {
  static const Map<String, String> erros = {
    'EMAIL_EXISTS': 'E-mail já cadastrado!',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente, tente mais tarde!',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado!',
    'INVALID_PASSWORD': 'Senha informada não confere!',
    'USER_DISABLED': 'Essa conta está desabilitada!',
    'INVALID_LOGIN_CREDENTIALS': 'Login incorreto!'
  };

  final String key;

  AuthException({required this.key});

  @override
  String toString() {
    return erros[key] ?? 'Sistema de autenticação com problema!';
  }
}
