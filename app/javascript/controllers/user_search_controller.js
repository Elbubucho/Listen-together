import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value.trim()
    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/users/autocomplete?query=${encodeURIComponent(query)}`)
      .then((response) => response.json())
      .then((users) => {
        this.resultsTarget.innerHTML = users.map((user) =>
          `<a href="/users/${user.id}" class="block px-4 py-2 hover:bg-base-300">${user.name}</a>`
        ).join("")
      })
  }
}
