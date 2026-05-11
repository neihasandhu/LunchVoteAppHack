# Frontend Deployment Instructions

To deploy the frontend manually to Azure App Service:

1.  **Build the project**:
    `ash
    npm install
    npm run build
    `

2.  **Create deployment package**:
    Navigate into the dist folder and zip its contents (ensure files are at the root of the zip):
    `powershell
    cd dist
    Compress-Archive -Path * -DestinationPath ../dist.zip -Force
    cd ..
    `

3.  **Configure App Service (One-time setup)**:
    Disable the default Oryx build process for zip deployments:
    `ash
    az webapp config appsettings set --resource-group rg-lunchvote-nonprod --name app-lunchvote-spa-nonprod-cfmkd6 --settings SCM_DO_BUILD_DURING_DEPLOYMENT=false
    `

4.  **Deploy**:
    `ash
    az webapp deploy --resource-group rg-lunchvote-nonprod --name app-lunchvote-spa-nonprod-cfmkd6 --src-path dist.zip --type zip
    `

Note: Replace cfmkd6 with your actual random suffix if different.
