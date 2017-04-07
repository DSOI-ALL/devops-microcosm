actions :install
default_action :install

attribute :servicename, kind_of: String, name_attribute: true
attribute :host, kind_of: [String, NilClass]
attribute :port, kind_of: Integer, default: 4444
attribute :jvm_args, kind_of: [String, NilClass]
attribute :newSessionWaitTimeout, kind_of: Integer, default: -1
attribute :prioritizer, kind_of: [Class, String, Symbol, NilClass]
attribute :servlets, kind_of: Array, default: []
attribute :withoutServlets, kind_of: Array, default: []
attribute :capabilityMatcher, kind_of: String, default: 'org.openqa.grid.internal.utils.DefaultCapabilityMatcher'
attribute :throwOnCapabilityNotPresent, kind_of: [TrueClass, FalseClass], default: true
attribute :cleanUpCycle, kind_of: Integer, default: 5000
attribute :debug, kind_of: [TrueClass, FalseClass], default: false
attribute :timeout, kind_of: Integer, default: 1800
attribute :browserTimeout, kind_of: Integer, default: 0
attribute :maxSession, kind_of: Integer, default: 5
attribute :jettyMaxThreads, kind_of: Integer, default: -1
attribute :log, kind_of: [String, NilClass]
