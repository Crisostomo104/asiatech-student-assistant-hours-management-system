(function () {
    const forms = document.querySelectorAll('[data-sa-name-form]');

    forms.forEach(function (form) {
        const lastNameField = form.querySelector('[data-name-part="last"]');
        const firstNameField = form.querySelector('[data-name-part="first"]');
        const middleNameField = form.querySelector('[data-name-part="middle"]');
        const suffixField = form.querySelector('[data-name-part="suffix"]');
        const fullNameField = form.querySelector('input[name="full_name"]');
        const preview = form.querySelector('[data-full-name-preview]');

        if (!lastNameField || !firstNameField || !middleNameField || !suffixField || !fullNameField || !preview) {
            return;
        }

        function normalize(value) {
            return value.trim().replace(/\s+/g, ' ').toUpperCase();
        }

        function formatMiddleName(value) {
            const middleName = normalize(value);
            if (!/^\p{L}\.?$/u.test(middleName)) return middleName;
            return middleName.endsWith('.') ? middleName : middleName + '.';
        }

        function updatePreview() {
            const lastName = normalize(lastNameField.value);
            const firstName = normalize(firstNameField.value);
            const middleName = formatMiddleName(middleNameField.value);
            const suffix = normalize(suffixField.value);
            const fullName = [
                lastName ? lastName + (firstName ? ',' : '') : '',
                firstName,
                middleName,
                suffix
            ].filter(Boolean).join(' ');

            fullNameField.value = fullName;
            preview.textContent = fullName || 'Start typing a name to preview.';
        }

        [lastNameField, firstNameField, middleNameField, suffixField].forEach(function (field) {
            field.addEventListener('input', updatePreview);
            field.addEventListener('change', updatePreview);
        });

        form.addEventListener('submit', updatePreview);
        form.addEventListener('submit', function () {
            form.querySelectorAll('[data-uppercase]').forEach(function (field) {
                field.value = normalize(field.value);
            });
            updatePreview();
        });
        updatePreview();
    });
})();
