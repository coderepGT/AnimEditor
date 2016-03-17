unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, ExtCtrls, DXSprite, DXClass, StdCtrls;

type
  TForm1 = class(TForm)
    dxsprtngnSpriteEngine: TDXSpriteEngine;
    vMainPanel: TPanel;
    dxdrwSurface: TDXDraw;
    dxtmrDrawTimer1: TDXTimer;
    StartAnim: TButton;
    tmrAnimanion: TTimer;
    labX: TLabel;
    labY: TLabel;
    edtX: TEdit;
    edtY: TEdit;
    edtFPS: TEdit;
    labFPS: TLabel;
    btnFPS: TButton;
    btnPrevFrame: TButton;
    btnNextFrame: TButton;
    labCurrFrame: TLabel;
    edtCurrFrame: TEdit;
    btnReadData: TButton;
    btnSetX: TButton;
    btnSetY: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    btnMoveLeft: TButton;
    btnMoveRight: TButton;
    btnWriteData: TButton;
    procedure FormCreate(Sender: TObject);
    procedure dxtmrDrawTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure tmrAnimanionTimer(Sender: TObject);
    procedure StartAnimClick(Sender: TObject);
    procedure btnFPSClick(Sender: TObject);
    procedure btnPrevFrameClick(Sender: TObject);
    procedure btnNextFrameClick(Sender: TObject);
    procedure btnReadDataClick(Sender: TObject);
    procedure btnSetXClick(Sender: TObject);
    procedure btnSetYClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnMoveLeftClick(Sender: TObject);
    procedure btnMoveRightClick(Sender: TObject);
    procedure btnWriteDataClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;    

  TImageCollection = class( TDXImageList )
  private
    Length : integer;
  public
    constructor Create( sPath : string; nNum : integer; bTrans : boolean = false; cColor : TColor = clLime ); overload;
    constructor Create( sPath : string; bTrans : boolean = false; cColor : TColor = clLime ); overload;
    function GetLength() : Integer;
  end;

  TPicture = class( TImageSpriteEx )
  public
    constructor Create( pSpriteEngine : TSpriteEngine; pImage : TPictureCollectionItem; nX, nY : Real; nZ : Integer; bVisible : boolean );
  end;

  procedure DrawAll;
  procedure ReadBonusPositions( nLen : Integer );

var
  Form1: TForm1;
  imgBack : TImageCollection;
  imgAnimation : TImageCollection;
  iBack : TPicture;
  iAnimation : TPicture;
  curdir:string;
  nBonusAnimPositions : array of array of integer;
  nCurrFrame : integer = 0;
  AnimLength : integer;
  nFPS : integer = 25;

implementation

{$R *.DFM}

procedure DrawAll;
begin
  if not form1.dxdrwSurface.CanDraw then exit;
    form1.dxsprtngnSpriteEngine.Dead;
  form1.dxdrwSurface.Surface.Fill(0);
  form1.dxsprtngnSpriteEngine.Draw;
  form1.dxdrwSurface.Flip;
end;

// TImageCollection  

constructor TImageCollection.Create( sPath : string; nNum : integer; bTrans : boolean = false; cColor : TColor = clLime );
var
  i : integer;
  sPic : string;
begin
  inherited Create( nil );
  DXDraw := form1.dxdrwSurface;
  for i := 0 to nNum do
  begin
    sPic := sPath +inttostr( i )+'.bmp';
    Items.Add;
    Items[ i ].Picture.LoadFromFile( sPic );
    Items[ i ].Transparent := bTrans;
    Items[ i ].TransparentColor := cColor;
  end;
  Length := nNum;
end;

constructor TImageCollection.Create( sPath : string; bTrans : boolean = false; cColor : TColor = clLime );
var
  i : integer;
begin
  inherited Create( nil );
  DXDraw := form1.dxdrwSurface;
  i := 0;
  while ( fileexists( sPath + IntToStr( i ) + '.bmp' ) ) do
  begin
    Items.Add;
    Items[ i ].Picture.LoadFromFile( sPath + IntToStr( i ) + '.bmp' );
    Items[ i ].Transparent := bTrans;
    Items[ i ].TransparentColor := cColor;
    Inc( i );
  end;
  Length := i - 1;
end;

function TImageCollection.GetLength() : Integer;
begin
  Result := Length;
end;

// TPicture
constructor TPicture.Create( pSpriteEngine : TSpriteEngine; pImage : TPictureCollectionItem; nX, nY : Real; nZ : Integer; bVisible : boolean );
begin
  inherited Create( pSpriteEngine );
  Image := pImage;
  Width  := Image.Width;
  Height := Image.Height;
  x := nX;
  y := nY;
  z := nZ;
  Visible := bVisible;
end;

// Form

procedure ReadBonusPositions( nLen : Integer );
var
  f : TextFile;
  ss : string;
  count, i : Integer;
begin
  ss := curdir + 'Positions\data.txt';
  AssignFile(f, ss);
  Reset( f );
  SetLength( nBonusAnimPositions, nLen + 1 );
  count := 0;
  while not Eof(f) do
  begin
    SetLength( nBonusAnimPositions[ count ], 2 );
    ReadLn( f, nBonusAnimPositions[ count, 0 ], nBonusAnimPositions[ count, 1 ] );
    Inc( count );
  end;
  closefile(f);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    ss : string;
begin

  curdir := ExtractFileDir(Application.ExeName) + '\';

  ss := curdir + 'Background\';
  imgBack      := TImageCollection.Create( ss, 0 );
  ss := curdir + 'Animation\';
  imgAnimation := TImageCollection.Create( ss );

  AnimLength := imgAnimation.GetLength();
  ReadBonusPositions( AnimLength );

  iBack      := TPicture.Create( dxsprtngnSpriteEngine.Engine,      imgBack.Items[ 0 ],                           0,                           0, 0, true );
  iAnimation := TPicture.Create( dxsprtngnSpriteEngine.Engine, imgAnimation.Items[ 0 ], nBonusAnimPositions[ 0, 0 ], nBonusAnimPositions[ 0, 1 ], 1, true );
end;

procedure TForm1.dxtmrDrawTimer1Timer(Sender: TObject; LagCount: Integer);
begin
  DrawAll;
end;

procedure TForm1.tmrAnimanionTimer(Sender: TObject);
begin       
  Inc( nCurrFrame );    
  if nCurrFrame > AnimLength then
  begin
    tmrAnimanion.Enabled := false;
    nCurrFrame := 0;
    StartAnim.Caption := 'Запустить анимацию';
    btnPrevFrame.Enabled := true;
    btnNextFrame.Enabled := true;
  end;
  iAnimation.Image := imgAnimation.Items[ nCurrFrame ];
  iAnimation.Height := iAnimation.Image.Height;
  iAnimation.Width := iAnimation.Image.Width;
  iAnimation.X     := nBonusAnimPositions[ nCurrFrame, 0 ];
  iAnimation.Y     := nBonusAnimPositions[ nCurrFrame, 1 ];
  edtX.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
  edtY.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
  edtCurrFrame.Text := IntToStr( nCurrFrame );
end;

procedure TForm1.StartAnimClick(Sender: TObject);
begin
  if tmrAnimanion.Enabled then
  begin
    tmrAnimanion.Enabled := false;
    btnPrevFrame.Enabled := true;
    btnNextFrame.Enabled := true;
    StartAnim.Caption := 'Запустить анимацию';
  end
  else
  begin
    btnPrevFrame.Enabled := False;
    btnNextFrame.Enabled := False;
    tmrAnimanion.Enabled := true;
    StartAnim.Caption := 'Остановить анимацию';
  end;
end;

procedure TForm1.btnFPSClick(Sender: TObject);
begin
  nFPS := StrToIntDef( edtFPS.Text , nFPS );
  tmrAnimanion.Interval := 1000 div nFPS;
  edtFPS.Text := IntToStr( nFPS );
end;

procedure TForm1.btnPrevFrameClick(Sender: TObject);
begin       
  dec( nCurrFrame );
  if nCurrFrame < 0 then
    nCurrFrame := AnimLength;
  iAnimation.Image := imgAnimation.Items[ nCurrFrame ];
  iAnimation.Height := iAnimation.Image.Height;
  iAnimation.Width := iAnimation.Image.Width;
  iAnimation.X     := nBonusAnimPositions[ nCurrFrame, 0 ];
  iAnimation.Y     := nBonusAnimPositions[ nCurrFrame, 1 ];
  edtX.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
  edtY.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
  edtCurrFrame.Text := IntToStr( nCurrFrame );
end;

procedure TForm1.btnNextFrameClick(Sender: TObject);
begin  
  Inc( nCurrFrame );
  if nCurrFrame > AnimLength then
    nCurrFrame := 0;
  iAnimation.Image := imgAnimation.Items[ nCurrFrame ];
  iAnimation.Height := iAnimation.Image.Height;
  iAnimation.Width := iAnimation.Image.Width;
  iAnimation.X     := nBonusAnimPositions[ nCurrFrame, 0 ];
  iAnimation.Y     := nBonusAnimPositions[ nCurrFrame, 1 ];
  edtX.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
  edtY.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
  edtCurrFrame.Text := IntToStr( nCurrFrame );
end;

procedure TForm1.btnReadDataClick(Sender: TObject);
begin
  ReadBonusPositions( AnimLength );
end;

procedure TForm1.btnSetXClick(Sender: TObject);
begin
  nBonusAnimPositions[ nCurrFrame, 0 ] := StrToIntDef( edtX.Text , nBonusAnimPositions[ nCurrFrame, 0 ] );
  edtX.Text := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
  iAnimation.X     := nBonusAnimPositions[ nCurrFrame, 0 ];
  edtX.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
end;

procedure TForm1.btnSetYClick(Sender: TObject);
begin
  nBonusAnimPositions[ nCurrFrame, 1 ] := StrToIntDef( edtY.Text , nBonusAnimPositions[ nCurrFrame, 1 ] );
  edtY.Text := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
  iAnimation.y     := nBonusAnimPositions[ nCurrFrame, 1 ];
  edtY.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
end;

procedure TForm1.btnMoveUpClick(Sender: TObject);
begin
  Dec( nBonusAnimPositions[ nCurrFrame, 1 ] );
  edtY.Text := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
  iAnimation.Y     := nBonusAnimPositions[ nCurrFrame, 1 ];
  edtY.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
end;

procedure TForm1.btnMoveDownClick(Sender: TObject);
begin
  Inc( nBonusAnimPositions[ nCurrFrame, 1 ] );
  edtY.Text := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
  iAnimation.Y     := nBonusAnimPositions[ nCurrFrame, 1 ];
  edtY.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 1 ] );
end;

procedure TForm1.btnMoveLeftClick(Sender: TObject);
begin
  Dec( nBonusAnimPositions[ nCurrFrame, 0 ] );
  edtX.Text := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
  iAnimation.X     := nBonusAnimPositions[ nCurrFrame, 0 ];
  edtX.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
end;

procedure TForm1.btnMoveRightClick(Sender: TObject);
begin
  Inc( nBonusAnimPositions[ nCurrFrame, 0 ] );
  edtX.Text := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
  iAnimation.X     := nBonusAnimPositions[ nCurrFrame, 0 ];
  edtX.Text        := IntToStr( nBonusAnimPositions[ nCurrFrame, 0 ] );
end;

procedure TForm1.btnWriteDataClick(Sender: TObject);
var
   sPath : string;
   f : TextFile;
   i : integer;
begin
  sPath := curdir + 'Positions\data.txt';
  assignfile(f,sPath);
  rewrite(f);
  for i := 0 to AnimLength do
  begin
   writeln( f, IntToStr( nBonusAnimPositions[ i, 0 ] )+ ' ' + IntToStr( nBonusAnimPositions[ i, 1 ] ) );
  end;
  closefile(f);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    37: btnMoveLeft.Click;
    38: btnMoveUp.Click;
    39: btnMoveRight.Click;
    40: btnMoveDown.Click;
  end;
end;

end.
