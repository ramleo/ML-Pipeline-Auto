# ML-Pipeline-Auto

> End-to-end machine learning automation — no Claude, no AI subscription required.
> Bring your CSV. The pipeline handles everything: training, API, Docker image, and deployment.

📖 **Full usage guide:** [docs/how_to_run.md](docs/how_to_run.md)

---

## What This Template Does

- 🔍 **Auto-detects** task type (classification vs regression) from your data
- 🧹 **Preprocesses** data: missing values, encoding, scaling
- 🏆 **Trains & tunes** multiple models with GridSearchCV (sklearn, LightGBM, XGBoost, CatBoost)
- 📊 **Evaluates** with classification report / RMSE + R²
- 🌐 **Wraps** the best model in a FastAPI REST API (`/predict`, `/predict/batch`)
- 🎨 **Auto-generates a themed prediction UI** — design matches your dataset domain
- 🔢 **Feature ranges** fetched via web search with p5-p95 dataset fallback
- 📋 **Categorical dropdowns** auto-populated from dataset unique values
- ✅ **Inline validation** — red border + error message for out-of-range numeric inputs
- 🐳 **Containerises** with a multi-stage Docker image
- 🚀 **Deploys** to your chosen cloud platform
- 📄 **Documents** everything in `docs/`

---

## Prerequisites

### Docker (recommended — nothing else required)

| Tool | How |
|---|---|
| Docker | [docker.com](https://docker.com) |
| GitHub CLI *(optional, for auto-push)* | `brew install gh` then `gh auth login` |

### Without Docker (host install)

| Tool | How |
|---|---|
| Python 3.9+ | [python.org](https://python.org) |
| Homebrew *(macOS)* | **Auto-installed** by `./start.sh` |
| libomp *(macOS, for XGBoost/LightGBM)* | **Auto-installed** by `./start.sh` |
| GitHub CLI *(optional)* | `brew install gh` then `gh auth login` |

---

## Quickstart

### 🐳 Docker — recommended (platform independent, nothing to install)

```bash
git clone https://github.com/ramleo/ML-Pipeline-Auto
cd ML-Pipeline-Auto
./run.sh
```

`run.sh` builds the image once (cached on repeat runs) and launches the interactive wizard.
Your generated project appears in `./output/` on your host machine.

### 💻 Without Docker (macOS / Linux)

```bash
git clone https://github.com/ramleo/ML-Pipeline-Auto
cd ML-Pipeline-Auto
./start.sh
```

`start.sh` checks and installs missing dependencies (Homebrew, libomp), then runs the same wizard.

### Bootstrap (no git required)

```bash
curl -O https://raw.githubusercontent.com/ramleo/ML-Pipeline-Auto/main/bootstrap.py
python3 bootstrap.py
```

---

## The Wizard

After running `./run.sh` or `./start.sh`, you answer five questions:

```
Project name         → my-insurance-model
Dataset CSV path     → /path/to/Insurance.csv
Target column        → charges   (required — no auto-detect)
Deployment platform  → Render / Fly.io / Railway / AWS / GCP / Azure / Skip
GitHub repo          → ramleo/my-insurance-model (optional)
```

Then everything runs automatically — no more prompts.

---

## What Runs Automatically

```
Setup wizard (./start.sh)
  ↓
auto_pipeline.py
  ├─ Step 1  Load config
  ├─ Step 2  EDA & data inspection
  ├─ Step 3  Preprocessing (impute, encode, scale)
  ├─ Step 4  Train candidates: LR/Ridge, RandomForest, GradientBoosting,
  │          LightGBM, XGBoost, CatBoost
  ├─ Step 5  GridSearchCV tuning → best model selected
  ├─ Step 6  Evaluate (accuracy/F1 or RMSE/R²)
  ├─ Step 7  Save model artifacts (.pkl) + feature_ranges.json
  ├─ Step 8  Generate FastAPI app + themed index.html
  ├─ Step 9  Generate Dockerfile
  ├─ Step 10 Push to GitHub (if configured)
  └─ Step 11 Deploy to chosen platform
```

---

## What Gets Created

```
output/my-insurance-model_20260601_120000/
├── .venv/                      ← isolated Python environment
├── .ml_config.json             ← your choices (dataset, platform, etc.)
├── .gitignore
├── data/                       ← your CSV
├── models/                     ← trained pipeline (.pkl) + feature_ranges.json
├── plots/                      ← EDA charts (.png)
├── src/preprocess.py
├── tests/test_pipeline.py
├── docs/
├── app.py                      ← FastAPI app (serves index.html at GET /)
├── index.html                  ← auto-themed prediction UI with dropdowns + validation
├── Dockerfile
├── requirements.txt
└── render.yaml / fly.toml / railway.toml / apprunner.yaml
```

---

## Models Trained

| Library | Classification | Regression | Notes |
|---|---|---|---|
| scikit-learn | LogisticRegression, RandomForest, GradientBoosting | Ridge, RandomForest, GradientBoosting | Always available |
| LightGBM | LGBMClassifier | LGBMRegressor | Skipped gracefully if missing |
| XGBoost | XGBClassifier | XGBRegressor | Skipped gracefully if missing |
| CatBoost | CatBoostClassifier | CatBoostRegressor | Skipped gracefully if missing |

All boosters are pre-installed in the Docker image and included in `requirements.txt` for host installs.

---

## Supported Deployment Platforms

| Platform | Free Tier | Config File |
|---|---|---|
| Render | ✅ | `render.yaml` |
| Fly.io | ✅ | `fly.toml` |
| Railway | ✅ | `railway.toml` |
| AWS App Runner | ✅ (free tier) | `apprunner.yaml` |
| GCP Cloud Run | ✅ (free tier) | — |
| Azure Container Apps | ✅ (free tier) | — |

---

## ML Tasks Supported

| Task | Target Column | Metrics |
|---|---|---|
| Classification | Categorical / ≤ 20 unique values | Accuracy, F1, Classification Report |
| Regression | Numeric / > 20 unique values | RMSE, MAE, R² |

Task type is **auto-detected** from your target column. Target column is **always required** — no auto-detect fallback.

---

## Auto-Themed Frontend

The generated `index.html` prediction UI is automatically matched to your dataset domain:

| Dataset domain | Theme |
|---|---|
| 🩺 Health / Medical | Deep teal gradient |
| ✈️ Travel / Airline | Navy blue gradient |
| 💰 Finance / Banking | Dark blue + gold |
| 🚢 Shipping / Logistics | Ocean blue + steel |
| 🏠 Real Estate | Brown + red |
| 👤 HR / People | Purple gradient |
| 🍷 Quality | Burgundy gradient |
| ⚓ Maritime | Ocean blue |
| 🛒 Retail | Orange gradient |
| ⚡ Energy | Amber gradient |
| 🤖 Generic | Midnight blue (unique hue derived from column names) |

**New in ML-Pipeline-Auto:**
- Categorical feature fields render as `<select>` dropdowns populated from dataset unique values
- Numeric fields show a red border + "Expected X – Y" hint on blur if value is out of range
- Feature ranges sourced from web search (DuckDuckGo) with p5–p95 percentile fallback

---

## File Reference

| File | Purpose |
|---|---|
| `run.sh` | One-command Docker build + run |
| `start.sh` | Host (non-Docker) entry point |
| `auto_pipeline.py` | Full ML pipeline — pure Python, no AI required |
| `init.py` | Python CLI alternative to `start.sh` |
| `bootstrap.py` | Single-file installer (no git required) |
| `Dockerfile.bootstrap` | Docker image definition |
| `.dockerignore` | Keeps build context lean |
| `requirements.txt` | All Python dependencies (including boosters) |
| `docs/how_to_run.md` | Step-by-step usage guide |

---

## Roadmap

Items 1–6 complete. Items 7–20 are scoped for future iterations:

| # | Feature | Status |
|---|---|---|
| 1 | Pydantic v2 Field(alias) for spaced column names | ✅ Done |
| 2 | Web search feature ranges (DuckDuckGo + p5-p95 fallback) | ✅ Done |
| 3 | Categorical dropdowns from dataset unique values | ✅ Done |
| 4 | Inline range validation (red border + error on blur) | ✅ Done |
| 5 | libomp auto-install (macOS/Linux/Windows) | ✅ Done |
| 6 | Target column always required (no auto-detect fallback) | ✅ Done |
| 7-17 | Portfolio website with model cards | Pending |
| 18 | CI/CD GitHub Actions workflow | Pending |
| 19 | Playwright UI smoke tests | Pending |
| 20 | One-click model retraining endpoint | Pending |

---

## Share with Someone

> Drop your CSV anywhere, then run:
> ```bash
> git clone https://github.com/ramleo/ML-Pipeline-Auto && cd ML-Pipeline-Auto && ./run.sh
> ```
> Answer five prompts (project name, CSV path, **target column**, platform, GitHub).
> Everything else runs automatically. No AI subscription needed.

---

## License

MIT — free to use, modify, and distribute.