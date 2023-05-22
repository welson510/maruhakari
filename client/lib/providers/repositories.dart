import 'package:client/providers/endpoint.dart';
import 'package:client/repositories/account_repository.dart';
import 'package:client/repositories/auth_repository.dart';
import 'package:client/repositories/food_template_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'grpc.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

final accountRepositoryProvider = Provider((ref) {
  return AccountRepository(
    client: ref.read(apiClientServiceProvider),
    authRepository: ref.read(authRepositoryProvider),
  );
});

final foodTemplateRepository = Provider((ref) {
  return FoodTemplateRepository(client: ref.read(apiClientServiceProvider));
});