import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.observer = new IntersectionObserver((entries) => {
      if (entries.some((entry) => entry.isIntersecting)) {
        this.load()
      }
    }, { rootMargin: "400px" })

    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer?.disconnect()
  }

  async load() {
    if (this.loading) return

    this.loading = true
    this.observer?.disconnect()

    const response = await fetch(this.urlValue, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })

    if (response.ok) {
      Turbo.renderStreamMessage(await response.text())
    }
  }
}