import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class AppResponse<T> extends Equatable {
  const AppResponse._({
    required this.success,
    required this.message,
    this.data,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.statusCode,
    required this.statusMessage,
  });

  /// The boolean indicates the [AppResponse] is success or failed
  final bool success;

  /// The message of [AppResponse]
  /// * can be array or string
  final String message;

  /// The [AppResponse] data
  final T? data;

  /// Current page number of pagination result.
  @JsonKey(defaultValue: 0)
  final int page;

  /// Limit page size of pagination
  @JsonKey(defaultValue: 0)
  final int pageSize;

  /// Total page of pagination result.
  @JsonKey(defaultValue: 0)
  final int total;

  /// `statusCode` added by http response (Not from server)
  final int statusCode;

  /// `statusMessage` added by http response (Not from server)
  final String statusMessage;

  factory AppResponse({
    bool? success,
    required String message,
    T? data,
    int? page,
    int? pageSize,
    int? total,
    int? statusCode,
    String? statusMessage,
  }) =>
      AppResponse._(
        success: success ?? true,
        message: message,
        data: data,
        page: page ?? 0,
        pageSize: pageSize ?? 0,
        total: total ?? 0,
        statusCode: statusCode ?? 200,
        statusMessage: statusMessage ?? "The request has succeeded.",
      );

  factory AppResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$AppResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object? Function(T? value) toJsonT,
  ) =>
      _$AppResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [
        success,
        message,
        data ?? '',
        page,
        pageSize,
        total,
        statusCode,
        statusMessage
      ];

  @override
  bool? get stringify => true;

  bool get hasNext => page < total;
  bool get isCompleted => page >= total;
}

@JsonSerializable()
class PaginationRequest extends Equatable {
  const PaginationRequest({
    required this.page,
    required this.limit,
  });

  final int page;
  final int limit;

  factory PaginationRequest.fromJson(Map<String, dynamic> json) =>
      _$PaginationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationRequestToJson(this);

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
