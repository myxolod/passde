object Login: TLogin
  Left = 643
  Top = 167
  Width = 364
  Height = 169
  BorderIcons = [biSystemMenu]
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 304
    Top = 24
    Width = 23
    Height = 22
    Visible = False
  end
  object Pass: TLabel
    Left = 8
    Top = 8
    Width = 3
    Height = 13
  end
  object Button1: TButton
    Left = 16
    Top = 96
    Width = 75
    Height = 25
    Caption = #1044#1072#1083#1077#1077
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 96
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 289
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    OnKeyDown = Edit1KeyDown
  end
  object Edit2: TEdit
    Left = 8
    Top = 64
    Width = 289
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
    OnKeyDown = Edit2KeyDown
  end
end
