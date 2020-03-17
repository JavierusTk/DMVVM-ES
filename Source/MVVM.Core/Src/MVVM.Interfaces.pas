unit MVVM.Interfaces;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.UITypes,
  Data.DB,

  Spring,
  Spring.Collections,

  MVVM.Types;

type
{$REGION 'IPlatformServices'}
  IPlatformServices = interface
    ['{95F9A402-2D01-48E5-A38B-9A6202FF5F59}']
    function MessageDlg(const ATitle: string; const AText: String): Boolean;
    function IsMainThreadUI: Boolean;
    function LoadBitmap(const AFileName: String): TObject; overload;
    function LoadBitmap(const AStream: TStream): TObject; overload;
    function LoadBitmap(const AData: System.SysUtils.TBytes): TObject; overload;
    function LoadBitmap(const AMemory: Pointer; const ASize: Integer)
      : TObject; overload;
  end;
{$ENDREGION}
{$REGION 'TPlatformServicesBase'}

  TPlatformServicesBase = class abstract(TInterfacedObject, IPlatformServices)
  public
    function MessageDlg(const ATitulo: string; const ATexto: String): Boolean;
      virtual; abstract;
    function IsMainThreadUI: Boolean; virtual; abstract;
    function LoadBitmap(const AFileName: String): TObject; overload;
      virtual; abstract;
    function LoadBitmap(const AStream: TStream): TObject; overload;
      virtual; abstract;
    function LoadBitmap(const AData: System.SysUtils.TBytes): TObject; overload;
      virtual; abstract;
    function LoadBitmap(const AMemory: Pointer; const ASize: Integer): TObject;
      overload; virtual; abstract;
  end;
{$ENDREGION}

  TPlatformServicesClass = class of TPlatformServicesBase;

{$REGION 'IObject'}

  IObject = interface
    ['{61A3454D-3B58-4CDE-83AE-4C3E73732977}']
    function GetAsObject: TObject;
  end;
{$ENDREGION}
{$REGION 'IMessage'}

  IMessage = interface(IObject)
    ['{8C6AE8E2-B18D-41B4-AAED-88CF3B110F1D}']
    function GetCreationDateTime: TDateTime;
    procedure Queue;

    property CreationDateTime: TDateTime read GetCreationDateTime;
  end;
{$ENDREGION}

  TNotifyMessage = procedure(AMessage: IMessage) of Object;

  TListenerFilter = reference to function(AMessage: IMessage): Boolean;

{$REGION 'IMessageListener'}

  IMessageListener = interface(IObject)
    ['{ABC992B0-4CB4-470A-BDCE-EBE6651C84DD}']
    function GetIsCodeToExecuteInUIMainThread: Boolean;
    procedure SetIsCodeToExecuteInUIMainThread(const AValue: Boolean);

    function GetTypeRestriction: EMessageTypeRestriction;
    procedure SetTypeRestriction(const ATypeRestriction
      : EMessageTypeRestriction);

    function GetListenerFilter: TListenerFilter;
    procedure SetListenerFilter(const AFilter: TListenerFilter);

    function GetMensajeClass: TClass;

    function GetConditionsMatch(AMessage: IMessage): Boolean;

    procedure Register;
    procedure UnRegister;

    procedure NewMessage(AMessage: IMessage);

    property FilterCondition: TListenerFilter read GetListenerFilter
      write SetListenerFilter;
    property IsCodeToExecuteInUIMainThread: Boolean
      read GetIsCodeToExecuteInUIMainThread
      write SetIsCodeToExecuteInUIMainThread;
    property TypeRestriction: EMessageTypeRestriction read GetTypeRestriction
      write SetTypeRestriction;
  end;
{$ENDREGION}
  (*
    {$REGION 'INotificationChanged'}
    INotificationChanged = interface
    ['{DC4EF24C-660A-46EE-8404-4ECF67CF7287}']
    end;
    {$ENDREGION}

    {$REGION 'INotificationChanged<T:INotificationChanged>'}
    IEventNotificationChanged<T:INotificationChanged> = interface(IEvent<T>)
    end;
    {$ENDREGION}

    IEventNotificationChanged = IEventNotificationChanged<INotificationChanged>;
  *)

  IBindingStrategy = interface;
  ICollectionViewProvider = interface;
  IBindableAction = interface;

  (*
    IBindingBase = interface
    ['{CD1A1D15-45F8-4E47-8CCA-98B2E85653A8}']
    function GetBindingStrategy: IBindingStrategy;

    function GetIsMultiCastEventBinding: Boolean;
    procedure SetIsMultiCastEventBinding(const AValue: Boolean);

    property BindingStrategy: IBindingStrategy read GetBindingStrategy;
    property IsMultiCastEventBinding: Boolean read GetIsMultiCastEventBinding write SetIsMultiCastEventBinding;
    end;

    IBindingBase<T> = interface(IBindingBase)
    ['{4AA82C2B-6E24-45DE-82C4-283CBFC337F6}']
    function GetOnEvent: IEvent<T>;

    property OnEvent: IEvent<T> read GetOnEvent;
    end;
  *)

  IStrategyBased = interface
    ['{3F645E49-CD84-430C-982F-2B2ADC128203}']
    function GetBindingStrategy: IBindingStrategy;

    property BindingStrategy: IBindingStrategy read GetBindingStrategy;
  end;

  IStrategyEventedObject = interface;

  IStrategyEventedBased = interface
    ['{72613457-8EBA-47F0-B277-47F66FD4A427}']
    function GetManager: IStrategyEventedObject;

    property Manager: IStrategyEventedObject read GetManager;
  end;

{$REGION 'INotifyFree'}

  TNotifyFreeObjectEvent = procedure(const ASender, AInstance: TObject)
    of Object;

  IFreeEvent = IEvent<TNotifyFreeObjectEvent>;

  INotifyFree = interface(IStrategyEventedBased)
    ['{6512F0E1-FB06-4056-8BF2-735EB05A60AC}']
    function GetOnFreeEvent: IFreeEvent;

    property OnFreeEvent: IFreeEvent read GetOnFreeEvent;
  end;
{$ENDREGION}
{$REGION 'INotifyPropertyChanged'}

  TNotifySomethingChangedEvent = procedure(const ASender: TObject; const AData: String) of Object;

  IChangedPropertyEvent = IEvent<TNotifySomethingChangedEvent>;

  INotifyChangedProperty = interface(IStrategyEventedBased)
    ['{9201E57B-98C2-4724-9D03-84E7BF15CDAE}']
    function GetOnPropertyChangedEvent: IChangedPropertyEvent;

    property OnPropertyChangedEvent: IChangedPropertyEvent
      read GetOnPropertyChangedEvent;
  end;
{$ENDREGION}
{$REGION 'INotifyPropertyChangeTracking'}

  IPropertyChangedTrackingEvent = IEvent<TNotifySomethingChangedEvent>;

  INotifyPropertyTrackingChanged = interface(IStrategyEventedBased)
    ['{70345AF0-199C-4E75-A7BE-5C4929E82620}']
    function GetOnPropertyChangedTrackingEvent: IPropertyChangedTrackingEvent;

    property OnPropertyChangedTrackingEvent: IChangedPropertyEvent
      read GetOnPropertyChangedTrackingEvent;
  end;
{$ENDREGION}

  TCollectionSource = TEnumerable<TObject>;

  TCollectionChangedEvent = procedure(const ASender: TObject; const AArgs: TCollectionChangedEventArgs) of Object;
  IChangedCollectionEvent = IEvent<TCollectionChangedEvent>;

{$REGION 'INotifyCollectionChanged'}

  INotifyCollectionChanged = interface(IStrategyEventedBased)
    ['{1DF02979-CEAF-4783-BEE9-2500700E6604}']
    function GetOnCollectionChangedEvent: IChangedCollectionEvent;

    property OnCollectionChangedEvent: IChangedCollectionEvent
      read GetOnCollectionChangedEvent;
  end;
{$ENDREGION}

{$REGION 'IStrategyEventedObject'}
  IStrategyEventedObject = interface(IStrategyBased)
    ['{CB3FA6A8-371A-481A-AD49-790692843777}']
    function GetOnFreeEvent: IFreeEvent;
    function GetOnPropertyChangedEvent: IChangedPropertyEvent;
    function GetOnPropertyChangedTrackingEvent: IPropertyChangedTrackingEvent;
    function GetOnCollectionChangedEvent: IChangedCollectionEvent;

    function IsAssignedFreeEvent: Boolean;
    function IsAssignedPropertyChangedEvent: Boolean;
    function IsAssignedPropertyChangedTrackingEvent: Boolean;
    function IsAssignedCollectionChangedEvent: Boolean;

    property OnFreeEvent: IFreeEvent read GetOnFreeEvent;
    property OnPropertyChangedEvent: IChangedPropertyEvent
      read GetOnPropertyChangedEvent;
    property OnPropertyChangedTrackingEvent: IChangedPropertyEvent
      read GetOnPropertyChangedTrackingEvent;
    property OnCollectionChangedEvent: IChangedCollectionEvent
      read GetOnCollectionChangedEvent;
  end;
{$ENDREGION}
{$REGION 'TStrategyEventedObject'}

  TStrategyEventedObject = class(TInterfacedObject, IStrategyEventedObject)
  protected
    FObject: TObject;
    FBindingStrategy: IBindingStrategy;
    FOnFreeEvent: IFreeEvent;
    FOnPropertyChangedEvent: IChangedPropertyEvent;
    FOnPropertyChangedTrackingEvent: IPropertyChangedTrackingEvent;
    FOnCollectionChangedEvent: IChangedCollectionEvent;

    function GetBindingStrategy: IBindingStrategy;

    procedure CheckObjectHasFreeInterface;
    procedure CheckObjectHasPropertyChangedInterface;
    procedure CheckObjectHasPropertyChangedTrackingInterface;
    procedure CheckObjectHasCollectionChangedInterface;

    function GetOnFreeEvent: IFreeEvent;
    function GetOnPropertyChangedEvent: IChangedPropertyEvent;
    function GetOnPropertyChangedTrackingEvent: IPropertyChangedTrackingEvent;
    function GetOnCollectionChangedEvent: IChangedCollectionEvent;

    function IsAssignedFreeEvent: Boolean;
    function IsAssignedPropertyChangedEvent: Boolean;
    function IsAssignedPropertyChangedTrackingEvent: Boolean;
    function IsAssignedCollectionChangedEvent: Boolean;
  public
    constructor Create(AObject: TObject); overload;
    constructor Create(ABindingStrategy: IBindingStrategy;
      AObject: TObject); overload;
    destructor Destroy; override;

    property OnFreeEvent: IFreeEvent read GetOnFreeEvent;
    property OnPropertyChangedEvent: IChangedPropertyEvent
      read GetOnPropertyChangedEvent;
    property OnPropertyChangedTrackingEvent: IChangedPropertyEvent
      read GetOnPropertyChangedTrackingEvent;
    property OnCollectionChangedEvent: IChangedCollectionEvent
      read GetOnCollectionChangedEvent;

    property BindingStrategy: IBindingStrategy read GetBindingStrategy;
  end;
{$ENDREGION}

{$REGION 'IBINDING'}

  IBinding = interface
    ['{13B534D5-094F-4DF3-AE62-C2BD8B703215}']
    function GetBindingStrategy: IBindingStrategy;

    procedure CheckNotificationSupport(AObject: TObject; ATracking: Boolean);

    procedure HandlePropertyChanged(const ASender: TObject;
      const APropertyName: String);
    procedure HandleLeafPropertyChanged(const ASender: TObject;
      const APropertyName: String);

    procedure SetFreeNotification(const AInstance: TObject);
    procedure RemoveFreeNotification(const AInstance: TObject);
    procedure HandleFreeEvent(const ASender, AInstance: TObject);

    property BindingStrategy: IBindingStrategy read GetBindingStrategy;
  end;

  TBindingBase = class abstract(TComponent, IBinding)
  protected
    FSynchronizer: IReadWriteSync;
    FBindingStrategy: IBindingStrategy;
    FTrackedInstances: ISet<Pointer>;

    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(ABindingStrategy: IBindingStrategy); overload;
    destructor Destroy; override;

    procedure CheckNotificationSupport(AObject: TObject; ATracking: Boolean);
      virtual; // DAVID? sobra?

    function GetBindingStrategy: IBindingStrategy;

    procedure HandlePropertyChanged(const ASender: TObject;
      const APropertyName: String); virtual;
    procedure HandleLeafPropertyChanged(const ASender: TObject;
      const APropertyName: String); virtual;

    procedure SetFreeNotification(const AInstance: TObject); virtual;
    procedure RemoveFreeNotification(const AInstance: TObject); virtual;
    procedure HandleFreeEvent(const ASender, AInstance: TObject); virtual;

    property BindingStrategy: IBindingStrategy read GetBindingStrategy;
  end;

{$ENDREGION}
  { Abstract base template class that defines the mapping between properties of
    each item in a collection and the corresponding item in the view.
    For example, if the collection contains objects of type TCustomer, than you
    can create a mapping between the customer name and the item title in the
    view (by overriding the GetTitle method).
    If the view is a TListBox for example, then the item title will
    be assigned to the TListBoxItem.Text property.

    You can pass the template to the TgoDataBinder.BindCollection method. }
{$REGION 'TDataTemplate'}

  TDataTemplate = class abstract
  public
    { Must be overridden to return the title of a given object.
      This title will be used to fill the Text property of items in a TListBox
      or TListView.

      Parameters:
      AItem: the object whose title to get. You need to typecast it to the
      type of the objects in the collection (as passed to
      TgoDataBinder.BindCollection).

      Returns:
      The title for this object. Should not be an empty string. }
    class function GetTitle(const AItem: TObject): String; virtual; abstract;

    { Returns some details of a given object.
      These details will be used to fill the Details property of items in a
      TListBox or TListView.

      Parameters:
      AItem: the object whose details to get. You need to typecast it to the
      type of the objects in the collection (as passed to
      TgoDataBinder.BindCollection).

      Returns:
      The details for this object.

      Returns an empty string by default. }
    class function GetDetail(const AItem: TObject): String; virtual;

    { Returns the index of an image that represents a given object.
      This index will be used to fill the ImageIndex property of items in a
      TListBox or TListView.

      Parameters:
      AItem: the object whose image index to get. You need to typecast it to
      the type of the objects in the collection (as passed to
      TgoDataBinder.BindCollection).

      Returns:
      The image index for this object, or -1 if there is no image associated
      with the object.

      Returns -1 by default. }
    class function GetID(const AItem: TObject): Integer; virtual; abstract;
    class function GetImageIndex(const AItem: TObject): Integer; virtual;
    class function GetStyle(const AItem: TObject): string; virtual;
    class function GetParent(const AItem: TObject): TObject; virtual; abstract;
    class function GetChildren(const AItem: TObject): TList<TObject>;
      virtual; abstract;
  end;
{$ENDREGION}

  TDataTemplateClass = class of TDataTemplate;

  { A view of items in a collection. Is uses by controls that present a
    collection of items, such as TListBox and TListView. These controls will
    implement the IgoCollectionViewProvider interface, that provides an object
    that implements this interface.

    Implementors should use the abstract TgoCollectionView class in the
    Grijjy.Mvvm.DataBinding.Collections unit as a base for their views. }

{$REGION 'ICollectionView'}

  ICollectionView = interface
    ['{FB28F410-1707-497B-BD1E-67C218E9EB42}']
{$REGION 'Internal Declarations'}
    function GetSource: TCollectionSource;
    procedure SetSource(AValue: TCollectionSource);
    function GetTemplate: TDataTemplateClass;
    procedure SetTemplate(const AValue: TDataTemplateClass);
    function GetComponent: TComponent;
{$ENDREGION 'Internal Declarations'}
    { The collection to show in the view. This can be any class derived from
      TEnumerable<T>, as long is T is a class type. You must typecast it to
      TgoCollectionSource to set the property.

      When you need to get notified when the collection changes, use a
      collection that implements the IgoNotifyCollectionChanged interface, such
      as TgoObservableCollection<T>.

      (In technical terms: TList<TPerson> is covariant, meaning that it is
      convertible to TList<TObject> if TPerson is a class. However, Delphi
      does not support covariance (and contravariance) with generics, so you
      need to typecast to TgoCollectionSource yourself.) }
    property Source: TCollectionSource read GetSource write SetSource;

    { The class that is used as a template to map items in the collection to
      properties of items in the view. }
    property Template: TDataTemplateClass read GetTemplate write SetTemplate;
    property Component: TComponent read GetComponent;
  end;
{$ENDREGION}

  ICollectionViewProvider = interface
    ['{22F1E2A9-0078-4401-BA80-C8EFFEE091EA}']
    function GetCollectionView: ICollectionView;
    // procedure Bind(const ACollection: TEnumerable<TObject>; const ATemplate: TDataTemplateClass; const ABindingStrategy: String = '');
  end;

  IBindableAction = interface
    ['{43A86FDB-96E2-47E4-B636-933430EFDD81}']
    procedure Bind(const AExecute: TExecuteMethod;
      const ACanExecute: TCanExecuteMethod = nil;
      const ABindingStrategy: String = ''); overload;
  end;

  IBindingStrategy = interface
    ['{84676E39-0351-4F3E-AB66-814E022014BD}']
    procedure Start;

    procedure AdquireRead;
    procedure ReleaseRead;
    procedure AdquireWrite;
    procedure ReleaseWrite;

    procedure Notify(const ASource: TObject;
      const APropertyName: String = ''); overload;
    procedure Notify(const ASource: TObject;
      const APropertiesNames: TArray<String>); overload;

    procedure AddBinding(ABinding: TBindingBase);
    function BindsCount: Integer;
    procedure ClearBindings;

    procedure Bind(const ASource: TObject; const ASourcePropertyPath: String;
      const ATarget: TObject; const ATargetPropertyPath: String;
      const ADirection: EBindDirection = EBindDirection.OneWay;
      const AFlags: EBindFlags = [];
      const AValueConverterClass: TBindingValueConverterClass = nil;
      const AExtraParams: TBindExtraParams = []); overload;
    procedure Bind(const ASources: TSourcePairArray;
      const ASourceExpresion: String; const ATarget: TObject;
      const ATargetAlias: String; const ATargetPropertyPath: String;
      const AFlags: EBindFlags = []; const AExtraParams: TBindExtraParams = []
      ); overload;
    procedure BindCollection(AServiceType: PTypeInfo;
      const ACollection: TEnumerable<TObject>;
      const ATarget: ICollectionViewProvider;
      const ATemplate: TDataTemplateClass);
    procedure BindDataSet(const ADataSet: TDataSet;
      const ATarget: ICollectionViewProvider;
      const ATemplate: TDataTemplateClass);
    procedure BindAction(const AAction: IBindableAction;
      const AExecute: TExecuteMethod;
      const ACanExecute: TCanExecuteMethod = nil); overload;
  end;

  TBindingStrategyBase = class abstract(TInterfacedObject, IBindingStrategy)
  protected
    FSynchronizer: IReadWriteSync;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Start; virtual;

    procedure AdquireRead;
    procedure ReleaseRead;
    procedure AdquireWrite;
    procedure ReleaseWrite;

    procedure Notify(const AObject: TObject; const APropertyName: String = '');
      overload; virtual; abstract;
    procedure Notify(const AObject: TObject;
      const APropertiesNames: TArray<String>); overload; virtual;

    procedure AddBinding(ABinding: TBindingBase); virtual; abstract;
    procedure ClearBindings; virtual; abstract;
    function BindsCount: Integer; virtual;

    procedure Bind(const ASource: TObject; const ASourcePropertyPath: String;
      const ATarget: TObject; const ATargetPropertyPath: String;
      const ADirection: EBindDirection = EBindDirection.OneWay;
      const AFlags: EBindFlags = [];
      const AValueConverterClass: TBindingValueConverterClass = nil;
      const AExtraParams: TBindExtraParams = []); overload; virtual; abstract;
    procedure Bind(const ASources: TSourcePairArray;
      const ASourceExpresion: String; const ATarget: TObject;
      const ATargetAlias: String; const ATargetPropertyPath: String;
      const AFlags: EBindFlags = []; const AExtraParams: TBindExtraParams = []);
      overload; virtual; abstract;
    procedure BindCollection(AServiceType: PTypeInfo;
      const ACollection: TEnumerable<TObject>;
      const ATarget: ICollectionViewProvider;
      const ATemplate: TDataTemplateClass); virtual; abstract;
    procedure BindDataSet(const ADataSet: TDataSet;
      const ATarget: ICollectionViewProvider;
      const ATemplate: TDataTemplateClass); virtual; abstract;
    procedure BindAction(const AAction: IBindableAction;
      const AExecute: TExecuteMethod;
      const ACanExecute: TCanExecuteMethod = nil); overload; virtual; abstract;
  end;

  TClass_BindingStrategyBase = class of TBindingStrategyBase;

  // IBinder = interface
  // ['{AA80417A-B7B8-4867-A310-89BDAB7FEEDD}']
  // //function GetDataBinder: IDataBinder;
  //
  // //property DataBinder: IDataBinder read GetDataBinder;  DAVID
  // end;

  IModel = interface(IObject)
    ['{28C9B05B-A5F5-49E1-913E-2AB10F9FB8F3}']
  end;

  IViewModel = interface(IObject)
    ['{37E13CBF-FDB2-4C6B-948A-7D5F7A6D0AC5}']
    procedure SetupViewModel;
  end;

  IViewModel<T: IModel> = interface(IViewModel)
    ['{2B47A54F-4C87-4C17-9D68-8848F4A0555A}']
    function GetModel: T;
    procedure SetModel(AModel: T);

    property Model: T read GetModel;
  end;

  IView = interface(IObject)
    ['{44055F6F-42A8-43DD-B393-1CC700B8C7F8}']
    procedure SetupView;
  end;

  IView<T: IViewModel> = interface(IView)
    ['{BF036A8C-6302-482C-BD7B-DED350D255F9}']
    function GetViewModel: T;
    procedure InitView(AViewModel: T);

    property ViewModel: T read GetViewModel;
  end;

  IViewForm<T: IViewModel> = interface(IView<T>)
  ['{16407011-00BD-4BCA-9453-1D3F4E1C5DE1}']
    procedure Execute;
    procedure ExecuteModal(const AResultProc: TProc<TModalResult>);
  end;

implementation

uses
  MVVM.Utils;

{ TDataTemplate }

class function TDataTemplate.GetDetail(const AItem: TObject): String;
begin
  Result := '';
end;

class function TDataTemplate.GetImageIndex(const AItem: TObject): Integer;
begin
  Result := -1;
end;

class function TDataTemplate.GetStyle(const AItem: TObject): string;
begin
  Result := '';
end;

{ TBindingStrategyBase }

procedure TBindingStrategyBase.AdquireRead;
begin
  FSynchronizer.BeginRead;
end;

procedure TBindingStrategyBase.AdquireWrite;
begin
  FSynchronizer.BeginWrite;
end;

function TBindingStrategyBase.BindsCount: Integer;
begin
  Result := 0;
end;

constructor TBindingStrategyBase.Create;
begin
  inherited;
  FSynchronizer := TMREWSync.Create;
end;

destructor TBindingStrategyBase.Destroy;
begin
  FSynchronizer := nil;
  inherited;
end;

procedure TBindingStrategyBase.Notify(const AObject: TObject;
  const APropertiesNames: TArray<String>);
var
  LValue: String;
begin
  for LValue in APropertiesNames do
    Notify(AObject, LValue);
end;

procedure TBindingStrategyBase.ReleaseRead;
begin
  FSynchronizer.EndRead;
end;

procedure TBindingStrategyBase.ReleaseWrite;
begin
  FSynchronizer.EndWrite;
end;

procedure TBindingStrategyBase.Start;
begin;
end;

{ TBindingBase }

procedure TBindingBase.CheckNotificationSupport(AObject: TObject;
  ATracking: Boolean);
begin

end;

constructor TBindingBase.Create(ABindingStrategy: IBindingStrategy);
begin
  inherited Create(nil);
  FBindingStrategy := ABindingStrategy;
  FSynchronizer := TMREWSync.Create;
  FTrackedInstances := TCollections.CreateSet<Pointer>;
end;

destructor TBindingBase.Destroy;
var
  P: Pointer;
  Instance: TObject;
begin
  if (FTrackedInstances <> nil) then
  begin
    for P in FTrackedInstances do
    begin
      Instance := TObject(P);
      RemoveFreeNotification(Instance);
    end;
    FTrackedInstances := nil;
  end;
  FBindingStrategy := nil;
  FSynchronizer := nil;
  FTrackedInstances := nil;
  inherited;
end;

function TBindingBase.GetBindingStrategy: IBindingStrategy;
begin
  Result := FBindingStrategy
end;

procedure TBindingBase.HandleFreeEvent(const ASender, AInstance: TObject);
begin
  FSynchronizer.BeginWrite;
  try
    FTrackedInstances.Remove(AInstance);
  finally
    FSynchronizer.EndWrite;
  end;
end;

procedure TBindingBase.HandleLeafPropertyChanged(const ASender: TObject;
  const APropertyName: String);
begin
  //
end;

procedure TBindingBase.HandlePropertyChanged(const ASender: TObject;
  const APropertyName: String);
begin
  //
end;

procedure TBindingBase.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then
    HandleFreeEvent(AComponent, AComponent);
end;

procedure TBindingBase.RemoveFreeNotification(const AInstance: TObject);
begin
  if (AInstance is TComponent) then
    TComponent(AInstance).RemoveFreeNotification(Self);
end;

procedure TBindingBase.SetFreeNotification(const AInstance: TObject);
var
  NotifyFree: INotifyFree;
begin
  if (AInstance is TComponent) then
  begin
    FSynchronizer.BeginWrite;
    try
      FTrackedInstances.Add(AInstance);
    finally
      FSynchronizer.EndWrite;
    end;
    TComponent(AInstance).FreeNotification(Self);
  end
  else if Supports(AInstance, INotifyFree, NotifyFree) then
  begin
    FSynchronizer.BeginWrite;
    try
      FTrackedInstances.Add(AInstance);
      NotifyFree.OnFreeEvent.Add(HandleFreeEvent);
    finally
      FSynchronizer.EndWrite;
    end;
  end;
end;

{ TStrategyEventedObject }

procedure TStrategyEventedObject.CheckObjectHasCollectionChangedInterface;
begin
  Guard.CheckTrue(Supports(FObject, INotifyCollectionChanged));
end;

procedure TStrategyEventedObject.CheckObjectHasFreeInterface;
begin
  Guard.CheckTrue(Supports(FObject, INotifyFree));
end;

procedure TStrategyEventedObject.CheckObjectHasPropertyChangedInterface;
begin
  Guard.CheckTrue(Supports(FObject, INotifyChangedProperty));
end;

procedure TStrategyEventedObject.CheckObjectHasPropertyChangedTrackingInterface;
begin
  Guard.CheckTrue(Supports(FObject, INotifyPropertyTrackingChanged));
end;

constructor TStrategyEventedObject.Create(AObject: TObject);
begin
  Guard.CheckNotNull(AObject, '(Param=AObject) is null');
  inherited Create;
  FObject := AObject;
end;

constructor TStrategyEventedObject.Create(ABindingStrategy: IBindingStrategy;
  AObject: TObject);
begin
  Guard.CheckNotNull(ABindingStrategy, '(Param=ABindingStrategy) is null');
  Guard.CheckNotNull(AObject, '(Param=AObject) is null');
  inherited Create;
  FObject := AObject;
  FBindingStrategy := ABindingStrategy;
end;

destructor TStrategyEventedObject.Destroy;
begin
  FBindingStrategy := nil;
  inherited;
end;

function TStrategyEventedObject.GetBindingStrategy: IBindingStrategy;
begin
  Result := FBindingStrategy
end;

function TStrategyEventedObject.GetOnCollectionChangedEvent: IChangedCollectionEvent;
begin
  if (FOnCollectionChangedEvent = nil) then
  begin
    CheckObjectHasCollectionChangedInterface;
    FOnCollectionChangedEvent := Utils.CreateEvent<TCollectionChangedEvent>;
  end;
  Result := FOnCollectionChangedEvent;
end;

function TStrategyEventedObject.GetOnFreeEvent: IFreeEvent;
begin
  if (FOnFreeEvent = nil) then
  begin
    CheckObjectHasFreeInterface;
    FOnFreeEvent := Utils.CreateEvent<TNotifyFreeObjectEvent>;
  end;
  Result := FOnFreeEvent;
end;

function TStrategyEventedObject.GetOnPropertyChangedEvent
  : IChangedPropertyEvent;
begin
  if (FOnPropertyChangedEvent = nil) then
  begin
    CheckObjectHasPropertyChangedInterface;
    FOnPropertyChangedEvent := Utils.CreateEvent<TNotifySomethingChangedEvent>;
  end;
  Result := FOnPropertyChangedEvent;
end;

function TStrategyEventedObject.GetOnPropertyChangedTrackingEvent
  : IPropertyChangedTrackingEvent;
begin
  if (FOnPropertyChangedTrackingEvent = nil) then
  begin
    CheckObjectHasPropertyChangedTrackingInterface;
    FOnPropertyChangedTrackingEvent :=
      Utils.CreateEvent<TNotifySomethingChangedEvent>;
  end;
  Result := FOnPropertyChangedTrackingEvent;
end;

function TStrategyEventedObject.IsAssignedCollectionChangedEvent: Boolean;
begin
  Result := Assigned(FOnCollectionChangedEvent)
end;

function TStrategyEventedObject.IsAssignedFreeEvent: Boolean;
begin
  Result := Assigned(FOnFreeEvent)
end;

function TStrategyEventedObject.IsAssignedPropertyChangedEvent: Boolean;
begin
  Result := Assigned(FOnPropertyChangedEvent)
end;

function TStrategyEventedObject.IsAssignedPropertyChangedTrackingEvent: Boolean;
begin
  Result := Assigned(FOnPropertyChangedTrackingEvent)
end;

end.
