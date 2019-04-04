import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

Map lightTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

Map darkTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

Map amoLEDTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

Map blueTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

Map redTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

Map greenTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

Map pinkTheme = {
  'background': '',
  'border':'',
  'solidIconDark':'',
  'solidIconLight':'',
  'colorPrimary':'',
  'colorSecondary':'',
  'colorSucess':'',
  'colorAttention':'',
  'colorDanger':'',
};

class ThemeBloc extends Bloc<ThemeEvent, ThemeState>{

  @override
  ThemeState get initialState => Theme();

  @override
  Stream<ThemeState> mapEventToState(ThemeState currentState, ThemeEvent event) async*{
    if(event is ChangeTheme){
      yield* _mapChangeThemeToState(currentState,event);
    }
  }

  Stream<ThemeState>_mapChangeThemeToState(currentState ,event) async*{
    yield Theme(event.theme);
  }

}


abstract class ThemeEvent extends Equatable{
  ThemeEvent([List props = const []]) : super(props);
}

class ChangeTheme extends ThemeEvent{
  int theme;


  ChangeTheme(this.theme) : super([theme]);

  @override
  String toString() => 'ThemeEvent { theme: $theme}';
}



abstract class ThemeState extends Equatable {
  ThemeState([List props = const []]) : super(props);
}

class Theme extends ThemeState {
  final theme;

  Theme([this.theme = const []]) : super([theme]);
  @override
  String toString() => 'Theme{theme: $theme}';
}
