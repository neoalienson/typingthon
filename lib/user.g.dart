// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CollectionGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class UserCollectionReference
    implements UserQuery, FirestoreCollectionReference<UserQuerySnapshot> {
  factory UserCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$UserCollectionReference;

  static User fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return _$UserFromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    User value,
    SetOptions? options,
  ) {
    return _$UserToJson(value);
  }

  @override
  UserDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<UserDocumentReference> add(User value);
}

class _$UserCollectionReference extends _$UserQuery
    implements UserCollectionReference {
  factory _$UserCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$UserCollectionReference._(
      firestore.collection('users').withConverter(
            fromFirestore: UserCollectionReference.fromFirestore,
            toFirestore: UserCollectionReference.toFirestore,
          ),
    );
  }

  _$UserCollectionReference._(
    CollectionReference<User> reference,
  ) : super(reference, reference);

  String get path => reference.path;

  @override
  CollectionReference<User> get reference =>
      super.reference as CollectionReference<User>;

  @override
  UserDocumentReference doc([String? id]) {
    return UserDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<UserDocumentReference> add(User value) {
    return reference.add(value).then((ref) => UserDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$UserCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class UserDocumentReference
    extends FirestoreDocumentReference<UserDocumentSnapshot> {
  factory UserDocumentReference(DocumentReference<User> reference) =
      _$UserDocumentReference;

  DocumentReference<User> get reference;

  /// A reference to the [UserCollectionReference] containing this document.
  UserCollectionReference get parent {
    return _$UserCollectionReference(reference.firestore);
  }

  late final HistoryRecordCollectionReference history =
      _$HistoryRecordCollectionReference(
    reference,
  );

  @override
  Stream<UserDocumentSnapshot> snapshots();

  @override
  Future<UserDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  Future<void> update({
    String email,
  });

  Future<void> set(User value);
}

class _$UserDocumentReference
    extends FirestoreDocumentReference<UserDocumentSnapshot>
    implements UserDocumentReference {
  _$UserDocumentReference(this.reference);

  @override
  final DocumentReference<User> reference;

  /// A reference to the [UserCollectionReference] containing this document.
  UserCollectionReference get parent {
    return _$UserCollectionReference(reference.firestore);
  }

  late final HistoryRecordCollectionReference history =
      _$HistoryRecordCollectionReference(
    reference,
  );

  @override
  Stream<UserDocumentSnapshot> snapshots() {
    return reference.snapshots().map((snapshot) {
      return UserDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<UserDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then((snapshot) {
      return UserDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<void> delete() {
    return reference.delete();
  }

  Future<void> update({
    Object? email = _sentinel,
  }) async {
    final json = {
      if (email != _sentinel) "email": email as String,
    };

    return reference.update(json);
  }

  Future<void> set(User value) {
    return reference.set(value);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

class UserDocumentSnapshot extends FirestoreDocumentSnapshot {
  UserDocumentSnapshot._(
    this.snapshot,
    this.data,
  );

  @override
  final DocumentSnapshot<User> snapshot;

  @override
  UserDocumentReference get reference {
    return UserDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final User? data;
}

abstract class UserQuery implements QueryReference<UserQuerySnapshot> {
  @override
  UserQuery limit(int limit);

  @override
  UserQuery limitToLast(int limit);

  UserQuery whereEmail({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  });

  UserQuery orderByEmail({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    UserDocumentSnapshot? startAtDocument,
    UserDocumentSnapshot? endAtDocument,
    UserDocumentSnapshot? endBeforeDocument,
    UserDocumentSnapshot? startAfterDocument,
  });
}

class _$UserQuery extends QueryReference<UserQuerySnapshot>
    implements UserQuery {
  _$UserQuery(
    this.reference,
    this._collection,
  );

  final CollectionReference<Object?> _collection;

  @override
  final Query<User> reference;

  UserQuerySnapshot _decodeSnapshot(
    QuerySnapshot<User> snapshot,
  ) {
    final docs = snapshot.docs.map((e) {
      return UserQueryDocumentSnapshot._(e, e.data());
    }).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return FirestoreDocumentChange<UserDocumentSnapshot>(
        type: change.type,
        oldIndex: change.oldIndex,
        newIndex: change.newIndex,
        doc: UserDocumentSnapshot._(change.doc, change.doc.data()),
      );
    }).toList();

    return UserQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  @override
  Stream<UserQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(_decodeSnapshot);
  }

  @override
  Future<UserQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(_decodeSnapshot);
  }

  @override
  UserQuery limit(int limit) {
    return _$UserQuery(
      reference.limit(limit),
      _collection,
    );
  }

  @override
  UserQuery limitToLast(int limit) {
    return _$UserQuery(
      reference.limitToLast(limit),
      _collection,
    );
  }

  UserQuery whereEmail({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  }) {
    return _$UserQuery(
      reference.where(
        'email',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  UserQuery orderByEmail({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    UserDocumentSnapshot? startAtDocument,
    UserDocumentSnapshot? endAtDocument,
    UserDocumentSnapshot? endBeforeDocument,
    UserDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('email', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$UserQuery(query, _collection);
  }

  @override
  bool operator ==(Object other) {
    return other is _$UserQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class UserQuerySnapshot
    extends FirestoreQuerySnapshot<UserQueryDocumentSnapshot> {
  UserQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  final QuerySnapshot<User> snapshot;

  @override
  final List<UserQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<UserDocumentSnapshot>> docChanges;
}

class UserQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot
    implements UserDocumentSnapshot {
  UserQueryDocumentSnapshot._(this.snapshot, this.data);

  @override
  final QueryDocumentSnapshot<User> snapshot;

  @override
  UserDocumentReference get reference {
    return UserDocumentReference(snapshot.reference);
  }

  @override
  final User data;
}

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class HistoryRecordCollectionReference
    implements
        HistoryRecordQuery,
        FirestoreCollectionReference<HistoryRecordQuerySnapshot> {
  factory HistoryRecordCollectionReference(
    DocumentReference<User> parent,
  ) = _$HistoryRecordCollectionReference;

  static HistoryRecord fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return _$HistoryRecordFromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    HistoryRecord value,
    SetOptions? options,
  ) {
    return _$HistoryRecordToJson(value);
  }

  /// A reference to the containing [UserDocumentReference] if this is a subcollection.
  UserDocumentReference get parent;

  @override
  HistoryRecordDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<HistoryRecordDocumentReference> add(HistoryRecord value);
}

class _$HistoryRecordCollectionReference extends _$HistoryRecordQuery
    implements HistoryRecordCollectionReference {
  factory _$HistoryRecordCollectionReference(
    DocumentReference<User> parent,
  ) {
    return _$HistoryRecordCollectionReference._(
      UserDocumentReference(parent),
      parent.collection('history').withConverter(
            fromFirestore: HistoryRecordCollectionReference.fromFirestore,
            toFirestore: HistoryRecordCollectionReference.toFirestore,
          ),
    );
  }

  _$HistoryRecordCollectionReference._(
    this.parent,
    CollectionReference<HistoryRecord> reference,
  ) : super(reference, reference);

  @override
  final UserDocumentReference parent;

  String get path => reference.path;

  @override
  CollectionReference<HistoryRecord> get reference =>
      super.reference as CollectionReference<HistoryRecord>;

  @override
  HistoryRecordDocumentReference doc([String? id]) {
    return HistoryRecordDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<HistoryRecordDocumentReference> add(HistoryRecord value) {
    return reference
        .add(value)
        .then((ref) => HistoryRecordDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$HistoryRecordCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class HistoryRecordDocumentReference
    extends FirestoreDocumentReference<HistoryRecordDocumentSnapshot> {
  factory HistoryRecordDocumentReference(
          DocumentReference<HistoryRecord> reference) =
      _$HistoryRecordDocumentReference;

  DocumentReference<HistoryRecord> get reference;

  /// A reference to the [HistoryRecordCollectionReference] containing this document.
  HistoryRecordCollectionReference get parent {
    return _$HistoryRecordCollectionReference(
      reference.parent.parent!.withConverter<User>(
        fromFirestore: UserCollectionReference.fromFirestore,
        toFirestore: UserCollectionReference.toFirestore,
      ),
    );
  }

  @override
  Stream<HistoryRecordDocumentSnapshot> snapshots();

  @override
  Future<HistoryRecordDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  Future<void> update({
    int wpm,
  });

  Future<void> set(HistoryRecord value);
}

class _$HistoryRecordDocumentReference
    extends FirestoreDocumentReference<HistoryRecordDocumentSnapshot>
    implements HistoryRecordDocumentReference {
  _$HistoryRecordDocumentReference(this.reference);

  @override
  final DocumentReference<HistoryRecord> reference;

  /// A reference to the [HistoryRecordCollectionReference] containing this document.
  HistoryRecordCollectionReference get parent {
    return _$HistoryRecordCollectionReference(
      reference.parent.parent!.withConverter<User>(
        fromFirestore: UserCollectionReference.fromFirestore,
        toFirestore: UserCollectionReference.toFirestore,
      ),
    );
  }

  @override
  Stream<HistoryRecordDocumentSnapshot> snapshots() {
    return reference.snapshots().map((snapshot) {
      return HistoryRecordDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<HistoryRecordDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then((snapshot) {
      return HistoryRecordDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<void> delete() {
    return reference.delete();
  }

  Future<void> update({
    Object? wpm = _sentinel,
  }) async {
    final json = {
      if (wpm != _sentinel) "wpm": wpm as int,
    };

    return reference.update(json);
  }

  Future<void> set(HistoryRecord value) {
    return reference.set(value);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoryRecordDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

class HistoryRecordDocumentSnapshot extends FirestoreDocumentSnapshot {
  HistoryRecordDocumentSnapshot._(
    this.snapshot,
    this.data,
  );

  @override
  final DocumentSnapshot<HistoryRecord> snapshot;

  @override
  HistoryRecordDocumentReference get reference {
    return HistoryRecordDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final HistoryRecord? data;
}

abstract class HistoryRecordQuery
    implements QueryReference<HistoryRecordQuerySnapshot> {
  @override
  HistoryRecordQuery limit(int limit);

  @override
  HistoryRecordQuery limitToLast(int limit);

  HistoryRecordQuery whereWpm({
    int? isEqualTo,
    int? isNotEqualTo,
    int? isLessThan,
    int? isLessThanOrEqualTo,
    int? isGreaterThan,
    int? isGreaterThanOrEqualTo,
    bool? isNull,
    List<int>? whereIn,
    List<int>? whereNotIn,
  });

  HistoryRecordQuery orderByWpm({
    bool descending = false,
    int startAt,
    int startAfter,
    int endAt,
    int endBefore,
    HistoryRecordDocumentSnapshot? startAtDocument,
    HistoryRecordDocumentSnapshot? endAtDocument,
    HistoryRecordDocumentSnapshot? endBeforeDocument,
    HistoryRecordDocumentSnapshot? startAfterDocument,
  });
}

class _$HistoryRecordQuery extends QueryReference<HistoryRecordQuerySnapshot>
    implements HistoryRecordQuery {
  _$HistoryRecordQuery(
    this.reference,
    this._collection,
  );

  final CollectionReference<Object?> _collection;

  @override
  final Query<HistoryRecord> reference;

  HistoryRecordQuerySnapshot _decodeSnapshot(
    QuerySnapshot<HistoryRecord> snapshot,
  ) {
    final docs = snapshot.docs.map((e) {
      return HistoryRecordQueryDocumentSnapshot._(e, e.data());
    }).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return FirestoreDocumentChange<HistoryRecordDocumentSnapshot>(
        type: change.type,
        oldIndex: change.oldIndex,
        newIndex: change.newIndex,
        doc: HistoryRecordDocumentSnapshot._(change.doc, change.doc.data()),
      );
    }).toList();

    return HistoryRecordQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  @override
  Stream<HistoryRecordQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(_decodeSnapshot);
  }

  @override
  Future<HistoryRecordQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(_decodeSnapshot);
  }

  @override
  HistoryRecordQuery limit(int limit) {
    return _$HistoryRecordQuery(
      reference.limit(limit),
      _collection,
    );
  }

  @override
  HistoryRecordQuery limitToLast(int limit) {
    return _$HistoryRecordQuery(
      reference.limitToLast(limit),
      _collection,
    );
  }

  HistoryRecordQuery whereWpm({
    int? isEqualTo,
    int? isNotEqualTo,
    int? isLessThan,
    int? isLessThanOrEqualTo,
    int? isGreaterThan,
    int? isGreaterThanOrEqualTo,
    bool? isNull,
    List<int>? whereIn,
    List<int>? whereNotIn,
  }) {
    return _$HistoryRecordQuery(
      reference.where(
        'wpm',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  HistoryRecordQuery orderByWpm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    HistoryRecordDocumentSnapshot? startAtDocument,
    HistoryRecordDocumentSnapshot? endAtDocument,
    HistoryRecordDocumentSnapshot? endBeforeDocument,
    HistoryRecordDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('wpm', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$HistoryRecordQuery(query, _collection);
  }

  @override
  bool operator ==(Object other) {
    return other is _$HistoryRecordQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class HistoryRecordQuerySnapshot
    extends FirestoreQuerySnapshot<HistoryRecordQueryDocumentSnapshot> {
  HistoryRecordQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  final QuerySnapshot<HistoryRecord> snapshot;

  @override
  final List<HistoryRecordQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<HistoryRecordDocumentSnapshot>> docChanges;
}

class HistoryRecordQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot
    implements HistoryRecordDocumentSnapshot {
  HistoryRecordQueryDocumentSnapshot._(this.snapshot, this.data);

  @override
  final QueryDocumentSnapshot<HistoryRecord> snapshot;

  @override
  HistoryRecordDocumentReference get reference {
    return HistoryRecordDocumentReference(snapshot.reference);
  }

  @override
  final HistoryRecord data;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
    };

HistoryRecord _$HistoryRecordFromJson(Map<String, dynamic> json) =>
    HistoryRecord(
      datetime: DateTime.parse(json['datetime'] as String),
      wpm: json['wpm'] as int,
    );

Map<String, dynamic> _$HistoryRecordToJson(HistoryRecord instance) =>
    <String, dynamic>{
      'datetime': instance.datetime.toIso8601String(),
      'wpm': instance.wpm,
    };
