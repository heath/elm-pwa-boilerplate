import { Elm } from './src/Main.elm'

var jpApp = 
  Elm.Main.init({
    node: document.getElementById('main'),
    flags: {
      width: window.innerWidth,
      height: window.innerHeight
    }
  })

jpApp.ports.reboot.subscribe(function(dimensions) {
  // TODO: log the failure
  reboot(dimensions.width, dimensions.height)
})

function reboot(width, height) {
  jpApp = null;
  Elm.Main.init({
    node: document.getElementById('main'),
    flags: {
      width: width,
      height: height
    }
  })
}
