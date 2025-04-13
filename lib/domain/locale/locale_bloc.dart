import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String _prefsKey = 'saved_locale'; // Ключ для SharedPreferences

  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<ChangeLocale>(_onChangeLocale);
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_prefsKey);

    if (savedLocale != null) {
      final locale = Locale(savedLocale);
      emit(LocaleState(locale));
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, event.newLocale.languageCode);
    emit(LocaleState(event.newLocale));
  }
}
