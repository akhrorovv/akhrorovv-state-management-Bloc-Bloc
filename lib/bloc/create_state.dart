import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ngdemo13/models/post_model.dart';

@immutable
abstract class CreateState extends Equatable {
  const CreateState();

  @override
  List<Object?> get props => [];
}

class CreateInitialState extends CreateState {}

class CreateLoadingState extends CreateState {}

class CreateErrorState extends CreateState {
  final String errorMessage;

  const CreateErrorState(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class CreatePostState extends CreateState {
  final Post post;

  const CreatePostState(this.post);

  @override
  List<Object?> get props => [post];
}
