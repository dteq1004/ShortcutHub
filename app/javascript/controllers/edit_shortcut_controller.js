import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-shortcut"
export default class extends Controller {
  static targets = [ "title", "error_title", "description", "error_description", "url", "error_url", "published_btn" ]
  connect() {
    this.validSubmit()
  }

  titleValidation() {
    const titleInput = this.titleTarget
    const titleError = this.error_titleTarget
    if (titleInput.value === "") {
      titleInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      titleInput.classList.add("border-rose-500", "focus:border-rose-500")
      titleError.textContent = "タイトルを入力してください"
    } else {
      if (titleInput.value.length < 3) {
        titleInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
        titleInput.classList.add("border-rose-500", "focus:border-rose-500")
        titleError.textContent = "3文字以上でタイトルを入力してください"
      } else {
        titleInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
        titleInput.classList.add("border-teal-500", "focus:border-teal-500")
        titleError.textContent = ""
      }
    }
  }

  descriptionValidation() {
    const descriptionInput = this.descriptionTarget
    const descriptionError = this.error_descriptionTarget
    if (descriptionInput.value === "") {
      descriptionInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      descriptionInput.classList.add("border-rose-500", "focus:border-rose-500")
      descriptionError.textContent = "説明を入力してください"
    } else {
      if (descriptionInput.value.length < 3) {
        descriptionInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
        descriptionInput.classList.add("border-rose-500", "focus:border-rose-500")
        descriptionError.textContent = "3文字以上で説明を入力してください"
      } else {
        descriptionInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
        descriptionInput.classList.add("border-teal-500", "focus:border-teal-500")
        descriptionError.textContent = ""
      }
    }
  }

  urlValidation() {
    const urlInput = this.urlTarget
    const urlError = this.error_urlTarget
    const urlRegex = /^https:\/\/www\.icloud\.com\/shortcuts\/[a-zA-Z0-9]+$/;
    if (!urlRegex.test(urlInput.value)){
      urlInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      urlInput.classList.add("border-rose-500", "focus:border-rose-500")
      if (urlInput.value === "" ) {
        urlError.textContent = "URLを入力してください"
      } else {
        urlError.textContent = "有効なURLを入力してください"
      }
    } else {
      urlInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
      urlInput.classList.add("border-teal-500", "focus:border-teal-500")
      urlError.textContent = ""
    }
  }

  validSubmit() {
    const publishedBtn = this.published_btnTarget
    if ((this.titleTarget.value !== "") && (this.descriptionTarget.value !== "") && (this.urlTarget.value !== "")) {
      if ((this.error_titleTarget.textContent === "") && (this.error_descriptionTarget.textContent === "") && (this.error_urlTarget.textContent === "")) {
        publishedBtn.classList.remove("bg-teal-500/50")
        publishedBtn.classList.add("bg-teal-500")
        publishedBtn.disabled = false
      } else {
        publishedBtn.classList.remove("bg-teal-500")
        publishedBtn.classList.add("bg-teal-500/50")
        publishedBtn.disabled = true
      }
    } else {
      publishedBtn.classList.remove("bg-teal-500")
      publishedBtn.classList.add("bg-teal-500/50")
      publishedBtn.disabled = true
    }
  }
}
