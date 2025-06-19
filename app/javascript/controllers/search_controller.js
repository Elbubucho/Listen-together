import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const query = this.element.querySelector("input[name='query']").value.trim()

      if (query.length === 0) {
        const frame = document.getElementById("search_results")
        if (frame) frame.innerHTML = ""
        return
      }

      this.element.requestSubmit()
    }, 200)
  }
}
