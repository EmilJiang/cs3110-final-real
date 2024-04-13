(* this method is called when your extension is activated *)
(* your extension is activated the very first time the command is executed *)
let activate (context : Vscode.ExtensionContext.t) =
  (* Use the console to output diagnostic information (console.log) and errors
     (console.error) *)
  (* This line of code will only be executed once when your extension is
     activated *)
  Js.Console.log
    "Congratulations, your extension \"helloworld-sample\" is now active!";

  (* The command has been defined in the package.json file *)
  (* Now provide the implementation of the command with registerCommand *)
  (* The commandId parameter must match the command field in package.json *)
  let disposable =
    Vscode.Commands.registerCommand "extension.helloWorld" (fun _ ->
        Vscode.Window.showInformationMessage "Extension Activated!" |> ignore;

        let terminal = Vscode.Window.createTerminal "AI Assistant" in
        Vscode.Terminal.show terminal ~preserveFocus:true ())
  in

  Js.Array.push ~value:disposable
    (Vscode.ExtensionContext.subscriptions context)
  |> ignore