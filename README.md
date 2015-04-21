### Overview

A presentation server based on [Reveal.js][1] and [Socket.IO][2].

Use a PC or a phone to control the presentation state on guest machines remotely.

Especially useful when you and your colleagues are on the same network.


### Features

* Deadly simple to setup.

* Auto refresh the presentation when your editor saves it.


### Screenshot

![screenshot][3]


### Quick Start

0. First we clone the project to a directory, and `cd` to the root directory of Notell.

   ```bash
   git clone https://github.com/ysmood/notell.git
   cd notell
   ```

0. Install dependencies. It may take a while to install all the dependencies, please be patient :D

    ```bash
    npm install
    ```

    The setup will automatically create a config file `var/config.coffee` and a demo ppt `usr/demo_ppt.ejs`.

0. Edit the `var/config.coffee` file. Change the value of the `token`, this is the password for logging in as host.

0. Now you can have a cup of tea, and start the test server.

    ```bash
    npm test
    ```

0. Visit the `http://127.0.0.1:8013` in browser, the server should work.

0. Edit the file `usr/demo_ppt.ejs`. When you save the file, the server will auto-reload the page, no F5 hell.


### Add New PPT

Of cause, Notell can serve multiple presentations at the same time. Here's an example.

0. Just create a `.ejs` file in the `usr` folder is all you need, say the file name is 'usr/moe.ejs'.

0. Then visit `http://127.0.0.1:8013/moe`, you'll get what you want.

0. To make `moe` the default page? Simply open the `var/config.coffee`, find the `default` key, change its value to `usr/moe`. Then restart the server.


### Daemon Operations

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
