object frmNetModify: TfrmNetModify
  Left = 0
  Top = 0
  Caption = 'Modify Plan'
  ClientHeight = 129
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 9
    Top = 30
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'Remark :'
  end
  object edtNetRemark: TFlatEdit
    Left = 72
    Top = 22
    Width = 433
    Height = 25
    ColorBorder = 16744448
    ColorFlat = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    MaxLength = 100
    ParentFont = False
    TabOrder = 0
  end
  object btnCancel: TFlatButton
    Left = 307
    Top = 64
    Width = 70
    Height = 27
    Cursor = crHandPoint
    ColorBorder = 10930928
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOK: TFlatButton
    Left = 395
    Top = 64
    Width = 70
    Height = 27
    Cursor = crHandPoint
    ColorBorder = 10930928
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
end
