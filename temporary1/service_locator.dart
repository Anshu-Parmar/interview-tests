import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:startopreneur/data/repository/auth/auth_repository_impl.dart';
import 'package:startopreneur/data/repository/channels/channel_repository_impl.dart';
import 'package:startopreneur/data/repository/news/news_interaction_repository_impl.dart';
import 'package:startopreneur/data/repository/news/news_repository_impl.dart';
import 'package:startopreneur/data/sources/auth/firebase_services.dart';
import 'package:startopreneur/data/sources/channel/firebase_channels_services.dart';
import 'package:startopreneur/data/sources/news/firebase_news_interactions.dart';
import 'package:startopreneur/data/sources/news/firebase_news_services.dart';
import 'package:startopreneur/domain/repository/auth/auth_repository.dart';
import 'package:startopreneur/domain/repository/channels/channel_repository.dart';
import 'package:startopreneur/domain/repository/news/news_interaction_repository.dart';
import 'package:startopreneur/domain/repository/news/news_repository.dart';
import 'package:startopreneur/domain/usecases/auth/apple_sign_in_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/delete_all_user_data_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/get_current_user_uid_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/get_user_provider_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/get_user_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/google_sign_in_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/is_user_signed_in_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/send_forgot_password_email_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/sign_out_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/signin_user_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/signup_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/update_user_data_usecase.dart';
import 'package:startopreneur/domain/usecases/channels/follow_unfollow_channels_usecase.dart';
import 'package:startopreneur/domain/usecases/channels/load_all_channels_usecase.dart';
import 'package:startopreneur/domain/usecases/channels/load_followed_channels_usecase.dart';
import 'package:startopreneur/domain/usecases/news/load_all_news_usecase.dart';
import 'package:startopreneur/domain/usecases/news/load_other_news_usecase.dart';
import 'package:startopreneur/domain/usecases/news/news_interactions/add_or_remove_bookmark_usecase.dart';
import 'package:startopreneur/domain/usecases/news/news_interactions/load_bookmarks_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'openid', 'profile'],
      signInOption: SignInOption.standard
  );
  AppleAuthProvider appleProvider = AppleAuthProvider();
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => googleSignIn);
  sl.registerLazySingleton(() {
    appleProvider = appleProvider.addScope('email');
    appleProvider = appleProvider.addScope('name');
    return appleProvider;
  });
  // sl.registerLazySingleton(() => storage);
  // FirebaseStorage storage = FirebaseStorage.instance;

  //SERVICES SINGLETON
  sl.registerSingleton<FirebaseService>(FirebaseServiceImpl(auth: sl.call(), fireStore: sl.call(), googleSignInInstance: sl.call(), appleProvider: sl.call()));
  sl.registerSingleton<FirebaseNewsServices>(FirebaseNewsServicesImpl(auth: sl.call(), fireStore: sl.call()));
  sl.registerSingleton<FirebaseNewsInteractions>(FirebaseNewsInteractionsImpl(auth: sl.call(), fireStore: sl.call()));
  sl.registerSingleton<FirebaseChannelsServices>(FirebaseChannelsServicesImpl(auth: sl.call(), fireStore: sl.call()));

  //REPOSITORIES
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(auth: sl.call(), fireStore: sl.call()));
  sl.registerSingleton<NewsRepository>(NewsRepositoryImpl(auth: sl.call(), fireStore: sl.call()));
  sl.registerSingleton<NewsInteractionRepository>(NewsInteractionRepositoryImpl(auth: sl.call(), fireStore: sl.call()));
  sl.registerSingleton<ChannelRepository>(ChannelRepositoryImpl(auth: sl.call(), fireStore: sl.call()));

  //USE CASES
  ///AUTH
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase(repository: sl.call()));
  sl.registerSingleton<SignInUseCase>(SignInUseCase(repository: sl.call()));
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase(repository: sl.call()));
  sl.registerSingleton<IsSignInUseCase>(IsSignInUseCase(repository: sl.call()));
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(repository: sl.call()));
  sl.registerSingleton<GetCurrentUserUidUsecase>(GetCurrentUserUidUsecase(repository: sl.call()));
  sl.registerSingleton<SendForgotPasswordEmailUsecase>(SendForgotPasswordEmailUsecase(repository: sl.call()));
  sl.registerSingleton<UpdateUserDataUsecase>(UpdateUserDataUsecase(repository: sl.call()));
  sl.registerSingleton<DeleteAllUserDataUsecase>(DeleteAllUserDataUsecase(repository: sl.call()));
  sl.registerSingleton<GoogleSignInUsecase>(GoogleSignInUsecase(repository: sl.call()));
  sl.registerSingleton<AppleSignInUsecase>(AppleSignInUsecase(repository: sl.call()));
  sl.registerSingleton<GetUserProviderUsecase>(GetUserProviderUsecase(repository: sl.call()));

  ///NEWS
  sl.registerSingleton<LoadAllNewsUsecase>(LoadAllNewsUsecase(repository: sl.call()));
  sl.registerSingleton<LoadOtherNewsUsecase>(LoadOtherNewsUsecase(repository: sl.call()));
  ///NEWS INTERACTIONS
  sl.registerSingleton<LoadBookmarksUsecase>(LoadBookmarksUsecase(repository: sl.call()));
  sl.registerSingleton<AddOrRemoveBookmarkUsecase>(AddOrRemoveBookmarkUsecase(repository: sl.call()));

  //CHANNELS
  sl.registerSingleton<LoadFollowedChannelsUsecase>(LoadFollowedChannelsUsecase(repository: sl.call()));
  sl.registerSingleton<LoadAllChannelsUsecase>(LoadAllChannelsUsecase(repository: sl.call()));
  sl.registerSingleton<FollowUnfollowChannelsUsecase>(FollowUnfollowChannelsUsecase(repository: sl.call()));
}