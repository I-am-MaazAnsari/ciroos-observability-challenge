\# Troubleshooting Guide



This document captures issues encountered during the implementation of the project and the steps taken to resolve them.



\---



\## Issue 1: Deployment Not Found



\### Problem



The following command returned no resources:



```bash

kubectl get deployment -n demo

```



Output:



```

No resources found in demo namespace.

```



\### Root Cause



The application had been deployed to the \*\*nginx\*\* namespace while the command was executed against the \*\*demo\*\* namespace.



\### Resolution



Verified the correct namespace:



```bash

kubectl get namespaces

kubectl get all -n nginx

```



Updated all commands and documentation to use the correct namespace.



\---



\## Issue 2: Screenshots Not Added to Git



\### Problem



Screenshots were present locally but did not appear in GitHub.



\### Root Cause



The `.gitignore` file contained:



```text

\*.png

\*.jpg

```



which prevented image files from being tracked.



\### Resolution



Force-added the screenshots:



```bash

git add -f screenshots/\*

```



Committed and pushed the changes successfully.



\---



\## Issue 3: Argo CD Did Not Reflect Changes Immediately



\### Problem



Application changes were not immediately visible after pushing commits.



\### Root Cause



Argo CD was still reconciling the latest Git commit.



\### Resolution



Verified application synchronization in the Argo CD UI and confirmed:



\- Application Health: Healthy

\- Sync Status: Synced



The application automatically reconciled after synchronization.



\---



\## Issue 4: Verifying Monitoring



\### Problem



Needed to verify whether Prometheus was collecting metrics successfully.



\### Resolution



Executed the Prometheus query:



```promql

up

```



All monitored targets returned a value of `1`, confirming successful metric collection.

