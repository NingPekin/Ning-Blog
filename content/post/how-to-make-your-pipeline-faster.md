---
title:       "How to make your pipeline faster"
subtitle:    "in Gitlab-CI"
description: "some tips I can share base on my personal experience."
date:        2021-03-01
author:      "Ning"
image:       ""
tags:        ["gitlabci", "devops", "pipeline"]
categories:  ["Tech"]
---

Automation everything is the slogan for DevOps at some points. In the development lifecycle, we have different stages in an inifite loop. And the pipeline is the bridge which can link these stages together to keep your application development process stable and efficient.

![development-lifecycle](/img/devlopement-lifecycle.png )


We are using Gitlab as our main repository management platform where GitLab Ci is our choice to build pipeline at work. When we do fast release, we would like to make pipeline as fast as possible to reduce CI/CD time.

Here are some tips I can share base on my personal experience.

1. Build customize images for your pipeline

    Gitlab CI allows us to use different images for different pipeline stage/job. For each stage or job, we might need different packages/tools. The size of image with different tools are quite differnet sometimes. For example, if you only need `curl` in one of your terraform pipeline, you don't need to add this extra tool to your main terraform image. Instead, you can use a light alpine image and only install curl inside. Because, the size of the image does matter a lot to the speed.

    This also means, instead of installing the same tooling during the pipeline jobs, we can choose to pre-install dependenices in the image directly and use light linux distros as much as possible.

2. Cache your docker image

    Docker build time is always a bottleneck of speed up CICD process because it takes time. From the [offical doc](https://docs.gitlab.com/ce/ci/docker/using_docker_build.html#using-docker-caching), it gives us an example to how to use docker caching in the pipelien. Basically, we will need to push our latest docker build to gitlab registry(or somewhere else you prefer), and everytime the pipeline gets triggered, we use that previous build as caching source to avoid duplicated build steps in order to speed up the build.



3. Use as fewer sequence jobs as possible

    What does `sequence jobs` mean here is the job it has to wait until end to run the next one. In the gitlab ci world, we can run multiple jobs in one stage in parellal. When your tasks don't have relationship with some others (i.e you don't need to start the jobs depends on the result of others), you should consider make them run at the same time to save significant time.

    To give your an example:

    In the below diagram, we can run different test cases in the test stage at the same time. And the deploy stage will wait until the test stage finish to start. Also gitlab ci supports some logical statement to let's say if any of jobs in the test stage fail, the deploy stage cannot start.


    ![pipeline-parallel-jobs](/img/pipeline-parallel-jobs.png )
