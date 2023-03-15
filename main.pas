unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, SyncObjs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ActionList1: TActionList;
    ProgressBar1: TProgressBar;
    AStartNewThread: TAction;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Memo2: TMemo;
    procedure AStartNewThreadExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }

  public
    { Public declarations }

    procedure HandleTerminate(Sender:TObject);
  end;

  TNewThread = class(TThread)
  private
    { Private declarations }
    Progress:integer;
    PrimeNumber:integer;  // Глобальная переменная простое число
    procedure SetProgress;
    procedure UpdateProgress;
    procedure UpdateMemo;
  protected
    procedure Execute; override;
  public
    OutMemo: TMemo;
  end;

var
  Form1: TForm1;



implementation

{$R *.dfm}

uses UPrimeNumber;

const MaxRange = 1000;
      MinRange = 2;

var   NewThread       : TNewThread;
      NewThread2      : TNewThread;
      CriticalSection : TCriticalSection;   // критическая секция
      FThreadRefCount : integer;            // число одновременно запушенных потоков
      MaxFounPrimeNumber: integer;


// -------------------------------------------------------------------
// TNewThread
//--------------------------------------------------------------------


procedure TNewThread.Execute;
begin
  { Place thread code here }

  SetProgress;

end;

procedure TNewThread.SetProgress;
var
  i: integer;
begin

  for i:=Form1.ProgressBar1.Min to Form1.ProgressBar1.Max do
  begin
//    sleep(50);
    Progress:=i;
    Synchronize(UpdateProgress);
    if IsNumberPrime(i) and (i>MaxFounPrimeNumber) then
    begin
      PrimeNumber:=i;
      CriticalSection.Enter;
        MaxFounPrimeNumber:=i;
      CriticalSection.Leave;
      Synchronize(UpdateMemo);
    end;

  end;

end;

procedure TNewThread.UpdateProgress;
begin
  Form1.ProgressBar1.Position:=Progress;
  Form1.StatusBar1.Panels[0].Text:=IntToStr(FThreadRefCount);
end;

procedure TNewThread.UpdateMemo;
begin
  OutMemo.Text:= OutMemo.Text + IntToStr(PrimeNumber)+' ';
end;

// -------------------------------------------------------------------
// Form1
//--------------------------------------------------------------------



procedure TForm1.AStartNewThreadExecute(Sender: TObject);

begin
  NewThread:=TNewThread.Create(true);
  NewThread.FreeOnTerminate:=true;
  NewThread.Priority:=tpLower;
  Inc(FThreadRefCount);
  NewThread.OnTerminate:=HandleTerminate;
  NewThread.OutMemo:=Memo1;
  NewThread.Start;

  NewThread2:=TNewThread.Create(true);
  NewThread2.FreeOnTerminate:=true;
  NewThread2.Priority:=tpLower;
  Inc(FThreadRefCount);
  NewThread2.OnTerminate:=HandleTerminate;
  NewThread2.OutMemo:=Memo2;
  NewThread2.Start;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{https://prog-example.ru/mnogopotochnost.html что-то тут не то}
begin
  CanClose := true;
  if FThreadRefCount>0 then
  begin
    if MessageDlg('Threads active. Do you still want to quit?',
      mtWarning, [mbYes, mbNo], 0) = mrNo then
      CanClose := false;
  end;
  {Sleep(50000);}{Line C}
  if CanClose then
  begin
    if FThreadRefCount>0 then
    begin
//      NewThread.Terminate;
////      NewThread.WaitFor;
//      NewThread.Free;
////      NewThread := nil;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    CriticalSection:=TCriticalSection.Create;
    FThreadRefCount:=0;
    Form1.StatusBar1.Panels[0].Text:=IntToStr(FThreadRefCount);
    ProgressBar1.Min:=MinRange;
    ProgressBar1.Max:=MaxRange;
    MaxFounPrimeNumber:=0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    CriticalSection.Free;
end;

procedure TForm1.HandleTerminate(Sender: TObject);
begin
  Dec(FThreadRefCount);
  Form1.StatusBar1.Panels[0].Text:=IntToStr(FThreadRefCount);
end;


end.
