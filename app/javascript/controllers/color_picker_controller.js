import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  update() {
    this.previewTarget.style.backgroundColor = this.inputTarget.value
  }
}
