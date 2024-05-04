import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo13/bloc/home_event.dart';
import 'package:ngdemo13/bloc/home_state.dart';

import '../models/post_model.dart';
import '../pages/create_page.dart';
import '../pages/update_page.dart';
import '../services/http_service.dart';
import 'create_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool isLoading = true;
  List<Post> posts = [];

  HomeBloc() : super(HomeInitialState()) {
    on<LoadPostListEvent>(_onLoadPostListEvent);
    on<DeletePostEvent>(_onDeletePostEvent);
  }

  Future<void> _onLoadPostListEvent(
      LoadPostListEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    var response =
        await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());

    if (response != null) {
      List<Post> postList = Network.parsePostList(response);
      posts.addAll(postList);
      emit(HomePostListState(posts));
    } else {
      emit(HomeErrorState('Could not fetch posts'));
    }
  }

  Future<void> _onDeletePostEvent(
      DeletePostEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    var response = await Network.DEL(
        Network.API_POST_DELETE + event.post.id.toString(),
        Network.paramsEmpty());
    if (response != null) {
      emit(HomeDeletePostState());
    } else {
      emit(HomeErrorState('Could not delete post'));
    }
  }

  Future callCreatePage(BuildContext context) async {
    bool result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => CreateBloc(),
            child: const CreatePage(),
          );
        },
      ),
    );

    if (result) {
      add(LoadPostListEvent());
    }
  }

  Future callUpdatePage(BuildContext context, Post post) async {
    bool result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return UpdatePage(post: post);
        },
      ),
    );

    if (result) {
      add(LoadPostListEvent());
    }
  }
}
