unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, SyncObjs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ActionList1: TActionList;
    ProgressBar1: TProgressBar;
    AStartNewThread: TAction;
    procedure AStartNewThreadExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CriticalSection: TCriticalSection;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UThreads;

procedure TForm1.AStartNewThreadExecute(Sender: TObject);
var
  NewThread: TNewThread;
begin
  NewThread:=TNewThread.Create(true);
  NewThread.FreeOnTerminate:=true;
  NewThread.Priority:=tpLower;
  NewThread.Resume;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    CriticalSection:=TCriticalSection.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    CriticalSection.Free;
end;

end.
