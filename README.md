### Overview

A presentation server based on [Reveal.js][1] and [Socket.IO][2].

You can use a PC or a phone to control the presentation state on guest machines.

When you and your colleagues have network connection, take up your phone and remote control your presentation ~


### Features

* Dead simple to setup.

* Auto refresh the presentation when you edit save it.


### Screenshot

![screenshot][3]


### Quick Start

0. First we clone the project to a directory.

   ```bash
   git clone https://github.com/ysmood/notell.git
   cd notell
   ```

0. Install dependencies.

    ```bash
    npm run-script setup
    ```

0. Edit the `var/config.coffee` file. Change the value of the `token`, this is the password for logging in as host.

0. Run the test server.

    ```bash
    npm test
    ```

0. Visit the `http://127.0.0.1:8013` in browser, the server should work.

0. Edit the file `app/client/ejs/reveal.ejs`, it is where you write your presentation contents.
   When you save the file, the server will auto-reload the page, no F5 hell.

   Edit the file `app/client/css/custom.styl` to define your custom styles.


### Deamon Operations

```bash
npm start
npm stop
npm restart
```


### License

The MIT License (MIT)

Feb 2014 ys


  [1]: https://github.com/hakimel/reveal.js
  [2]: http://socket.io/
  [3]: https://raw.github.com/ysmood/notell/master/docs/screenshot.jpg