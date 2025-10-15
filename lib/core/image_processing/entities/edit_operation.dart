import '../enums/transformation.dart';

class EditOperation {
  final TransformationType type;
  final Map<String, dynamic> params;
  final DateTime at;

  EditOperation({
    required this.type,
    this.params = const {},
    DateTime? at,
  }) : at = at ?? DateTime.now();

  @override
  String toString() => 'EditOperation($type, $params)';
}