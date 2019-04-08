import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rallyapp/utility/config.dart';
import 'package:ini/ini.dart';

/// background: everything behind the grid and the main color of most pages
/// text: Text on the background or header color
/// header: Top row on the calendar and also appbars in other pages
/// headerText: Normal text shown on the header color
/// headerTodayText: Text to show which day is "today"
/// border: border for grid on calendar and any card elements
/// solidIconDark: Icon color for when its display with a lighter background
/// solidIconLight: Icon color for when its displayed with a darker background
/// colorPrimary: main buttons New event or sent friend invite
/// colorSecondary: secondary buttons mostly for canceling
/// colorSuccess: color used for alerts of success
/// colorAttention: color used for something to get the user's attention
/// colorDanger: color used to display an error message or a dangerous button.

Map lightTheme = {
  'background': Colors.white,
  'text': Colors.grey[500],
  'textTitle': Colors.black,
  'card': Colors.white,
  'cardListBackground': Colors.grey[200],
  'header': Colors.white,
  'headerText': Colors.grey[500],
  'headerTodayText': Colors.blue,
  'footer': Colors.white,
  'border': Colors.grey[400],
  'shadow': Colors.grey[500],
  'solidIconDark':Colors.grey,
  'solidIconLight':Colors.grey,
  'colorPrimary':Colors.blue,
  'colorSecondary':Colors.grey,
  'colorSuccess':Colors.green,
  'colorAttention':Colors.orange,
  'colorDanger':Colors.red,
};

Map darkTheme = {
  'background': Colors.grey[700],
  'text': Colors.grey[500],
  'textTitle': Colors.white,
  'card': Colors.grey[800],
  'cardListBackground': Colors.grey[600],
  'header':Colors.grey[800],
  'headerText': Colors.grey[500],
  'headerTodayText': Colors.orange,
  'footer': Colors.grey[800],
  'border':Colors.grey[600],
  'shadow': Colors.grey[900],
  'solidIconDark':Colors.grey[600],
  'solidIconLight':Colors.orange,
  'colorPrimary':Colors.orange,
  'colorSecondary':Colors.grey[600],
  'colorSuccess':Colors.green,
  'colorAttention':Colors.yellow[800],
  'colorDanger':Colors.red,
};

Map darkBlueTheme = {
  'background': Colors.blueGrey[700],
  'text': Colors.blueGrey[200],
  'textTitle': Colors.white,
  'card': Colors.blueGrey[400],
  'cardListBackground': Colors.blueGrey[600],
  'header':Colors.blueGrey[800],
  'headerText': Colors.blueGrey[400],
  'headerTodayText': Colors.blueGrey[100],
  'footer': Colors.blueGrey[800],
  'border':Colors.blueGrey[200],
  'shadow': Colors.grey[900],
  'solidIconDark':Colors.blueGrey[600],
  'solidIconLight':Colors.grey[300],
  'colorPrimary':Colors.blueGrey[300],
  'colorSecondary':Colors.grey[600],
  'colorSuccess':Colors.green[800],
  'colorAttention':Colors.yellow[800],
  'colorDanger':Colors.deepOrange,
};

Map amoLEDTheme = {
  'background': Colors.black,
  'text': Colors.grey[500],
  'textTitle': Colors.white,
  'card': Colors.grey[800],
  'cardListBackground': Colors.grey[900],
  'header':Colors.black,
  'headerText': Colors.grey[500],
  'headerTodayText': Colors.white,
  'footer': Colors.black,
  'border':Colors.grey[800],
  'shadow': Colors.grey[900],
  'solidIconDark':Colors.grey[500],
  'solidIconLight':Colors.white,
  'colorPrimary':Colors.blue[900],
  'colorSecondary':Colors.blueGrey,
  'colorSuccess':Colors.green[900],
  'colorAttention':Colors.orange[900],
  'colorDanger':Colors.red[900],
};

Map blueTheme = {
  'background': Colors.white,
  'text': Colors.grey[500],
  'textTitle': Colors.black,
  'card': Colors.white,
  'cardListBackground': Colors.grey,
  'header': Colors.blue,
  'headerText': Colors.white,
  'headerTodayText': Colors.orange,
  'footer': Colors.white,
  'border': Colors.grey[400],
  'shadow': Colors.grey[500],
  'solidIconDark':Colors.grey,
  'solidIconLight':Colors.white,
  'colorPrimary':Colors.blue,
  'colorSecondary':Colors.grey,
  'colorSuccess':Colors.green,
  'colorAttention':Colors.orange,
  'colorDanger':Colors.red,
};

Map redTheme = {
  'background': Colors.white,
  'text': Colors.grey[500],
  'textTitle': Colors.black,
  'card': Colors.white,
  'cardListBackground': Colors.grey,
  'header': Colors.red,
  'headerText': Colors.white,
  'headerTodayText': Colors.green[200],
  'footer': Colors.white,
  'border': Colors.grey[400],
  'shadow': Colors.grey[500],
  'solidIconDark':Colors.grey,
  'solidIconLight':Colors.white,
  'colorPrimary':Colors.red,
  'colorSecondary':Colors.grey,
  'colorSuccess':Colors.green,
  'colorAttention':Colors.orange,
  'colorDanger':Colors.red,
};

Map greenTheme = {
  'background': Colors.white,
  'text': Colors.grey[500],
  'card': Colors.white,
  'cardListBackground': Colors.grey,
  'header': Colors.green,
  'headerText': Colors.white,
  'headerTodayText': Colors.red[200],
  'footer': Colors.white,
  'border': Colors.grey[400],
  'shadow': Colors.grey[500],
  'solidIconDark':Colors.grey,
  'solidIconLight':Colors.white,
  'colorPrimary':Colors.green,
  'colorSecondary':Colors.grey,
  'colorSuccess':Colors.green,
  'colorAttention':Colors.orange,
  'colorDanger':Colors.red,
};

Map pinkTheme = {
  'background': Colors.white,
  'text': Colors.grey[500],
  'textTitle': Colors.black,
  'card': Colors.white,
  'cardListBackground': Colors.grey,
  'header': Colors.pink,
  'headerText': Colors.white,
  'headerTodayText': Colors.green[200],
  'footer': Colors.white,
  'border': Colors.grey[400],
  'shadow': Colors.grey[500],
  'solidIconDark':Colors.grey,
  'solidIconLight':Colors.white,
  'colorPrimary':Colors.pink,
  'colorSecondary':Colors.grey,
  'colorSuccess':Colors.green,
  'colorAttention':Colors.orange,
  'colorDanger':Colors.red,
};

class ThemeBloc extends Bloc<ThemeEvent, ThemeState>{

  @override
  ThemeState get initialState => ThemeLoaded(lightTheme);

  @override
  Stream<ThemeState> mapEventToState(ThemeState currentState, ThemeEvent event) async*{
    if(event is ChangeTheme){
      yield* _mapChangeThemeToState(currentState,event);
    }
  }

  Stream<ThemeState>_mapChangeThemeToState(currentState ,event) async*{
    if(event.theme == "light"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'light');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'light');
        writeToConf(config);
      }
      yield ThemeLoaded(lightTheme);
    }
    else if(event.theme == "dark"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'dark');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'dark');
        writeToConf(config);
      }
      yield ThemeLoaded(darkTheme);
    }
    else if(event.theme == "darkBlue"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'darkBlue');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'darkBlue');
        writeToConf(config);
      }
      yield ThemeLoaded(darkBlueTheme);
    }
    else if(event.theme == "amoled"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'amoled');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'amoled');
        writeToConf(config);
      }
      yield ThemeLoaded(amoLEDTheme);
    }
    else if(event.theme == "blue"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'blue');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'blue');
        writeToConf(config);
      }
      yield ThemeLoaded(blueTheme);
    }
    else if(event.theme == "red"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'red');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'red');
        writeToConf(config);
      }
      yield ThemeLoaded(redTheme);
    }
    else if(event.theme == "green"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'green');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'green');
        writeToConf(config);
      }
      yield ThemeLoaded(greenTheme);
    }
    else if(event.theme == "pink"){
      var config = await readConf();
      if(!config.hasSection('theme')){
        config.addSection('theme');
        config.set('theme', 'appTheme', 'pink');
        writeToConf(config);
      } else{
        config.set('theme', 'appTheme', 'pink');
        writeToConf(config);
      }
      yield ThemeLoaded(pinkTheme);
    }
  }

}


abstract class ThemeEvent extends Equatable{
  ThemeEvent([List props = const []]) : super(props);
}

class ChangeTheme extends ThemeEvent{
  String theme;


  ChangeTheme(this.theme) : super([theme]);

  @override
  String toString() => 'ThemeEvent { theme: $theme}';
}



abstract class ThemeState extends Equatable {
  ThemeState([List props = const []]) : super(props);
}

class ThemeLoaded extends ThemeState {
  final theme;

  ThemeLoaded([this.theme = const []]) : super([theme]);
  @override
  String toString() => 'Theme{theme: $theme}';
}
