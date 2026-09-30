# Lab 2 - Kubernetes runbook. Run from the folder that contains app/ and k8s/
# Usage:  powershell -ExecutionPolicy Bypass -File .\run-k8s-tasks.ps1
# Each figure: the commands run, then the script waits so you can press Win+Shift+S,
# capture the terminal, and paste it into the matching box in the Word document.

function Fig($doc, $n, $note) {
    Write-Host ""
    Write-Host ">>> TAKE SCREENSHOT: $doc - Figure $n" -ForegroundColor Yellow
    Write-Host "    $note" -ForegroundColor Yellow
    Read-Host "    Press Enter when captured" | Out-Null
}
function Run($cmd) {
    Write-Host "PS> $cmd" -ForegroundColor Cyan
    Invoke-Expression $cmd
}

Write-Host "=== TASK 5: Deploy to Kubernetes ===" -ForegroundColor Green
Run "minikube start --driver=docker"
Run "minikube status"
Run "kubectl cluster-info"
Run "kubectl get nodes"
Fig "Task-5" 1 "Node STATUS = Ready"

Run "minikube image load lab2-python-app:1.0"
Run "minikube image ls"
Fig "Task-5" 2 "lab2-python-app:1.0 in the list"

Run "kubectl apply -f k8s/"
Run "kubectl rollout status deployment/lab2-app"
Fig "Task-5" 3 "created + successfully rolled out"

Run "kubectl get deployments"
Run "kubectl get pods -o wide"
Run "kubectl get svc lab2-app-svc"
Run "kubectl get endpoints lab2-app-svc"
Fig "Task-5" 4 "3/3 ready, 3 pods Running, NodePort, 3 endpoints"

Write-Host "Opening tunnel in a new window - leave it open. Copy the URL it prints." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit","-Command","minikube service lab2-app-svc --url"
$url = Read-Host "Paste the URL (e.g. http://127.0.0.1:54321)"
Run "curl.exe -s $url/"
Run "curl.exe -s $url/health"
Fig "Task-5" 5 "Include the tunnel window if you can (URL) + JSON output"

Write-Host "=== TASK 6: Rolling update, rollback, scaling ===" -ForegroundColor Green
Run "kubectl get deployment lab2-app -o wide"
Run "kubectl describe deployment lab2-app | Select-String 'StrategyType|RollingUpdateStrategy'"
Run "kubectl rollout history deployment/lab2-app"
Fig "Task-6" 1 "RollingUpdate, 0 max unavailable, 1 max surge"

Write-Host "Now edit the greeting message in app\app.py and save." -ForegroundColor Yellow
Read-Host "Press Enter when edited" | Out-Null
Run "docker build -t lab2-python-app:2.0 ./app"
Run "minikube image load lab2-python-app:2.0"
Start-Process powershell -ArgumentList "-NoExit","-Command","kubectl get pods -w"
Start-Sleep 2
Run "kubectl set image deployment/lab2-app lab2-app=lab2-python-app:2.0"
Run "kubectl annotate deployment/lab2-app kubernetes.io/change-cause='Update to version 2.0' --overwrite"
Run "kubectl rollout status deployment/lab2-app"
Run "kubectl rollout history deployment/lab2-app"
Fig "Task-6" 2 "Capture BOTH windows: the pods -w watch and this one"

Run "kubectl set image deployment/lab2-app lab2-app=lab2-python-app:99.0"
Start-Sleep 20
Run "kubectl get pods"
Fig "Task-6" 3 "One pod ErrImagePull/ImagePullBackOff, others Running"

Run "kubectl rollout undo deployment/lab2-app"
Run "kubectl rollout status deployment/lab2-app"
Run "kubectl rollout history deployment/lab2-app"
Run "kubectl get deployment lab2-app -o jsonpath='{.spec.template.spec.containers[0].image}'"
Run "kubectl get pods"
Fig "Task-6" 4 "Image is back to a good version, pods Running"

Run "kubectl scale deployment lab2-app --replicas=5"
Start-Sleep 8
Run "kubectl get deployment lab2-app"
Run "kubectl get pods"
Fig "Task-6" 5 "5/5 ready"
Run "kubectl scale deployment lab2-app --replicas=2"
Run "kubectl get pods"
Fig "Task-6" 5 "(same figure) after scaling down - optional second capture"
Run "kubectl scale deployment lab2-app --replicas=3"

1..6 | ForEach-Object { curl.exe -s "$url/" ; "" }
Fig "Task-6" 6 "Different hostname values in the responses"

Write-Host "=== TASK 8 (report) extras ===" -ForegroundColor Green
Run "docker --version"
Run "minikube version"
Run "kubectl version --client"
Fig "Task-8" 1 "Tool versions"
Run "kubectl get deployments,pods,svc"
Fig "Task-8" 4 "Running state"
Run "kubectl rollout history deployment/lab2-app"
Fig "Task-8" 5 "Revision history"
Run "kubectl scale deployment lab2-app --replicas=5"
Start-Sleep 8
Run "kubectl get pods"
Fig "Task-8" 6 "5 pods Running"
Run "kubectl scale deployment lab2-app --replicas=3"

Write-Host ""
Write-Host "Done. CD screenshots (Task 7 and Task-8 Figure 7) come from the GitHub Actions page after you push." -ForegroundColor Green
