import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { date: String, view: { type: String, default: "week" } }
  static targets = ["container"]

  navigate(event) {
    const direction = event.params.direction
    const url = new URL(window.location)
    const currentDate = new Date(this.dateValue)

    if (this.viewValue === "week") {
      currentDate.setDate(currentDate.getDate() + (direction === "next" ? 7 : -7))
    } else {
      currentDate.setDate(currentDate.getDate() + (direction === "next" ? 1 : -1))
    }

    url.searchParams.set("date", currentDate.toISOString().split("T")[0])
    url.searchParams.set("view", this.viewValue)
    Turbo.visit(url.toString())
  }

  switchView(event) {
    const url = new URL(window.location)
    url.searchParams.set("view", event.params.view)
    Turbo.visit(url.toString())
  }
}
