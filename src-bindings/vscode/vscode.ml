module Disposable = struct
  type t
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

  external createTerminal : string -> unit Js.Promise.t = "createTerminal"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external activeTerminal : unit -> unit Js.Promise.t = "activeTerminal"
  [@@mel.scope "window"] [@@mel.module "vscode"]

  external sendTextToTerminal : string -> unit = "sendTextToTerminal"
  [@@mel.scope "window"] [@@mel.module "vscode"]
end

module Terminal = struct
  type t

  external sendText : t -> string -> unit = "sendText"
  [@@mel.scope "window"] [@@mel.module "vscode"]
end
