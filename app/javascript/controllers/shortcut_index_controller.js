import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shortcut-index"
export default class extends Controller {
  static targets = [ "category", "content" ]
  click(event) {
    const tabs = this.categoryTargets
    const current = event.currentTarget
    const currentIndex = tabs.indexOf(current)
    const contents = this.contentTargets

    tabs.forEach((tab, index)=>{
      if(current.classList.contains("not-active")){
        tab.classList.remove("is-active", "text-white", "bg-teal-700")
        tab.classList.add("not-active", "text-zinc-500", "hover:bg-zinc-100")
        contents[index].classList.add("hidden")
      }
    })

    if(current.classList.contains("not-active")){
      current.classList.remove("not-active", "text-zinc-500", "hover:bg-zinc-100")
      current.classList.add("is-active", "text-white", "bg-teal-700")
      contents[currentIndex].classList.remove("hidden")
    }
  }
}
