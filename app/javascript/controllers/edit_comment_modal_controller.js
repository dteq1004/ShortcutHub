import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-comment-modal"
export default class extends Controller {
  static targets = ["backGround"]
  connect() {
    document.querySelector("body").classList.add("overflow-hidden")
  }

  close(event) {
    if(event.detail.success) {
      this.backGroundTarget.classList.add("hidden")
      document.querySelector("body").classList.remove("overflow-hidden")
    }
  }

  closeModal() {
    this.backGroundTarget.classList.add("hidden")
    document.querySelector("body").classList.remove("overflow-hidden")
  }
}
