unit UPrimeNumber;

interface
  function NextPrimeNumber(PrimeStart:integer):integer;
  function IsNumberPrime(Number:integer):Boolean;
implementation

  function NextPrimeNumber(PrimeStart:integer):integer;
  begin
    //
  end;

  {*********************************************************}
  {***Нахожление простого числа методом оптимизированного**}
  {****перебора делителей**********************************}
  {*********************************************************}
  function IsNumberPrime (Number:integer):Boolean;
  var i:integer;
  begin
    if Number <= 1 then Result:=false else
    begin
      Result:= true;
      for i := 2 to trunc(sqrt(Number)) do
        if Number mod i = 0 then
          begin
            Result:=false;
            exit;
          end;
    end;
  end;
end.
