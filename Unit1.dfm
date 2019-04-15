object Form1: TForm1
  Left = 348
  Top = 169
  Width = 945
  Height = 454
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'HEX80-By Cloud'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 168
    Top = 13
    Width = 71
    Height = 13
    Caption = 'HEX-80'#25991#26412#21306
  end
  object lbl2: TLabel
    Left = 664
    Top = 13
    Width = 55
    Height = 13
    Caption = 'HEX'#25991#26412#21306
  end
  object lbl3: TLabel
    Left = 97
    Top = 391
    Width = 84
    Height = 13
    Caption = #40664#35748#22635#20805#23383#33410#65306
  end
  object mmo1: TMemo
    Left = 8
    Top = 32
    Width = 377
    Height = 350
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    Lines.Strings = (
      ':020000042001D9'
      ':02649E004500B7'
      ':1064A00000884CBB400040326A2FC0A80104C0A83D'
      ':1064B000010500001014000000018354C76E3EC3A4'
      ':1064C000AE8FEBE34E8088A2497B2A64AD3A244329'
      ':1064D000A0A8A83CB859D3BB80E3EACF744A4E3495'
      ':1064E000A7FFA35BFA8BFC8AC592691BCFE041AF83'
      ':1064F000E20FA45AA6BDAD58E38A81D7402B636F43'
      ':106500001D0294A0B2F1B801EE2EEC8DE370BBC772'
      ':1065100032F04CD7AC628F2B7ADCD8D5F8698FD0AB'
      ':0B6520008908D733B8620000000000BB'
      ':00000001FF')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object mmo2: TMemo
    Left = 431
    Top = 32
    Width = 490
    Height = 350
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 391
    Top = 144
    Width = 34
    Height = 89
    Caption = '->'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 384
    Width = 75
    Height = 25
    Caption = #25171#24320#25991#20214
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 768
    Top = 384
    Width = 75
    Height = 25
    Caption = #20445#23384#25991#20214
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 848
    Top = 384
    Width = 75
    Height = 25
    Caption = #20445#23384'BIN'
    TabOrder = 5
    OnClick = Button4Click
  end
  object chk1: TCheckBox
    Left = 265
    Top = 389
    Width = 121
    Height = 17
    Caption = #22522#22320#22336'16'#23383#33410#23545#40784
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 6
  end
  object cbb1: TComboBox
    Left = 184
    Top = 387
    Width = 65
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 7
    Text = '0x00'
    Items.Strings = (
      '0x00'
      '0xFF'
      '0xAA'
      '0x55'
      #20854#20182)
  end
  object chk2: TCheckBox
    Left = 392
    Top = 389
    Width = 97
    Height = 17
    Caption = #36755#20986#35814#32454#20449#24687
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 8
  end
  object dlgOpen1: TOpenDialog
    Filter = '*.hex(hex'#25991#20214')|*.hex'
    Left = 400
    Top = 336
  end
  object dlgSave1: TSaveDialog
    Filter = '*.bin|*.bin|*.*|*.*'
    Left = 400
    Top = 304
  end
end
