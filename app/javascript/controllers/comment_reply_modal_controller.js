import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-reply-modal"
export default class extends Controller {
  static targets = ["commentReplyModal", "backGround"]

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

  closeBackground(event) {
    if(event.target === this.backGroundTarget) {
      this.closeModal()
    }
  }
}
