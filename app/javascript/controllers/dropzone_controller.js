import Dropzone from "dropzone";
import {
  Controller
} from "@hotwired/stimulus"
import {
  getMetaValue,
} from "../helpers";

function createDropZone(controller) {
  return new Dropzone(controller.element, {
    url: controller.url,
    headers: controller.headers,
    maxFiles: 1,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoProcessQueue: false,
    paramName: "image[file]",
    method: controller.method,
  });
}


export default class extends Controller {
  static targets = ["input"];

  connect() {
    Dropzone.autoDiscover = false; // necessary quirk for Dropzone error in console
    this.dropZone = createDropZone(this);
    this.addExistingFiles();
    this.hideFileInput();
    this.bindEvents();
    const form = this.element.closest("form");
    form.addEventListener("submit", this.handleFormSubmit.bind(this));
  }

  addExistingFiles() {
    const file = this.inputTarget;
    var mockFile = {
      url: file.getAttribute('value'),
      name: file.getAttribute('filename'),
      size: file.getAttribute('filesize'),
      accepted: true
    };
    this.dropZone.files.push(mockFile);
    this.dropZone.emit("addedfile", mockFile);
    this.dropZone.emit("thumbnail", mockFile, file.getAttribute('value'));
    this.dropZone.emit("complete", mockFile);
    this.dropZone.options.maxFiles = this.maxFiles;
  }

  handleFormSubmit(event) {
    event.preventDefault();
    console.log("submit");
    this.dropZone.processQueue();
  }

  bindEvents() {
    this.dropZone.on("sending", (file, xhr, formData) => {
      formData.append("image[title]", document.querySelector("#image_title").value);
    });
    this.dropZone.on("success", (file) => {
      console.log("success");
      window.location = "/images";
    });
    this.dropZone.on("addedfile", (file) => {
      document.querySelector(".dropzone-msg").classList.add("d-none");
    });
    this.dropZone.on("removedfile", (file) => {
      document.querySelector(".dropzone-msg").classList.remove("d-none");
    });
  }

  // Private
  hideFileInput() {
    this.inputTarget.disabled = true;
    this.inputTarget.style.display = "none";
  }

  get headers() {
    return {
      "X-CSRF-Token": getMetaValue("csrf-token"),
    };
  }

  get url() {
    return this.inputTarget.getAttribute("data-direct-upload-url");
  }

  get method() {
    console.log(this.data.get("method"));
    return this.data.get("method") || "post";
  }

  get maxFiles() {
    return this.data.get("maxFiles") || 1;
  }

  get maxFileSize() {
    return this.data.get("maxFileSize") || 256;
  }

  get acceptedFiles() {
    return this.data.get("acceptedFiles") || "image/*";
  }

  get addRemoveLinks() {
    return this.data.get("addRemoveLinks") || true;
  }
}