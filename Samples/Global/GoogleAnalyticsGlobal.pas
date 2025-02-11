unit GoogleAnalyticsGlobal;

interface

uses
  Google.Controller.Analytics.Interfaces;

var
  _GoogleAnalytics: iControllerGoogleAnalytics;

implementation

uses
  Google.Controller.Analytics, DotEnv, System.SysUtils;

var
  DotEnv: TDotEnv;
  GooglePropertyID, GoogleApiSecretKey, AppName, AppLicense, AppEdition, VersaoSistema: string;

initialization
  DotEnv := TDotEnv.Create('.env');
  try
    GooglePropertyID   := DotEnv.Get('GOOGLE_PROPERTY_ID', '');
    GoogleApiSecretKey := DotEnv.Get('GOOGLE_API_SECRET', '');
    AppName            := DotEnv.Get('APP_NAME', 'Aplicacao');
    AppLicense         := DotEnv.Get('APP_LICENSE', 'Comercial');
    AppEdition         := DotEnv.Get('APP_EDITION', 'ERP');
    VersaoSistema      := DotEnv.Get('APP_VERSION', '1.0.0');
  finally
    DotEnv.Free;
  end;

  _GoogleAnalytics := TControllerGoogleAnalytics
                        .New(GooglePropertyID, GoogleApiSecretKey);

  _GoogleAnalytics.AppInfo
    .AppName(AppName)
    .AppVersion(VersaoSistema)
    .AppLicense(AppLicense)
    .AppEdition(AppEdition);

finalization
  _GoogleAnalytics.EndSession;

end.

