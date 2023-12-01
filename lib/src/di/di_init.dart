import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:profile_book_flutter/src/di/di_init.config.dart';

final getIt = GetIt.instance;  
  
@InjectableInit(  
  initializerName: 'init', // default  
  preferRelativeImports: true, // default  
  asExtension: true, // default  
)  
void configureDependencies() => getIt.init(); 