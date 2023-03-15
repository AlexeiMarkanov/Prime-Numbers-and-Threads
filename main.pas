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
    MyFileName: string;
    SharedFileName: string;
  end;

var
  Form1: TForm1;



implementation

{$R *.dfm}

uses UPrimeNumber;

const MaxRange = 1000;
      MinRange = 2;
      FileName1 = 'Thread1.txt';
      FileName2 = 'Thread2.txt';
      FileName3 = 'Result.txt';

var   NewThread       : TNewThread;
      NewThread2      : TNewThread;
      CriticalSection : TCriticalSection;   // критическая секция
      FThreadRefCount : integer;            // число одновременно запушенных потоков
      MaxFounPrimeNumber: integer;          // наибольшее простое число, найденное в
                                            // ходе текущего расчета

// -------------------------------------------------------------------
// Операции с файлами
//--------------------------------------------------------------------

// Добавление найденного числа в конец файла
procedure SaveToFile (FileName:string; Number:integer);
var f: TextFile;
begin
  AssignFile(f,FileName);
  if FileExists(FileName) then Append(f) else  Rewrite(f);
  write(f,IntToStr(Number)+' ');
  CloseFile(f);
end;

// Очистка файла перед началом работы
procedure EraseFile(FileName:string);
var f: TextFile;
begin
  AssignFile(f,FileName);
  if FileExists(FileName) then Rewrite(f);
  CloseFile(f);
end;

// Запрашиваем подтверждение перезаписи файлов перед новымм запуском
function CanStart:boolean;
begin
  if  (FileExists(FileName1)) or (FileExists(FileName2)) or (FileExists(FileName3)) then
  begin
    Result:=false;
    if MessageDlg('Файлы результатов будут перезаписаны. Продолжить?',
    mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      if (FileExists(FileName1)) then EraseFile(FileName1);
      if (FileExists(FileName2)) then EraseFile(FileName2);
      if (FileExists(FileName3)) then EraseFile(FileName3);
      Result:=true
    end;
  end else Result:=true;
end;

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
        SaveToFile(SharedFileName,i);
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
  SaveToFile(MyFileName,PrimeNumber);
end;

// -------------------------------------------------------------------
// Form1
//--------------------------------------------------------------------



procedure TForm1.AStartNewThreadExecute(Sender: TObject);

begin
  if not(CanStart) then exit;

  MaxFounPrimeNumber:=0; //  Обнуление наибольшего простого числа, найденного в
                        // ходе текущего расчета
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;

  NewThread:=TNewThread.Create(true);
  NewThread.FreeOnTerminate:=true;
  NewThread.Priority:=tpLower;
  Inc(FThreadRefCount);
  NewThread.OnTerminate:=HandleTerminate;
  NewThread.OutMemo:=Memo1;
  NewThread.SharedFileName:=FileName3;
  NewThread.MyFileName:=FileName1;
  NewThread.Start;

  NewThread2:=TNewThread.Create(true);
  NewThread2.FreeOnTerminate:=true;
  NewThread2.Priority:=tpLower;
  Inc(FThreadRefCount);
  NewThread2.OnTerminate:=HandleTerminate;
  NewThread2.OutMemo:=Memo2;
  NewThread2.SharedFileName:=FileName3;
  NewThread2.MyFileName:= FileName2;
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
