import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["form", "input", "results"]

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const query = encodeURIComponent(this.inputTarget.value);
      if (query.length === 0) {
        this.resultsTarget.innerHTML = ""
        this.inputTarget.classList.remove("rounded-bl-none", "rounded-tl-3xl", "border-b-0", "border-teal-500")
        this.inputTarget.classList.add("border-zinc-300")
        this.resultsTarget.classList.remove("border", "border-teal-500", "border-t-0")
        return
      }

      fetch(`/autocomplete?q=${query}`, {
        headers: {
          "Accept": "application/json"
        }
      })
        .then(response => response.json())
        .then(data => {
          this.inputTarget.classList.remove("border-zinc-300")
          this.inputTarget.classList.add("rounded-bl-none", "rounded-tl-3xl", "border-b-0", "border-teal-500")
          this.resultsTarget.classList.add("border", "border-teal-500", "border-t-0")
          if (data.length > 0) {
            this.updateResults(data);
          } else {
            this.resultsTarget.innerHTML = "";
            const li = document.createElement('li');
            li.textContent = "検索候補がありません";
            li.classList.add("p-2", "pl-4", "text-zinc-500");
            this.resultsTarget.appendChild(li);
          }
        })
        .catch(error => console.error('Error fetching autocomplete data:', error));
    }, 300)
  }

  updateResults(data) {
    this.resultsTarget.innerHTML = "";
    data.forEach(item => {
      const li = document.createElement('li');
      li.textContent = item;
      li.classList.add("p-2", "pl-4", "hover:bg-zinc-300");
      li.addEventListener('click', () => {
        this.selectResult(item);
      });
      this.resultsTarget.appendChild(li);
    });
  }

  selectResult(item) {
    this.inputTarget.value = item;
    this.resultsTarget.innerHTML = "";
    this.inputTarget.classList.remove("rounded-bl-none", "rounded-tl-3xl", "border-b-0", "border-teal-500")
    this.inputTarget.classList.add("border-zinc-300")
    this.resultsTarget.classList.remove("border", "border-teal-500", "border-t-0")
    this.formTarget.submit();
  }
}
