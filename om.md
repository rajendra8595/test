***How to add runbook to onemarket docs***


*1. To get runbooks in **docs.one.market**, need to update below yml file*

  https://github.com/wrsinc/omdocs/blob/master/mkdocs.yml


#2. git clone https://github.com/wrsinc/omdocs.git

  Username:

  Password:

  ls

  cd omdocs/

  vim mkdocs.yml

  `Update new runbook details under **"Tier One"** in required format`

  git status

  git add mkdocs.yml

  git commit -m "[POT-XXXX] Update mdocs file"


#3. Update new runbook details under **"Level One"** in below format

  e.g.

  - Level One:

     - Granting IAM Permissions: ops/runbooks/talentica/grantingiam.md

     - Talentica: ops/runbooks/talentica/talentica.md

     - Troubleshooting Builds: ops/runbooks/talentica/troubleshooting_jenkins.md


#4. Add all runbooks in alphabetical order


#5. Create new PR for this & review it from prodeng

  https://github.com/wrsinc/omdocs/blob/master/docs/ops/runbooks/talentica/createpr.md


#6. When it's approved from prodeng, we can merge this PR


#7. Verify the following are rendering properly in **docs.one.market**

  - Changes/Addition/Deletions

  - New Documentation reflected accurately in YML (e.g. Syntax, Location, etc)
