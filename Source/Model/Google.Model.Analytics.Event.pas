unit Google.Model.Analytics.Event;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces,System.JSON;

type
  TModelGoogleAnalyticsEvent = Class(TInterfacedObject, iModelGoogleEvent, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FCategory: String;
    FAction: String;
    FEventLabel: String;
    FEventValue: Integer;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleEvent;

    function Category: String; overload;
    function Category(Value: String): iModelGoogleEvent; overload;
    function Action: String; overload;
    function Action(Value: String): iModelGoogleEvent; overload;
    function EventLabel: String; overload;
    function EventLabel(Value: String): iModelGoogleEvent; overload;
    function EventValue: Integer; overload;
    function EventValue(Value: Integer): iModelGoogleEvent; overload;
    function Send: iCommand;
    function Execute: iCommand;
    function BuildJsonEvent: string;
  End;

implementation

{ TModelGoogleAnalyticsEvent }

uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils;

function TModelGoogleAnalyticsEvent.Action(Value: String): iModelGoogleEvent;
begin
  Result  :=  Self;
  FAction :=  Value;
end;

function TModelGoogleAnalyticsEvent.BuildJsonEvent: string;
var
  RootObject, EventObject, ParamsObject: TJSONObject;
  EventsArray: TJSONArray;
begin
  RootObject := TJSONObject.Create;
  try
    RootObject.AddPair('client_id', FParent.ClienteID);

    EventsArray := TJSONArray.Create;
    RootObject.AddPair('events', EventsArray);

    EventObject := TJSONObject.Create;
    EventObject.AddPair('name', Trim(FEventLabel));

    ParamsObject := TJSONObject.Create;
    ParamsObject.AddPair('engagement_time_msec', '1000');
    ParamsObject.AddPair('session_id', '999');
    ParamsObject.AddPair('category', FAction);
    ParamsObject.AddPair('action', FEventLabel);
    ParamsObject.AddPair('label', FEventLabel);
    ParamsObject.AddPair('value', FEventValue.ToString);

    EventObject.AddPair('params', ParamsObject);
    EventsArray.AddElement(EventObject);

    Result := RootObject.ToJSON;
  finally
    RootObject.Free;
  end;
end;

function TModelGoogleAnalyticsEvent.Action: String;
begin
  Result  :=  FAction;
end;

function TModelGoogleAnalyticsEvent.Category: String;
begin
  Result  :=  FCategory;
end;

function TModelGoogleAnalyticsEvent.Category(Value: String): iModelGoogleEvent;
begin
  Result  :=  Self;

  FCategory :=  Value;
end;

constructor TModelGoogleAnalyticsEvent.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent :=  AParent;
end;

destructor TModelGoogleAnalyticsEvent.Destroy;
begin
    inherited;
end;

function TModelGoogleAnalyticsEvent.EventLabel(
  Value: String): iModelGoogleEvent;
begin
  Result  :=  Self;
  FEventLabel :=  StringReplace(Value,' ','',[rfReplaceAll]);
end;

function TModelGoogleAnalyticsEvent.EventLabel: String;
begin
  Result  :=  FEventLabel;
end;

function TModelGoogleAnalyticsEvent.EventValue: Integer;
begin
  Result  :=  FEventValue;
end;

function TModelGoogleAnalyticsEvent.EventValue(
  Value: Integer): iModelGoogleEvent;
begin
  Result  :=  Self;

  FEventValue :=  Value;
end;

function TModelGoogleAnalyticsEvent.Execute: iCommand;
var
  HTTPClient: TNetHTTPClient;
  Params: TStringList;
  ResponseContent: string;
  ResponseStream: TStringStream;
begin
  Result:=  Self;
  ResponseStream:= TStringStream.Create(self.BuildJsonEvent,TEncoding.UTF8);
  HTTPClient:= TNetHTTPClient.Create(nil);
  HTTPClient.CustomHeaders['Content-Type'] := 'application/json';
  try
    Params := TStringList.Create;
    try
      Params.Values['&api_secret']:= FParent.googleApiSecretKey;
      Params.Values['&measurement_id']:= FParent.GooglePropertyID;
      try
        ResponseContent:= HTTPClient.Post(StringReplace(FParent.URL+Params.Text,#$D#$A,'',[rfReplaceAll]),ResponseStream).StatusCode.ToString;
      except  on E : Exception do
        raise Exception.Create('Erro na classe: '+E.ClassName+' Mensagem de erro: '+E.Message+ ' Linha: ' + E.StackTrace + 'Status Code'+ ResponseContent);
      end;
    finally
      Params.Free;
      ResponseStream.Free;
    end;
  finally
    HTTPClient.Free;
  end;
end;

class function TModelGoogleAnalyticsEvent.New(AParent: iControllerGoogleAnalytics): iModelGoogleEvent;
begin
  Result := Self.Create(AParent);
end;

function TModelGoogleAnalyticsEvent.Send: iCommand;
begin
  Result  :=  Self;
end;

end.



