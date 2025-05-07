import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-reply-modal"
export default class extends Controller {
  static targets = ["backGround"]

  connect() {
    document.querySelector("body").classList.add("overflow-hidden")
  }

  closeModal() {
    this.backGroundTarget.classList.add("hidden")
    document.querySelector("body").classList.remove("overflow-hidden")
  }
}
