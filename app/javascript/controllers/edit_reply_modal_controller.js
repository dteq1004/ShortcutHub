import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-reply-modal"
export default class extends Controller {
  static targets = ["backGround"]
  connect() {
  }

  close(event) {
    if(event.detail.success) {
      this.backGroundTarget.classList.add("hidden")
    }
  }

  closeModal() {
    this.backGroundTarget.classList.add("hidden")
  }
}
