class AuthExeption {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "email existe",
    "OPERATION_NOT_ALLOWED": "operação não disponível",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "muitas tentativas, tente depois",
    "EMAIL_NOT_FOUND": "email não encontrado",
    "INVALID_PASSWORD": "senha inválida",
    "USER_DISABLED": "usuário desabilitado",
  };

  final String key;
  const AuthExeption(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro!';
    }
  }
}
