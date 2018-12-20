# Steps to upgrade GKE version


1. Prerequisites - The person who is assigned JIRA ticket should have IAM access of target projects in which we have to upgrade cluster.



2. Clone the git repository. 
	  
	  git clone https://github.com/wrsinc/bin.git
      
	  Location of gke.sh file : The file is in bin repository. Path : bin/gke_updates/gke.sh
	


3. cd bin/gke_updates/
	 
	  Edit the file gke.sh and put project name against PROJECTS variable. Below are all the project names

	Pre-production: TBD
       
	       - poc-tier1
           - staging-tier1
           - data-poc-198617
           - data-staging-198617
           - ops-staging-179618
      
    Production: TBD
       
	       - sandbox-tier1
           - production-tier1
           - data-sandbox-198617
           - data-production-198617
           - ops-production

	   

4. Go to "Workload" tab in Kubernetes Engine on GCP console, Check the status of all workloads and also see the status of clusters in Kubernetes Engine (Check status of deployments   in cluster, noting any with Error) 



5. Run the gke script as below
   
      ./gke.sh
   
      It will show both old and new version which is going to be upgrade and the targeted/new version should be noted in Jira

      If cluster version target is newer than lower environment, cancel and move back to lower env upgrade.
	  
	  Then it will ask to continue - press Y and Enter
   
      It will take some time   
   
      If necessary, open console to follow progress for long-running cluster upgrades



6. Upgrading master will happen relatively quickly. Wait for completion and prompt to continue to node pool. Node pools may take several hours. If node pool is larger than 7 nodes, move on to other tasks and intermittently check on progress.



7. We can see status of cluster upgrade on GCP console.     



8. We have to confirm all deployments/pod are in healthy state and showing green..



9. After the completion of deployments, we have to updates below parameters in jira ticket.

      - Previous GKE version
      - Current GKE version
      - Project(s)
      - Cluster(s)
      - Issues, if any

	  

10. If we observe any issue related to deployment on terminal as well as on console, We have to ask in #techops slack channel  
