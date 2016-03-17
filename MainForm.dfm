object Form1: TForm1
  Left = 405
  Top = 164
  Width = 1280
  Height = 768
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object vMainPanel: TPanel
    Left = 0
    Top = 0
    Width = 1264
    Height = 730
    Align = alClient
    Caption = 'vMainPanel'
    TabOrder = 0
    object labX: TLabel
      Left = 8
      Top = 632
      Width = 35
      Height = 24
      Caption = 'X = '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object labY: TLabel
      Left = 8
      Top = 680
      Width = 33
      Height = 24
      Caption = 'Y = '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object labFPS: TLabel
      Left = 832
      Top = 32
      Width = 47
      Height = 29
      Caption = 'FPS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object labCurrFrame: TLabel
      Left = 832
      Top = 216
      Width = 162
      Height = 29
      Caption = 'Текущий кадр'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dxdrwSurface: TDXDraw
      Left = 1
      Top = 1
      Width = 816
      Height = 612
      AutoInitialize = True
      AutoSize = True
      Color = clBtnFace
      Display.BitCount = 24
      Display.FixedBitCount = True
      Display.FixedRatio = True
      Display.FixedSize = False
      Display.Height = 600
      Display.Width = 800
      Options = [doAllowReboot, doWaitVBlank, doCenter, doRetainedMode, doHardware, doSelectDriver]
      SurfaceHeight = 612
      SurfaceWidth = 816
      TabOrder = 0
    end
    object StartAnim: TButton
      Left = 1008
      Top = 576
      Width = 145
      Height = 41
      Caption = 'Запустить анимацию'
      TabOrder = 1
      TabStop = False
      OnClick = StartAnimClick
    end
    object edtX: TEdit
      Left = 56
      Top = 632
      Width = 57
      Height = 21
      TabStop = False
      TabOrder = 2
      Text = '0'
    end
    object edtY: TEdit
      Left = 56
      Top = 680
      Width = 57
      Height = 21
      TabStop = False
      TabOrder = 3
      Text = '0'
    end
    object edtFPS: TEdit
      Left = 896
      Top = 32
      Width = 57
      Height = 28
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '25'
    end
    object btnFPS: TButton
      Left = 1000
      Top = 32
      Width = 113
      Height = 33
      Caption = 'Установить'
      TabOrder = 5
      TabStop = False
      OnClick = btnFPSClick
    end
    object btnPrevFrame: TButton
      Left = 856
      Top = 312
      Width = 153
      Height = 57
      Caption = 'Предыдущий кадр'
      TabOrder = 6
      TabStop = False
      OnClick = btnPrevFrameClick
    end
    object btnNextFrame: TButton
      Left = 1016
      Top = 312
      Width = 153
      Height = 57
      Caption = 'Следующий кадр'
      TabOrder = 7
      TabStop = False
      OnClick = btnNextFrameClick
    end
    object edtCurrFrame: TEdit
      Left = 1016
      Top = 216
      Width = 105
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 8
      Text = '0'
    end
    object btnReadData: TButton
      Left = 752
      Top = 648
      Width = 137
      Height = 49
      Caption = 'Считать данные'
      TabOrder = 9
      TabStop = False
      OnClick = btnReadDataClick
    end
    object btnSetX: TButton
      Left = 120
      Top = 624
      Width = 113
      Height = 33
      Caption = 'Установить'
      TabOrder = 10
      TabStop = False
      OnClick = btnSetXClick
    end
    object btnSetY: TButton
      Left = 120
      Top = 672
      Width = 113
      Height = 33
      Caption = 'Установить'
      TabOrder = 11
      TabStop = False
      OnClick = btnSetYClick
    end
    object btnMoveUp: TButton
      Left = 408
      Top = 624
      Width = 105
      Height = 41
      Caption = 'Вверх'
      TabOrder = 12
      TabStop = False
      OnClick = btnMoveUpClick
    end
    object btnMoveDown: TButton
      Left = 408
      Top = 672
      Width = 105
      Height = 41
      Caption = 'Вниз'
      TabOrder = 13
      TabStop = False
      OnClick = btnMoveDownClick
    end
    object btnMoveLeft: TButton
      Left = 296
      Top = 648
      Width = 105
      Height = 41
      Caption = 'Влево'
      TabOrder = 14
      TabStop = False
      OnClick = btnMoveLeftClick
    end
    object btnMoveRight: TButton
      Left = 520
      Top = 648
      Width = 105
      Height = 41
      Caption = 'Вправо'
      TabOrder = 15
      TabStop = False
      OnClick = btnMoveRightClick
    end
    object btnWriteData: TButton
      Left = 896
      Top = 648
      Width = 137
      Height = 49
      Caption = 'Сохранить данные'
      TabOrder = 16
      TabStop = False
      OnClick = btnWriteDataClick
    end
  end
  object dxsprtngnSpriteEngine: TDXSpriteEngine
    DXDraw = dxdrwSurface
    Left = 808
  end
  object dxtmrDrawTimer1: TDXTimer
    ActiveOnly = False
    Enabled = True
    Interval = 0
    OnTimer = dxtmrDrawTimer1Timer
    Left = 840
  end
  object tmrAnimanion: TTimer
    Enabled = False
    Interval = 40
    OnTimer = tmrAnimanionTimer
    Left = 904
  end
end
