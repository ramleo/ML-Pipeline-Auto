#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────
#  ML Pipeline Template — One-command Docker launcher
#  Usage: ./run.sh
#
#  Builds the Docker image (once) and runs the interactive setup.
#  Generated projects land in ./output/ on your host machine.
# ──────────────────────────────────────────────────────────────────
set -e

IMAGE="ml-pipeline-auto"
OUTPUT_DIR="$(pwd)/output"

# Check Docker daemon is reachable before doing anything
if ! docker info > /dev/null 2>&1; then
  echo ""
  echo "ERROR: Docker is not running."
  echo ""
  echo "  Fix:"
  echo "    1. Open Docker Desktop from your Applications folder"
  echo "       (or: open -a Docker)"
  echo "    2. Wait for the whale icon in the menu bar to stop animating (~30-60s)"
  echo "    3. Re-run:  ./run.sh"
  echo ""
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo ""
echo "Building Docker image (first run takes a few minutes — cached after that)..."
docker build -f Dockerfile.bootstrap -t "$IMAGE" .

echo ""
echo "Starting ML Pipeline..."
docker run --rm -it \
  -p 8000:8000 \
  -v "$OUTPUT_DIR":/output \
  -v "$HOME/.config/gh":/root/.config/gh:ro \
  "$IMAGE"

echo ""
echo "Project saved to: $OUTPUT_DIR"
