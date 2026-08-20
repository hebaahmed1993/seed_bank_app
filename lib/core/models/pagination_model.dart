import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PaginationModel<T> extends Equatable {
  final List<T> items;
  final DocumentSnapshot? firstDoc;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;
  final int currentPage;

  const PaginationModel({
    required this.items,
    this.firstDoc,
    this.lastDoc,
    required this.hasMore,
    this.currentPage = 1,
  });

  factory PaginationModel.empty() {
    return const PaginationModel(
      items: [],
      firstDoc: null,
      lastDoc: null,
      hasMore: true,
      currentPage: 1,
    );
  }

  PaginationModel<T> copyWith({
    List<T>? items,
    DocumentSnapshot? firstDoc,
    DocumentSnapshot? lastDoc,
    bool? hasMore,
    int? currentPage,
  }) {
    return PaginationModel<T>(
      items: items ?? this.items,
      firstDoc: firstDoc ?? this.firstDoc,
      lastDoc: lastDoc ?? this.lastDoc,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    items,
    firstDoc,
    lastDoc,
    hasMore,
    currentPage,
  ];
}