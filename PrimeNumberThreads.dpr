program PrimeNumberThreads;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  UPrimeNumber in 'UPrimeNumber.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
