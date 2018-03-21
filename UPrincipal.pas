unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.AppEvnts;

type
  TFPrincipal = class(TForm)
    btnAnterior: TButton;
    btnPlayPause: TButton;
    btnProximo: TButton;
    TrayIcon: TTrayIcon;
    ApplicationEvents: TApplicationEvents;
    btnAumentarVolume: TButton;
    btnDiminuirVolume: TButton;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnPlayPauseClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAumentarVolumeClick(Sender: TObject);
    procedure btnDiminuirVolumeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    procedure MusicaAnterior;
    procedure PlayPause;
    procedure ProximaMusica;
    procedure AumentarVolume;
    procedure DiminuirVolume;
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

uses
  System.UITypes, System.Threading;

function ToUnicodeEx(wVirtKey, wScanCode: UINT; lpKeyState: PByte;
   pwszBuff: PWideChar; cchBuff: Integer; wFlags: UINT; dwhkl: HKL): Integer; stdcall; external 'user32.dll';

const
  LLKHF_ALTDOWN = KF_ALTDOWN shr 8;
  WH_KEYBOARD_LL = 13;

type
  PKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;
  TKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;

var
  llKeyboardHook: HHOOK = 0;
  AltDown, ShiftDown, CtrlDown: Boolean;
  Inicializacao: Boolean;

function LowLevelKeyboardHook(nCode: Integer; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
var
  pkbhs: PKBDLLHOOKSTRUCT;
  VirtualKey: integer;
  Str: widestring;
begin
  pkbhs := PKBDLLHOOKSTRUCT(Pointer(lParam));
  if nCode = HC_ACTION then
  begin
    VirtualKey := pkbhs^.vkCode;

    Str := '';
    //Alt key, log once on keydown
    if LongBool(pkbhs^.flags and LLKHF_ALTDOWN) and (not AltDown) then
    begin
      Str := '[Alt]';
      AltDown := True;
    end;
    if (not LongBool(pkbhs^.flags and LLKHF_ALTDOWN)) and (AltDown) then
      AltDown := False;

    //Ctrl key, log once on keydown
    if (WordBool(GetAsyncKeyState(VK_CONTROL) and $8000)) and (not CtrlDown) then
    begin
      Str := '[Ctrl]';
      CtrlDown := True;
    end;
    if (not WordBool(GetAsyncKeyState(VK_CONTROL) and $8000)) and (CtrlDown) then
      CtrlDown := False;

    //Shift key, log once on keydown
    if ((VirtualKey = VK_LSHIFT) or (VirtualKey = VK_RSHIFT)) and (not ShiftDown) then
    begin
      Str := '[Shift]';
      ShiftDown := True;
    end;
    if (wParam = WM_KEYUP) and ((VirtualKey = VK_LSHIFT) or (VirtualKey = VK_RSHIFT)) then
      ShiftDown := False;

    //Other Virtual Keys, log once on keydown
    if (wParam = WM_KEYDOWN) and
          ((VirtualKey <> VK_LMENU) and (VirtualKey <> VK_RMENU)) and  //not Alt
           (VirtualKey <> VK_LSHIFT) and (VirtualKey <> VK_RSHIFT) and // not Shift
            (VirtualKey <> VK_LCONTROL) and (VirtualKey <> VK_RCONTROL) then //not Ctrl
    begin
      if (CtrlDown) then
        case VirtualKey of
          VK_NUMPAD4: FPrincipal.btnAnterior.Click;
          VK_NUMPAD5: FPrincipal.btnPlayPause.Click;
          VK_NUMPAD6: FPrincipal.btnProximo.Click;
          VK_NUMPAD8: FPrincipal.AumentarVolume;
          VK_NUMPAD2: FPrincipal.DiminuirVolume;
        end;

      {Str := fMain.TranslateVirtualKey(VirtualKey);
      if Str = '' then
      begin
        ActiveWindow := GetForegroundWindow;
        ActiveThreadID := GetWindowThreadProcessId(ActiveWindow, nil);
        GetKeyboardState(KeyBoardState);
        KeyBoardLayOut := GetKeyboardLayout(ActiveThreadID);
        ScanCode := MapVirtualKeyEx(VirtualKey, 0, KeyBoardLayOut);
        if ScanCode <> 0 then
        begin
          ConvRes := ToUnicodeEx(VirtualKey, ScanCode, @KeyBoardState, @AChr, SizeOf(Achr), 0, KeyBoardLayOut);
          if ConvRes > 0 then
            Str := AChr;
        end;
      end;}
    end;
    //do whatever you have to do with Str, add to memo, write to file, etc...
{    if Str <> '' then
      fMain.mLog.Text :=  fMain.mLog.Text + UTF16ToUTF8(Str);
}
  end;
  Result := CallNextHookEx(llKeyboardHook, nCode, wParam, lParam);
end;

procedure TFPrincipal.btnAnteriorClick(Sender: TObject);
begin
  MusicaAnterior;
end;

procedure TFPrincipal.btnAumentarVolumeClick(Sender: TObject);
begin
  AumentarVolume;
end;

procedure TFPrincipal.btnDiminuirVolumeClick(Sender: TObject);
begin
  DiminuirVolume;
end;

procedure TFPrincipal.btnPlayPauseClick(Sender: TObject);
begin
  PlayPause;
end;

procedure TFPrincipal.btnProximoClick(Sender: TObject);
begin
  ProximaMusica;
end;

procedure TFPrincipal.MusicaAnterior;
begin
  keybd_event(vkMediaPrevTrack, 0, 0, 0);
  keybd_event(vkMediaPrevTrack, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFPrincipal.PlayPause;
begin
  keybd_event(vkMediaPlayPause, 0, 0, 0);
  keybd_event(vkMediaPlayPause, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFPrincipal.ProximaMusica;
begin
  keybd_event(vkMediaNextTrack, 0, 0, 0);
  keybd_event(vkMediaNextTrack, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFPrincipal.AumentarVolume;
begin
  keybd_event(vkVolumeUp, 0, 0, 0);
  keybd_event(vkVolumeUp, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFPrincipal.DiminuirVolume;
begin
  keybd_event(vkVolumeDown, 0, 0, 0);
  keybd_event(vkVolumeDown, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  Inicializacao := True;
  TrayIcon.Hint := Caption;

  llKeyboardHook := SetWindowsHookEx(WH_KEYBOARD_LL,
                                     @LowLevelKeyboardHook,
                                     HInstance,
                                     0);
end;

procedure TFPrincipal.FormDestroy(Sender: TObject);
begin
  if (llKeyboardHook <> 0) then
    UnhookWindowsHookEx(llKeyboardHook);
end;

procedure TFPrincipal.FormShow(Sender: TObject);
var
  Task: ITask;
begin
  if (Inicializacao) then
  begin
    Task := TTask.Create (procedure ()
    begin
      Inicializacao := False;
      sleep (50);
      ApplicationEventsMinimize(Self);
    end);
    Task.Start;
  end;
end;

procedure TFPrincipal.TrayIconDblClick(Sender: TObject);
begin
  TrayIcon.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TFPrincipal.ApplicationEventsMinimize(Sender: TObject);
begin
  Hide();
  WindowState := wsMinimized;

  TrayIcon.Visible := True;
  TrayIcon.Animate := True;
  TrayIcon.ShowBalloonHint;
end;

end.
