(function () {
    const monthSelect = document.getElementById('calculatorMonth');
    const periodSelect = document.getElementById('calculatorPeriod');
    const daysBody = document.getElementById('calculatorDays');
    const periodLabel = document.getElementById('calculatorPeriodLabel');
    const periodTotal = document.getElementById('calculatorPeriodTotal');
    const errorOutput = document.getElementById('calculatorError');

    if (!monthSelect || !periodSelect || !daysBody || !periodLabel || !periodTotal || !errorOutput) {
        return;
    }

    const configuredYear = Number(monthSelect.dataset.year);
    const year = Number.isInteger(configuredYear) && configuredYear >= 2000
        ? configuredYear
        : new Date().getFullYear();
    const entriesByDate = {};

    function toMinutes(value) {
        const parts = value.split(':');
        if (parts.length !== 2) return null;
        const hours = Number(parts[0]);
        const minutes = Number(parts[1]);
        if (!Number.isInteger(hours) || !Number.isInteger(minutes)) return null;
        if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) return null;
        return hours * 60 + minutes;
    }

    function calculateDay(startValue, endValue, touched) {
        if (startValue === '' && endValue === '') {
            return { minutes: 0, error: '' };
        }
        if (startValue === '08:00' && endValue === '' && !touched) {
            return { minutes: 0, error: '' };
        }
        if (startValue === '' || endValue === '') {
            return { minutes: 0, error: 'Enter both times, or leave both blank.' };
        }

        const start = toMinutes(startValue);
        const end = toMinutes(endValue);
        if (start === null || end === null || end <= start) {
            return { minutes: 0, error: 'Time Out must be later than Time In.' };
        }

        const duration = end - start;
        const scheduledEnd = 17 * 60;
        const regularEnd = Math.min(end, scheduledEnd);
        let regularMinutes = Math.max(0, regularEnd - start);
        if (duration > 8 * 60) {
            regularMinutes = Math.max(0, regularMinutes - 60);
        }

        const overtimeStart = Math.max(start, scheduledEnd);
        const rawOvertimeMinutes = Math.max(0, end - overtimeStart);
        const countedOvertimeMinutes = Math.floor(rawOvertimeMinutes / 30) * 30;

        return {
            minutes: regularMinutes + countedOvertimeMinutes,
            error: ''
        };
    }

    function updateTotals() {
        let periodMinutes = 0;
        let invalidDays = 0;
        const rows = daysBody.querySelectorAll('tr');

        rows.forEach(function (row) {
            const timeIn = row.querySelector('.calculator-time-in');
            const timeOut = row.querySelector('.calculator-time-out');
            const totalOutput = row.querySelector('.calculator-day-total');
            const dayError = row.querySelector('.calculator-day-error');
            const result = calculateDay(timeIn.value, timeOut.value, row.dataset.touched === 'true');

            dayError.textContent = result.error;
            if (result.error) {
                invalidDays++;
                totalOutput.textContent = '—';
            } else {
                periodMinutes += result.minutes;
                totalOutput.textContent = (result.minutes / 60).toFixed(1) + ' hrs';
            }
        });

        periodTotal.textContent = invalidDays > 0
            ? '—'
            : (periodMinutes / 60).toFixed(1) + ' hrs';
        errorOutput.textContent = invalidDays > 0
            ? 'Complete or correct the highlighted days to calculate the cutoff total.'
            : '';
    }

    function renderDays() {
        while (daysBody.firstChild) {
            daysBody.removeChild(daysBody.firstChild);
        }

        const monthIndex = Number(monthSelect.value);
        const firstDay = periodSelect.value === 'first' ? 1 : 16;
        const lastDay = periodSelect.value === 'first'
            ? 15
            : new Date(year, monthIndex + 1, 0).getDate();
        const monthName = monthSelect.options[monthSelect.selectedIndex].textContent;
        periodLabel.textContent = monthName + ' ' + year + ' (' + firstDay + '-' + lastDay + ') total';

        for (let day = firstDay; day <= lastDay; day++) {
            const date = new Date(Date.UTC(year, monthIndex, day));
            const isWeekend = date.getUTCDay() === 0 || date.getUTCDay() === 6;
            const dateLabel = date.toLocaleDateString('en', {
                weekday: 'short',
                month: 'short',
                day: 'numeric',
                timeZone: 'UTC'
            });
            const dateId = year + '-' + String(monthIndex + 1).padStart(2, '0') + '-' + String(day).padStart(2, '0');
            const row = document.createElement('tr');
            row.dataset.touched = 'false';
            row.dataset.date = dateId;
            const savedEntry = entriesByDate[dateId];
            if (savedEntry) {
                row.dataset.touched = savedEntry.touched ? 'true' : 'false';
            }

            const dateCell = document.createElement('th');
            dateCell.scope = 'row';
            dateCell.textContent = dateLabel;
            row.appendChild(dateCell);

            const timeInCell = document.createElement('td');
            const timeIn = document.createElement('input');
            timeIn.type = 'time';
            timeIn.value = savedEntry ? savedEntry.timeIn : (isWeekend ? '' : '08:00');
            timeIn.className = 'form-control form-control-sm calculator-time calculator-time-in';
            timeIn.setAttribute('aria-label', 'Time In for ' + dateLabel);
            timeInCell.appendChild(timeIn);
            row.appendChild(timeInCell);

            const timeOutCell = document.createElement('td');
            const timeOut = document.createElement('input');
            timeOut.type = 'time';
            timeOut.value = savedEntry ? savedEntry.timeOut : '';
            timeOut.className = 'form-control form-control-sm calculator-time calculator-time-out';
            timeOut.setAttribute('aria-label', 'Time Out for ' + dateLabel);
            timeOutCell.appendChild(timeOut);
            row.appendChild(timeOutCell);

            const totalCell = document.createElement('td');
            totalCell.className = 'text-end';
            const total = document.createElement('strong');
            total.className = 'calculator-day-total';
            total.textContent = '0.0 hrs';
            totalCell.appendChild(total);

            const dayError = document.createElement('small');
            dayError.id = 'calculator-day-error-' + dateId;
            dayError.className = 'calculator-day-error';
            totalCell.appendChild(dayError);
            row.appendChild(totalCell);

            timeIn.setAttribute('aria-describedby', dayError.id);
            timeOut.setAttribute('aria-describedby', dayError.id);
            timeIn.addEventListener('input', function () {
                row.dataset.touched = 'true';
                entriesByDate[dateId] = {
                    timeIn: timeIn.value,
                    timeOut: timeOut.value,
                    touched: true
                };
                updateTotals();
            });
            timeOut.addEventListener('input', function () {
                row.dataset.touched = 'true';
                entriesByDate[dateId] = {
                    timeIn: timeIn.value,
                    timeOut: timeOut.value,
                    touched: true
                };
                updateTotals();
            });

            daysBody.appendChild(row);
        }

        updateTotals();
    }

    monthSelect.addEventListener('change', renderDays);
    periodSelect.addEventListener('change', renderDays);
    renderDays();
})();
