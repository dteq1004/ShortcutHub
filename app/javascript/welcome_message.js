document.addEventListener("turbo:load", function() {
    const welcome_message_modal = document.querySelector("#welcome_message_modal")
    if(localStorage.getItem("welcome_message")){
        welcome_message_modal.classList.add("hidden")
    } else {
        const welcome_message_close_button = document.querySelector("#welcome_message_close_button")
        welcome_message_close_button.addEventListener("click", function () {
            welcome_message_modal.classList.add("hidden")
            localStorage.setItem("welcome_message", "close")
        })
    }
})