import { events, Job } from "@brigadecore/brigadier"

const bundleToolsImg = "ghcr.io/vdice/bundle-tools:v0.1.0"
const localPath = "/workspaces/brigade"

// A map of all jobs. When a check_run:rerequested event wants to re-run a
// single job, this allows us to easily find that job by name.
const jobs: {[key: string]: (event: any) => Job } = {}

const buildBundleJobName = "build-bundle"
const buildBundleJob = (event: any) => {
  let job = new Job(buildBundleJobName, bundleToolsImg, event)
  job.primaryContainer.sourceMountPath = localPath
  job.primaryContainer.workingDirectory = localPath
  job.primaryContainer.privileged = true
  job.primaryContainer.command = ["bash"]
  job.primaryContainer.arguments = [
    '-c',
    `dockerd-entrypoint.sh & sleep 20 && make get-mixins build-bundle validate-bundle`
  ]
  return job
}
jobs[buildBundleJobName] = buildBundleJob


// Run the entire suite of tests, builds, etc. concurrently WITHOUT publishing
// anything initially. If EVERYTHING passes AND this was a push (merge,
// presumably) to the v2 branch, then run jobs to publish "edge" images.
async function runSuite(event: any): Promise<void> {
  await buildBundleJob(event).run()
}

// Either of these events should initiate execution of the entire test suite.
events.on("brigade.sh/github", "check_suite:requested", runSuite)
events.on("brigade.sh/github", "check_suite:rerequested", runSuite)

// This event indicates a specific job is to be re-run.
events.on("brigade.sh/github", "check_run:rerequested", async event => {
  const jobName = JSON.parse(event.payload).check_run.name
  const job = jobs[jobName]
  if (job) {
    await job(event).run()
  }
  throw new Error(`No job found with name: ${jobName}`)
})

events.on("brigade.sh/cli", "exec", runSuite)

events.process()