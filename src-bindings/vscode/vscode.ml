module Disposable = struct
  type t
end

module Terminal = struct
  type t

  external sendText : t -> string -> ?shouldExecute:bool -> unit -> unit
    = "sendText"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external show : t -> ?preserveFocus:bool -> unit -> unit = "show"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external hide : t -> unit = "hide"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external dispose : t -> unit = "dispose"
  [@@mel.scope "window"] [@@mel.module "vscode"]
end

module ExtensionContext = struct
  type t

  external subscriptions : t -> Disposable.t array = "subscriptions" [@@mel.get]
end

module Commands = struct
  external registerCommand : string -> ('a array -> unit) -> Disposable.t
    = "registerCommand"
  [@@mel.scope "commands"] [@@mel.module "vscode"]

  external executeCommands : string -> 'a array -> unit = "executeCommands"
  [@@mel.scope "commands"] [@@mel.module "vscode"] [@@mel.variadic]
end

module Window = struct
  external showInformationMessage : string -> unit = "showInformationMessage"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external createTerminal : string -> Terminal.t = "createTerminal"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external activeTerminal : unit -> Terminal.t Js.Promise.t = "activeTerminal"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external sendTextToTerminal : string -> unit = "sendTextToTerminal"
  [@@mel.scope "window"] [@@mel.module "vscode"]
end
