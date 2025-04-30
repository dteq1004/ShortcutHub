import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="title-count"
export default class extends Controller {
  static targets = [ "output", "field" ]

  static values = {
    characterCount: Number
  }

  connect() {
    this.change()
  }

  change() {
    let length = this.fieldTarget.value.length
    this.outputTargets[0].textContent = `${length} / 50`

    if (length < 3 || length > this.characterCount) {
      this.outputTargets[0].classList.add("text-rose-500")
    } else {
      this.outputTargets[0].classList.remove("text-rose-500")
    }
  }
}
