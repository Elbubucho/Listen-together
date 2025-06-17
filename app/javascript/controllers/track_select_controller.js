import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "iframe", "cover"]

  timeout = null

  connect() {
    console.log("Connecté au formulaire")
  }

  searchTracks(query) {
    fetch(`/tracks/autocomplete?query=${encodeURIComponent(query)}`)
      .then(res => res.json())
      .then(data => {
        this.resultsTarget.innerHTML = ""
        data.forEach(track => {
          const li = document.createElement("li")
          li.classList.add("pt-2")
          li.textContent = `${track.name} — ${track.artist}`
          li.addEventListener("click", () => {
            this.inputTarget.value = `${track.name} — ${track.artist}`
            this.iframeTarget.value = track.id
            this.coverTarget.value = track.cover
            this.resultsTarget.innerHTML = ""
          })
          this.resultsTarget.appendChild(li)
        })
      })
  }

  inputTargetConnected() {
    this.inputTarget.addEventListener("input", () => {
      clearTimeout(this.timeout)
      this.timeout = setTimeout(() => {
        const query = this.inputTarget.value
        if (query.length > 1) this.searchTracks(query)
      }, 300)
    })
  }

    clear() {
    this.element.reset()
  }
}
