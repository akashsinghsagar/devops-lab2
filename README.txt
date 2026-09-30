SETUP
1. Copy k8s/ and .github/ into your repo (next to app/).
   Note: k8s/deployment.yaml and the workflow assume the image is lab2-python-app and the
   Dockerfile is in app/. Adjust if yours differs.
2. Docker Desktop and Minikube must be running.
3. From the repo root:  powershell -ExecutionPolicy Bypass -File .\run-k8s-tasks.ps1
4. At each yellow prompt press Win+Shift+S, capture the terminal, paste into the
   matching box in the Word file, then press Enter.

TASK 7 (CD) - after the scripts:
   git add .github k8s
   git commit -m "Add Kubernetes CD workflow"
   git push origin main
   Screenshot the Actions tab (Figures 1-3), then edit app/app.py, push again for Figure 4.
   For Task-8 Figure 7 reuse a successful Actions run screenshot.
