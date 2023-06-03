program wc;
{$mode objfpc}{$H+}

uses StrUtils, SysUtils, Classes, LazUTF8;
var
   i                                : integer;
   hasL, hasW, hasC, hasM, needsAll : boolean;
   filename                         : string;
   contents, line                   : string;

function CheckFlag(const f : string) : boolean;
begin
   for i := 1 to ParamCount() do
      if ParamStr(i) = f then
         Exit(true);
   Exit(false);
end;

function GetFilename() : string;
begin
   for i := 1 to ParamCount() do
      if not StartsStr('-', ParamStr(i)) then
         Exit(ParamStr(i));
   Exit('');
end;

procedure ContentsStdin();
begin
   contents := '';
   while not Eof do
      begin
         ReadLn(line);
         contents := contents + line + #13#10;
      end;
end;

procedure ContentsFile();
var
   stream : TFileStream;
   size   : int64;
begin
   stream := TFileStream.Create(filename, fmOpenRead);
   size := stream.size;
   SetLength(contents, size);
   stream.ReadBuffer(contents[1], size);
   stream.Free;
end;

begin
   filename := GetFilename();
   hasL := CheckFlag('-l');
   hasW := CheckFlag('-w');
   hasC := CheckFlag('-c');
   hasM := CheckFlag('-m');
   needsAll := not (hasL or hasW or hasC or hasM);

   if filename = '' then
      ContentsStdin()
   else
      ContentsFile();

   if hasL or needsAll then
      Write(#9, WordCount(contents, [#10]));

   if hasW or needsAll then
      Write(#9, WordCount(contents, [#32, #9, #10, #11, #12, #13]));

   if (hasC and not hasM) or needsAll then
      Write(#9, Length(contents));

   if hasM then
      Write(#9, UTF8Length(contents));

   Writeln(' ' + filename);
end.

