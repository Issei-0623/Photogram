import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "removeFlag", "fileName"]

  select() {
    this.inputTarget.click()
  }

  preview(event) {
    const file = event.target.files[0]
    if (!file) return

    this.removeFlagTarget.value = "0"
    this.fileNameTarget.textContent = file.name

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
    }

    reader.readAsDataURL(file)
  }

  reset() {
    this.previewTarget.src = this.previewTarget.dataset.defaultAvatarUrl
    this.inputTarget.value = ""
    this.removeFlagTarget.value = "1"
    this.fileNameTarget.textContent = ""
  }
}