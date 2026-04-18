import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/firebase_config.dart';
import '../../dtos/pass_dtos.dart';
import '/model/pass/pass.dart';
import 'pass_repository.dart';

class PassRepositoryFirebase implements PassRepository {
  final Uri passesUri =
      FirebaseConfig.baseUri.replace(path: '/passes.json');

  List<Pass>? _cachedPasses;

  // 🔹 Fetch all passes
  @override
  Future<List<Pass>> getPasses({bool forceFetch = false}) async {
    // return cache
    if (_cachedPasses != null && !forceFetch) {
      return _cachedPasses!;
    }

    final http.Response response = await http.get(passesUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load passes');
    }

    final body = json.decode(response.body);

    if (body == null) return [];

    final Map<String, dynamic> passesJson = body;

    final List<Pass> result = [];

    for (final entry in passesJson.entries) {
      result.add(PassDto.fromJson(entry.key, entry.value));
    }

    _cachedPasses = result;

    return result;
  }

  // 🔹 Fetch single pass
  @override
  Future<Pass?> getPassById(String id) async {
    final Uri uri =
        FirebaseConfig.baseUri.replace(path: '/passes/$id.json');

    final http.Response response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load pass $id');
    }

    final body = json.decode(response.body);

    if (body == null) return null;

    return PassDto.fromJson(id, body);
  }

  // 🔹 Purchase pass
  @override
  Future<Pass> purchasePass(PassType type) async {
    final Uri uri =
        FirebaseConfig.baseUri.replace(path: '/passes.json');

    final now = DateTime.now();

    final pass = Pass(
      id: '',
      type: type,
      startDate: now,
      endDate: now.add(_getDuration(type)),
    );

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(PassDto().toJson(pass)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to purchase pass');
    }

    final Map<String, dynamic> responseJson =
        json.decode(response.body);

    final String newId = responseJson['name'];

    final newPass = Pass(
      id: newId,
      type: pass.type,
      startDate: pass.startDate,
      endDate: pass.endDate,
    );

    _cachedPasses?.add(newPass);

    return newPass;
  }

  // cancel pass
  @override
  Future<void> cancelPass(String id) async {
    final Uri uri =
        FirebaseConfig.baseUri.replace(path: '/passes/$id.json');

    final http.Response response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete pass $id');
    }

    _cachedPasses?.removeWhere((p) => p.id == id);
  }

  // 🔹 Helper
  Duration _getDuration(PassType type) {
    switch (type) {
      case PassType.day:
        return const Duration(days: 1);
      case PassType.monthly:
        return const Duration(days: 30);
      case PassType.yearly:
        return const Duration(days: 365);
    }
  }
}