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
    const iconPreview = document.querySelector('#icon_preview')
    const iconBtn = document.querySelector('#icon_select')
    const iconModal = document.querySelector('#icon_modal')
    iconBtn.addEventListener('click', () => {
        iconModal.showModal()
    })
    iconModal.addEventListener('click', (event) => {
        if (event.target.closest('#icon_modal_container') === null ) {
            iconModal.close();
        }
    });
    for (let step = 1; step < 42; step++ ) {
        document.querySelector(`#icon${step}`).addEventListener('click', (e) => {
            const img = document.createElement('img')
            const oldImg = iconPreview.firstElementChild
            const input = document.querySelector('#shortcut_icon')
            img.setAttribute('src', e.target.attributes.src.nodeValue)
            iconPreview.replaceChild(img, oldImg)
            input.setAttribute('value', `icon${step}`)
            iconModal.close();
        })
    }
})
