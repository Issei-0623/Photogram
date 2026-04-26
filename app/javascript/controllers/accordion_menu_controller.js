import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.closeOnOutsideClick = this.closeOnOutsideClick.bind(this)
    document.addEventListener("click", this.closeOnOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnOutsideClick)
  }

  closeOthers(event) {
    const currentMenu = event.currentTarget

    if (!currentMenu.open) return

    this.menuTargets.forEach((menu) => {
      if (menu !== currentMenu) {
        menu.open = false
      }
    })
  }

  closeOnOutsideClick(event) {
    const clickedMenu = this.menuTargets.some((menu) => menu.contains(event.target))

    if (clickedMenu) return

    this.closeAll()
  }

  closeAll() {
    this.menuTargets.forEach((menu) => {
      menu.open = false
    })
  }
}

