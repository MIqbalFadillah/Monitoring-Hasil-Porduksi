program Project1;

uses
  Forms,
  Monitor in 'Monitor.pas' {Main},
  ModifyPlan in 'ModifyPlan.pas' {frmNetModify},
  U_STBLibrary in '..\Monitoring (Author. Pak Dian)\U_STBLibrary.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TfrmNetModify, frmNetModify);
  Application.Run;
end.
