- [Problem to Be Solved](task_github.md#problem-to-be-solved-in-this-lab)
  * [Explanation of the Solution](task_github.md#explanation-of-the-solution)
  * [PRE-REQUISITES](task_github.md#pre-requisites)
- [Creating GitHub resources](task_github.md#creating-github-resources)
  * [TASK 1 - Create GitHub Organization settings](task_github.md#task-1---create-github-organization-settings)
  * [TASK 2 - Create an organization secret](task_github.md#task-2---create-an-organization-secret)
  * [TASK 3 - Create teams and memberships](task_github.md#task-3---create-teams-and-memberships)
  * [TASK 4 - Create a security manager](task_github.md#task-4---create-a-security-manager)
  * [TASK 5 - Create a Private Repository](task_github.md#task-5---create-a-private-repository)
  * [TASK 6 - Form TF Output](task_github.md#task-6---form-tf-output)
  * [TASK 7 - Configure a remote data source](task_github.md#task-7---configure-a-remote-data-source)
  * [TASK 8 - Create a Secure Public Repository](task_github.md#task-8---create-secure-public-repositories)
- [Working with Terraform state](task_github.md#working-with-terraform-state)
  * [TASK 9 - Move resources](task_github.md#task-9---move-resources)
  * [TASK 10 - Move state to Postgres database](task_github.md#task-10---move-state-to-postgres-database)
  * [TASK 11 - Import resources](task_github.md#task-11---import-resources)
- [Configuring GitHub Actions](task_github.md#configuring-github-Actions)
  * [TASK 12 - Use data discovery](task_github.md#task-12---use-data-discovery)
  * [TASK 13 - Configuring GitHub Action Workflow](task_github.md#task-13---configuring-github-action-workflow)
- [Advanced tasks](task_github.md#advanced-tasks)
  * [TASK 14 - Create dynamically manageable resources](task_github.md#task-14---create-dynamically-manageable-resources)
  * [TASK 15 - Modules](task_github.md#task-15---modules)
  


# Problem to Be Solved in This Lab
This lab shows you how to use Terraform to configure an organization, members, teams, and repositories in GitHub. This task is binding to real production needs – for instance, the DevOps team centrally manages the state of the GitHub repositories within their organization.

 
### Explanation of the Solution
You will use Terraform with the GitHub provider to create 2 separate Terraform configurations:
 1) Base configuration
 2) Repos configuration
After you’ve created the configuration, we will work on its optimization like using a data-driven approach and creating modules.

As a result, at the end of this lab, you will get a managed by terraform GitHub organization shown in the image below.
![alt text](images/lab_diagram.png)

## PRE-REQUISITES
1. Fork current repository. A fork is a copy of a project and this allows you to make changes without affecting the original project.
2. Create a GitHub organization [refer to this document](https://docs.github.com/ru/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch). Choose a name you find appealing, like `epam-tf-lab-{StudentSurname}`.
  
    For example, `epam-tf-lab-skywalker`.

3. Create a classic personal access token with full access [refer to this document](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
4. All actions should be done under your fork and Terraform gets it context from your local clone working directory: 
    - Change current directory to `/tf-epam-lab/non_cloud_task/github/base` folder and create files `root.tf` and `variables.tf`.
    - In the `variables.tf` create variable `gh_token` without default value. To prevent providing GitHub token on each configuration run and staying secure set binding environment variable:
        ```bash
        export TF_VAR_gh_token={CREATED_PERSONAL_GITHUB_TOKEN}
        ```
    <b><mark>**NOTE**: NEVER store the value of the GitHub token in the repository code.</b></mark>
    - Add a `terraform {}` empty block to the file `root.tf`. In the same file create an GitHub provider block with the following attributes: 
        - `owner = "{organization_name}"`
        - `token = "var.gh_token"`.

    Run `terraform init` to initialize your configuration. 
    Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
    Run `terraform plan` to ensure that there are no changes.

    Please use **underscore** Terraform resources naming, e.g. `my_resource` instead of `my-resource`.

5. Create directory `/tf-epam-lab/non_cloud_task/github/repos`, change current directory  to `/tf-epam-lab/non_cloud_task/github/repos` and repeat the steps in [2].
6. Install docker on your laptop.

You are ready for the lab!

# Creating GitHub resources

## TASK 1 - Create GitHub Organization settings
Change current directory  to `/tf-epam-lab/non_cloud_task/github/base`

Create an organization settings resource with attributes:

-	`billing_email`: `{Student github account email}`
-	`company`: `{Organization Name}`
-	`description`: `{StudentName} {StudentSurname} organization for EPAM Terraform Lab`
-	`default_repository_permission`: `"read"`
-	`members_can_create_repositories`: `false`
-	`members_can_create_public_repositories`: `false`
-	`members_can_create_private_repositories`: `false`
-	`members_can_create_internal_repositories`: `false`
-	`members_can_create_pages`: `false`
-	`members_can_create_public_pages`: `false`
-	`members_can_create_private_pages`: `false`
-	`members_can_fork_private_repositories`: `false`
-	`web_commit_signoff_required`: `true`
-	`dependabot_alerts_enabled_for_new_repositories`: `true`
-	`dependabot_security_updates_enabled_for_new_repositories`: `true`
-	`dependency_graph_enabled_for_new_repositories`: `true`
- `advanced_security_enabled_for_new_repositories`: `false`

**Hint**: A local value assigns a name to an expression, so you can use it multiple times within a module without repeating it. 

Store all resources from this task in the `settings.tf` file.
Store all locals in `locals.tf`.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub organization is configured as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 2 - Create an organization secret

The target of this task is to create a GitHub organization secret.

The purpose of a GitHub secret is to securely store and manage sensitive information, such as authentication tokens, encryption keys, and other confidential data, that is needed to use in your GitHub Actions workflows or other integrations. This helps to keep sensitive information secure and avoid exposing it in open source code or in logs.

Ensure that the current directory is `/tf-epam-lab/non_cloud_task/github/base`

- Create empty variables `username` and `password` but with the following descriptions `Dummy API username` and `Dummy API password`. <br><b><mark>Never store you secrets inside the code!</b></mark>
- Create a `secrets.tf` file with `github_actions_organization_secret` resources (`visibility="selected"`). Use `username` and `passwords` variables as secret value sources.
- Run `terraform plan` and provide required public key. Observe the output and run `terraform plan` again.
- To prevent providing read only token on each configuration run and staying secure set binding environment variable - `export TF_VAR_username="kminchelle"`,
`export TF_VAR_password="0lelplR"`.
- Run `terraform plan` and observe the output.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.

Apply your changes when ready.

**Note:** Actually, the data for these secrets are used for [lab_rest_api](lab_rest_api). So, they are fake secrets. These secrets will be used later in the one of the folowing tasks.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub organization secret is configured as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 3 - Create teams and memberships

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create a team and team's members for your GitHub organization:

-	Create `members.tf`.
- Create an organization team (`name="devops-team"`, `privacy="secret"`)
- Create an organization team (`name="nodejs-team"`, `privacy="secret"`)
-	Create 1 member (`role="member"`) and add this member to one of the the teams.

**Hint**: Use your colleagues' GitHub account username as a member in terms of this lab.

**Hint**: [The API no longer supports working with the new set of Projects](https://stackoverflow.com/questions/73268885/unable-to-create-project-in-repository-or-organisation-using-github-rest-api); it only supports classic projects. Since classic projects cannot be created in GitHub anymore, you should either use [GraphQL](https://docs.github.com/en/graphql/reference/mutations) or create them manually.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub teams and members resources created as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 4 - Create a security manager

The purpose of this task is to create a security manager for the created GitHub organization.

GitHub Security Managers is a feature in GitHub that allows an organization to designate specific people as security managers. Security managers have the ability to manage security alerts, perform security triage, and dismiss false positives. This helps organizations to streamline their security processes, ensuring that security issues are addressed efficiently and effectively. Security Managers can be assigned to specific repositories or across an entire organization, providing greater flexibility and control over security management.

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create a GitHub organization project resource with attributes:
-   Create add a new team resource (`name="security-team"`, `privacy="closed"`).
-   Create add a new security manager for the organization and assign to the created team.

Store all resources from this task in the `security.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub team and security manager assignment are created as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 5 - Create a Private Repository
Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create the following repository with attributes:
- `name`: `"tf-lab-devops"`
- `description`: `"{StudentName} {StudentSurname}, TF EPAM lab repository for DevOps team"`
- `vulnerability_alerts`: `true`
- `visibility`: `"private"`

Store all resources from this task in the `base_repository.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying  your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub repository is created as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 6 - Form TF Output
Ensure that current directory is `/tf-epam-lab/non_cloud_task/github/base`

Create outputs for your configuration:

- Create `outputs.tf` file.
- Following outputs are required: `organization_id`, `teams_ids` [set of strings], `security_manager_team_slug` (name), `secret_names`[set of strings], `base_repository_name` (name).

Store all resources from this task in the `outputs.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready. You can update outputs without using `terraform apply` - just use the `terraform refresh` command.

### Definition of DONE:

- Push *.tf configuration files to git

## TASK 7 - Configure a remote data source

Learn about [terraform remote state data source](https://www.terraform.io/docs/language/state/remote-state-data.html).

! Change the current directory to  `/tf-epam-lab/non_cloud_task/github/repos`
! Copy `root.tf` from `/tf-epam-lab/non_cloud_task/github/base` to `/tf-epam-lab/non_cloud_task/github/repos`

Add remote state resources to your configuration to be able to import output resources:

-	Create a data resource for base remote state. (backend="local")

Store all resources from this task in the `data.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Push *.tf configuration files to git

## TASK 8 - Create Secure Public Repositories

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/repos`

Store all resources from this task in the `repository.tf` file.

- Create a repository resource with attributes:
    - `name=tf-lab-app`
    - `description="TF EPAM lab repository for nodejs app"`,
    - `vulnerability_alerts=true`,
    - `visibility="public"`,
    - `has_issues=true`,
    - `has_projects=true`,
    - `has_wiki=true`,
    - `allow_squash_merge=true`,
    - `allow_merge_commit=true`,
    - `allow_rebase_merge=true`,
    - `delete_branch_on_merge=true`,
    - `auto_init=true`.
- Assign `push` permissions to the repository for `nodejs-team`, `security-team` and `pull` permissions for `devops-team`.
- Create `.github/CODEOWNERS` files with the content using `terraform resource`:
    ```
    * @ORGANIZATION_NAME/SECURITY_TEAM_SLUG
    ```
  
  **INFO**: The purpose of a CODEOWNERS file in GitHub is to specify which users or teams are responsible for reviewing and maintaining specific parts of a repository. When a pull request is created, GitHub uses the information in the CODEOWNERS file to determine who should be requested for review based on the files that were changed. This helps to ensure that changes to code are reviewed by the appropriate people and helps to maintain quality and consistency in the codebase.

Run `terraform validate` and `terraform fmt` to check if your configuration valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub repository is created as expected (check GitHub WebUI)
- `CODEOWNERS` file exists in the repository.
- Push *.tf configuration files to git
    
# Working with Terraform state

**Mandatory**: Please do not proceed to [TASKS  9-15] until your have finished previous tasks. Once completed please remove `.gitlab-ci.yml` from your repository and merge this change. This will disable the proctor checks but store the progress for previous tasks. Proctor cannot access to the resources in non-local state therefore it should be disabled.

In this section, we will delve into Terraform state management and Terraform backends. A backend serves as the repository where Terraform  stores its state files. The default backend is local, meaning that it stores the state file on your local disk. To enable effective collaboration with your colleagues, you should consider utilizing a [remote backend](https://developer.hashicorp.com/terraform/language/settings/backends/remote).

Switching the backend is a straightforward process accomplished by [re-initializing](https://developer.hashicorp.com/terraform/cli/commands/init#backend-initialization) with Terraform.

It's crucial to highlight an important note regarding importing or moving resources between states in the upcoming tasks. Typically, there are several methods for transferring resources between two states:

 1)   Employing the built-in `terraform state mv` command.
 2)   Directly editing state files.
 3)   Using the `terraform import` command.

When migrating a resource block (your code) between configurations, you must simultaneously transfer the data between states. Additionally, there is an [experimantal feature](https://developer.hashicorp.com/terraform/language/import/generating-configuration) available for auto-generating configuration during the import process. However, this is beyond the scope of our current training.

Please note that the `terraform state mv` [1] command exclusively functions with local states. Therefore, if you opt for this method, ensure that you migrate your resources before transitioning to a remote state.

Alternatively, you can copy state files locally and relocate resources using either `terraform state mv`` or inline editing[2]. However, please be aware that inline editing is not a secure option, and you would need to modify the 'serial' counter each time you make changes in the state file.

Finally, you have the option to import an existing resource into a new state using the `terraform state import resource.name resource.id` command[3] and remove it from the old state with `terraform state rm resource.name`.

Any of these options will serve the purpose, but for educational purposes, we have opted for the simplest approach using `terraform state mv` command.

>>>
When working with Terraform in a multiple teams environment, it is common for each team to have their own state file for the resources they are managing. This is because Terraform state is meant to be a shared resource, but it can be difficult to coordinate changes to the state file among multiple teams. Having separate state files for each team can help avoid conflicts and make it easier to manage changes to the infrastructure.

Additionally, having separate state files can help with security and access control. Different teams may have different levels of access to different resources, and having separate state files can help ensure that each team only has access to the resources they need.

In most cases, using separate state files for each team is recommended to help manage complexity and ensure that changes are made in a coordinated and controlled manner.

For this lab, the first state file (`base` folder) belongs to the DevOps team, which manages the global GitHub organization settings, and the second state (`repos` folder) is managed by developers teams which usually work with repositories and their configurations. In the real environment, these state files may be more.
>>>


## TASK 9 - Move resources

Learn about [terraform state mv](https://www.terraform.io/docs/cli/commands/state/mv.html) command

You are going to move (rename) previously created resource.

Hint: The purpose of the `terraform state mv` command in Terraform is to move or rename resources within a Terraform state. This is useful for reorganizing resources within your infrastructure, for example, if you want to rename a resource or move it from one module to another. When you move a resource, Terraform updates the state file to reflect the new location or name of the resource, and generates a plan to update the infrastructure to match the new state. The terraform mv command should be used with care, as it can impact existing infrastructure and potentially result in changes to your environment.

- Change the created GitHub repository `tf-lab-devops` resource name in the configuration file.

  Example:

  From:
  ```
  resource "github_repository" "tf_epam_lab_base_repository" {
    ...
  }
  ```
  To:
  ```
  resource "github_repository" "tf_epam_lab_devops_repository" {
    ...
  }
  ```
- Rename the `github_repository` resource by `terraform state mv` command.
Example:
  ```
  terraform state mv github_repository.tf_epam_lab_base_repository github_repository.tf_epam_lab_devops_repository
  ```

- Run `terraform plan` on both configurations and observe the changes. 

  Hint: there should not be any changes detected (no resource creation or deletion in case of correct resource move).

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style.

### Definition of DONE:

- Terraform moved resources with no errors
- GitHub repository is created as expected (check GitHub WebUI)


## TASK 10 - Move state to Postgres database

Hint: Create a docker container with Postgres databases as a pre-requirement for this task. 
```bash
docker run -d --name pg-state -e POSTGRES_USER=tfstate -e POSTGRES_PASSWORD={YOUR_PASSWORD} -e POSTGRES_MULTIPLE_DATABASES=repos,base -p 5432:5432 gradescope/postgresql-multiple-databases:14.4
```

Learn about [terraform backend in Postgres](https://developer.hashicorp.com/terraform/language/settings/backends/pg)

Postgres state was selected for this lab as a free available backend state. To make postgres backend usage simpler here you need to have docker installed.

Refine your configurations:

- Refine `base` configuration by moving local state to a postgres database.
- Refine `repos` configuration by moving local state to a postgres database.

Hint: configuration for `base` state:
```tf
  backend "pg" {
    conn_str = "postgres://tfstate:{YOUR_PASSWORD}@localhost/base?sslmode=disable"
  }
```

Do not forget to change the path to the remote state for `repos` configuration.

Run `terraform validate` and `terraform fmt` to check if your modules valid and fits to a canonical format and style.
Run `terraform plan` to see your changes and re-apply your changes if needed.

## TASK 11 - Import resources

Learn about the [terraform import](https://www.terraform.io/docs/cli/import/index.html) command.

You are going to import a new resource (repository `tf-lab-spa`) to your state.
Hint: Keep in mind that there are 3 instances: GitHub resource, Terraform state file which store some state of that resource, and Terraform configuration which describe resource. "Importing a resource" is importing its attributes into a Terraform state. Then you have to add said resource to the destination configuration (this action is not automated).

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/repos`. Use file `imported_repository.tf`.

- Create a public GitHub repository in the created GitHub organization via GitHub WebUI (`name="tf-lab-spa"`).
- Add a new resource `github_repository` `tf_epam_lab_spa_repository` to the `repos` configuration.
- Run `terraform plan` to see your changes but do not apply changes.
- Import `tf_epam_lab_spa_repository` repository to the `repos` state.
- Run `terraform plan` again to ensure that import was successful.

**Note**: SPA - Single Page Application

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style.

- Terraform imported resources with no errors
- GitHub resources are NOT changed (check GitHub WebUI)

# Configuring GitHub Actions
## TASK 12 - Use data discovery
Learn about [terraform data sources](https://www.terraform.io/docs/language/data-sources/index.html) and [querying terraform data sources](https://learn.hashicorp.com/tutorials/terraform/data-sources?in=terraform/configuration-language&utm_source=WEBSITE&utm_medium=WEB_BLOG&utm_offer=ARTICLE_PAGE).

In this task we are going to use a data driven approach instead to use remote state data source.

#### base configuration

Change the current directory to `/tf-epam-lab/non_cloud_task/github/base`

Use a data source to request the resource `github_repository`. Use this datasource to request data about the repository which was created in the task 8.

Store all resources from this task in the `data.tf` file.

#### repos configuration
Change the current directory to `/tf-epam-lab/non_cloud_task/github/repos`

Refine your configuration:

- Use a data source to request the following resources: `organization_id`, `organization_teams`.

Hint: These data sources should replace remote state outputs, therefore you can delete `data "terraform_remote_state" "base"` resource from your current state and the `outputs.tf` file from the `base` configuration. **Don't forget to replace references with a new data sources.**
Hint: run `terraform refresh` command under `base` configuration to reflect changes.

Store all resources from this task in the `data.tf` file.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes. Also you can use `terraform refresh`.
If applicable all resources should be defined with the provider alias.

Apply your changes when ready.


## TASK 13 - Configuring GitHub Action Workflow

In this lab we will configure a GitHub action workflow which performs `SCA`, `SAST` and `DAST` checks of the application.

  **INFO**: 
  
  <details closed>
  <summary>
  - <strong>SCA</strong> (Software Composition Analysis) - a process of analyzing software components and their dependencies in order to identify known vulnerablities.
  </summary>
  SCA involves analyzing software dependencies and the third-party components used in an application. The purpose of SCA is to understand and manage the risks associated with using open source and third-party components in their software applications, such as license compliance issues, security vulnerabilities, and potential intellectual property concerns. By identifying and addressing these risks, organizations can improve the overall security and quality of their software applications.
  <br>
  SCA tools typically scan the source code, build files, and dependencies of an application to identify any open source or third-party components that are being used, along with their licenses, security vulnerabilities, and potential risks.
  </details>

  <details closed>
  <summary>
  - <strong>SAST</strong> (Static Application Security Testing) - a type of software testing that is used to identify security vulnerabilities in the source code (not dependencies like SCA) of an application before it is deployed.
  </summary>
  SAST tools analyze the application's source code and identify potential security vulnerabilities, such as SQL injection, cross-site scripting, and buffer overflow attacks. The analysis is done without actually executing the application, which is why it's called "static" testing.
  <br>
  SAST tools work by analyzing the source code of an application and comparing it against a set of predefined security rules or signatures. The tool will flag any lines of code that match these rules or signatures as potential security vulnerabilities, and then report them to the developer or security team.
  <br>
  The purpose of SAST is to identify and eliminate security vulnerabilities in the code before it is deployed, which can help to reduce the risk of cyber attacks and data breaches. By identifying and fixing vulnerabilities early in the software development process, organizations can improve the overall security and quality of their software applications.
  </details>

  <details closed>
  <summary>
  - <strong>DAST</strong> - Dynamic Application Security Testing - a type of software testing that is used to identify security vulnerabilities in a web application while it's running (not source code like SAST or software dependencies like SCA).
  </summary>
  DAST tools test the web application by simulating attacks against it and then analyze the application's response to these attacks. The attacks can include things like SQL injection, cross-site scripting, and parameter tampering.
  <br>
  DAST tools work by sending requests to the web application and analyzing the responses to identify vulnerabilities. The tool will look for things like error messages, server responses, and other signs that indicate that the application may be vulnerable to attack.
  <br>
  The purpose of DAST is to identify security vulnerabilities that may not be apparent in the application's source code. By testing the application while it's running, DAST tools can identify vulnerabilities that may only be exposed when the application is in a live environment.
  <br>
  DAST complements SAST by providing a different perspective on the application's security posture. While SAST focuses on the application's source code, DAST focuses on the application's behavior at runtime. Together, these two types of testing can help to identify and eliminate security vulnerabilities in a web application, improving the overall security and quality of the application.
  </details>  


Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

All new resources should be written to the file `actions.tf`.

- By default, GitHub actions are disabled in our organization. So, for the repository `tf-lab-app` add permission to run GitHub actions. [Hint](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_permissions). Use datasource `github_repository` created in the task 12 to get repository id. 

- During `DAST`, a GitHub action workflow will perform authenticated scan and it requires credentails for the test application. In order to avoid hard-coding the credentials GitHab action should use values from organization secrets. Add permissions for the repository to organization secrets which were created in the task 2. In can be added as the attribute `selected_repository_ids` to the resource `github_actions_organization_secret`.

- Downloads files of the test application from this [repository](https://github.com/Ovi/DummyJSON). Replace file `.eslintrc.js` with the [file](lab_rest_api/.eslintrc.js) from the folder `lab_rest_api`.

  <details closed>
  <summary>
  - <strong>.eslintrc.js</strong> - configuration file for ESLint.
  </summary>
   <strong>ESLint</strong> - is a tool for identifying and reporting on patterns found in ECMAScript/JavaScript code, with the goal of making code more consistent and avoiding bugs. In this lab it will be used for SAST scans.
  </details>  


- Add files from this repository to the `tf-lab-app` repository using `git`. Please do not forget to put these files to the root of the repository:
  ```
  .gitignore
  .prettierrc
  .eslintrc.js
  ```

- Add the GitHub action workflow configuration [file](lab_rest_api/workflow.yml) to the repository `tf-lab-app` using `git`. You must store workflow files in the `.github/workflows` directory of the repository.

Run `terraform validate` and `terraform fmt` to check if your configuration valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

As a result, you should have code of the test REST API added to the newly created repository. For this code a new GitHub action will be added. The added GitHub action will be perform SCA, SAST and DAST testing.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub repository contains code of the simple web application.
- GitHub Action works correctly.
- Push *.tf configuration files to git

# Advanced tasks

## TASK 14 - Create dynamically manageable resources

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Make the organization teams memberships management more manageable. In order to do this, for each team create a variable. For instance, for the team `security-team` create a variable:
```tf
variable "security_team_membership" {
  type = list(strings)
}
```
Create a file `github-team-membership.auto.tfvars`.
To this file add values for the variable `security_team_membership`:
```
security_team_membership = [
  "username1",
  "username2"
]
```

Configure resources in the file `members.tf` to use created variables in order to create resources dynamically.

**Hint:** Use this [documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/count).

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform imported resources with no errors
- GitHub resources are NOT changed (check GitHub WebUI)

## TASK 15 - Modules

Learn about [terraform modules](https://www.terraform.io/docs/language/modules/develop/index.html)

Refine your configurations:

- Refine `repos` configuration by creating a repository module.
- Expected input variables:
  - Repositories parameters:
    - `name`
    - `description` (default value: `""`)
    - `homepage` (default value: `""`)
    - `private` (default value: `false`)
    - `has_issues` (default value: `false`)
    - `has_projects` (default value: `false`)
    - `has_wiki` (default value: `false`)
    - `default_branch` (default value: `"main"`)
    - `allow_squash_merge` (default value: `true`)
    - `allow_merge_commit` (default value: `true`)
    - `allow_rebase_merge` (default value: `true`)
    - `delete_branch_on_merge` (default value: `true`)
  - List of branches with configuration (for protected branches):
    - `name`
    - `requiresApprovingReviews` (default value: `true`)
    - `requiredApprovingReviewCount` (default value: `1`)
    - `dismissesStaleReviews` (default value: `false`)
    - `requiresCodeOwnerReviews` (default value: `false`)
    - `requiresStatusChecks` (default value: `false`)
    - `requiredStatusCheckContexts` (default value: `[]`)
    - `requiresStrictStatusChecks` (default value: `false`)
    - `requiresCommitSignatures` (default value: `false`)
    - `restrictsPushes` (default value: `false`)
    - `pushActorIds` (default value: `[]`)
    - `isAdminEnforced` (default value: `false`)
  - List of teams and their access levels. For example:
    ```yml
    teams:
    - name: devops-team
      permissions: pull
    - name: nodejs-team
      permissions: push
    ```
  - List of names of the Organizational Secrets
  - List of repositories secrets

Store your modules in `/tf-epam-lab/non_cloud_task/github/modules` subfolders.

Run `terraform validate` and `terraform fmt` to check if your modules are valid and fit to a canonical format and style.
Run `terraform plan` to see your changes and re-apply your changes if needed.
