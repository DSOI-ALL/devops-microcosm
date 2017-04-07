selenium_hub node['selenium']['hub']['servicename'] do
  host node['selenium']['hub']['host']
  port node['selenium']['hub']['port']
  jvm_args node['selenium']['hub']['jvm_args']
  newSessionWaitTimeout node['selenium']['hub']['newSessionWaitTimeout']
  prioritizer node['selenium']['hub']['prioritizer']
  servlets node['selenium']['hub']['servlets']
  withoutServlets node['selenium']['hub']['withoutServlets']
  capabilityMatcher node['selenium']['hub']['capabilityMatcher']
  throwOnCapabilityNotPresent node['selenium']['hub']['throwOnCapabilityNotPresent']
  cleanUpCycle node['selenium']['hub']['cleanUpCycle']
  debug node['selenium']['hub']['debug']
  timeout node['selenium']['hub']['timeout']
  browserTimeout node['selenium']['hub']['browserTimeout']
  maxSession node['selenium']['hub']['maxSession']
  jettyMaxThreads node['selenium']['hub']['jettyMaxThreads']
  log node['selenium']['hub']['log']
  action :install
end
