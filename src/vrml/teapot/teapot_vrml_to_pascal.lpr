{
  Copyright 2010 Michalis Kamburelis.

  This file is part of "Kambi VRML game engine".

  "Kambi VRML game engine" is free software; see the file COPYING.txt,
  included in this distribution, for details about the copyright.

  "Kambi VRML game engine" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  ----------------------------------------------------------------------------
}

{ Convert teapot VRML file teapot.wrl into Pascal source file
  with 4 Teapot constants.
  This way we get Utah teapot coordinate data in Pascal. }

uses SysUtils, VRMLNodes;

var
  Model: TVRMLNode;

  procedure HandleCoords(const BlenderName, PascalName: string);
  var
    G: TNodeGroup_2;
    IFS: TNodeIndexedFaceSet_2;
    C: TNodeCoordinate;
    I: Integer;
  begin
    { We know how a VRML file generated by Blender looks like, so we simply assume
      in the code below that it's as expected (1st child of the Group is a Shape etc.).
      In case of problems, we can simply fail with an exception. }
    G := Model.FindNodeByName(TNodeGroup_2, 'ME_' + BlenderName, false) as TNodeGroup_2;
    IFS := (G.FdChildren.Items[0] as TNodeShape).FdGeometry.Value as TNodeIndexedFaceSet_2;
    C := IFS.FdCoord.Value as TNodeCoordinate;

    Writeln('Teapot' + PascalName + 'Coord: array [0..', C.FdPoint.Count - 1, '] of TVector3Single = (');
    for I := 0 to C.FdPoint.Count - 1 do
    begin
      Write(Format('(%g, %g, %g)', [
        C.FdPoint.Items.Items[I][0],
        C.FdPoint.Items.Items[I][1],
        C.FdPoint.Items.Items[I][2] ]));
      if I < C.FdPoint.Count - 1 then Write(',');
      Writeln;
    end;
    Writeln(');');

    Writeln('Teapot' + PascalName + 'CoordIndex: array [0..', IFS.FdCoordIndex.Count - 1, '] of LongInt = (');
    for I := 0 to IFS.FdCoordIndex.Count - 1 do
    begin
      Write(IFS.FdCoordIndex.Items[I]);
      if I < IFS.FdCoordIndex.Count - 1 then Write(', ');
      if IFS.FdCoordIndex.Items[I] < 0 then Writeln;
    end;
    Writeln(');');
  end;

begin
  Model := LoadVRMLClassic('teapot.wrl', false);
  try
    HandleCoords('TeapotManifold', 'Manifold');
    HandleCoords('Teapot', '');
  finally FreeAndNil(Model) end;
end.
