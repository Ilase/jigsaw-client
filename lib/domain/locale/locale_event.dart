part of 'locale_bloc.dart';

@immutable
sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLocale extends LocaleEvent {
  final Locale newLocale;
  const ChangeLocale(this.newLocale);

  @override
  List<Object?> get props => [newLocale];
}
