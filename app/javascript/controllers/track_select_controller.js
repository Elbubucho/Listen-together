import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "iframe", "cover"]

  connect() {
    this.clickOutsideHandler = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.clickOutsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  handleClickOutside(event) {
    const clickedOutsideInput = !this.inputTarget.contains(event.target)
    const clickedOutsideResults = !this.resultsTarget.contains(event.target)

    if (clickedOutsideInput && clickedOutsideResults) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.classList.add("hidden")
    }
  }

  async search() {
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.classList.add("hidden")
      return
    }

    const response = await fetch(`/tracks/autocomplete?query=${encodeURIComponent(query)}`)
    const tracks = await response.json()

    this.resultsTarget.innerHTML = ""

    tracks.forEach(track => {
      const li = document.createElement("li")
      li.textContent = `${track.name} - ${track.artist}`
      li.className = "px-4 py-2 bg-base-200 hover:bg-primary hover:text-white transition cursor-pointer"
      li.addEventListener("click", () => this.selectTrack(track))
      this.resultsTarget.appendChild(li)
    })

    if (tracks.length > 0) {
      this.resultsTarget.classList.remove("hidden")
    } else {
      this.resultsTarget.classList.add("hidden")
    }
  }

  selectTrack(track) {
    this.inputTarget.value = `${track.name} - ${track.artist}`
    this.iframeTarget.value = track.id
    this.coverTarget.value = track.cover
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }
}
