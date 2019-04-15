unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ShellAPI, ComCtrls;

type
  TBytes = array of Byte;

type
  THEX80_Line = record        //:LLAAAARRDD.......DDCC     CC=(LL+AA+AA+RR+DD+...+DD) % 256
                              //LL = length ; AAAA = start address ; RR = type
                              //'00'=DataRecord '01'=EndOfFileRecord '02'=ExtendedSegmentAddressRecord
                              //'03'=StartSegmentAddressRecord '04'=ExtendedLinearAddressRecord '05'=StartLinearAddressRecod
                              //后面两种记录，都是用来提供地址信息的。每次碰到这两个记录的时候，都可以根据记录计算出一个基地址
                              //对于后面的数据记录，计算地址的时候，这是以这些基地址为基础的
    LL: Integer;
    AAAA: Integer;
    RR: Byte;
    DD: TBytes;
    CC: Byte;
    Checked: Byte;            //0: checked   1:check err   2:text err
  end;

  //TODO 构造
//type
//  THEX80_file = class
//  end;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    mmo2: TMemo;
    Button1: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    Button2: TButton;
    dlgOpen1: TOpenDialog;
    Button3: TButton;
    Button4: TButton;
    dlgSave1: TSaveDialog;
    chk1: TCheckBox;
    lbl3: TLabel;
    cbb1: TComboBox;
    chk2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure AppOnMessage(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }
    procedure LoadFileToMemo(FileName: string);
    function HEX80Convert: Boolean;
  end;

var
  Form1: TForm1;
  bin_out: TMemoryStream;
  convert_flag: Boolean;

implementation

{$R *.dfm}

function HexChar2Byte(c: Char): Byte;
begin
  if (c >= '0') and (c <= '9') then
    Result := Ord(c) - Ord('0')
  else if (c >= 'a') and (c <= 'f') then
    Result := Ord(c) - Ord('a') + 10
  else if (c >= 'A') and (c <= 'F') then
    Result := Ord(c) - Ord('A') + 10;
end;

function HexStr2Bytes(str: string): TBytes;
var
  i: Integer;
begin
  SetLength(Result, Length(str) div 2);
  for i := 0 to (Length(str) div 2) - 1 do
  begin
    Result[i] := HexChar2Byte(str[1 + i * 2]) * 16 +
                 HexChar2Byte(str[2 + i * 2]);
  end;

end;

function Str2Hex80_Line(ALine: string): THEX80_Line;
var
  i: Integer;
  byte_len: Integer;
  data_len: Integer;
  str1: string;
  tmpBytes: TBytes;
begin
  Result.Checked := 2;
  if Copy(ALine, 1, 1) <> ':' then
    Exit;
  byte_len := (Length(ALine) - 1) div 2;
  data_len := byte_len - 5;
  if data_len < 0 then
    Exit;
  tmpBytes := HexStr2Bytes(Copy(ALine, 2, byte_len * 2));
  Result.LL := tmpBytes[0];
  Result.AAAA := tmpBytes[1] * 256 + tmpBytes[2];
  Result.RR := tmpBytes[3];
  SetLength(Result.DD, data_len);
  for i := 0 to data_len - 1 do
  begin
    Result.DD[i] := tmpBytes[i + 4];
  end;
  Result.CC := tmpBytes[data_len + 4];
  Result.Checked := 0;
  //TODO Check sum
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  HEX80Convert;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mmo1.clear;
  mmo2.Clear;
  bin_out := TMemoryStream.Create;
  convert_flag := False;

  DragAcceptFiles(mmo1.Handle, True);
  Application.OnMessage := AppOnMessage;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    LoadFileToMemo(dlgOpen1.FileName);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if convert_flag = False then
  begin
    ShowMessage('无数据文件需要保存！');
    Exit;
  end;
  dlgSave1.Filter := '*.bin|*.bin|*.*|*.*';
  dlgSave1.FileName := '*.bin';
  if dlgSave1.Execute then
  begin
    if dlgSave1.FilterIndex = 1 then
    begin
    end;
    bin_out.SaveToFile(dlgSave1.FileName);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if convert_flag = False then
  begin
    ShowMessage('无记录文件需要保存！');
    Exit;
  end;
  dlgSave1.Filter := '*.log|*.log|*.*|*.*';   
  dlgSave1.FileName := '*.log';
  if dlgSave1.Execute then
  begin
    bin_out.SaveToFile(dlgSave1.FileName);
  end;
end;

procedure TForm1.AppOnMessage(var Msg: TMsg; var Handled: Boolean);
var
  WMD: TWMDropFiles;
begin
  if Msg.message = WM_DROPFILES then
  begin
    WMD.Msg := Msg.message;
    WMD.Drop := Msg.wParam;
    WMD.Unused := Msg.lParam;
    WMD.Result := 0;
    WMDropFiles(WMD);
    Handled := True;
  end;
end;

procedure TForm1.WMDropFiles(var Msg: TWMDropFiles);
var
  N: Word;
  buffer: array[0..512] of Char;
  f_name: string;
begin
  with Msg do
  begin
    for N := 0 to DragQueryFile(Drop, $FFFFFFFF, buffer, 1) - 1 do
    begin
      DragQueryFile(Drop, N, Buffer, 512);
      f_name := StrPas(Buffer);
      LoadFileToMemo(f_name);
      ShowMessage('已加载文件：'+ f_name);
    end;
    DragFinish(Drop);
  end;
end;

procedure TForm1.LoadFileToMemo(FileName: string);
var
  TempList: TStringList;
begin
  mmo1.Lines.Clear;
  TempList := TStringList.Create;
  try
    TempList.LoadFromFile(FileName);
    mmo1.Lines.AddStrings(TempList);
  finally
    FreeAndNil(TempList);
  end;
end;

function TForm1.HEX80Convert: Boolean;
var
  i,j: Integer;
  line_count: Integer;
  tmpHEX80: THEX80_Line;
  tmpstr: string;
  addr_base: Integer;
  addr_offset: Integer;
  EOF_flag: Boolean;
  str_out: TStrings;
  tmpbuf: array[0..15] of Byte;
begin
  convert_flag := False;
  mmo2.Lines.Clear;
  line_count := mmo1.Lines.Count;
  addr_base := 0;
  EOF_flag := False;
  str_out := TStringList.Create;
  bin_out.SetSize(1024 * 1024);                             //alloc 1M for use
  bin_out.Seek(0, soFromBeginning);                         //ptr reset
  for i := 0 to line_count - 1 do
  begin
    tmpHEX80 := Str2Hex80_Line(mmo1.Lines[i]);
    if tmpHEX80.Checked <> 0 then
    begin
      tmpstr := '--------输入文件错误，位置在第 ' + IntToStr(i) + ' 行--------';
      Break;
    end;
    case tmpHEX80.RR of
      0:                  //DataRecord
      begin
        addr_offset := tmpHEX80.AAAA;
        if addr_offset mod 16 = 0 then
        begin
          tmpstr := IntToHex(addr_base + addr_offset, 8) + ':';
          for j := 0 to tmpHEX80.LL - 1 do
          begin
            tmpstr := tmpstr + ' ' + IntToHex(tmpHEX80.DD[j], 2);
            tmpbuf[j] := tmpHEX80.DD[j];
          end;
        end
        else
        begin
          tmpstr := IntToHex(addr_base + (addr_offset div 16 * 16), 8) + ':';
          for j := 0 to ((addr_offset mod 16) -1) do
          begin
            tmpstr := tmpstr + '   ';
            tmpbuf[j] := $00;                                //TODO: fill char
          end;
          for j := 0 to tmpHEX80.LL - 1 do
          begin
            tmpstr := tmpstr + ' ' + IntToHex(tmpHEX80.DD[j], 2);
            tmpbuf[j] := tmpHEX80.DD[j];
          end;
        end;
        bin_out.Write(tmpbuf, tmpHEX80.LL);
        str_out.Add(tmpstr);
      end;
      1:                  //EndOfFileRecord
      begin
        EOF_flag := True;
      end;
      2:                  //ExtendedSegmentAddressRecord
      begin

      end;
      3:                  //StartSegmentAddressRecord
      begin

      end;
      4:                  //ExtendedLinearAddressRecord
      begin
        addr_base := (tmpHEX80.DD[0] * 256 + tmpHEX80.DD[1]) * 65536;
        str_out.Add('------------------- 基地址: 0x' + IntToHex(addr_base, 8) + ' -------------------');
      end;
      5:                  //StartLinearAddressRecod
      begin

      end;
    end;
  end;
  bin_out.SetSize(bin_out.Position);
  //mmo2.Lines.Add('------------------- 基地址: 0x' + IntToHex(addr_base, 8) + ' -------------------');
  mmo2.Lines.AddStrings(str_out);
  mmo2.Lines.Add('----------------------- 文 件 结 束 ----------------------');
  str_out.Free;
  if EOF_flag <> True then
  begin
    mmo2.Lines.Add('EOF不存在，文件可能不完整');
  end;
  convert_flag := True;
end;

end.
