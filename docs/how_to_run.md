# How to Run the ML Pipeline Template

---

## Prerequisites

### Docker (recommended — nothing else required)

| Tool | How |
|---|---|
| Docker | [docker.com](https://docker.com) |
| GitHub CLI *(optional, for auto-push)* | `brew install gh` then `gh auth login` |

### Without Docker (macOS / Linux)

| Tool | How |
|---|---|
| Python 3.9+ | [python.org](https://python.org) |
| Homebrew *(macOS)* | **Auto-installed** by `./start.sh` |
| libomp *(macOS, for LightGBM)* | **Auto-installed** by `./start.sh` |
| GitHub CLI *(optional)* | `brew install gh` then `gh auth login` |

---

## Method 1 — Docker (recommended)

```bash
git clone https://github.com/ramleo/builds_bootstrap
cd builds_bootstrap
./run.sh
```

`run.sh` builds the Docker image on first run (cached after that) and launches the setup wizard.
Your generated project appears in `./output/` on your host machine.

**What Docker gives you:**
- Python 3.11 (pinned — no version conflicts)
- LightGBM, XGBoost, CatBoost pre-installed (no compilation, no `libomp` errors)
- Works identically on Mac, Linux, Windows
- Your host machine is untouched

---

## Method 2 — Git Clone (host install)

```bash
git clone https://github.com/ramleo/builds_bootstrap
cd builds_bootstrap
./start.sh
```

`start.sh` checks and auto-installs missing dependencies (Homebrew, libomp), then runs the wizard using your system Python.

---

## Method 3 — Bootstrap (no git required)

```bash
curl -O https://raw.githubusercontent.com/ramleo/builds_bootstrap/main/bootstrap.py
python3 bootstrap.py
```

Downloads a single installer file and runs the same wizard.

---

## Step 1 — Answer the setup prompts

| Prompt | Example answer |
|---|---|
| Entry mode | `1` (Shell wizard) or `2` (Python CLI) |
| Project name | `titanic-predictor` |
| Dataset CSV path | `/Users/yourname/Downloads/titanic.csv` |
| Target column name | `Survived` (press Enter to auto-detect) |
| Deployment platform | `2` for Render, or `1` to decide later |
| GitHub username | `your-github-username` (press Enter to skip) |
| GitHub repo name | `titanic-predictor` (defaults to project name) |
| Repo visibility | `1` for Public, `2` for Private |

**You do not need to move your CSV beforehand.** Type its full path — the script copies it into `data/` automatically.

---

## Step 2 — Pipeline runs automatically

After the prompts, `auto_pipeline.py` starts immediately — no further input needed:

```
Step 1  Load config + dataset
Step 2  EDA — profile data, correlation heatmap, target distribution
Step 3  Preprocessing — impute, encode, scale
Step 4  Train candidates:
          Classification: LogisticRegression, RandomForest, GradientBoosting,
                          LightGBM, XGBoost, CatBoost
          Regression:     Ridge, RandomForest, GradientBoosting,
                          LightGBM, XGBoost, CatBoost
Step 5  GridSearchCV tuning → best model selected
Step 6  Evaluate (accuracy/F1  or  RMSE/R²)
Step 7  Save model artifacts (.pkl)
Step 8  Generate FastAPI app + auto-themed index.html
Step 9  Generate Dockerfile
Step 10 Push to GitHub (if configured)
Step 11 Deploy to chosen platform
```

---

## Step 3 — Post-pipeline deploy menu

After training completes, a menu appears:

```
What would you like to do next?
  1) Generate FastAPI app + Dockerfile + themed frontend
  2) Push to GitHub
  3) Deploy to Render
  4) All of the above  ← recommended
  5) Done — I'll handle it myself
```

Choose **4** to generate the app, push to GitHub, and configure Render in one go.

---

## Folder layout after the pipeline

```
output/my-project_20260531_120000/
├── .venv/                  ← Python virtual environment
├── .ml_config.json         ← your choices (dataset, platform, GitHub)
├── data/                   ← your CSV file
├── models/                 ← trained pipeline artifacts (.pkl)
├── plots/                  ← EDA charts (.png)
├── src/preprocess.py
├── tests/test_pipeline.py
├── docs/
├── app.py                  ← FastAPI prediction API
├── index.html              ← auto-themed prediction UI
├── Dockerfile
├── requirements.txt
└── render.yaml / fly.toml / railway.toml / apprunner.yaml
```

---

## Running the End-to-End Test Suite

```bash
# Fast mode — skips Docker suite (~5 min)
python3 tests/run_e2e.py --fast

# Full run including Docker build (~10 min)
python3 tests/run_e2e.py

# Single suite only
python3 tests/run_e2e.py --suite 1   # bootstrap & project creation
python3 tests/run_e2e.py --suite 2   # pipeline artifacts
python3 tests/run_e2e.py --suite 3   # app.py & Dockerfile content
python3 tests/run_e2e.py --suite 4   # live API (uvicorn)
python3 tests/run_e2e.py --suite 5   # Docker smoke tests
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `python3: command not found` | Install Python 3.9+ from [python.org](https://python.org) |
| `lightgbm` build fails / `libomp` missing | Use `./run.sh` (Docker), or on macOS: `brew install libomp` |
| `Permission denied: ./start.sh` | `chmod +x start.sh` |
| `Permission denied: ./run.sh` | `chmod +x run.sh` |
| Dataset not found | Copy your `.csv` into `data/`, then re-run `python3 auto_pipeline.py` |
| GitHub push fails | `gh auth login` first |
| `builds_bootstrap/` already exists | Rename the existing folder before re-cloning |
| Homebrew install hangs | Accept the Xcode Command Line Tools prompt |
| pip install fails | Check Python version — requires 3.9+ |
| `Cannot connect to the Docker daemon` | Docker Desktop is not running — open it from Applications (or `open -a Docker`), wait for the whale icon to stop animating, then re-run `./run.sh` |
| Docker image takes long to build | Normal on first run (~5 min); cached on repeat runs |
| Projects not appearing in `./output/` | Run `./run.sh` from inside the `builds_bootstrap/` folder |
