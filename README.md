# Nobone

A general node server template.

## Usage

### Installation

    npm run-script setup

### Generate Module

Run the `kit/make_module.coffee` with a namespace and a class name. Such as:

    kit/make_module.coffee MOE.App

It will create a folder named `App`, and a `app/app.coffee` file contains a class named `MOE.App`.

### Configuration

Edit the `var/config.coffee` file. Add your generated module to the `modules` array. For example you want to load a module named `MOE.App`, you'd add this to the config file.

    modules: ['MOE.App']

### Run Test Server

Run `npm test` will start a local test server.