{
  Copyright 2018-2018 Michalis Kamburelis.

  This file is part of "Castle Game Engine".

  "Castle Game Engine" is free software; see the file COPYING.txt,
  included in this distribution, for details about the copyright.

  "Castle Game Engine" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  ----------------------------------------------------------------------------
}

{ Project form (@link(TProjectForm)). }
unit FormProject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DOM, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, ComCtrls, ShellCtrls, StdCtrls, ValEdit, ActnList, ProjectUtils,
  Types, Contnrs,
  CastleControl, CastleUIControls, CastlePropEdits, CastleDialogs, X3DNodes,
  EditorUtils, FrameDesign;

type
  { Main project management. }
  TProjectForm = class(TForm)
    LabelNoDesign: TLabel;
    ListWarnings: TListBox;
    MenuItemDuplicateComponent: TMenuItem;
    MenuItemPasteComponent: TMenuItem;
    MenuItemCopyComponent: TMenuItem;
    MenuItemSupport: TMenuItem;
    MenuItemSeparator788: TMenuItem;
    MenuItemRestartRebuildEditor: TMenuItem;
    MenuItemSortBackToFront2D: TMenuItem;
    MenuItemCameraViewAll: TMenuItem;
    MenuItemSeparator1300: TMenuItem;
    MenuItemSeparatorInAddTransform: TMenuItem;
    MenuItemDesignAddSphere: TMenuItem;
    MenuItemDesignAddRectangle2D: TMenuItem;
    MenuItemDesignAddBox: TMenuItem;
    MenuItemSeparator170: TMenuItem;
    MenuItemDesignNewUserInterfaceCustomRoot: TMenuItem;
    MenuItemDesignNewTransformCustomRoot: TMenuItem;
    MenuItemDesignDeleteComponent: TMenuItem;
    MenuItemDesignAddTransform: TMenuItem;
    MenuItemDesignAddUserInterface: TMenuItem;
    MenuItemSeparator150: TMenuItem;
    MenuItemDesignClose: TMenuItem;
    MenuItemSeparator400: TMenuItem;
    MenuItemDesign: TMenuItem;
    OpenDesignDialog: TCastleOpenDialog;
    MenuItemOpenDesign: TMenuItem;
    MenuItemSeparator201: TMenuItem;
    MenuItemDesignNewTransform: TMenuItem;
    MenuItemDesignNewUserInterfaceRect: TMenuItem;
    SaveDesignDialog: TCastleSaveDialog;
    MenuItemSaveAsDesign: TMenuItem;
    MenuItemSaveDesign: TMenuItem;
    ListOutput: TListBox;
    MainMenu1: TMainMenu;
    MenuItemSeparator101: TMenuItem;
    MenuItemBreakProcess: TMenuItem;
    MenuItemSeprator100: TMenuItem;
    MenuItemAutoGenerateClean: TMenuItem;
    MenuItemAutoGenerateTextures: TMenuItem;
    MenuItemPackageSource: TMenuItem;
    MenuItemModeRelease: TMenuItem;
    MenuItemPackage: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItemModeDebug: TMenuItem;
    MenuItemSeparator3: TMenuItem;
    MenuItemSeparator2: TMenuItem;
    MenuItemReference: TMenuItem;
    MenuItemManual: TMenuItem;
    MenuItemCgeWww: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemSeparator: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemClean: TMenuItem;
    MenuItemOnlyRun: TMenuItem;
    MenuItemCompileRun: TMenuItem;
    MenuItemCompile: TMenuItem;
    MenuItemSwitchProject: TMenuItem;
    MenuItemRun: TMenuItem;
    MenuItemFile: TMenuItem;
    MenuItemQuit: TMenuItem;
    PageControlBottom: TPageControl;
    PanelAboveTabs: TPanel;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    SplitterBetweenFiles: TSplitter;
    Splitter2: TSplitter;
    TabFiles: TTabSheet;
    TabOutput: TTabSheet;
    ProcessUpdateTimer: TTimer;
    TabWarnings: TTabSheet;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListOutputClick(Sender: TObject);
    procedure MenuItemAutoGenerateCleanClick(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemAutoGenerateTexturesClick(Sender: TObject);
    procedure MenuItemBreakProcessClick(Sender: TObject);
    procedure MenuItemCameraViewAllClick(Sender: TObject);
    procedure MenuItemCgeWwwClick(Sender: TObject);
    procedure MenuItemCleanClick(Sender: TObject);
    procedure MenuItemCompileClick(Sender: TObject);
    procedure MenuItemCompileRunClick(Sender: TObject);
    procedure MenuItemCopyComponentClick(Sender: TObject);
    procedure MenuItemDesignAddBoxClick(Sender: TObject);
    procedure MenuItemDesignAddRectangle2DClick(Sender: TObject);
    procedure MenuItemDesignAddSphereClick(Sender: TObject);
    procedure MenuItemDesignCloseClick(Sender: TObject);
    procedure MenuItemDesignDeleteComponentClick(Sender: TObject);
    procedure MenuItemDuplicateComponentClick(Sender: TObject);
    procedure MenuItemManualClick(Sender: TObject);
    procedure MenuItemModeDebugClick(Sender: TObject);
    procedure MenuItemDesignNewUserInterfaceRectClick(Sender: TObject);
    procedure MenuItemDesignNewTransformClick(Sender: TObject);
    procedure MenuItemOnlyRunClick(Sender: TObject);
    procedure MenuItemOpenDesignClick(Sender: TObject);
    procedure MenuItemPackageClick(Sender: TObject);
    procedure MenuItemPackageSourceClick(Sender: TObject);
    procedure MenuItemPasteComponentClick(Sender: TObject);
    procedure MenuItemQuitClick(Sender: TObject);
    procedure MenuItemReferenceClick(Sender: TObject);
    procedure MenuItemModeReleaseClick(Sender: TObject);
    procedure MenuItemRestartRebuildEditorClick(Sender: TObject);
    procedure MenuItemSaveAsDesignClick(Sender: TObject);
    procedure MenuItemSaveDesignClick(Sender: TObject);
    procedure MenuItemSortBackToFront2DClick(Sender: TObject);
    procedure MenuItemSupportClick(Sender: TObject);
    procedure MenuItemSwitchProjectClick(Sender: TObject);
    procedure ProcessUpdateTimerTimer(Sender: TObject);
  private
    ProjectName: String;
    ProjectPath, ProjectPathUrl: String;
    BuildMode: TBuildMode;
    OutputList: TOutputList;
    RunningProcess: TAsynchronousProcessQueue;
    Design: TDesignFrame;
    procedure BuildToolCall(const Commands: array of String;
        const ExitOnSuccess: Boolean = false);
    procedure MenuItemAddComponentClick(Sender: TObject);
    procedure MenuItemDesignNewCustomRootClick(Sender: TObject);
    procedure SetEnabledCommandRun(const AEnabled: Boolean);
    procedure FreeProcess;
    procedure UpdateFormCaption(Sender: TObject);
    { Propose saving the hierarchy.
      Returns should we continue (user did not cancel). }
    function ProposeSaveDesign: Boolean;
    { Call always when Design<>nil value changed. }
    procedure DesignExistenceChanged;
    { Create Design, if nil. }
    procedure NeedsDesignFrame;
    procedure WarningNotification(Sender: TObject; const Category, Message: string);
  public
    { Open a project, given an absolute path to CastleEngineManifest.xml }
    procedure OpenProject(const ManifestUrl: String);
  end;

var
  ProjectForm: TProjectForm;

implementation

{$R *.lfm}

uses TypInfo,
  CastleXMLUtils, CastleLCLUtils, CastleOpenDocument, CastleURIUtils,
  CastleFilesUtils, CastleUtils, CastleVectors, CastleColors,
  CastleScene, CastleSceneManager, Castle2DSceneManager,
  CastleTransform, CastleControls, CastleDownload, CastleApplicationProperties,
  CastleLog, CastleComponentSerialize, CastleSceneCore, CastleStringUtils,
  CastleFonts,
  FormChooseProject, ToolCommonUtils, FormAbout;

procedure TProjectForm.MenuItemQuitClick(Sender: TObject);
begin
  if ProposeSaveDesign then
    Application.Terminate;
end;

procedure TProjectForm.MenuItemReferenceClick(Sender: TObject);
begin
  OpenURL('https://castle-engine.io/apidoc/html/index.html');
end;

procedure TProjectForm.MenuItemModeReleaseClick(Sender: TObject);
begin
  BuildMode := bmRelease;
  MenuItemModeRelease.Checked := true;
end;

procedure TProjectForm.MenuItemRestartRebuildEditorClick(Sender: TObject);
begin
  BuildToolCall(['editor'], true);
end;

procedure TProjectForm.MenuItemSaveAsDesignClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise

  if Design.DesignRoot is TCastleUserInterface then
    SaveDesignDialog.DefaultExt := 'castle-user-interface'
  else
  if Design.DesignRoot is TCastleTransform then
    SaveDesignDialog.DefaultExt := 'castle-transform'
  else
    raise EInternalError.Create('DesignRoot does not descend from TCastleUserInterface or TCastleTransform');

  SaveDesignDialog.Url := Design.DesignUrl;
  if SaveDesignDialog.Execute then
    Design.SaveDesign(SaveDesignDialog.Url);
    // TODO: save DesignUrl somewhere? CastleEditorSettings.xml?
end;

procedure TProjectForm.MenuItemSaveDesignClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise

  if Design.DesignUrl = '' then
    MenuItemSaveAsDesignClick(Sender)
  else
    Design.SaveDesign(Design.DesignUrl);
end;

procedure TProjectForm.MenuItemSortBackToFront2DClick(Sender: TObject);
begin
  Assert(Design <> nil);
  Design.SortBackToFront2D;
end;

procedure TProjectForm.MenuItemSupportClick(Sender: TObject);
begin
  OpenURL('https://patreon.com/castleengine/');
end;

procedure TProjectForm.MenuItemCgeWwwClick(Sender: TObject);
begin
  OpenURL('https://castle-engine.io/');
end;

procedure TProjectForm.MenuItemAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TProjectForm.MenuItemAutoGenerateTexturesClick(Sender: TObject);
begin
  BuildToolCall(['auto-generate-textures']);
end;

procedure TProjectForm.MenuItemBreakProcessClick(Sender: TObject);
begin
  if RunningProcess = nil then
    raise EInternalError.Create('It should not be possible to call this when RunningProcess = nil');

  OutputList.AddSeparator;
  OutputList.AddLine('Forcefully killing the process.', okError);
  FreeProcess;
end;

procedure TProjectForm.MenuItemCameraViewAllClick(Sender: TObject);
begin
  Assert(Design <> nil);
  Design.CameraViewAll;
end;

procedure TProjectForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ProposeSaveDesign then
    Application.Terminate
  else
    CanClose := false;
end;

procedure TProjectForm.FormCreate(Sender: TObject);

  function CreateMenuItemForComponent(const R: TRegisteredComponent): TMenuItem;
  begin
    Result := TMenuItem.Create(Self);
    Result.Caption := R.Caption + ' (' + R.ComponentClass.ClassName + ')';
    Result.Tag := PtrInt(Pointer(R.ComponentClass));
  end;

  procedure BuildComponentsMenu;
  var
    MenuItem: TMenuItem;
    R: TRegisteredComponent;
    SeparatorIndex: Integer;
  begin
    for R in RegisteredComponents do
    begin
      if R.ComponentClass.InheritsFrom(TCastleUserInterface) then
      begin
        MenuItem := CreateMenuItemForComponent(R);
        MenuItem.OnClick := @MenuItemDesignNewCustomRootClick;
        MenuItemDesignNewUserInterfaceCustomRoot.Add(MenuItem);

        MenuItem := CreateMenuItemForComponent(R);
        MenuItem.OnClick := @MenuItemAddComponentClick;
        MenuItemDesignAddUserInterface.Add(MenuItem);
      end else
      if R.ComponentClass.InheritsFrom(TCastleTransform) then
      begin
        MenuItem := CreateMenuItemForComponent(R);
        MenuItem.OnClick := @MenuItemDesignNewCustomRootClick;
        MenuItemDesignNewTransformCustomRoot.Add(MenuItem);

        MenuItem := CreateMenuItemForComponent(R);
        MenuItem.OnClick := @MenuItemAddComponentClick;
        SeparatorIndex := MenuItemDesignAddTransform.IndexOf(MenuItemSeparatorInAddTransform);
        MenuItemDesignAddTransform.Insert(SeparatorIndex, MenuItem);
      end;
    end;
  end;

begin
  OutputList := TOutputList.Create(ListOutput);
  BuildComponentsMenu;
  ApplicationProperties.OnWarning.Add(@WarningNotification);
end;

procedure TProjectForm.FormDestroy(Sender: TObject);
begin
  ApplicationProperties.OnWarning.Remove(@WarningNotification);
  ApplicationDataOverride := '';
  FreeProcess;
  FreeAndNil(OutputList);
end;

procedure TProjectForm.ListOutputClick(Sender: TObject);
begin
  // TODO: just to source code line in case of error message here
end;

procedure TProjectForm.MenuItemAutoGenerateCleanClick(Sender: TObject);
begin
  BuildToolCall(['auto-generate-clean']);
end;

procedure TProjectForm.MenuItemCleanClick(Sender: TObject);
begin
  BuildToolCall(['clean']);
end;

procedure TProjectForm.MenuItemCompileClick(Sender: TObject);
begin
  BuildToolCall(['compile']);
end;

procedure TProjectForm.MenuItemCompileRunClick(Sender: TObject);
begin
  if ProposeSaveDesign then
    BuildToolCall(['compile', 'run']);
end;

procedure TProjectForm.MenuItemCopyComponentClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise
  Design.CopyComponent;
end;

procedure TProjectForm.MenuItemDesignAddBoxClick(Sender: TObject);
begin
  NeedsDesignFrame;
  Design.AddComponent(TCastleScene, pgBox);
end;

procedure TProjectForm.MenuItemDesignAddRectangle2DClick(Sender: TObject);
begin
  NeedsDesignFrame;
  Design.AddComponent(TCastleScene, pgRectangle2D);
end;

procedure TProjectForm.MenuItemDesignAddSphereClick(Sender: TObject);
begin
  NeedsDesignFrame;
  Design.AddComponent(TCastleScene, pgSphere);
end;

procedure TProjectForm.MenuItemDesignCloseClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise

  if ProposeSaveDesign then
  begin
    FreeAndNil(Design);
    DesignExistenceChanged;
  end;
end;

procedure TProjectForm.MenuItemDesignDeleteComponentClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise
  Design.DeleteComponent;
end;

procedure TProjectForm.MenuItemDuplicateComponentClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise
  Design.DuplicateComponent;
end;

procedure TProjectForm.MenuItemManualClick(Sender: TObject);
begin
  OpenURL('https://castle-engine.io/manual_intro.php');
end;

procedure TProjectForm.MenuItemModeDebugClick(Sender: TObject);
begin
  BuildMode := bmDebug;
  MenuItemModeDebug.Checked := true;
end;

procedure TProjectForm.DesignExistenceChanged;
begin
  MenuItemSaveAsDesign.Enabled := Design <> nil;
  MenuItemSaveDesign.Enabled := Design <> nil;
  MenuItemDesignClose.Enabled := Design <> nil;
  MenuItemDesignAddTransform.Enabled := Design <> nil;
  MenuItemDesignAddUserInterface.Enabled := Design <> nil;
  MenuItemDesignDeleteComponent.Enabled := Design <> nil;
  MenuItemCameraViewAll.Enabled := Design <> nil;
  MenuItemSortBackToFront2D.Enabled := Design <> nil;
  MenuItemCopyComponent.Enabled := Design <> nil;
  MenuItemPasteComponent.Enabled := Design <> nil;
  MenuItemDuplicateComponent.Enabled := Design <> nil;

  LabelNoDesign.Visible := Design = nil;
end;

procedure TProjectForm.NeedsDesignFrame;
begin
  if Design = nil then
  begin
    Design := TDesignFrame.Create(Self);
    Design.Parent := PanelAboveTabs;
    Design.Align := alClient;
    Design.OnUpdateFormCaption := @UpdateFormCaption;
    DesignExistenceChanged;
  end;
end;

procedure TProjectForm.WarningNotification(Sender: TObject; const Category,
  Message: string);
begin
  if Category <> '' then
    ListWarnings.Items.Add(Category + ': ' + Message)
  else
    ListWarnings.Items.Add(Message);
  TabWarnings.Caption := 'Warnings (' + IntToStr(ListWarnings.Count) + ')';
  TabWarnings.TabVisible := true;
end;

procedure TProjectForm.MenuItemDesignNewUserInterfaceRectClick(Sender: TObject);
begin
  if ProposeSaveDesign then
  begin
    NeedsDesignFrame;
    Design.NewDesign(TCastleUserInterface);
  end;
end;

procedure TProjectForm.MenuItemDesignNewTransformClick(Sender: TObject);
begin
  if ProposeSaveDesign then
  begin
    NeedsDesignFrame;
    Design.NewDesign(TCastleTransform);
  end;
end;

procedure TProjectForm.MenuItemOnlyRunClick(Sender: TObject);
begin
  if ProposeSaveDesign then
    BuildToolCall(['run']);
end;

procedure TProjectForm.MenuItemOpenDesignClick(Sender: TObject);
begin
  if ProposeSaveDesign then
  begin
    if Design <> nil then
      OpenDesignDialog.Url := Design.DesignUrl;
    if OpenDesignDialog.Execute then
    begin
      NeedsDesignFrame;
      Design.OpenDesign(OpenDesignDialog.Url);
    end;
  end;
end;

procedure TProjectForm.MenuItemPackageClick(Sender: TObject);
begin
  BuildToolCall(['package']);
end;

procedure TProjectForm.MenuItemPackageSourceClick(Sender: TObject);
begin
  BuildToolCall(['package-source']);
end;

procedure TProjectForm.MenuItemPasteComponentClick(Sender: TObject);
begin
  Assert(Design <> nil); // menu item is disabled otherwise
  Design.PasteComponent;
end;

procedure TProjectForm.MenuItemSwitchProjectClick(Sender: TObject);
begin
  if ProposeSaveDesign then
  begin
    Free; // do not call MenuItemDesignClose, to avoid OnCloseQuery
    ChooseProjectForm.Show;
  end;
end;

procedure TProjectForm.ProcessUpdateTimerTimer(Sender: TObject);
begin
  if RunningProcess <> nil then
  begin
    RunningProcess.Update;
    if not RunningProcess.Running then
      FreeProcess;
  end;
end;

procedure TProjectForm.FreeProcess;
begin
  FreeAndNil(RunningProcess);
  SetEnabledCommandRun(true);
  ProcessUpdateTimer.Enabled := false;
end;

procedure TProjectForm.BuildToolCall(const Commands: array of String;
  const ExitOnSuccess: Boolean);
var
  BuildToolExe, ModeString, Command: String;
  QueueItem: TAsynchronousProcessQueue.TQueueItem;
begin
  if RunningProcess <> nil then
    raise EInternalError.Create('It should not be possible to call this when RunningProcess <> nil');

  BuildToolExe := FindExeCastleTool('castle-engine');
  if BuildToolExe = '' then
  begin
    EditorUtils.ErrorBox('Cannot find build tool (castle-engine) on $PATH environment variable.');
    Exit;
  end;

  case BuildMode of
    bmDebug  : ModeString := '--mode=debug';
    bmRelease: ModeString := '--mode=release';
    else raise EInternalError.Create('BuildMode?');
  end;

  SetEnabledCommandRun(false);
  OutputList.Clear;
  PageControlBottom.ActivePage := TabOutput;
  ProcessUpdateTimer.Enabled := true;

  RunningProcess := TAsynchronousProcessQueue.Create;
  RunningProcess.OutputList := OutputList;

  for Command in Commands do
  begin
    QueueItem := TAsynchronousProcessQueue.TQueueItem.Create;
    QueueItem.ExeName := BuildToolExe;
    QueueItem.CurrentDirectory := ProjectPath;
    QueueItem.Parameters.Add(ModeString);
    QueueItem.Parameters.Add(Command);
    RunningProcess.Queue.Add(QueueItem);
  end;

  if ExitOnSuccess then
    RunningProcess.OnSuccessfullyFinishedAll := @MenuItemQuitClick;

  RunningProcess.Start;
end;

procedure TProjectForm.MenuItemAddComponentClick(Sender: TObject);
var
  ComponentClass: TComponentClass;
begin
  ComponentClass := TComponentClass(Pointer((Sender as TComponent).Tag));
  Design.AddComponent(ComponentClass);
end;

procedure TProjectForm.MenuItemDesignNewCustomRootClick(Sender: TObject);
var
  ComponentClass: TComponentClass;
begin
  if ProposeSaveDesign then
  begin
    ComponentClass := TComponentClass(Pointer((Sender as TComponent).Tag));
    NeedsDesignFrame;
    Design.NewDesign(ComponentClass);
  end;
end;

procedure TProjectForm.SetEnabledCommandRun(const AEnabled: Boolean);
begin
  MenuItemCompile.Enabled := AEnabled;
  MenuItemCompileRun.Enabled := AEnabled;
  MenuItemOnlyRun.Enabled := AEnabled;
  MenuItemClean.Enabled := AEnabled;
  MenuItemPackage.Enabled := AEnabled;
  MenuItemPackageSource.Enabled := AEnabled;
  MenuItemAutoGenerateTextures.Enabled := AEnabled;
  MenuItemAutoGenerateClean.Enabled := AEnabled;
  MenuItemBreakProcess.Enabled := not AEnabled;
end;

procedure TProjectForm.UpdateFormCaption(Sender: TObject);
var
  S: String;
begin
  if Design <> nil then
    S := Design.FormCaption
  else
    S := '';
  Caption := S + SQuoteLCLCaption(ProjectName) + ' | Castle Game Engine';
end;

function TProjectForm.ProposeSaveDesign: Boolean;
var
  Mr: TModalResult;
  DesignName: String;
begin
  Result := true;

  if Design <> nil then
  begin
    Design.BeforeProposeSaveDesign;
    if Design.DesignModified then
    begin
      if Design.DesignUrl <> '' then
        DesignName := '"' + Design.DesignUrl + '"'
      else
        DesignName := '<unnnamed>';
      Mr := MessageDlg('Save Design',
        'Design ' + DesignName + ' was modified but not saved yet. Save it now?',
        mtConfirmation, mbYesNoCancel, 0);
      case Mr of
        mrYes: MenuItemSaveDesign.Click;
        mrCancel: Result := false;
      end;
    end;
  end;
end;

procedure TProjectForm.OpenProject(const ManifestUrl: String);
var
  ManifestDoc: TXMLDocument;
begin
  ManifestDoc := URLReadXML(ManifestUrl);
  try
    ProjectName := ManifestDoc.DocumentElement.AttributeString('name');
  finally FreeAndNil(ManifestDoc) end;

  { Below we assume ManifestUrl contains an absolute path,
    otherwise ProjectPathUrl could be '',
    and OpenDesignDialog.InitialDir would be left '' and so on. }
  ProjectPathUrl := ExtractURIPath(ManifestUrl);
  ProjectPath := URIToFilenameSafe(ProjectPathUrl);

  { override ApplicationData interpretation, and castle-data:/xxx URL,
    while this project is open. }
  ApplicationDataOverride := CombineURI(ProjectPathUrl, 'data/');
  OpenDesignDialog.InitialDir := URIToFilenameSafe(ApplicationDataOverride);
  SaveDesignDialog.InitialDir := URIToFilenameSafe(ApplicationDataOverride);

  ShellTreeView1.Root := ProjectPath;

  // It's too easy to change it visually and forget, so we set it from code
  PageControlBottom.ActivePage := TabFiles;
  SetEnabledCommandRun(true);

  BuildMode := bmDebug;
  MenuItemModeDebug.Checked := true;

  DesignExistenceChanged;
  UpdateFormCaption(nil); // make form Caption reflect project name
end;

initialization
  // initialize CGE log
  ApplicationProperties.ApplicationName := 'castle-editor';
  InitializeLog;
end.
