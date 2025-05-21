import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="delete-user"
export default class extends Controller {
  static targets = ["modal"]

  show() {
    this.modalTarget.show();
  }

  close() {
    this.modalTarget.close();
  }
}
