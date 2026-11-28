(function () {
    let widgetId = null;
    let renderedSize = null;
    let isVerified = false;
    let resizeTimer = null;

    function setSubmitState(verified) {
        document.querySelectorAll('form').forEach(function (form) {
            var button = form.querySelector('[data-turnstile-submit]');
            if (button) button.disabled = !verified;
        });
    }

    // Block Enter-key submits until the security check succeeds.
    document.addEventListener('keydown', function (event) {
        if (event.key !== 'Enter' || isVerified) return;
        var target = event.target;
        if (target && (target.tagName === 'INPUT' || target.tagName === 'BUTTON') && target.closest('form')) {
            event.preventDefault();
        }
    }, true);

    document.querySelectorAll('form').forEach(function (form) {
        if (!form.querySelector('[data-turnstile-submit]')) return;
        form.addEventListener('submit', function (event) {
            if (!isVerified) event.preventDefault();
        });
    });

    function setVerificationState(state) {
        const container = document.querySelector('.turnstile-widget');
        const form = container ? container.closest('form') : null;
        if (!form) return;

        const status = form.querySelector('[data-turnstile-status]');
        const message = status ? status.querySelector('[data-turnstile-message]') : null;
        const verified = state === 'success';

        if (!status || !message) return;
        status.classList.remove('login-feedback', 'login-feedback-error');

        if (verified) {
            message.textContent = '';
            status.hidden = true;
        } else if (state === 'expired') {
            message.textContent = 'The security check expired. Please complete it again.';
            status.hidden = false;
            status.classList.add('login-feedback', 'login-feedback-error');
        } else {
            message.textContent = 'We could not load the security check. Check your connection and try again.';
            status.hidden = false;
            status.classList.add('login-feedback', 'login-feedback-error');
        }
    }

    function renderTurnstile() {
        const container = document.querySelector('.turnstile-widget');
        if (!container || !window.turnstile || typeof window.turnstile.render !== 'function') return;

        const size = container.getBoundingClientRect().width < 320 ? 'compact' : 'flexible';
        if (widgetId !== null) {
            if (renderedSize === size || isVerified) return;
            window.turnstile.remove(widgetId);
        }

        renderedSize = size;
        widgetId = window.turnstile.render(container, {
            sitekey: container.dataset.sitekey,
            theme: 'light',
            size: size,
            callback: function () {
                isVerified = true;
                setVerificationState('success');
                setSubmitState(true);
            },
            'expired-callback': function () {
                isVerified = false;
                setVerificationState('expired');
                setSubmitState(false);
            },
            'error-callback': function () {
                isVerified = false;
                setVerificationState('error');
                setSubmitState(false);
            }
        });
    }

    window.sahmsTurnstileReady = renderTurnstile;
    window.sahmsTurnstileError = function () {
        isVerified = false;
        setVerificationState('error');
        setSubmitState(false);
    };

    setSubmitState(false);

    window.addEventListener('resize', function () {
        if (resizeTimer !== null) window.clearTimeout(resizeTimer);
        resizeTimer = window.setTimeout(renderTurnstile, 180);
    }, { passive: true });
})();
