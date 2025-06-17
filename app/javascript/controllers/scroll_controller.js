import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("connected");
    this.messages = document.getElementById('messages');
    this.observer = new MutationObserver(() => this.scrollToBottom());
    this.observer.observe(this.messages, { childList: true, subtree: true });
    this.scrollToBottom();
  }

  disconnect() {
    console.log("disconnected");
    this.observer?.disconnect();
  }

  scrollToBottom() {
    this.messages.scrollTop = this.messages.scrollHeight;
  }
}
