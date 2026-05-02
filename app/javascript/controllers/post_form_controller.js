import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static targets = ["content", "images", "fileName", "submit", "message", "uploads"]
  static values = { directUploadUrl: String }

  connect() {
    this.touched = false
    this.uploading = false
    this.uploadedCount = 0
    this.validate()
  }

  openFilePicker() {
    this.imagesTarget.click()
  }

  async selectImages() {
    this.touched = true
    this.resetUploadedImages()

    const files = Array.from(this.imagesTarget.files)

    if (files.length === 0) {
      this.fileNameTarget.textContent = ""
      this.validate()
      return
    }

    this.fileNameTarget.textContent = files.length === 1 ? files[0].name : `${files[0].name} 他${files.length - 1}枚`
    this.uploading = true
    this.uploadedCount = 0
    this.validate()

    try {
      for (const [index, file] of files.entries()) {
        this.messageTarget.textContent = `写真を準備中です (${index + 1}/${files.length})`
        const uploadFile = await this.compressImage(file)
        const blob = await this.uploadFile(uploadFile, files.length, index)
        this.addBlobInput(blob.signed_id)
        this.uploadedCount += 1
      }

      this.messageTarget.textContent = ""
    } catch (error) {
      console.error(error)
      this.messageTarget.textContent = "写真のアップロードに失敗しました。もう一度選択してください"
      this.resetUploadedImages()
    } finally {
      this.uploading = false
      this.imagesTarget.value = ""
      this.validate()
    }
  }

  validate() {
    const hasContent = this.contentTarget.value.trim().length > 0
    const hasImages = this.uploadedCount > 0
    const canSubmit = hasContent && hasImages && !this.uploading

    this.submitTarget.disabled = !canSubmit
    this.submitTarget.classList.toggle("status-submit--active", canSubmit)

    if (this.uploading) return
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

  async compressImage(file) {
    if (!file.type.startsWith("image/")) return file

    const image = await this.loadImage(file).catch(() => null)
    if (!image) return file

    const maxSize = 1600
    const scale = Math.min(maxSize / image.width, maxSize / image.height, 1)

    if (scale === 1 && file.size < 1_200_000) return file

    const canvas = document.createElement("canvas")
    canvas.width = Math.round(image.width * scale)
    canvas.height = Math.round(image.height * scale)

    const context = canvas.getContext("2d")
    context.drawImage(image, 0, 0, canvas.width, canvas.height)

    const blob = await new Promise((resolve) => canvas.toBlob(resolve, "image/jpeg", 0.82))
    if (!blob || blob.size >= file.size) return file

    const filename = file.name.replace(/\.[^.]+$/, ".jpg")
    return new File([blob], filename, { type: "image/jpeg", lastModified: Date.now() })
  }

  loadImage(file) {
    return new Promise((resolve, reject) => {
      const image = new Image()
      const url = URL.createObjectURL(file)

      image.onload = () => {
        URL.revokeObjectURL(url)
        resolve(image)
      }

      image.onerror = () => {
        URL.revokeObjectURL(url)
        reject(new Error("Image could not be loaded"))
      }

      image.src = url
    })
  }

  uploadFile(file, total, index) {
    return new Promise((resolve, reject) => {
      this.currentUpload = { total, index }
      const upload = new DirectUpload(file, this.directUploadUrlValue, this)

      upload.create((error, blob) => {
        this.currentUpload = null

        if (error) {
          reject(error)
        } else {
          resolve(blob)
        }
      })
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) => {
      if (!event.lengthComputable || !this.currentUpload) return

      const progress = Math.round((event.loaded / event.total) * 100)
      const { index, total } = this.currentUpload
      this.messageTarget.textContent = `写真をアップロード中です (${index + 1}/${total}) ${progress}%`
    })
  }

  addBlobInput(signedId) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "post[images][]"
    input.value = signedId
    input.dataset.uploadedImage = "true"
    this.uploadsTarget.appendChild(input)
  }

  resetUploadedImages() {
    this.uploadsTarget.querySelectorAll("[data-uploaded-image='true']").forEach((input) => input.remove())
    this.uploadedCount = 0
  }
}
