#!/bin/bash

# ==========================================
#   Voila Notebook Launcher (Crash_Daddy)
# ==========================================

ENV_DIR="$(dirname "$0")/crash_daddy"
PYTHON_EXE="$ENV_DIR/bin/python"

if [ ! -x "$PYTHON_EXE" ]; then
  echo "[ERROR] Python not found in crash_daddy environment!"
  exit 1
fi

echo
echo "=========================================="
echo "       Voila Notebook Launcher"
echo "=========================================="
echo

# --- Re-register Jupyter kernel to fix stale paths ---
echo "Checking Jupyter kernel registration..."
if ! "$PYTHON_EXE" -m jupyter kernelspec list | grep -q crash_daddy; then
  echo "Kernel not found. Registering crash_daddy kernel..."
  "$PYTHON_EXE" -m ipykernel install --user --name crash_daddy --display-name "Python (crash_daddy)"
else
  echo "Refreshing kernel spec to ensure correct Python path..."
  jupyter kernelspec remove crash_daddy -f >/dev/null 2>&1
  "$PYTHON_EXE" -m ipykernel install --user --name crash_daddy --display-name "Python (crash_daddy)"
fi

# --- List notebooks in current folder ---
echo "Available notebooks:"
count=0
declare -A notebooks
for f in *.ipynb; do
  if [ -f "$f" ]; then
    count=$((count + 1))
    notebooks[$count]="$f"
    echo "$count. $f"
  fi
done

if [ "$count" -eq 0 ]; then
  echo "No notebooks found in this folder."
  exit 1
fi

echo
read -p "Select a notebook number to launch: " choice
selected="${notebooks[$choice]}"

if [ -z "$selected" ]; then
  echo "Invalid choice."
  exit 1
fi

echo
echo "You selected: $selected"

# --- Default port ---
PORT=8866

# --- Check if default port is in use ---
if lsof -i :$PORT >/dev/null 2>&1; then
  echo "Port $PORT is already in use. Finding another port..."
  PORT=$((1025 + RANDOM % 50000))
fi

URL="http://localhost:$PORT"

echo
echo "------------------------------------------"
echo "Launching Voila Dashboard:"
echo "    $selected"
echo "Accessible at:"
echo "    $URL"
echo "------------------------------------------"
echo

# --- Launch Voilà ---
# Optional: add --static-path=static if you have a favicon.ico in a 'static' folder
"$PYTHON_EXE" -m voila "$selected" --port="$PORT" --strip_sources=True

if [ $? -ne 0 ]; then
  echo
  echo "[ERROR] Voila failed to start."
  echo "Please ensure crash_daddy was unpacked correctly."
fi