window.addEventListener('message', function(event) {
    let audio = new Audio('sounds/sound.ogg');
    audio.volume = 0.2;
    audio.play();
    audio.play().catch(error => {
        console.error("音声の再生に失敗しました:", error);
    });
});