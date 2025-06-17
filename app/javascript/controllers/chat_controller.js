import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { currentUserId: String }
  static targets = ["message"]

  connect() {
    this.messageTargets.forEach(element => this.alignMessage(element))
  }

  messageTargetConnected(element) {
    this.alignMessage(element)
  }

  alignMessage(element) {
    if (element.dataset.userId === this.currentUserIdValue) {
      element.classList.remove('chat-start')
      element.classList.add('chat-end')
    } else {
      element.classList.remove('chat-end')
      element.classList.add('chat-start')
    }
  }
}
