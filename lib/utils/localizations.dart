import 'dart:convert';

//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {

    // constructor:
    AppLocalizations(this.locale);

    // fields:
    final Locale locale;
    late Map<String, String> _localizedStrings;

    // static fields:
    static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate(); // Static member to have a simple access from the MaterialApp


    ///
    /// Helper method to keep the code in the widgets concise
    /// Localizations are accessed using an InheritedWidget "of" syntax
    ///
    static AppLocalizations? of(BuildContext context)
    {
      return Localizations.of<AppLocalizations>(context, AppLocalizations);
    }

    ///
    /// This method will be called from every widget which needs a localized text
    ///
    String translate(String key)
    {
      return _localizedStrings[key] ?? 'translation of `$key` is undefined';
    }


    ///
    /// Load the language JSON file from the "lang" folder
    ///
    Future<bool> load() async
    {
        String jsonString = await rootBundle.loadString('i18n/${locale.languageCode}.json');

        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap.map((key, value)
        {
            return MapEntry(key, value.toString());
        });

        return true;
    }
}


///
/// This delegate instance will never change (it doesn't even have fields!)
/// It can provide a constant constructor.
///
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

    const _AppLocalizationsDelegate();

    @override
    bool isSupported(Locale locale)
    {
        // Include all of your supported language codes here:

        return ['en', 'es', 'ru'].contains(locale.languageCode);
    }

    @override Future<AppLocalizations> load(Locale locale) async
    {
        // AppLocalizations class is where the JSON loading actually runs:

        AppLocalizations localizations = AppLocalizations(locale);
        await localizations.load();
        return localizations;
    }

    @override bool shouldReload(_AppLocalizationsDelegate old) => false;
}