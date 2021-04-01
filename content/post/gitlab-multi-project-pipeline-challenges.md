---
title:       "Gitlab Muti-project pipeline challenges"
subtitle:    "and stupidness"
description: "Here is the most complicated pipeline I have ever designed and built so far."
date:        2021-03-15
author:      "Ning"
image:       ""
tags:        ["gitlabci", "devops", "pipeline"]
categories:  ["Tech" ]
---
![abstract-multiproject-pipeline](/img/abstract-multiproject-pipeline.png)
This is the most complicated deployment and deco pipeline I have ever designed and built so far.

1. The workflow is the biggest challenge
I am trying my best to simplify the workflow:
    - On the main page, customer will enter the app name and closet region to deploy on.
    - Our pipeline will be trigger with the passed in params
    - Based on the params, this pipeline will become either to be a provision pipeline or the deprovision pipeline.
        - provision pipeline:
            - Based on the closet region customer chose, we decide if we need to trigger provision infra project
            - If provision infra project is triggered, we will wait until it successes/fails to continue.
            - If the provision infra project success, at the end of the project will trigger the provision app stage on the parent pipeline, then trigger the next project.
            - If everything is running fine, the post job will return good status, if any of them fails, return error
            - meanwhile, there is a image build pipeline for dev to build images for the customer
        - deprovision pipeline:
            - If the deprovision option is true, another pipeline template will be used
            - the pipeline will fetch the last customer provision pipeline id and trigger the deco job

2. Overcome gitlab ci multi-project native solution
    GitLab CI is powerful, true. However, I feel helpless over again when I look for the multi-project solution.
    - It supports keyword `trigger` to trigger another project's pipeline, but it doesn't support add extra scripts to be able to pass dynamic variables.
    - It supports using curl to trigger pipeline, but the api does not wait for its result.
    Finally, I went for an opensource tool called `pipeline-trigger` to satisfy all my needs.

3. Overcome gitlab ci dynamic variables stupidness
    All my pipeline depends on an initial variable I need to fetch from db during the pipeline run. However, I cannot pass this variable across the stages easily. I finally went to use curl api to create this variable on the fly and delete it after.
    Other unsupported feature is, I cannot define variable when the variable name is a variable...

4. `rules` is powerful
    I use keyword `rules` to control different stages creation and do lots of amazing logic
    ```
    rules:
        - if: '$FOO == "bar"'
    ```
    In the above case, only when var `FOO` is bar, this job will be created.
