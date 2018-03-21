object FPrincipal: TFPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Multimedia Keys'
  ClientHeight = 40
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Padding.Left = 5
  Padding.Top = 5
  Padding.Right = 5
  Padding.Bottom = 5
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnAnterior: TButton
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 84
    Height = 30
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alLeft
    Caption = '<< Anterior'
    TabOrder = 0
    OnClick = btnAnteriorClick
  end
  object btnPlayPause: TButton
    AlignWithMargins = True
    Left = 94
    Top = 5
    Width = 84
    Height = 30
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alLeft
    Caption = 'Play/Pause'
    TabOrder = 1
    OnClick = btnPlayPauseClick
  end
  object btnProximo: TButton
    AlignWithMargins = True
    Left = 183
    Top = 5
    Width = 84
    Height = 30
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 15
    Margins.Bottom = 0
    Align = alLeft
    Caption = 'Pr'#243'ximo >>'
    TabOrder = 2
    OnClick = btnProximoClick
  end
  object btnAumentarVolume: TButton
    AlignWithMargins = True
    Left = 282
    Top = 5
    Width = 82
    Height = 30
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alLeft
    Caption = 'Aumentar Vol.'
    TabOrder = 3
    OnClick = btnAumentarVolumeClick
  end
  object btnDiminuirVolume: TButton
    AlignWithMargins = True
    Left = 369
    Top = 5
    Width = 82
    Height = 30
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alLeft
    Caption = 'DiminuirVol.'
    TabOrder = 4
    OnClick = btnDiminuirVolumeClick
  end
  object TrayIcon: TTrayIcon
    OnDblClick = TrayIconDblClick
    Left = 136
    Top = 8
  end
  object ApplicationEvents: TApplicationEvents
    OnMinimize = ApplicationEventsMinimize
    Left = 64
    Top = 8
  end
end
