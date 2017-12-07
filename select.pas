unit select;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBTables, Grids, DBGrids, strutils,
  SMDBGrid, RxMemDS, ExtCtrls, Shader, TFlatTitlebarUnit, ADODB, Buttons,
  SUIForm, SUIDBCtrls, SUIScrollBar;

type
  TfrmSelectModel = class(TForm)
    ds_rg: TDataSource;
    RxMemoryData1: TRxMemoryData;
    Qry: TADOQuery;
    suiForm1: TsuiForm;
    rg: TsuiDBGrid;
    suiScrollBar2: TsuiScrollBar;
    qryCopper_Child: TADOQuery;
    qryCopper_ChildCopper_ModelCode: TStringField;
    qryCopper_ChildCopper_Product: TStringField;
    procedure FormShow(Sender: TObject);
    procedure rgDblClick(Sender: TObject);
    procedure ds_rgDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qryCopper_ChildBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectModel: TfrmSelectModel;

implementation
 uses fMain, U_STBLibrary, U_DM;
{$R *.dfm}

procedure TfrmSelectModel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult <> mrOk then Application.Terminate;
end;

procedure TfrmSelectModel.FormShow(Sender: TObject);
begin
  //rg.Color := suiForm1.Color;

  ds_rg.DataSet:= nil;

  With qry do begin
       SQL.Clear;
       Close;
       Sql.Add('Select MODEL_MACCOUNT, MODEL_SAPCODE, MODEL_CATCODE, Copper_Product,');
       Sql.Add('MODEL_Code, MODEL_NAME, MODEL_BASICMODEL, MODEL_USEREARLABEL, '+QuotedStr('SCT')+' [DATABASE] From T_MST_MODEL ') ;            //, '+QuotedStr('PBX')+' [DATABASE]
       Sql.Add('Left outer join T_MODEL_COPPER on Copper_modelCode = MOdel_Code');
       Sql.Add('Where MODEL_Group in ('+QuotedStr('RF')+','+QuotedStr('IR')+','+QuotedStr('RFs')+','+QuotedStr('IRs')+')');
       Sql.Add('Group by MODEL_MACCOUNT, MODEL_SAPCODE, MODEL_CATCODE, Copper_Product,');
       Sql.Add('MODEL_Code, MODEL_NAME, MODEL_BASICMODEL, MODEL_USEREARLABEL');
       Sql.Add('Order by MODEL_Code, MODEL_NAME');

       Open;
       First;
  end;

  RxMemoryData1.Open;
  While not   qry.Eof do begin
              RxMemoryData1.Append;
              RxMemoryData1.FieldByName('MODEL_CATCODE').AsString := Trim(qry.FieldByName('MODEL_CATCODE').AsString);
              RxMemoryData1.FieldByName('MODELCODE').AsString := Trim(qry.FieldByName('MODEL_Code').AsString);
              RxMemoryData1.FieldByName('MODELNAME').AsString := Trim(qry.FieldByName('MODEL_NAME').AsString);
              RxMemoryData1.FieldByName('ModelBasic').AsString := Trim(qry.FieldByName('MODEL_BASICMODEL').AsString);
              RxMemoryData1.FieldByName('DATABASE').AsString := Trim(qry.FieldByName('DATABASE').AsString);
              RxMemoryData1.FieldByName('MODELKET').AsString := Trim(qry.FieldByName('MODEL_SAPCODE').AsString);
              RxMemoryData1.FieldByName('MACCOUNT').Value := qry.FieldByName('MODEL_MACCOUNT').AsInteger;
              RxMemoryData1.FieldByName('Copper_Product').Value := qry.FieldByName('Copper_Product').AsString;
              RxMemoryData1.FieldByName('MODEL_USEREARLABEL').Value := qry.FieldByName('MODEL_USEREARLABEL').AsInteger;
              RxMemoryData1.Post;

              qry.Next;
  end;

  RxMemoryData1.First;
  ds_rg.DataSet:= RxMemoryData1;
end;

procedure TfrmSelectModel.qryCopper_ChildBeforeOpen(DataSet: TDataSet);
begin
  qryCopper_Child.Parameters.ParamByName('Model').Value := Model.ModelCode;

end;

procedure TfrmSelectModel.rgDblClick(Sender: TObject);
begin
   ModalResult := mrOk;
end;

procedure TfrmSelectModel.ds_rgDataChange(Sender: TObject; Field: TField);
begin
  Model.ModelCode :=UpperCase(trim(RxMemoryData1.fieldbyname('MODELCODE').AsString));
  Model.ModelDesc :=UpperCase(trim(RxMemoryData1.fieldbyname('MODELKET').AsString));
  Model.ModelCat :=UpperCase(trim(RxMemoryData1.fieldbyname('MODEL_CATCODE').AsString));
  Model.ModelName :=trim(RxMemoryData1.fieldbyname('MODELNAME').AsString);
  Model.ModelBasic :=trim(RxMemoryData1.fieldbyname('ModelBasic').AsString);
  Model.MacCount := RxMemoryData1.fieldbyname('MACCOUNT').Value;
  model.CopperProduct := UpperCase(trim(RxMemoryData1.fieldbyname('Copper_product').AsString));
  Database.DatabaseName :=UpperCase(trim(RxMemoryData1.fieldbyname('DATABASE').AsString));
  Model.UseRearLabel := RxMemoryData1.fieldbyname('MODEL_USEREARLABEL').Value;


  if leftstr(model.CopperProduct,6) = 'BUNDLE' then
  begin
     qryCopper_Child.Close;
     qryCopper_Child.Open;

  end;

  if model.CopperProduct <> '' then
  begin
     if qryCopper_Child.Locate('Copper_Product','HANDY',[loCaseInsensitive]) then
     Model.CopperHandyModelCode:=qryCopper_ChildCopper_ModelCode.AsString;

     if qryCopper_Child.Locate('Copper_Product','BASE',[loCaseInsensitive]) then
     Model.CopperBaseModelCode:=qryCopper_ChildCopper_ModelCode.AsString;

  end;


  with dm.Qry_Model do
  begin
     close;
     open;
  end;
end;

end.
