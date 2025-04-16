import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="instruction"
export default class extends Controller {
  static targets = ["instructions"];

  append() {
    if (this.instructionsTarget.childElementCount > 9) {
      alert("これ以上追加できません")
      return
    }
    const parentDiv = document.createElement("div");
    const childDiv = document.createElement("div");
    const p = document.createElement("p");
    const textarea = document.createElement("textarea");
    const dropdownContainer = document.createElement("div");
    const dropdownButton = document.createElement("div");
    const deleteButtonContainer = document.createElement("div");
    const deleteButton = document.createElement("button");

    const step = this.instructionsTarget.childElementCount + 1

    parentDiv.classList.add("flex","items-center", "gap-4", "pb-4");
    childDiv.classList.add("flex-none", "flex", "justify-center", "items-center", "bg-zinc-700", "rounded-full", "size-5")
    p.classList.add("text-white", "text-xs")
    p.textContent = step
    textarea.placeholder = "ここに使い方を入力してください"
    textarea.classList.add("resize-none", "overflow-hidden", "auto-adjust", "outline-none","border", "border-transparent", "focus:border-teal-700", "h-10", "w-full", "p-2", "bg-white", "rounded-xl", "border-zinc-300")
    textarea.setAttribute("name", `shortcut[instructions][]`)
    textarea.setAttribute("required", true)
    dropdownContainer.classList.add("dropdown", "dropdown-top", "dropdown-end")
    dropdownButton.setAttribute("tabindex", "0")
    dropdownButton.setAttribute("role", "button")
    dropdownButton.classList.add("pb-2")
    dropdownButton.textContent = "..."
    deleteButtonContainer.setAttribute("tabindex", "0")
    deleteButtonContainer.classList.add("dropdown-content", "menu", "bg-base-100", "rounded-box", "z-1", "w-26", "p-2", "shadow-sm")
    deleteButton.setAttribute("data-action", "click->instruction#remove")
    deleteButton.setAttribute("type", "button")
    deleteButton.classList.add("text-rose-500")
    deleteButton.textContent = "削除する"

    deleteButtonContainer.append(deleteButton)
    dropdownContainer.append(dropdownButton)
    dropdownContainer.append(deleteButtonContainer)
    childDiv.append(p);
    parentDiv.append(childDiv)
    parentDiv.append(textarea)
    parentDiv.append(dropdownContainer)
    this.instructionsTarget.append(parentDiv);
  }

  remove(event) {
    event.currentTarget.closest("div").parentElement.parentElement.remove();
    for (let i = 0; i < this.instructionsTarget.childElementCount; i++) {
      if (this.instructionsTarget.children[i].firstElementChild.firstElementChild.textContent != i + 1) {
        this.instructionsTarget.children[i].firstElementChild.firstElementChild.textContent = i + 1
      }
    }
  }
}
