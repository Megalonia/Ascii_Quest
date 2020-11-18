# WebAssembly

## Building For the Web
First, we need a target installed to handle compilation to wasm. The targets name is ```wasm32-unknown-unknown```(you need rustup to install this):

```
rustup target add wasm32-unknown-unknown
```
We'll also need ```wasm-bindgen```. This scans our wasm and builds the parts we need to make the code run on the web. To install:
```
cargo install wasm-bindgen-cli
```

### Compiling our program into wasm

```
cargo build --release --target wasm32-unknown-unknown
```
This creates files in ```target/wasm32-unknown-unknown/release/``` directory.  There are several folders of build information and important files: PROJECTNAME.d(debug info) and PROJECTNAME.wasm(the wasm target).

## Assemble web files
in release we'll make a output directory ```wasm```
Now we will use wasm-bindgen to build the groundwork to integrate with browsers.
```
wasm-bindgen target\wasm32-unknown-unknown\release\PROJECTNAME.wasm --out-dir wasm --no-modules --no-typescript
```

In the ```wasm``` dir, we'll see two files:
```PROJECTNAME.js``` - JS binding for the project
```PROJECTNAME_bg.wasm``` - A modified version of the wasm output including the binding required by the JS file.

## Create some HTML 
In the ```wasm``` folder, we'll create an HTML page to host/lauch our applicaiton. 
```html
<html>
  <head>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
  </head>
  <body>
    <canvas id="canvas" width="640" height="480"></canvas>
    <script src="./PROJECTNAME_.js"></script>
    <script>
      window.addEventListener("load", async () => {
        await wasm_bindgen("./PROJECTNAME_bg.wasm");
      });
    </script>
  </body>
</html>
```

## Host
You can't run WASM from a local file source (presumably for security reasons). You need to put it into a web server, and run it from there.

We'll be using python3 for a quick solution.
```
python3 http.server 9000
```
