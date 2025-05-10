document.addEventListener("turbo:load", function() {
    document.querySelectorAll(".auto-adjust").forEach((targetArea) => {
        let lineHeight = Number(targetArea.rows);
        while(targetArea.scrollHeight > targetArea.offsetHeight) {
            lineHeight++;
            targetArea.rows = lineHeight;
        }
        targetArea.addEventListener("input", (e) => {
            e.target.style.height = 0
            e.target.style.height = e.target.scrollHeight + "px"
            if(e.target.offsetHeight < 40){
                e.target.style.height = 40 + "px"
            }
        })
    })

    const thumbnailBtn = document.querySelector("#thumbnail_modal_btn")
    const thumbnailModal = document.querySelector("#thumbnail_modal")
    const title_confirm = document.querySelector("#shortcut_title_confirm")
    const title_input = document.querySelector("#shortcut_title")
    const closeModalBtn = document.querySelector("#close_modal_btn")
    thumbnailBtn.addEventListener("click", () => {
        thumbnailModal.showModal()
        title_confirm.textContent = title_input.value
    })
    thumbnailModal.addEventListener("click", (event) => {
        if (event.target.closest("#thumbnail_modal_container") === null ) {
            thumbnailModal.close();
        }
    });
    closeModalBtn.addEventListener("click", () => {
        thumbnailModal.close();
    })
    document.getElementById("create_thumbnail").addEventListener("click", function(e) {
        const shortcut_title = title_input.value;
        const shortcut_id = document.querySelector("#shortcut_id").textContent
        thumbnailModal.close();
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
            thumbnailBtn.classList.add("hidden")
        })
        .catch(error => {
            alert("画像生成に失敗しました");
            console.error('Error:', error);
            document.querySelector("body").classList.remove("overflow-hidden")
            document.querySelector("#thumbnail_loading").classList.add("hidden")
        });
    });

    document.querySelector("#confirm_btn").addEventListener("click", () => {
        document.querySelector("#confirm_loading").classList.remove("hidden")
    })
})
