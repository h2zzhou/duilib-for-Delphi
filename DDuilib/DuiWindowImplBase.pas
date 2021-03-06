//***************************************************************************
//
//       名称：DuiWindowImplBase.pas
//       工具：RAD Studio XE6
//       日期：2015/11/18
//       作者：ying32
//       QQ  ：1444386932
//       E-mail：1444386932@qq.com
//       版权所有 (C) 2015-2015 ying32 All Rights Reserved
//
//
//***************************************************************************
unit DuiWindowImplBase;

{$I DDuilib.inc}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
  Messages,
  ShellAPI,
  MultiMon,
{$ENDIF}
  Classes,
  Types,
{$IFDEF DelphiGeneric}
  Generics.Collections,
{$ENDIF}
  SysUtils,
  DuiBase,
  DuiConst,
  Duilib;

const
  WM_TRAYICON_MESSAGE = WM_USER + $128;

type
  TDuiWindowImplBaseClass = class of TDuiWindowImplBase;

  TDuiWindowImplBase = class(TDuiBase{$IFDEF SupportGeneric}<CDelphi_WindowImplBase>{$ENDIF})
  private
    FHandle: HWND;
    FParentHandle: HWND;
    FPaintManagerUI: CPaintManagerUI;
    FCaption: string;
    FAcceptFiles: Boolean;
    FDropFileFilter: string;
    function GetHandle: HWND;
    function GetInitSize: TSize;
    function GetScreenSize: TSize;
    function GetWorkAreaRect: TRect;
    function GetMousePos: TPoint;
    function GetClientRect: TRect;
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetParentHandle(const Value: HWND);
    procedure SetCaption(const Value: string);
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
{$IFDEF UseLowVer}
  published
{$ELSE}
  protected
{$ENDIF}
    // 回调函数
    procedure DUI_InitWindow; cdecl;
    procedure DUI_Click(var Msg: TNotifyUI); cdecl;
    procedure DUI_Notify(var Msg: TNotifyUI); cdecl;
    function  DUI_HandleMessage(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; var bHandled: BOOL): LRESULT; cdecl;
    function  DUI_MessageHandler(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; var bHandled: BOOL): LRESULT; cdecl;
    procedure DUI_FinalMessage(hWd: HWND); cdecl;
    function  DUI_HandleCustomMessage(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; var bHandled: BOOL): LRESULT; cdecl;
    function  DUI_CreateControl(pstrStr: LPCTSTR): CControlUI; cdecl;
    function DUI_ResponseDefaultKeyEvent(wParam: WPARAM): LRESULT; cdecl;
  protected
    // Delphi虚函数
    procedure DoInitWindow; virtual;
    procedure DoNotify(var Msg: TNotifyUI); virtual;
    procedure DoClick(var msg: TNotifyUI); virtual;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); virtual;
    procedure DoMessageHandler(var Msg: TMessage; var bHandled: BOOL); virtual;
    procedure DoFinalMessage(hWd: HWND); virtual;
    procedure DoHandleCustomMessage(var Msg: TMessage; var bHandled: BOOL); virtual;
    function DoCreateControl(pstrStr: string): CControlUI; virtual;
    procedure DoResponseDefaultKeyEvent(wParam: WPARAM; var AResult: LRESULT); virtual;
    procedure DoDropFiles(var Msg: TMessage; var bHandled: BOOL); virtual;

    // 准备函数，重写下CDelphi_WindowImplBase之用，尽可能的使用pascal
//    function DoGetClassStyle: LongWord; virtual;
    {function DoGetResourceType: TResourceType; virtual;
    function DoGetZIPFileName: string; virtual;
    function DoGetResourceID: string; virtual;
    procedure DoClose(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoDestroy(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoNcActivate(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoNcCalcSize(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoNcPaint(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoNcHitTest(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoGetMinMaxInfo(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoMouseWheel(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoMouseHover(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoSize(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoChar(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoSysCommand(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoCreate(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoKeyDown(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoKillFocus(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoSetFocus(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoLButtonDown(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoLButtonUp(var Msg: TMessage; var bHandled: Boolean); virtual;
    procedure DoMouseMove(var Msg: TMessage; var bHandled: Boolean); virtual;
    //procedure DoHandleCustomMessage(var Msg: TMessage; var bHandled: Boolean);
    function DoGetStyle: Longint; virtual;}
  public
    procedure Show;
    procedure Hide;
    function ShowModal: Integer;
    procedure CenterWindow;
    procedure Close;
    procedure CreateDuiWindow(AParent: HWND; ATitle: string);
    procedure CreateWindow(hwndParent: HWND; ATitle: string; dwStyle: DWORD; dwExStyle: DWORD;
       const rc: TRect; hMenu: HMENU); overload;
    procedure CreateWindow(hwndParent: HWND; ATitle: string; dwStyle: DWORD; dwExStyle: DWORD;
       x: Integer = Integer(CW_USEDEFAULT); y: Integer = Integer(CW_USEDEFAULT);
       cx: Integer = Integer(CW_USEDEFAULT); cy: Integer = Integer(CW_USEDEFAULT); hMenu: HMENU = 0); overload;
    procedure SetClassStyle(nStyle: UINT);
    procedure SetIcon(nRes: UINT);
  {$IFDEF SupportGeneric}
    function FindControl<T>(const AName: string): T; overload;
    function FindControl<T>(const APoint: TPoint): T; overload;
  {$ENDIF}
    function FindControl(const AName: string):CControlUI; overload;
    function FindControl(const pt: TPoint): CControlUI; overload;

    function FindSubControl(const AParent: CControlUI; const AName: string): CControlUI; overload;
    function FindSubControl(const AParent: CControlUI; const P: TPoint): CControlUI; overload;
  {$IFDEF SupportGeneric}
    function FindSubControl<T>(const AParent: CControlUI; const AName: string): T; overload;
    function FindSubControl<T>(const AParent: CControlUI; const P: TPoint): T; overload;
  {$ENDIF}

    function FindSubControls(const AParent: CControlUI; const AClassName: string): CStdPtrArray;
    function FindSubControlByClass(const AParent: CControlUI; const AClassName: string; AIndex: Integer = 0): CControlUI; {$IFDEF SupportGeneric} overload;{$ENDIF}
  {$IFDEF SupportGeneric}
    function FindSubControlByClass<T>(const AParent: CControlUI; const AClassName: string; AIndex: Integer = 0): T; overload;
  {$ENDIF}
    function Perform(uMsg: UINT; wParam: WPARAM = 0; lParam: LPARAM = 0): LRESULT;
    procedure Minimize;
    procedure Restore;
    procedure Maximize;
    procedure RemoveThisInPaintManager;
  public
    constructor Create; overload;
    constructor Create(ASkinFile, ASkinFolder, AZipFileName: string; AResSkin: string; ARType: TResourceType); overload;
    constructor Create(ASkinFile, ASkinFolder: string; ARType: TResourceType); overload;
    constructor Create(ASkinFile, ASkinFolder: string);  overload;
    constructor Create(ASkinFile, ASkinFolder, AZipFileName: string); overload;
    destructor Destroy; override;
    procedure OnReceive(Param: Pointer); virtual;
    procedure ShowMessage(const Fmt: string; Args: array of const); overload;
    procedure ShowMessage(const Msg: string); overload;
    procedure SetBuounds(AX, AY, AWidth, AHeigth: Integer);
  public
    property AcceptFiles: Boolean read FAcceptFiles write FAcceptFiles;
    property Caption: string read FCaption write SetCaption;
    property DropFileFilter: string read FDropFileFilter write FDropFileFilter;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property ClientRect: TRect read GetClientRect;
    property Handle: HWND read GetHandle;
    property ParentHandle: HWND read FParentHandle write SetParentHandle;
    property PaintManagerUI: CPaintManagerUI read FPaintManagerUI;
    property InitSize: TSize read GetInitSize;
    property ScreenSize: TSize read GetScreenSize;
    property WorkAreaRect: TRect read GetWorkAreaRect;
    property MousePos: TPoint read GetMousePos;
  end;

  TSimplePopupMenu = class(TDuiWindowImplBase)
  private
    FLostFocusFree: Boolean;
    procedure Popup(X: Integer = -1; Y: Integer = -1);
  protected
    FParentPaintManager: CPaintManagerUI;
    FMsg: string;
    procedure DoNotify(var Msg: TNotifyUI); override;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); override;
    procedure DoInitWindow; override;
    procedure DoFinalMessage(hWd: HWND); override;
  public
    constructor Create(ASkinFile, ASkinFolder, AZipFileName: string; ARType: TResourceType;
       const AParentPaintManager: CPaintManagerUI; const AMsg: string; ALostFocusFree: Boolean = True);
    destructor Destroy; override;
  public
    property Msg: string read FMsg;
  end;

// fpc下有点不同，以后再看，先禁用fpc下的
{$IFDEF MSWINDOWS}
{$IFNDEF FPC}
  TDuiTrayWindowImplBase = class(TDuiWindowImplBase)
  private
    FTrayData: TNotifyIconData;
    FOnLClick: TNotifyEvent;
    FOnRClick: TNotifyEvent;
    FOnLDClick: TNotifyEvent;
    FHint: string;
    FHIcon: HICON;
    procedure SetHint(const Value: string);
    procedure SetHIcon(const Value: HICON);
  protected
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); override;
    procedure TrayLClick; virtual;
    procedure TrayRClick; virtual;
    procedure TrayDClick; virtual;
  public
  {$IFNDEF UseLowVer}
    procedure ShowBalloonTips(ATitle, AInfo: string; ATimeout: Integer = 1000);
  {$ENDIF}
  public
    property Hint: string read FHint write SetHint;
    property Icon: HICON read FHIcon write SetHIcon;
    property OnRClick: TNotifyEvent read FOnRClick write FOnRClick;
    property OnLClick: TNotifyEvent read FOnLClick write FOnLClick;
    property OnLDClick: TNotifyEvent read FOnLDClick write FOnLDClick;
  end;
{$ENDIF FPC}
{$ENDIF MSWINDOWS}

  TDuiApplication = class
  public
    class procedure Initialize;
    class procedure Run;
    procedure Terminate;
    class function LoadPlugin(const pstrModuleName: string): Boolean;
    class procedure ReloadSkin;
    class function GetPlugins: CStdPtrArray;
    class procedure SetResourcePath(pStrPath: string);
    class function IsCachedResourceZip: Boolean;
    class procedure SetResourceDll(hInst: HINST);
    class procedure SetResourceZip(pVoid: Pointer; len: LongInt); overload;
    class procedure SetResourceZip(pstrZip: string; bCachedResourceZip: Boolean = False); overload;
  end;


var
  DuiApplication: TDuiApplication;

implementation


procedure RectOffset(var ARect: TRect; const DX, DY: Integer);
begin
  Inc(ARect.Left, DX);
  Inc(ARect.Top, DY);
  Inc(ARect.Right, DX);
  Inc(ARect.Bottom, DY);
end;


{ TWindowImplBase }

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder, AZipFileName: string; AResSkin: string; ARType: TResourceType);
begin
  Create;
  {$IFNDEF UseLowVer}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetClassName(ClassName);
  {$IFNDEF UseLowVer}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetSkinFile(ASkinFile);
  {$IFNDEF UseLowVer}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetSkinFolder(ASkinFolder);
  {$IFNDEF UseLowVer}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetZipFileName(AZipFileName);
  {$IFNDEF UseLowVer}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetResourceType(ARType);
  {$IFNDEF UseLowVer}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetResSkin(AResSkin);
end;

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder: string; ARType: TResourceType);
begin
  Create(ASkinFile, ASkinFolder, '', '', ARType);
end;

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder: string);
begin
  Create(ASkinFile, ASkinFolder, UILIB_FILE);
end;

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder,
  AZipFileName: string);
begin
  Create(ASkinFile, ASkinFolder, AZipFileName, '', UILIB_ZIP);
end;

constructor TDuiWindowImplBase.Create;
begin
  FDropFileFilter := ''; // *.*
  FThis := CDelphi_WindowImplBase.CppCreate;
  FPaintManagerUI := {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.GetPaintManagerUI;

  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetDelphiSelf(Self);
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetInitWindow(GetMethodAddr('DUI_InitWindow'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetClick(GetMethodAddr('DUI_Click'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetNotify(GetMethodAddr('DUI_Notify'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetMessageHandler(GetMethodAddr('DUI_MessageHandler'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetFinalMessage(GetMethodAddr('DUI_FinalMessage'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetHandleMessage(GetMethodAddr('DUI_HandleMessage'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetHandleCustomMessage(GetMethodAddr('DUI_HandleCustomMessage'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetCreateControl(GetMethodAddr('DUI_CreateControl'));
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetResponseDefaultKeyEvent(GetMethodAddr('DUI_ResponseDefaultKeyEvent'));
end;

destructor TDuiWindowImplBase.Destroy;
begin
  if FThis <> nil then
    {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.CppDestroy;
  inherited;
end;

procedure TDuiWindowImplBase.CreateDuiWindow(AParent: HWND; ATitle: string);
var
  LStyleEx: Cardinal;
begin
  FParentHandle := AParent;
  FCaption := ATitle;
  LStyleEx := WS_EX_STATICEDGE;
  if FAcceptFiles then
     LStyleEx := LStyleEx or WS_EX_ACCEPTFILES;
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.CreateDuiWindow(AParent, ATitle, UI_WNDSTYLE_FRAME, LStyleEx);
end;

procedure TDuiWindowImplBase.CreateWindow(hwndParent: HWND; ATitle: string;
  dwStyle, dwExStyle: DWORD; x, y, cx, cy: Integer; hMenu: HMENU);
begin
  FParentHandle := hwndParent;
  FCaption := ATitle;
  if FAcceptFiles then
  begin
    if dwExStyle and WS_EX_ACCEPTFILES = 0 then
      dwExStyle := dwExStyle or WS_EX_ACCEPTFILES
  end;
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.Create(hwndParent, ATitle, dwStyle, dwExStyle, x, y, cx, cy, hMenu);
end;

procedure TDuiWindowImplBase.CreateWindow(hwndParent: HWND; ATitle: string;
  dwStyle, dwExStyle: DWORD; const rc: TRect; hMenu: HMENU);
begin
  FParentHandle := hwndParent;
  FCaption := ATitle;
  if FAcceptFiles then
  begin
    if dwExStyle and WS_EX_ACCEPTFILES = 0 then
      dwExStyle := dwExStyle or WS_EX_ACCEPTFILES
  end;
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.Create(hwndParent, ATitle, dwStyle, dwExStyle, rc, hMenu);
end;

procedure TDuiWindowImplBase.DoClick(var Msg: TNotifyUI);
begin
  // virtual method
end;

function TDuiWindowImplBase.DoCreateControl(pstrStr: string): CControlUI;
begin
  // virtual method
  Result := nil;
end;

procedure TDuiWindowImplBase.DoDropFiles(var Msg: TMessage;
  var bHandled: BOOL);
begin

end;

procedure TDuiWindowImplBase.DoFinalMessage(hWd: HWND);
begin
  // virtual method
  RemoveThisInPaintManager;
end;

procedure TDuiWindowImplBase.DoHandleCustomMessage(var Msg: TMessage; var bHandled: BOOL);
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoHandleMessage(var Msg: TMessage; var bHandled: BOOL);
begin
  // virtual method
  case Msg.Msg of
    WM_DROPFILES:  DoDropFiles(Msg, bHandled);
  else

  end;
end;

procedure TDuiWindowImplBase.DoInitWindow;
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoMessageHandler(var Msg: TMessage; var bHandled: BOOL);
begin
  // virtual method
  if Msg.Msg = WM_KEYDOWN then
end;

procedure TDuiWindowImplBase.DoNotify(var Msg: TNotifyUI);
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoResponseDefaultKeyEvent(wParam: WPARAM;
  var AResult: LRESULT);
begin
  // virtual method
  AResult := 0;
end;

procedure TDuiWindowImplBase.DUI_Click(var Msg: TNotifyUI);
begin
  DoClick(Msg);
end;

function TDuiWindowImplBase.DUI_CreateControl(pstrStr: LPCTSTR): CControlUI;
begin
  Result := DoCreateControl(pstrStr);
end;

procedure TDuiWindowImplBase.DUI_FinalMessage(hWd: HWND);
begin
  DoFinalMessage(hWd);
end;

function TDuiWindowImplBase.DUI_HandleCustomMessage(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM; var bHandled: BOOL): LRESULT;
var
  LMsg: TMessage;
begin
  LMsg.Msg := uMsg;
  LMsg.WParam := wParam;
  LMsg.LParam := lParam;
  LMsg.Result := 0;
  DoHandleCustomMessage(LMsg, bHandled);
  Result := LMsg.Result;
end;

function TDuiWindowImplBase.DUI_HandleMessage(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM; var bHandled: BOOL): LRESULT;
var
  LMsg: TMessage;
begin
  LMsg.Msg := uMsg;
  LMsg.WParam := wParam;
  LMsg.LParam := lParam;
  LMsg.Result := 0;
  DoHandleMessage(LMsg, bHandled);
  Result := LMsg.Result;
end;

procedure TDuiWindowImplBase.DUI_InitWindow;
begin
  DoInitWindow;
end;

function TDuiWindowImplBase.DUI_MessageHandler(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM; var bHandled: BOOL): LRESULT;
var
  LMsg: TMessage;
begin
  LMsg.Msg := uMsg;
  LMsg.WParam := wParam;
  LMsg.LParam := lParam;
  LMsg.Result := 0;
  DoMessageHandler(LMsg, bHandled);
  Result := LMsg.Result;
end;

procedure TDuiWindowImplBase.DUI_Notify(var Msg: TNotifyUI);
begin
  DoNotify(Msg);
end;

function TDuiWindowImplBase.DUI_ResponseDefaultKeyEvent(
  wParam: WPARAM): LRESULT;
begin
  DoResponseDefaultKeyEvent(wParam, Result);
end;

function TDuiWindowImplBase.FindSubControl(const AParent: CControlUI;
  const P: TPoint): CControlUI;
begin
  Result := PaintManagerUI.FindSubControlByPoint(AParent, P);
end;

function TDuiWindowImplBase.FindSubControl(const AParent: CControlUI;
  const AName: string): CControlUI;
begin
  Result := PaintManagerUI.FindSubControlByName(AParent, AName);
end;

function TDuiWindowImplBase.FindSubControlByClass(const AParent: CControlUI;
  const AClassName: string; AIndex: Integer): CControlUI;
begin
  Result := PaintManagerUI.FindSubControlByClass(AParent, AClassName, AIndex);
end;

function TDuiWindowImplBase.FindSubControls(const AParent: CControlUI;
  const AClassName: string): CStdPtrArray;
begin
  Result := PaintManagerUI.FindSubControlsByClass(AParent, AClassName);
end;



function TDuiWindowImplBase.GetClientRect: TRect;
begin
  Windows.GetWindowRect(Handle, Result);
end;

function TDuiWindowImplBase.GetHandle: HWND;
begin
  if FHandle = 0 then
    FHandle := {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.GetHWND;
   Result := FHandle;
end;

function TDuiWindowImplBase.GetHeight: Integer;
begin
  Result := ClientRect.Bottom - ClientRect.Top;
end;

function TDuiWindowImplBase.GetInitSize: TSize;
begin
  Result := FPaintManagerUI.GetInitSize;
end;

function TDuiWindowImplBase.GetLeft: Integer;
begin
  Result := ClientRect.Left;
end;

function TDuiWindowImplBase.GetMousePos: TPoint;
begin
  GetCursorPos(Result);
end;

function TDuiWindowImplBase.GetScreenSize: TSize;
begin
  Result.cx := GetSystemMetrics(SM_CXSCREEN);
  Result.cy := GetSystemMetrics(SM_CYSCREEN);
end;

function TDuiWindowImplBase.GetTop: Integer;
begin
  Result := ClientRect.Top;
end;

function TDuiWindowImplBase.GetWidth: Integer;
begin
  Result := ClientRect.Right - ClientRect.Left;
end;

function TDuiWindowImplBase.GetWorkAreaRect: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, {$IFDEF UseLowVer}@{$ENDIF}Result, 0);
end;

{$IFDEF SupportGeneric}
function TDuiWindowImplBase.FindControl<T>(const AName: string): T;
begin
  Result := TCVC.CV<T>(FPaintManagerUI.FindControl(AName));
end;

function TDuiWindowImplBase.FindControl<T>(const APoint: TPoint): T;
begin
  Result := TCVC.CV<T>(FPaintManagerUI.FindControl(APoint));
end;

function TDuiWindowImplBase.FindSubControl<T>(const AParent: CControlUI; const AName: string): T;
begin
  Result := TCVC.CV<T>(FPaintManagerUI.FindSubControlByName(AParent, AName));
end;

function TDuiWindowImplBase.FindSubControl<T>(const AParent: CControlUI; const P: TPoint): T;
begin
  Result := TCVC.CV<T>(FPaintManagerUI.FindSubControlByPoint(AParent, P));
end;

function TDuiWindowImplBase.FindSubControlByClass<T>(const AParent: CControlUI; const AClassName: string; AIndex: Integer = 0): T;
begin
  Result := TCVC.CV<T>(PaintManagerUI.FindSubControlByClass(AParent, AClassName, AIndex));
end;
{$ENDIF}

function TDuiWindowImplBase.FindControl(const AName: string): CControlUI;
begin
  Result := FPaintManagerUI.FindControl(AName);
end;

function TDuiWindowImplBase.FindControl(const pt: TPoint): CControlUI;
begin
  Result := FPaintManagerUI.FindControl(pt);
end;


procedure TDuiWindowImplBase.Hide;
begin
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.ShowWindow(False, False);
end;

procedure TDuiWindowImplBase.Maximize;
begin
  Perform(WM_SYSCOMMAND, SC_MAXIMIZE);
end;

procedure TDuiWindowImplBase.Minimize;
begin
  Perform(WM_SYSCOMMAND, SC_MINIMIZE);
end;

procedure TDuiWindowImplBase.ShowMessage(const Fmt: string; Args: array of const);
begin
  MessageBox(Handle, PChar(Format(Fmt, Args)), '消息', MB_OK or MB_ICONINFORMATION);
end;

procedure TDuiWindowImplBase.ShowMessage(const Msg: string);
begin
  ShowMessage(Msg, []);
end;

procedure TDuiWindowImplBase.OnReceive(Param: Pointer);
begin
  // virtual method
end;

function TDuiWindowImplBase.Perform(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT;
begin
  Result := SendMessage(Handle, uMsg, wParam, lParam);
end;

procedure TDuiWindowImplBase.RemoveThisInPaintManager;
begin
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.RemoveThisInPaintManager;
end;

procedure TDuiWindowImplBase.Restore;
begin
  Perform(WM_SYSCOMMAND, SC_RESTORE);
end;

procedure TDuiWindowImplBase.SetBuounds(AX, AY, AWidth, AHeigth: Integer);
begin
  MoveWindow(Handle, AX, AY, AWidth, AHeigth, False);
end;

procedure TDuiWindowImplBase.SetCaption(const Value: string);
begin
  if FCaption <> '' then
  begin
    FCaption := Value;
    SetWindowText(Handle, FCaption);
  end;
end;

procedure TDuiWindowImplBase.SetClassStyle(nStyle: UINT);
begin
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetGetClassStyle(nStyle);
end;

procedure TDuiWindowImplBase.SetHeight(const Value: Integer);
var
  R: TRect;
begin
  R := ClientRect;
  if Value <> R.Bottom - R.Top then
    SetBuounds(R.Left, R.Top, R.Right - R.Left, Value);
end;

procedure TDuiWindowImplBase.SetIcon(nRes: UINT);
begin
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.SetIcon(nRes);
end;

procedure TDuiWindowImplBase.SetLeft(const Value: Integer);
var
  R: TRect;
begin
  R := ClientRect;
  if Value <> R.Left then
    SetBuounds(Value, R.Top, R.Right - R.Left, R.Bottom - R.Top);
end;

procedure TDuiWindowImplBase.SetParentHandle(const Value: HWND);
begin
  if FParentHandle <> Value then
  begin
    FParentHandle := Value;
    SetParent(Handle, FParentHandle);
  end;
end;

procedure TDuiWindowImplBase.SetTop(const Value: Integer);
var
  R: TRect;
begin
  R := ClientRect;
  if Value <> R.Top then
    SetBuounds(R.Left, Value, R.Right - R.Left, R.Bottom - R.Top);
end;

procedure TDuiWindowImplBase.SetWidth(const Value: Integer);
var
  R: TRect;
begin
  R := ClientRect;
  if Value <> R.Right - R.Left then
    SetBuounds(R.Left, R.Top, Value, R.Bottom - R.Top);
end;

procedure TDuiWindowImplBase.Show;
begin
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.ShowWindow(True, False);
end;

function TDuiWindowImplBase.ShowModal: Integer;
begin
  Result := {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.ShowModal;
end;

procedure TDuiWindowImplBase.CenterWindow;
var
  LParentRect: TRect;
begin
  if (FParentHandle <> 0) and IsWindow(FParentHandle) then
  begin
    GetWindowRect(FParentHandle, LParentRect);
    SetWindowPos(Handle, HWND_TOP, LParentRect.Left + ((LParentRect.Right - LParentRect.Left) div 2 - Width div 2),
      LParentRect.Top + ((LParentRect.Bottom - LParentRect.Top) div 2 - Height div 2), 0, 0, SWP_NOSIZE or SWP_NOREDRAW);
  end else
    {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.CenterWindow;
end;

procedure TDuiWindowImplBase.Close;
begin
  {$IFDEF SupportGeneric}FThis{$ELSE}CDelphi_WindowImplBase(FThis){$ENDIF}.Close;
end;


//function TDuiWindowImplBase.DoGetClassStyle: LongWord;
//begin
//  Result := CS_DBLCLKS;
//end;
(*

function TDuiWindowImplBase.DoGetResourceType: TResourceType;
begin
  Result := UILIB_FILE;
end;

function TDuiWindowImplBase.DoGetZIPFileName: string;
begin
  Result := '';
end;

function TDuiWindowImplBase.DoGetResourceID: string;
begin
  Result := '';
end;

procedure TDuiWindowImplBase.DoClose(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoDestroy(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoNcActivate(var Msg: TMessage; var bHandled: Boolean);
begin
	if IsIconic(Handle) then
    bHandled := False;
  Msg.Result := LRESULT(Msg.WParam = 0);
end;

procedure TDuiWindowImplBase.DoNcCalcSize(var Msg: TMessage; var bHandled: Boolean);
var
  LPRect: PRect;
  LPParam: PNCCalcSizeParams;
  oMonitor: TMonitorInfo;
  rcWork, rcMonitor: TRect;
begin
	if Msg.WParam <> 0 then
	begin
	  LPParam := PNCCalcSizeParams(Msg.LParam);
		LPRect := @LPParam^.rgrc[0];
	end	else
		LPRect := PRect(Msg.LParam);

  if  IsZoomed(Handle) then
  begin
    FillChar(oMonitor, SizeOf(oMonitor), #0);
    oMonitor.cbSize := sizeof(oMonitor);
    GetMonitorInfo(MonitorFromWindow(Handle, MONITOR_DEFAULTTONEAREST), @oMonitor);
    rcWork := oMonitor.rcWork;
    rcMonitor := oMonitor.rcMonitor;

    RectOffset(rcWork, -oMonitor.rcMonitor.Left, -oMonitor.rcMonitor.Top);
   //   rcWork.Offset(-oMonitor.rcMonitor.left, -oMonitor.rcMonitor.top);

    LPRect^.Right := LPRect^.Left + (rcWork.Right - rcWork.Left);
    LPRect^.Bottom := LPRect^.Top + (rcWork.Bottom - rcWork.Top);
    Msg.Result := WVR_REDRAW;
    Exit;
  end;

	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoNcPaint(var Msg: TMessage; var bHandled: Boolean);
begin
  Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoNcHitTest(var Msg: TMessage; var bHandled: Boolean);
begin
end;

procedure TDuiWindowImplBase.DoGetMinMaxInfo(var Msg: TMessage; var bHandled: Boolean);
begin
end;

procedure TDuiWindowImplBase.DoMouseWheel(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoMouseHover(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoSize(var Msg: TMessage; var bHandled: Boolean);
var
  szRoundCorner: TSize;
  rcWnd: TRect;
  LhRgn: HRGN;
begin
  szRoundCorner := FPaintManagerUI.GetRoundCorner;
	if IsIconic(Handle) and ((szRoundCorner.cx <> 0) or (szRoundCorner.cy <> 0)) then
  begin
		GetWindowRect(Handle, rcWnd);
    RectOffset(rcWnd, -rcWnd.Left, -rcWnd.Top);
    Inc(rcWnd.Right);
    Inc(rcWnd.Bottom);
		LhRgn := CreateRoundRectRgn(rcWnd.Left, rcWnd.Top, rcWnd.Right, rcWnd.Bottom, szRoundCorner.cx, szRoundCorner.cy);
		SetWindowRgn(Handle, LhRgn, True);
		DeleteObject(LhRgn);
	end;
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoChar(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoSysCommand(var Msg: TMessage; var bHandled: Boolean);
var
  bZoomed: Boolean;
  lRes: LRESULT;
  pbtnMax, pbtnRestore: CControlUI;
begin
  if Msg.WParam = SC_CLOSE then
  begin
    bHandled := True;
    Perform(WM_CLOSE);
    Msg.Result := 0;
    Exit;
  end;
  bZoomed := IsZoomed(Handle);
  //lRes := CWindowWnd::HandleMessage(uMsg, wParam, lParam);
  if IsZoomed(Handle) <> bZoomed then
  begin
    pbtnMax := FindControl('maxbtn');         // max button
    pbtnRestore := FindControl('restorebtn'); // restore button
    // toggle status of max and restore button
    if Assigned(pbtnMax) and Assigned(pbtnRestore) then
    begin
      pbtnMax.Visible := True = bZoomed;
      pbtnRestore.Visible := False = bZoomed;
    end;
  end;
  Msg.Result := lRes;
end;

procedure TDuiWindowImplBase.DoCreate(var Msg: TMessage; var bHandled: Boolean);
begin
end;

procedure TDuiWindowImplBase.DoKeyDown(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoKillFocus(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoSetFocus(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoLButtonDown(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoLButtonUp(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

procedure TDuiWindowImplBase.DoMouseMove(var Msg: TMessage; var bHandled: Boolean);
begin
	bHandled := False;
	Msg.Result := 0;
end;

//procedure TDuiWindowImplBase.DoHandleCustomMessage(var Msg: TMessage; var bHandled: Boolean);
//begin
//end;

function TDuiWindowImplBase.DoGetStyle: Longint;
begin
	Result := GetWindowLong(Handle, GWL_STYLE);
	Result := Result and not WS_CAPTION;
end; *)



{ TDuiApplication }

class function TDuiApplication.GetPlugins: CStdPtrArray;
begin
  Result := CPaintManagerUI.GetPlugins;
end;

class procedure TDuiApplication.Initialize;
begin
  CPaintManagerUI.SetInstance(HInstance);
end;

class function TDuiApplication.IsCachedResourceZip: Boolean;
begin
  Result := CPaintManagerUI.IsCachedResourceZip;
end;

class function TDuiApplication.LoadPlugin(const pstrModuleName: string): Boolean;
begin
  Result := CPaintManagerUI.LoadPlugin(pstrModuleName);
end;

class procedure TDuiApplication.ReloadSkin;
begin
  CPaintManagerUI.ReloadSkin;
end;

class procedure TDuiApplication.Run;
begin
  CPaintManagerUI.MessageLoop;
end;

class procedure TDuiApplication.SetResourceDll(hInst: HINST);
begin
  CPaintManagerUI.SetResourceDll(hInst);
end;

class procedure TDuiApplication.SetResourcePath(pStrPath: string);
begin
  CPaintManagerUI.SetResourcePath(pStrPath);
end;

class procedure TDuiApplication.SetResourceZip(pVoid: Pointer; len: Integer);
begin
  CPaintManagerUI.SetResourceZip(pVoid, len);
end;

class procedure TDuiApplication.SetResourceZip(pstrZip: string;
  bCachedResourceZip: Boolean);
begin
  CPaintManagerUI.SetResourceZip(pstrZip, bCachedResourceZip);
end;

procedure TDuiApplication.Terminate;
begin
  PostQuitMessage(0);
end;

{ TSimplePopupMenu }

constructor TSimplePopupMenu.Create(ASkinFile, ASkinFolder, AZipFileName: string; ARType: TResourceType;
  const AParentPaintManager: CPaintManagerUI; const AMsg: string; ALostFocusFree: Boolean);
begin
  FMsg := AMsg;
  FParentPaintManager := AParentPaintManager;
  FLostFocusFree := ALostFocusFree;
  inherited Create(ASkinFile, ASkinFolder, AZipFileName, '', ARType);
  CreateWindow(0, ClassName, WS_POPUP, WS_EX_TOOLWINDOW or WS_EX_TOPMOST);
end;

destructor TSimplePopupMenu.Destroy;
begin
  if not FLostFocusFree then
    RemoveThisInPaintManager;
  inherited;
end;

procedure TSimplePopupMenu.DoFinalMessage(hWd: HWND);
begin
  if FLostFocusFree then
  begin
    inherited;
    Free;
  end;
end;

procedure TSimplePopupMenu.DoHandleMessage(var Msg: TMessage;
  var bHandled: BOOL);
begin
  inherited;
  if Msg.Msg = WM_KILLFOCUS then
  begin
    if FLostFocusFree then
      Close
    else Hide;
    Msg.Result := 1;
  end;
end;

procedure TSimplePopupMenu.DoInitWindow;
begin
  inherited;
  Popup;
end;

procedure TSimplePopupMenu.DoNotify(var Msg: TNotifyUI);
begin
  inherited;
  if {$IFDEF UseLowVer}DuiStringToString(Msg.sType){$ELSE}Msg.sType{$ENDIF} = DUI_MSGTYPE_ITEMSELECT then
    Close
  else if {$IFDEF UseLowVer}DuiStringToString(Msg.sType){$ELSE}Msg.sType{$ENDIF} = DUI_MSGTYPE_ITEMCLICK then
    FParentPaintManager.SendNotify(Msg.pSender, FMsg);
end;

procedure TSimplePopupMenu.Popup(X, Y: Integer);
var
  LSize, LScreenSize: TSize;
  LP: TPoint;
begin
  LSize := InitSize;
  if (X = -1) and (Y = -1) then
    LP := MousePos
  else LP := Point(X, Y);
  LScreenSize := ScreenSize;
  if LP.X + LSize.cx >= LScreenSize.cx then
    LP.X := LP.X - LSize.cx;
  if LP.Y + LSize.cy >= LScreenSize.cy then
    LP.Y := LP.Y - LSize.cy;
  SetWindowPos(Handle, HWND_TOPMOST, LP.X, LP.Y, 0, 0, SWP_NOSIZE);
  if IsWindow(Handle) and not IsWindowVisible(Handle) then
    ShowWindow(Handle, SW_SHOWNORMAL or SWP_NOREDRAW);
end;


{ TDuiTrayWindowImplBase }
{$IFDEF MSWINDOWS}
{$IFNDEF FPC}
procedure TDuiTrayWindowImplBase.DoHandleMessage(var Msg: TMessage;
  var bHandled: BOOL);
begin
  case Msg.Msg of
    WM_CREATE:
     begin
       FTrayData.Wnd := Handle;
       FTrayData.uID := Handle;
       FTrayData.cbSize := Sizeof(TNotifyIconData);
       FTrayData.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP{$IFNDEF UseLowVer} or NIF_INFO{$ENDIF};
       FTrayData.ucallbackmessage := WM_TRAYICON_MESSAGE;
       // 默认加载MAINICON
       FTrayData.hIcon := LoadIcon(HInstance, 'MAINICON');
       StrPLCopy(FTrayData.szTip, FHint, Length(FHint));
       Shell_NotifyIcon(NIM_ADD, @FTrayData);
     end;

    WM_DESTROY:
     begin
       Shell_NotifyIcon(NIM_DELETE, @FTrayData);
     end;

    WM_TRAYICON_MESSAGE:
     begin
       case Msg.LParam of
         WM_LBUTTONDOWN: TrayLClick;
         WM_RBUTTONDOWN: TrayRClick;
         WM_LBUTTONDBLCLK: TrayDClick;
       end;
       bHandled := False;
     end;
  end;
  inherited;
end;

procedure TDuiTrayWindowImplBase.TrayDClick;
begin
 if Assigned(FOnLDClick) then
   FOnLDClick(Self);
end;

procedure TDuiTrayWindowImplBase.TrayLClick;
begin
  if Assigned(FOnLClick) then
    FOnLClick(Self);
end;

procedure TDuiTrayWindowImplBase.TrayRClick;
begin
  if Assigned(FOnRClick) then
   FOnRClick(Self);
end;

procedure TDuiTrayWindowImplBase.SetHIcon(const Value: HICON);
begin
  if FHIcon <> Value then
  begin
    FHIcon := Value;
    FTrayData.hIcon := FHIcon;
    Shell_NotifyIcon(NIM_MODIFY, @FTrayData);
  end;
end;

procedure TDuiTrayWindowImplBase.SetHint(const Value: string);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    StrPLCopy(FTrayData.szTip, FHint, Length(FTrayData.szTip) - 1);
    Shell_NotifyIcon(NIM_MODIFY, @FTrayData);
  end;
end;

{$IFNDEF UseLowVer}
procedure TDuiTrayWindowImplBase.ShowBalloonTips(ATitle, AInfo: string;
  ATimeout: Integer);
begin
  FTrayData.uTimeout := ATimeout;
  FTrayData.dwInfoFlags := NIIF_INFO;
  StrPLCopy(FTrayData.szInfoTitle, ATitle, Length(FTrayData.szInfoTitle) - 1);
  StrPLCopy(FTrayData.szInfo, AInfo, Length(FTrayData.szInfo) - 1);
  Shell_NotifyIcon(NIM_MODIFY, @FTrayData);
end;
{$ENDIF UseLowVer}
{$ENDIF FPC}
{$ENDIF MSWINDOWS}

initialization
   DuiApplication := TDuiApplication.Create;

finalization
   DuiApplication.Free;


end.
