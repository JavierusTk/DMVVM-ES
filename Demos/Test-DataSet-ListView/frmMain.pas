//---------------------------------------------------------------------------

// This software is Copyright (c) 2015 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit frmMain;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Types, System.UITypes,
  System.Rtti, FMX.Forms, FMX.Dialogs, FMX.Types, FMX.Layouts, FMX.Styles, FMX.StdCtrls,
  FMX.Objects, FMX.Controls, FMX.Edit, FMX.Effects, FMX.Graphics,
  FMX.Controls.Presentation, Data.Bind.GenData, Fmx.Bind.GenData,
  Data.Bind.Components, Data.Bind.ObjectScope, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.DBScope,
  Data.DB, Datasnap.DBClient, Data.Bind.Controls, Fmx.Bind.Navigator,

  System.Generics.Collections, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TfrmMain = class(TForm)
    Resources1: TStyleBook;
    InfoLabel: TLabel;
    Label1: TLabel;
    Image1: TImage;
    BindingsList1: TBindingsList;
    cdsSource: TClientDataSet;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    BindSourceDB1: TBindSourceDB;
    BindNavigator1: TBindNavigator;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    cdsSourceSpeciesNo: TFloatField;
    cdsSourceCategory: TStringField;
    cdsSourceCommon_Name: TStringField;
    cdsSourceSpeciesName: TStringField;
    cdsSourceLengthcm: TFloatField;
    cdsSourceLength_In: TFloatField;
    cdsSourceNotes: TMemoField;
    cdsSourceGraphic: TGraphicField;
    ListView1: TListView;
    Line1: TLine;
    ListView2: TListView;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }

    procedure SetNoStyled;
    procedure SetStyled;
  public
    { Public declarations }
  end;

  TBinder = class
  type
    TConvData = record
    public
      DSField: String;
      LBField: String;
      CustomFormat: String;

      constructor Create(const ADSField: String; const ALBField: String; const ACustomFormat: String = '');
    end;
  private
    class function StyledFieldOfComponent(const AField: String): String; static;
    class procedure BindDataSetToListView(ADataSet: TDataSet; AListView: TListView; const AField: String; const AOnlyFillValues: Boolean = True; const ACustomDisplayExpression: String = ''); overload; static;
    class procedure BindDataSetToListView(ADataSet: TDataSet; AListView: TListView; const ALinks: array of TConvData; const AOnlyFillValues: Boolean = True); overload; static;
    class procedure BindDataSetAppendFieldToListView(ADataSet: TDataSet; AListView: TListView; const ALink: TConvData; const AOnlyFillValues: Boolean = True); overload; static;
  end;

var
  fMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TfrmMain.Button10Click(Sender: TObject);
begin
  SetStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1,
                               [
                                 TBinder.TConvData.Create('Common_Name', 'Text'),
//                                 TBinder.TConvData.Create('Category', TBinder.StyledFieldOfComponent('resolution')),
  //                               TBinder.TConvData.Create('Species No', TBinder.StyledFieldOfComponent('depth')),
                                 TBinder.TConvData.Create('Graphic', 'Bitmap')
                               ], False);
end;

procedure TfrmMain.Button11Click(Sender: TObject);
begin
  SetStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1,
                               [
                                 TBinder.TConvData.Create('Common_Name', 'Text', '%s + '' - '' + DataSet.Category.Text'),
//                                 TBinder.TConvData.Create('Category', TBinder.StyledFieldOfComponent('resolution')),
  //                               TBinder.TConvData.Create('Species No', TBinder.StyledFieldOfComponent('depth')),
                                 TBinder.TConvData.Create('Graphic', 'Bitmap')
                               ], False);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  TBinder.BindDataSetToListView(cdsSource, ListView2,
                               [
                                 TBinder.TConvData.Create('Common_Name', 'Text1'),
                                 TBinder.TConvData.Create('Category', 'Text3')
                               ]);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  TBinder.BindDataSetToListView(cdsSource, ListView2,
                               [
                                 TBinder.TConvData.Create('Common_Name', 'Text1'),
                                 TBinder.TConvData.Create('Category', 'Text3'),
                                 TBinder.TConvData.Create('Graphic', 'Image2')
                               ],
                               False);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  TBinder.BindDataSetAppendFieldToListView(cdsSource, ListView2,
                                           TBinder.TConvData.Create('Graphic', 'Image2'));
end;

procedure TfrmMain.SetNoStyled;
begin
  ListView1.ItemAppearance.ItemAppearance := 'ListItem';
end;

procedure TfrmMain.SetStyled;
begin
  ListView1.ItemAppearance.ItemAppearance := 'ImageListItemBottomDetail';
end;
 
procedure TfrmMain.Button4Click(Sender: TObject);
begin
  SetNoStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1, 'Common_Name');
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  SetNoStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1, 'Common_Name', False);
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
  SetNoStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1, 'Common_Name', True, '%s + '' - '' + DataSet.Category.Text');
end;

procedure TfrmMain.Button7Click(Sender: TObject);
begin
  SetNoStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1, 'Common_Name', False, '%s + '' - '' + DataSet.Category.Text');
end;

procedure TfrmMain.Button8Click(Sender: TObject);
begin
  SetStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1,
                               [
                                 TBinder.TConvData.Create('Common_Name', 'Text'),
    //                             TBinder.TConvData.Create('Category', TBinder.StyledFieldOfComponent('resolution')),
      //                           TBinder.TConvData.Create('Species No', TBinder.StyledFieldOfComponent('depth')),
                                 TBinder.TConvData.Create('Graphic', 'Bitmap')
                               ]);
end;

procedure TfrmMain.Button9Click(Sender: TObject);
begin
  SetStyled;
  TBinder.BindDataSetToListView(cdsSource, ListView1,
                               [
                                 TBinder.TConvData.Create('Common_Name', 'Text', '%s + '' - '' + DataSet.Category.Text'),
//                                 TBinder.TConvData.Create('Category', TBinder.StyledFieldOfComponent('resolution')),
  //                               TBinder.TConvData.Create('Species No', TBinder.StyledFieldOfComponent('depth')),
                                 TBinder.TConvData.Create('Graphic', 'Bitmap')
                               ]);
end;

procedure TfrmMain.CheckBox1Change(Sender: TObject);
begin
end;

{ TBinder }

class procedure TBinder.BindDataSetToListView(ADataSet: TDataSet; AListView: TListView; const AField: String; const AOnlyFillValues: Boolean; const ACustomDisplayExpression: String);
var
  LFiller: TLinkFillControlToField;
  LLinker: TLinkListControlToField;
  LSource: TBindSourceDB;
  I      : Integer;
begin
  for I := 0 to AListView.ComponentCount - 1 do
  begin
    if (AListView.Components[I] is TBindSourceDB) then
    begin
      AListView.Components[I].Free;
      Break;
    end;
  end;

  LSource          := TBindSourceDB.Create(AListView);
  LSource.DataSet  := ADataSet;
  if AOnlyFillValues then
  begin
    LFiller          := TLinkFillControlToField.Create(LSource);
    LFiller.Category := 'Quick Bindings';
    LFiller.Control  := AListView;
    LFiller.Track    := True;

    LFiller.FillDataSource := LSource;
    LFiller.FillDisplayFieldName := AField;
    if not ACustomDisplayExpression.IsEmpty then
      LFiller.FillDisplayCustomFormat := ACustomDisplayExpression;
    LFiller.AutoFill := True;
    LFiller.Active   := True;
  end
  else begin
         LLinker          := TLinkListControlToField.Create(LSource);
         LLinker.Category := 'Quick Bindings';
         LLinker.Control  := AListView;

         LLinker.DataSource := LSource;
         LLinker.FieldName  := AField;
         if not ACustomDisplayExpression.IsEmpty then
           LLinker.CustomFormat := ACustomDisplayExpression;
         LLinker.Active   := True;
       end;
end;

class procedure TBinder.BindDataSetAppendFieldToListView(ADataSet: TDataSet; AListView: TListView; const ALink: TConvData; const AOnlyFillValues: Boolean);
var
  LFiller: TLinkFillControlToField;
  LLinker: TLinkListControlToField;
  LSource: TBindSourceDB;
  I, J   : Integer;
  LFound : Boolean;
  LItem  : TCollectionItem;
  LItem1: TFormatExpressionItem;
begin
  //si hay link lo usamos
  LFiller := nil;
  LLinker := nil;
  LFound := False;
  for I := 0 to AListView.ComponentCount - 1 do
  begin
    if (AListView.Components[I] is TBindSourceDB) then
    begin
      for J := 0 to AListView.Components[I].ComponentCount - 1 do
      begin
        if (AListView.Components[I].Components[J] is TLinkFillControlToField) then
        begin
          LFiller := AListView.Components[I].Components[J] as TLinkFillControlToField;
          LFiller.Active := False;
          LFound := True;
          Break;
        end;
        if (AListView.Components[I].Components[J] is TLinkListControlToField) then
        begin
          LLinker := AListView.Components[I].Components[J] as TLinkListControlToField;
          LLinker.Active := False;
          LFound := True;
          Break;
        end;
      end;
      if LFound then
        break;
    end;
  end;
  if Assigned(LFiller) then
  begin
    LItem1 := LFiller.FillExpressions.AddExpression;
    LItem1.SourceMemberName  := ALink.DSField;
    LItem1.ControlMemberName := ALink.LBField;
    if not ALink.CustomFormat.IsEmpty then
      LItem1.CustomFormat := ALink.CustomFormat;
    LFiller.Active := True;
    Exit;
  end;
  if Assigned(LLinker) then
  begin
    LItem1 := LLinker.FillExpressions.AddExpression;
    LItem1.SourceMemberName  := ALink.DSField;
    LItem1.ControlMemberName := ALink.LBField;
    if not ALink.CustomFormat.IsEmpty then
      LItem1.CustomFormat := ALink.CustomFormat;
    LLinker.Active := True;
  end;
end;

class procedure TBinder.BindDataSetToListView(ADataSet: TDataSet; AListView: TListView; const ALinks: array of TConvData; const AOnlyFillValues: Boolean);
var
  LFiller: TLinkFillControlToField;
  LLinker: TLinkListControlToField;
  LSource: TBindSourceDB;
  I      : Integer;
  LItem  : TCollectionItem;
  LItem1: TFormatExpressionItem;
begin
  for I := 0 to AListView.ComponentCount - 1 do
  begin
    if (AListView.Components[I] is TBindSourceDB) then
    begin
      AListView.Components[I].Free;
      Break;
    end;
  end;

  LSource          := TBindSourceDB.Create(AListView);
  LSource.DataSet  := ADataSet;
  if AOnlyFillValues then
  begin
    LFiller          := TLinkFillControlToField.Create(LSource);
    LFiller.Category := 'Quick Bindings';
    LFiller.Control  := AListView;
    LFiller.Track    := True;

    LFiller.FillDataSource := LSource;

    for I := Low(ALinks) to High(ALinks) do
    begin
      LItem1 := LFiller.FillExpressions.AddExpression;
      LItem1.SourceMemberName  := ALinks[I].DSField;
      LItem1.ControlMemberName := ALinks[I].LBField;
      if not ALinks[I].CustomFormat.IsEmpty then
        LItem1.CustomFormat := ALinks[I].CustomFormat;
    end;

    LFiller.AutoFill := True;
    LFiller.Active   := True;
  end
  else begin
         LLinker          := TLinkListControlToField.Create(LSource);
         LLinker.Category := 'Quick Bindings';
         LLinker.Control  := AListView;

         LLinker.DataSource := LSource;
         //LLinker.FieldName  := AField;

         for I := Low(ALinks) to High(ALinks) do
         begin
           LItem1 := LLinker.FillExpressions.AddExpression;
           LItem1.SourceMemberName  := ALinks[I].DSField;
           LItem1.ControlMemberName := ALinks[I].LBField;
           if not ALinks[I].CustomFormat.IsEmpty then
             LItem1.CustomFormat := ALinks[I].CustomFormat;
         end;

         LLinker.Active   := True;
       end;
end;

class function TBinder.StyledFieldOfComponent(const AField: String): String;
begin
  Result := 'StylesData[''' + AField + ''']';
end;

{ TBinder.TConvData }

constructor TBinder.TConvData.Create(const ADSField: String; const ALBField: String; const ACustomFormat: String);
begin
  DSField      := ADSField;
  LBField      := ALBField;
  CustomFormat := ACustomFormat;
end;

end.
