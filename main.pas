unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, SyncObjs, UThreads, Vcl.ExtCtrls;

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
    const MaxRange = 1000;
          MinRange = 2;
  public
    { Public declarations }
    NewThread: TNewThread;
    CriticalSection: TCriticalSection;
    FThreadRefCount: integer;
    procedure HandleTerminate(Sender:TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.AStartNewThreadExecute(Sender: TObject);

begin
  NewThread:=TNewThread.Create(true);
  NewThread.FreeOnTerminate:=true;
  NewThread.Priority:=tpLower;
  Inc(FThreadRefCount);
  NewThread.OnTerminate:=HandleTerminate;
  NewThread.Start;
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
