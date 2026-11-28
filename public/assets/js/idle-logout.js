(function () {
    var limit = 30 * 60 * 1000;
    var timerId = null;
    function arm() {
        clearTimeout(timerId);
        timerId = window.setTimeout(function () {
            window.location.href = '/sahms/logout';
        }, limit);
    }
    var events = ['click', 'keydown', 'mousemove', 'scroll', 'touchstart'];
    events.forEach(function (name) {
        document.addEventListener(name, arm, { passive: true });
    });
    arm();
})();
