# Installation Steps:

Create a new opam switch with the latest version of the compiler and Melange:

```
opam switch create . 5.1.1 --no-install
opam install melange
```

# Running the Extension
You can build the project using:

```
eval $(opam env)
dune build
```

To run the extension, follow these steps:

1. Open the project in Visual Studio Code.
2. Go to the 'Run and Debug' panel in VSCode.
3. Select the "Run Extension" launch target.
4. The extension will now activate in a new VSCode window.

To test the extension, try running the "Hello World" command, you should see a notification with the "Hello World" message.

# Change switch
If switch has already been create, switch to it using the following command:
eval $(opam env --switch=<switchname --set-switch>)