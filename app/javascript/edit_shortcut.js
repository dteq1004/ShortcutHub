const openPublishedModalButton = document.getElementById('openPublishedModal');
const closePublishedModalButton = document.getElementById('closePublishedModal');
const publishedModal = document.getElementById('published_modal');
const statusInput = document.getElementById('shortcut_status');

const changeStatusToPublished = () => {
    statusInput.value = 'published';
}
const changeStatusToDraft = () => {
    statusInput.value = 'draft';
}

openPublishedModalButton.addEventListener('click', () => {
    publishedModal.showModal();
    changeStatusToPublished();
});
closePublishedModalButton.addEventListener('click', () => {
    publishedModal.close();
    changeStatusToDraft();
});
publishedModal.addEventListener('click', (event) => {
    if (event.target.closest('#publishedModalContainer') === null ) {
        publishedModal.close();
        changeStatusToDraft();
    }
});

document.querySelectorAll('.auto-adjust').forEach((targetArea) => {
    let lineHeight = Number(targetArea.rows);
    while(targetArea.scrollHeight > targetArea.offsetHeight) {
        lineHeight++;
        targetArea.rows = lineHeight;
    }

    targetArea.addEventListener('input', (e) => {
        e.target.style.height = 0
        e.target.style.height = e.target.scrollHeight + "px"
        if(e.target.offsetHeight < 40){
            e.target.style.height = 40 + "px"
        }
    })
})
