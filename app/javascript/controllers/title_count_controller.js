import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="title-count"
export default class extends Controller {
  static targets = [ "count", "title", "error_title", "submit" ]

  connect() {
    this.change()
  }

  static values = {
    characterCount: Number
  }

  change() {
    const titleInput = this.titleTarget
    const titleError = this.error_titleTarget
    const submitBtn = this.submitTarget
    let length = titleInput.value.length
    this.countTarget.textContent = `${length} / 50`

    if (length < 3 || length > this.characterCount) {
      this.countTarget.classList.add("text-rose-500")
      titleInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      titleInput.classList.add("border-rose-500", "focus:border-rose-500")
      titleError.textContent = "3文字以上50文字以内で入力してください。"
      submitBtn.classList.remove("bg-teal-500")
      submitBtn.classList.add("bg-teal-500/50")
      submitBtn.disabled = true
    } else {
      this.countTarget.classList.remove("text-rose-500")
      titleInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
      titleInput.classList.add("border-teal-500", "focus:border-teal-500")
      titleError.textContent = ""
      submitBtn.classList.remove("bg-teal-500/50")
      submitBtn.classList.add("bg-teal-500")
      submitBtn.disabled = false
    }
  }
}
