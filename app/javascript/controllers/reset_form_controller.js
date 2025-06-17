import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="resetform"
export default class extends Controller {
  connect() {
    console.log("hello")
  }

  reset() {
    this.element.reset()
  }
}
