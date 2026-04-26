import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "indicator"]
  static values = {
    activeSrc: String,
    inactiveSrc: String
  }

  connect() {
    this.update = this.update.bind(this)
    this.sliderTarget.addEventListener("scroll", this.update)
    this.update()
  }

  disconnect() {
    this.sliderTarget.removeEventListener("scroll", this.update)
  }

  update() {
    const slideWidth = this.sliderTarget.clientWidth
    const currentIndex = Math.round(this.sliderTarget.scrollLeft / slideWidth)

    this.indicatorTargets.forEach((indicator, index) => {
      indicator.src = index === currentIndex ? this.activeSrcValue : this.inactiveSrcValue
    })
  }
}
