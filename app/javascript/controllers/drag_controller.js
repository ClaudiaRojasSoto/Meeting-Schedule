import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["list"]
  static values = { url: String, meetingId: Number }

  connect() {
    this.sortable = Sortable.create(this.listTarget, {
      animation: 150,
      handle: ".cursor-move",
      onEnd: this.saveOrder.bind(this)
    })
  }

  saveOrder(event) {
    const ids = Array.from(this.listTarget.querySelectorAll("[data-id]"))
      .map(el => el.dataset.id)

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ order: ids })
    })
  }

  disconnect() {
    if (this.sortable) this.sortable.destroy()
  }
}

