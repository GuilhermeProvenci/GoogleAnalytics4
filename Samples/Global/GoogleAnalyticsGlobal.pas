unit GoogleAnalyticsGlobal;

interface

uses
  Google.Controller.Analytics.Interfaces;

var _GoogleAnalytics: iControllerGoogleAnalytics;

implementation

uses
  Google.Controller.Analytics;

const
  //Google Analytics property ID.
  GooglePropertyID =  'ID DA MÉTRICA';
  GoogleApiSecretKey = 'YOURKEYHERE';
  AppName = 'Minha Aplicacao';
  AppLicense = 'Comercial';
  AppEdition = 'ERP';
  VersaoSistema = '1.0.0';

initialization
  _GoogleAnalytics  :=  TControllerGoogleAnalytics
                          .New(GooglePropertyID, GoogleApiSecretKey);

  _GoogleAnalytics.AppInfo
    .AppName(AppName)
    .AppVersion(VersaoSistema)
    .AppLicense(AppLicense)
    .AppEdition(AppEdition);

end.
