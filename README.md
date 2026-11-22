# SpendWise 2.0 – personal expense tracker (Expo SDK 58)

A mobile app (React Native + Expo) with its own backend (Python FastAPI + SQLite).
**Features**
- Sign up / sign in, secure login (hashed passwords, 30-day sessions)
- Income & expense tracking – add, delete, quick date buttons (Today / Yesterday / ±1 day)
- **Custom categories** (tap **＋ New** when adding an expense)
- **Search and filter** transactions (by text, expenses / income)
- Monthly budgets: overall + per category, **budget alerts on Home** (80 % used / over budget), **copy last month's budgets**
- Reports: savings rate, **comparison with last month**, daily average, **month-end projection**, biggest category, **6-month income vs expense chart**
- **Export all data as CSV** and **import a CSV** (preview first, duplicates skipped), **change password**, **delete account** (Profile tab)
- Keyboard-safe screens: inputs are never hidden behind the keyboard

```
SpendWise/
├── setup.bat            one-time install (backend + app)
├── start_backend.bat    starts the API on port 8000
├── start_app.bat        starts the Expo app
├── check_backend.bat    optional: tests the running backend
├── allow_firewall.bat   optional: lets your phone reach the backend (run as admin)
├── backend/             FastAPI + SQLite  (main.py, requirements.txt, smoke_test.py)
└── mobile/              Expo app          (App.tsx, src/…)
```

## 1. What you need (install once)

| Tool | Version | Get it |
|------|---------|--------|
| Node.js | 20.19 or newer (LTS) | https://nodejs.org |
| Python | 3.10 or newer (tick **Add python.exe to PATH**) | https://www.python.org |
| Expo Go app | the **SDK 58** version, on your Android phone (update it from the Play Store) | Play Store – *or* Android Studio emulator |

## 2. Run it (Windows)

1. **Double-click `setup.bat`** – installs everything. Takes a few minutes, only needed once.
2. **Double-click `start_backend.bat`** – leave this window open. You should see
   `Uvicorn running on http://0.0.0.0:8000`.
3. *(optional)* **Double-click `check_backend.bat`** – prints PASS lines if the backend works.
4. **Double-click `start_app.bat`** – a QR code appears.
   - **Real phone:** phone and PC on the **same Wi-Fi**. Open Expo Go and scan the QR code.
   - **Android emulator:** press **`a`** in that window.
5. In the app tap **Create account**, then add your first income and expense.

The login screen shows `Server: http://…:8000` at the bottom, so you can always see where
the app is trying to connect.

### Manual commands (instead of the .bat files)
```
cd backend
py -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
.venv\Scripts\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000

cd mobile
npm install
npx expo install --fix
npx expo start
```

## 3. Troubleshooting

| Problem | Fix |
|---------|-----|
| **"Cannot reach the server"** on a real phone | 1) Backend window must be open. 2) Same Wi-Fi as the PC. 3) Run `allow_firewall.bat` as administrator (Windows Firewall blocks port 8000 by default). 4) On the PC open `http://PC-IP:8000/health` in your phone's browser – if that fails, it's the network/firewall, not the app. |
| Still wrong address | Copy `mobile\.env.example` to `mobile\.env` and set `EXPO_PUBLIC_API_URL=http://YOUR-PC-IP:8000` (IP from `ipconfig`, the Wi-Fi IPv4). Restart `start_app.bat`. |
| Android emulator can't connect | Use `EXPO_PUBLIC_API_URL=http://10.0.2.2:8000` in `mobile\.env`. |
| Expo Go says the project is **incompatible / needs SDK xx** | This project uses **SDK 58**. Update Expo Go from the Play Store. If the store version is still older, use the Android emulator (press `a` – it installs a matching Expo Go). |
| Upgrading from the earlier SDK 57 folder | Use this new folder (don't copy the old `node_modules`). To keep your data, copy your old `backend\data\expense_tracker.db` into this project's `backend\data\` folder (create it) before starting the backend – the database format is unchanged. |
| `npm install` errors about versions | Delete `mobile\node_modules` and `mobile\package-lock.json`, run `setup.bat` again. |
| `py` / `python` not recognised | Reinstall Python and tick **Add python.exe to PATH**, then reopen the window. |
| Port 8000 already in use | Close the other backend window, or change `--port 8000` in `start_backend.bat` and use the same port in `mobile\.env`. |
| Want to reset all data | Stop the backend and delete `backend\data\expense_tracker.db`. |

## CSV import format

First row is a header; columns can be in any order and separated by `,` `;` or tab.

| Column | Required | Accepted values |
|--------|----------|-----------------|
| `date` | yes | `2026-11-03`, `03/11/2026` (day first), `03-11-2026` |
| `type` | yes | `expense` / `income` (also debit, credit) |
| `amount` | yes | `250`, `1,234.50`, `₹1,23,456` |
| `category` | no | any name (default `Other`); for income it is the source |
| `payment_method` | no | `upi`, `cash`, `card`, `bank_transfer` (default `upi`) |
| `description` | no | free text (expenses only) |

Limits: 5,000 rows and 2 MB per import. Importing the same file twice never creates duplicates.

## 4. Where is my data?

`backend\data\expense_tracker.db` (SQLite). It is created automatically on first start.
Back it up by copying the file while the backend is stopped.
Passwords are stored only as salted PBKDF2 hashes; login tokens are stored hashed and expire after 30 days.

## 5. API (for reference)

Interactive docs: `http://localhost:8000/docs`

| Method & path | Purpose |
|---------------|---------|
| `POST /auth/register`, `POST /auth/login` | returns `{token, user}` |
| `GET /auth/me`, `POST /auth/logout` | current user / sign out |
| `GET /dashboard?month=YYYY-MM` | totals, recent items, spending by category |
| `GET /transactions?month=YYYY-MM` | list (income + expenses) |
| `POST /transactions`, `DELETE /transactions/{expense\|income}/{id}` | add / delete |
| `GET /budgets?month=`, `PUT /budgets`, `DELETE /budgets?category=&month=` | budgets |
| `POST /budgets/copy` | copy budgets from one month to another |
| `GET /categories` | default + your custom categories |
| `GET /reports/trend?months=6&end=YYYY-MM` | income/expense per month |
| `GET /export` | all transactions as CSV text |
| `POST /import` | import CSV text `{csv, dry_run, skip_duplicates}` |
| `PUT /auth/password`, `POST /auth/delete-account` | change password / delete account |

All endpoints except register/login need `Authorization: Bearer <token>`.
