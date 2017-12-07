  unit Monitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RunText, TFlatButtonUnit, ComCtrls, Grids,
  DBGrids, SMDBGrid, jpeg, SUIPageControl, SUITabControl, DB, ADODB;

type
  TMain = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    LblTime: TLabel;
    LblDate: TLabel;
    Label3: TLabel;
    Page: TsuiPageControl;
    TabSetting: TsuiTabSheet;
    Panel6: TPanel;
    Panel11: TPanel;
    Panel4: TPanel;
    Label19: TLabel;
    Panel10: TPanel;
    Image1: TImage;
    Label5: TLabel;
    grdNetRun: TSMDBGrid;
    dtpNetRun: TDateTimePicker;
    btnNetInit: TFlatButton;
    btnNetRefresh: TFlatButton;
    btnNetAdd: TFlatButton;
    btnNetDel: TFlatButton;
    btnNetModify: TFlatButton;
    TabSDS: TsuiTabSheet;
    Panel3: TPanel;
    Panel7: TPanel;
    Image3: TImage;
    Label6: TLabel;
    Panel8: TPanel;
    Image4: TImage;
    Label7: TLabel;
    Panel9: TPanel;
    Image5: TImage;
    Label8: TLabel;
    Panel16: TPanel;
    Image12: TImage;
    Label13: TLabel;
    Panel17: TPanel;
    Image13: TImage;
    Label14: TLabel;
    Panel18: TPanel;
    Image14: TImage;
    Label15: TLabel;
    Panel5: TPanel;
    Panel19: TPanel;
    rntNet: TRunningText;
    Panel25: TPanel;
    Label21: TLabel;
    Panel26: TPanel;
    Panel27: TPanel;
    Timer2: TTimer;
    Image2: TImage;
    Qry: TADOQuery;
    BCDField1: TBCDField;
    DateTimeField1: TDateTimeField;
    StringField1: TStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    StringField2: TStringField;
    dsNetRun: TDataSource;
    QryNetRun: TADOQuery;
    QryNetRunNo: TBCDField;
    QryNetRunDate: TDateTimeField;
    QryNetRunModel: TStringField;
    QryNetRunPlan: TIntegerField;
    QryNetRunQty: TIntegerField;
    QryNetRunRemain: TIntegerField;
    QryNetRunRemark: TStringField;
    dsSDSRun: TDataSource;
    QryNetProgress: TADOQuery;
    QryNetInit: TADOQuery;
    ADOConnection1: TADOConnection;
    QryNetRunWeek: TStringField;
    QryNetRunPO: TStringField;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    SMDBGrid1: TSMDBGrid;
    ADOStoredProc2: TADOStoredProc;
    sp_NetRunText: TADOStoredProc;
    QryNetPlan: TADOQuery;
    QryNetPlanDy_Plan: TBCDField;
    QryNetPlanDy_Week: TStringField;
    QryNetPlanDy_WO: TStringField;
    suiTabSheet1: TsuiTabSheet;
    QryNetProgressDy_Plan: TBCDField;
    QryNetProgressDy_Week: TStringField;
    QryNetProgressDy_WO: TStringField;
    QryNetProgressModel: TStringField;
    QryNetProgressResult: TBCDField;
    QryNetProgressRemain: TBCDField;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnNetInitClick(Sender: TObject);
   // procedure Plan();
    procedure Result();
    procedure NetRunText();
    procedure QryNetInitBeforeOpen(DataSet: TDataSet);
    procedure btnNetModifyClick(Sender: TObject);
    procedure btnNetRefreshClick(Sender: TObject);
    procedure QryNetRunBeforeOpen(DataSet: TDataSet);
    procedure Timer2Timer(Sender: TObject);
   // procedure QryNetPlanBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  NetTckTime,NetSumModel,NetCountSet,NetHasilOld,NetHasil,NetRemain,iNetPlan : integer;
  NetRateModel : double;
  NetModelOld : string;
  NetOldDate : Variant;
  CompName: array[0..256] of Char;
  d: DWord;
  Net : integer;


implementation
uses ModifyPlan;

{$R *.dfm}


procedure TMain.btnNetInitClick(Sender: TObject);
begin
  Screen.Cursor := crSQLWait;

  //QryNetInit.Close;
  //QryNetInit.Open;

 // plan;
  NetRunText;
  Result;

  btnNetRefreshClick(Self);

  Screen.Cursor := crDefault;
end;


//pengisian nilai Variabel
procedure TMain.btnNetModifyClick(Sender: TObject);
  var i : integer;
begin
    i := 0;
    QryNetRun.First;
    while i < grdNetRun.RowCount do
    begin
      if grdNetRun.SelectedRows.CurrentRowSelected then
      begin
        frmNetModify.edtNetRemark.Text := QryNetRunRemark.AsString;
        IF frmNetModify.ShowModal<> mrOk THEN EXIT;

      d:=256;
      GetComputerName(CompName, d);

      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('update T_MONITOR_DailyPlan set MONITOR_Remark = '+QuotedStr(frmNetModify.edtNetRemark.Text));
      Qry.SQL.Add(',MONITOR_Pc = '+QuotedStr(StrPas(CompName)));
      Qry.SQL.Add(',MONITOR_PO = '+QuotedStr(QryNetRunPO.AsString));
      Qry.SQL.Add(',MONITOR_Week = '+QuotedStr(QryNetRunWeek.AsString));
      Qry.SQL.Add(',MONITOR_Status = '+QuotedStr('U'));
      Qry.SQL.Add(',MONITOR_Date = getdate()');
      Qry.SQL.Add('where MONITOR_Model = '+QuotedStr(QryNetRunModel.AsString));
      Qry.SQL.Add('and MONITOR_PlanDate = '+QuotedStr(Formatdatetime('yyyymmdd', QryNetRun.FieldByName('Date').Value)));
      Qry.ExecSQL;

      NetRunText;

      btnNetRefreshClick(self);
      Exit;
    end;
    i := i +1;
    QryNetRun.Next;
  end;
end;

procedure TMain.btnNetRefreshClick(Sender: TObject);
begin
  Screen.Cursor := crSQLWait;

  QryNetRun.close;
  QryNetRun.Open;

  grdNetRun.CalculateTotals();

  Screen.Cursor := crDefault;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  Net := 1;
  NetHasilOld := 0;         //Nilai variabel
  NetRateModel := 0;
  NetCountSet := 0;
  dtpNetRun.Date := Date;
  NetOldDate := Date;


   btnNetInitClick(Self);

end;


 {
procedure TMain.TabMpeonShow(Sender: TObject);
begin
  Label4.Caption := 'MPEON';
end;
  }
 {
procedure TMain.TabSDSShow(Sender: TObject);
begin
  Label4.Caption := ' ';
end;
  }
 {
procedure TMain.TabSettingShow(Sender: TObject);
begin
 Label4.Caption := ' ';
end;
 }



procedure TMain.Timer1Timer(Sender: TObject);
begin
  LblDate.Caption := FormatDateTime('dddd, mmmm yyyy',Now);
  LblTime.Caption := FormatDateTime('HH:MM:SS',Now);
end;




procedure TMain.Timer2Timer(Sender: TObject);
begin
 Result;
end;


//source code lama penampilan untuk perplan
{procedure TMain.plan();
begin
  Screen.Cursor := crSQLWait;

    QryNetPlan.close; //--
    QryNetPlan.Open;   //--
  // with QryNetPlan do

    iNetPlan := QryNetPlan.FindField('Dy_Plan').AsInteger;
      //iNetPlan := Parameters.ParamByName('Dy_Plan').Value;
    Panel27.Caption := QryNetPlan.FindField('Dy_Week').AsString;
    Panel26.Caption := QryNetPlan.FindField('Dy_WO').AsString;


  //QryNetRun.close;
  //QryNetRun.Open;

  //iNetPlan :=      //--

     //iNetPlan := QryNetRun.FindField('Plan').AsInteger;
       // if QryNetRunModel = Model then

     //if  Label21.Caption  := QryNetProgress.FindField('o_model').AsString; then

  label13.Caption := FormatFloat('#,##0',iNetPlan);

  Screen.Cursor := crDefault;
end;
 }


procedure TMain.QryNetInitBeforeOpen(DataSet: TDataSet);
begin
  with QryNetInit do
  begin

    d:=256;
    GetComputerName(CompName, d);

    Parameters.ParamByName('Date').Value := FormatDateTime('yyyyMMdd',dtpNetRun.DateTime);
    Parameters.ParamByName('PC').Value := StrPas(CompName);
    if not prepared then prepared;

  end;
 end;


{procedure TMain.QryNetPlanBeforeOpen(DataSet: TDataSet);
begin
 with QryNetPlan do
 begin
    Parameters.ParamByName('Dy_Plan').Value := iNetPlan;
    if not prepared then Prepared;

 end;
end; }

procedure TMain.QryNetRunBeforeOpen(DataSet: TDataSet);
begin
  with QryNetRun do
  begin
    Parameters.ParamByName('Date').Value := FormatDateTime('yyyyMMdd',dtpNetRun.DateTime);
    if not Prepared then Prepared;
  end;
end;

//pengisian Nilai Run Text
procedure TMain.NetRunText();
begin
  with sp_NetRunText do
  begin
    close;
    Parameters.ParamByName('Date').Value := FormatDateTime('yyyyMMdd', dtpNetRun.DateTime);
    ExecProc;
    rntNet.Caption := Parameters.ParamByName('Result').Value;
  end;
end;


  //pengisian QryProgress untuk pengambilan data monitor output dari sql server
procedure TMain.Result();
begin
  Screen.Cursor := crSQLWait;

  if NetOldDate <> date then
  begin
    btnNetInitClick(Self);
    NetOldDate := date;
    exit;
  end;

  QryNetProgress.close;
  QryNetProgress.Open;

   iNetPlan := QryNetProgress.FindField('Dy_Plan').AsInteger;
   NetHasil := QryNetProgress.FindField('Result').AsInteger;
 // NetTckTime := QryNetProgress.FindField('model_TckTime').AsInteger;
 // NetHasil := QryNetProgress.FindField('Dy_Result').AsInteger;

  Panel27.Caption := QryNetProgress.FindField('Dy_Week').AsString;
  Panel26.Caption := QryNetProgress.FindField('Dy_WO').AsString;
  Label21.Caption  := QryNetProgress.FindField('Model').AsString;

  label13.Caption := FormatFloat('#,##0',iNetPlan);
  label14.Caption := FormatFloat('#,##0', NetHasil);
  label15.Caption := FormatFloat('#,##0',iNetPlan - NetHasil);

  Screen.Cursor := crDefault;

  {f NetHasilOld <> NetHasil then
  begin
    if NetModelOld <> Label21.Caption then
    begin
      NetCountSet := 0;
      NetSumModel := 0;
      NetRateModel :=0;
    end
    else
    begin
      NetCountSet := NetCountSet +1;
      NetSumModel := NetSumModel + Net;
      NetRateModel := NetSumModel / NetCountSet;
    end;
    Net := 0;
    panel26.Color := clTeal;
  end
  else
  begin
      Net := Net + 1;
      if NetTckTime < Net then
      begin
        panel26.Color := clRed;
      end
      }
  end;
   //end;

end.
