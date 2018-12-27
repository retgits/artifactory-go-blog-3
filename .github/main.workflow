workflow "New workflow" {
  on = "push"
  resolves = ["Step3 - Publish Build Info"]
}

action "Step1 - Publish package" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  env = {
    CRED = "username"
    COMMAND = "go-publish go v1.0.0 --build-name=my-build --build-number=1"
  }
}

action "Step2 - Collect Build Info" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  env = {
    CRED = "username"
    COMMAND = "build-collect-env my-build 1"
  }
  needs = ["Step1 - Publish package"]
}

action "Step3 - Publish Build Info" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  env = {
    CRED = "username"
    COMMAND = "build-publish my-build 1"
  }
  needs = ["Step2 - Collect Build Info"]
}
