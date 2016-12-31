// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import $ from "jquery"
import marked from "marked"
import SimpleMDE from "simplemde"

class MainView {
  mount() {
    console.log("MainView mounted");
  }

  unmount() {
    console.log("MainView unmounted");
  }
}

class WordEditView extends MainView {
  mount() {
    super.mount();

    console.log("WordShowView mounted");

    $(document).ready(() => {
      var simplemde = new SimpleMDE({spellChecker: false});

      $("#edit, input, textarea").on("keyup change", () => {
        $(window).bind("beforeunload", () => {
          return "本当に移動しますか？";
        })
      });

      $("input[type=submit]").on("click", (e) => {
        $(window).off("beforeunload");
      })
    });
  }

  unmount() {
    super.unmount();

    console.log("WordShowView unmounted");
  }
}

const views = {
  WordEditView
};

function loadView(viewName) {
  return views[viewName] || MainView
}

function handleDOMContentLoaded() {
  const viewName = document.getElementsByTagName("body")[0].dataset.jsViewName;

  const ViewClass = loadView(viewName);
  const view = new ViewClass();
  view.mount();

  window.currentView = view;
}

function handleDocumentUnload() {
  window.currentView.unmount();
}

window.addEventListener("DOMContentLoaded", handleDOMContentLoaded, false);
window.addEventListener("unload", handleDocumentUnload, false);
