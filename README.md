# SAHMS

The Student Assistant Hours Management System is a native PHP application using PDO and MariaDB.

## Current workflow

- Student Assistants enter their registered student number on the public login page to view their hours summary. No SA password is required.
- Head SAs sign in with their registered email or student number and password.
- Head SAs maintain monthly total hours and a separate OT portion in **Reports → Annual Summary**. The monthly total includes OT.
- Approved legacy DTR data is retained. Months without a manually entered summary continue to display approved historic DTR hours.
- The public calculator defaults Time In to 08:00 (editable), deducts a one-hour break for shifts longer than eight hours, and counts OT after 17:00 in completed 30-minute blocks.
- DTR upload, bulk-entry, and approval endpoints are retired; legacy DTR rows are not deleted.

> **Privacy:** Student-number lookup is not identity verification. Anyone who knows an SA's number and passes CAPTCHA can view that SA's hours summary. Use authenticated SA accounts instead if this exposure is not acceptable.

## Setup

1. Copy `.env.example` to `.env` in the project root and fill in the database connection values. `config/database.php` loads this file; server-level environment variables take precedence.
2. Set `APP_ENV=production` and the appropriate `APP_TIMEZONE`.
3. For a new database, import `database/schema.sql`. For an existing installation, back up the database and apply `database/migrations/20261117_create_sa_monthly_hours.sql`. The migration only creates the new monthly-hours table; it does not delete historic records.
4. Put the Cloudflare values in `.env` or configure them as server environment variables:
   - `TURNSTILE_SITE_KEY`
   - `TURNSTILE_SECRET_KEY`
5. Enable PHP's cURL extension so the server can verify Cloudflare Turnstile tokens.
6. For clean routes such as `/sahms/login` and `/sahms/dashboard`, deploy the project under `/sahms` on Apache with `mod_rewrite` and `.htaccess` overrides enabled. The root rewrite maps these routes to `public/*.php`; legacy login URLs redirect to `/sahms/login` for GET/HEAD requests. Verify the site over HTTPS before production use.

Turnstile verification is required and fails closed if keys or cURL are unavailable. Do not put secret keys in source control.

`.env` is ignored by Git and by the VS Code upload configuration. If the PHP app uses the file on the server, place it in the project root through a secure method. The root `.htaccess` denies HTTP access to `.env` files as an additional safeguard.

The local VS Code configuration at `.vscode/sftp.json` contains deployment credentials. Keep it private and do not commit it. The current connection uses FTP, which does not encrypt credentials or traffic; do not use it to transfer `.env`. Prefer SFTP or FTPS if the hosting provider supports either.

## Data behavior

`sa_monthly_hours` stores one row per SA, year, and month. Each monthly OT value must be between zero and that month's total. When a month has a manual row, it replaces that month's legacy DTR total in reports. Historic DTR rows remain untouched.

No live database migration or deployment is performed by this project setup.
