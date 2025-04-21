import { Controller } from "@hotwired/stimulus"
import Tagify from "@yaireo/tagify"

// Connects to data-controller="tag"
export default class extends Controller {
  connect() {
    var tagify = new Tagify(this.element, {
      whitelist: [],
      maxTags: 5,
      dropdown: {
        maxItems: 5,
        enabled: 0,
        classname: "",
        clearOnSelect: false,
      },
      originalInputValueFormat: valuesArr => valuesArr.map(item => item.value)
    }),
    controller;

    tagify.on("input", onInput)
    function onInput(e) {
      var value = e.detail.value
      tagify.whitelist = null

      controller && controller.abort()
      controller = new AbortController()

      tagify.loading(true)

      fetch(`/tags/search?query=${value}`, { signal:controller.signal })
        .then(RES => RES.json())
        .then(function(newWhitelist) {
          tagify.whitelist = newWhitelist
          tagify.loading(false).dropdown.show(value)
        })
    }
  }
}
