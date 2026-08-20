import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/pagination_action.dart';

class PaginationParams extends Equatable {
  final int limit;
  final PaginationAction action;
  final DocumentSnapshot? firstDoc;
  final DocumentSnapshot? lastDoc;

  const PaginationParams({
    this.limit = 10,
    this.action = PaginationAction.refresh,
    this.firstDoc,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [
    limit,
    action,
    firstDoc,
    lastDoc,
  ];
}