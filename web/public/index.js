document.addEventListener('keydown', event => {
    if (event.key === 'ArrowLeft') {
        event.preventDefault();
        window.location.replace("/?key=left");
    }
    else if (event.key === 'ArrowRight') {
        event.preventDefault();
        window.location.replace("/?key=right");
    }
    else if (event.key === 'ArrowUp') {
        event.preventDefault();
        window.location.replace("/?key=up");
        
    } else if (event.key === 'ArrowDown') {
        event.preventDefault();
        window.location.replace("/?key=down");
    } else if (event.key === 'r') {
        event.preventDefault();
        window.location.replace("/?key=r");
    }
});
