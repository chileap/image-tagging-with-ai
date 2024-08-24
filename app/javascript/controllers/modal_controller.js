import { Modal } from 'flowbite';
import {
  Controller
} from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    const currentController = this.element.attributes.getNamedItem("data-current-controller").value;
    let backdrop = document.querySelector(".modal-backdrop");
    if (backdrop) {
      backdrop.remove();
    }
    this.modal = new Modal(this.element);
    console.log(this.modal);
    this.modal.show();
    this.element.addEventListener('hidden.bs.modal', (event) => {
      this.element.remove();
      window.location.href = `/${currentController}`;
    })
  }
}
