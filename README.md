### Overview

A general node server template.

This project is more like a general configuration than a framework.
It will give you some useful tools to quick setup a commmon node server project.

These are the server tools that you can take advantage of.

* express
* formidable
* bower
* underscore
* underscore.string
* coffee-script
* stylus
* forever
* request
* fs-extra
* nedb
* gaze
* socket.io

These are the client tools that you can take advantage of.

* requirejs
* jquery
* underscore
* underscore.string
* bootstrap
* font-awesome
* jquery.transit
* ys-keymaster


### Quick Start

Let's create a sample application with namespace `MOE` and named `App`.

0. First we clone the **nobone** to a directory.

   ```bash
   git clone https://github.com/ysmood/nobone.git
   cd nobone
   ```

0. Install dependencies.

    ```bash
    npm run-script setup
    ```
0. Create the module.

    ```bash
    kit/make_module.coffee MOE.App
    ```

    You can look into the `app` folder and custom whatever you want.

0. Edit the `var/config.coffee` file. Add your generated module to the `modules` array. You'd add this to the config file.

    ```coffee
    modules: ['MOE.App']
    ```

0. Run the server.

    ```bash
    npm test
    ```

0. Visit the `http://127.0.0.1:8013` in browser, the framework should work.
