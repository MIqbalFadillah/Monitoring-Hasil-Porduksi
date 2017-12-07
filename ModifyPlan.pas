unit ModifyPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TFlatButtonUnit, StdCtrls, TFlatEditUnit;

type
  TfrmNetModify = class(TForm)
    edtNetRemark: TFlatEdit;
    Label2: TLabel;
    btnCancel: TFlatButton;
    btnOK: TFlatButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNetModify: TfrmNetModify;

implementation

{$R *.dfm}

procedure TfrmNetModify.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmNetModify.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
