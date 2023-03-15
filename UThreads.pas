unit UThreads;

interface

uses
  System.Classes, System.SysUtils, UPrimeNumber;

type
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
    OutMemo: string;
  end;

implementation
uses main;

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TNewThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ TNewThread }

procedure TNewThread.Execute;
begin
  { Place thread code here }

//  SetProgress;

end;

procedure TNewThread.SetProgress;
//var
//  i: integer;
begin
//   Form1.CriticalSection.Enter;
//  for i:=Form1.ProgressBar1.Min to Form1.ProgressBar1.Max do
//  begin
////    sleep(50);
//    Progress:=i;
//    Synchronize(UpdateProgress);
//    if IsNumberPrime(i) then
//    begin
//      PrimeNumber:=i;
//      Synchronize(UpdateMemo);
//    end;
//
//  end;
//  Form1.CriticalSection.Leave;
end;

procedure TNewThread.UpdateProgress;
begin
//  Form1.ProgressBar1.Position:=Progress;
//  Form1.StatusBar1.Panels[0].Text:=IntToStr(Form1.FThreadRefCount);
end;

procedure TNewThread.UpdateMemo;
begin
//  Form1.Memo1.Text:= Form1.Memo1.Text + IntToStr(PrimeNumber)+' ';
end;


end.
