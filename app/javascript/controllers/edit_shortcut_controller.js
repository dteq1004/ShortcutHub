import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-shortcut"
export default class extends Controller {
  static targets = [
    "title",
    "error_title",
    "description",
    "error_description",
    "url",
    "error_url",
    "published_btn",
    "confirm_loading",
    "published_modal",
    "shortcut_status",
    "thumbnail_modal",
    "thumbnail_btn",
    "shortcut_title_confirm",
    "shortcut_id"
  ]
  connect() {
    this.titleValidation()
    this.descriptionValidation()
    this.urlValidation()
    this.validSubmit()
  }

  titleValidation() {
    const titleInput = this.titleTarget
    const titleError = this.error_titleTarget
    if (titleInput.value === "") {
      titleInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      titleInput.classList.add("border-rose-500", "focus:border-rose-500")
      titleError.textContent = "タイトルを入力してください"
    } else {
      if (titleInput.value.length < 3) {
        titleInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
        titleInput.classList.add("border-rose-500", "focus:border-rose-500")
        titleError.textContent = "3文字以上でタイトルを入力してください"
      } else {
        titleInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
        titleInput.classList.add("border-teal-500", "focus:border-teal-500")
        titleError.textContent = ""
      }
    }
  }

  descriptionValidation() {
    const descriptionInput = this.descriptionTarget
    const descriptionError = this.error_descriptionTarget
    // let lineHeight = Number(descriptionInput.rows)
    // while(descriptionInput.scrollHeight > descriptionInput.offsetHeight) {
    //   lineHeight++;
    //   descriptionInput.rows = lineHeight;
    // }
    // descriptionInput.style.height = 0
    // descriptionInput.style.height = descriptionInput.scrollHeight + "px"
    // if(descriptionInput.offsetHeight < 40){
    //     descriptionInput.style.height = 40 + "px"
    // }
    if (descriptionInput.value === "") {
      descriptionInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      descriptionInput.classList.add("border-rose-500", "focus:border-rose-500")
      descriptionError.textContent = "説明を入力してください"
    } else {
      if (descriptionInput.value.length < 3) {
        descriptionInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
        descriptionInput.classList.add("border-rose-500", "focus:border-rose-500")
        descriptionError.textContent = "3文字以上で説明を入力してください"
      } else {
        descriptionInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
        descriptionInput.classList.add("border-teal-500", "focus:border-teal-500")
        descriptionError.textContent = ""
      }
    }
  }

  urlValidation() {
    const urlInput = this.urlTarget
    const urlError = this.error_urlTarget
    const urlRegex = /^https:\/\/www\.icloud\.com\/shortcuts\/[a-zA-Z0-9]+$/;
    if (!urlRegex.test(urlInput.value)){
      urlInput.classList.remove("border-zinc-300", "focus:border-zinc-500", "border-teal-500", "focus:border-teal-500")
      urlInput.classList.add("border-rose-500", "focus:border-rose-500")
      if (urlInput.value === "" ) {
        urlError.textContent = "URLを入力してください"
      } else {
        urlError.textContent = "有効なURLを入力してください"
      }
    } else {
      urlInput.classList.remove("border-rose-500", "focus:border-rose-500", "border-zinc-300", "focus:border-zinc-500")
      urlInput.classList.add("border-teal-500", "focus:border-teal-500")
      urlError.textContent = ""
    }
  }

  validSubmit() {
    const publishedBtn = this.published_btnTarget
    if ((this.titleTarget.value !== "") && (this.descriptionTarget.value !== "") && (this.urlTarget.value !== "")) {
      if ((this.error_titleTarget.textContent === "") && (this.error_descriptionTarget.textContent === "") && (this.error_urlTarget.textContent === "")) {
        publishedBtn.disabled = false
      } else {
        publishedBtn.disabled = true
      }
    } else {
      publishedBtn.disabled = true
    }
  }

  confirmSubmit() {
    this.confirm_loadingTarget.classList.remove("hidden");
  }

  showPublishedModal() {
    this.changeStatusToPublished()
    this.published_modalTarget.show()
  }

  closePublishedModal() {
    this.changeStatusToDraft()
    this.published_modalTarget.close()
  }

  clickOutsidePublishedModal(event) {
    if (event.target.closest("#published_modal_container") === null) {
      this.closePublishedModal()
    }
  }

  changeStatusToPublished() {
    this.shortcut_statusTarget.value = "published"
  }

  changeStatusToDraft() {
    this.shortcut_statusTarget.value = "draft"
  }

  showThumbnailModal() {
    if (this.hasShortcut_title_confirmTarget) {
      this.shortcut_title_confirmTarget.textContent = this.titleTarget.value
    }
    this.thumbnail_modalTarget.show()
  }

  closeThumbnailModal() {
    this.thumbnail_modalTarget.close()
  }

  clickOutsideThumbnailModal(event) {
    if (event.target.closest("#thumbnail_modal_container") === null) {
      this.closeThumbnailModal()
    }
  }

  createThumbnail() {
    const shortcut_title = this.titleTarget.value
    const shortcut_id = this.shortcut_idTarget.textContent
    this.closeThumbnailModal();
    document.querySelector("body").classList.add("overflow-hidden")
    document.querySelector("#thumbnail_loading").classList.remove("hidden")
    fetch('/shortcuts/generate_thumbnail', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ shortcut_title: shortcut_title, shortcut_id: shortcut_id })
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('shortcut_thumbnail_preview').src = data.image_url; // 新しい画像に入れ替え
        document.querySelector("body").classList.remove("overflow-hidden")
        document.querySelector("#thumbnail_loading").classList.add("hidden")
        document.querySelector("#credit").classList.add("hidden")
        this.thumbnail_btnTarget.classList.add("hidden")
    })
    .catch(error => {
        alert("画像生成に失敗しました");
        console.error('Error:', error);
        document.querySelector("body").classList.remove("overflow-hidden")
        document.querySelector("#thumbnail_loading").classList.add("hidden")
    });
  }
}
