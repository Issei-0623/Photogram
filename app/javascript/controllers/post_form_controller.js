import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "images", "fileName", "submit", "message"]

  connect() {
    this.touched = false
    this.validate()
  }

  selectImages() {
    this.touched = true

    const files = Array.from(this.imagesTarget.files)

    if (files.length === 0) {
      this.fileNameTarget.textContent = ""
    } else if (files.length === 1) {
      this.fileNameTarget.textContent = files[0].name
    } else {
      this.fileNameTarget.textContent = `${files[0].name} 他${files.length - 1}枚`
    }

    this.validate()
  }

  validate() {
    const hasContent = this.contentTarget.value.trim().length > 0
    const hasImages = this.imagesTarget.files.length > 0
    const canSubmit = hasContent && hasImages

    this.submitTarget.disabled = !canSubmit
    this.submitTarget.classList.toggle("status-submit--active", canSubmit)

    if (!this.touched && !hasContent) return

    if (!hasContent && !hasImages) {
      this.messageTarget.textContent = "本文と写真を追加してください"
    } else if (!hasContent) {
      this.messageTarget.textContent = "本文を入力してください"
    } else if (!hasImages) {
      this.messageTarget.textContent = "写真を選択してください"
    } else {
      this.messageTarget.textContent = ""
    }
  }
}
