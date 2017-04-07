actions :install
default_action :install

attribute :servicename, kind_of: String, name_attribute: true
attribute :host, kind_of: [String, NilClass]
attribute :port, kind_of: Integer, default: 5555
attribute :jvm_args, kind_of: [String, NilClass]
attribute :proxy, kind_of: String, default: 'org.openqa.grid.selenium.proxy.DefaultRemoteProxy'
attribute :maxSession, kind_of: Integer, default: 5
attribute :register, kind_of: [TrueClass, FalseClass], default: true
attribute :registerCycle, kind_of: Integer, default: 5000
attribute :nodeStatusCheckTimeout, kind_of: Integer, default: 5000
attribute :nodePolling, kind_of: Integer, default: 5000
attribute :unregisterIfStillDownAfter, kind_of: Integer, default: 60_000
attribute :downPollingLimit, kind_of: Integer, default: 2
attribute :debug, kind_of: [TrueClass, FalseClass], default: false
attribute :servlets, kind_of: Array, default: []
attribute :withoutServlets, kind_of: Array, default: []
attribute :timeout, kind_of: Integer, default: 1800
attribute :browserTimeout, kind_of: Integer, default: 0
attribute :jettyMaxThreads, kind_of: Integer, default: -1
attribute :log, kind_of: [String, NilClass]
attribute :hub, kind_of: String, default: 'http://localhost:4444'
attribute :capabilities, kind_of: [Array, Hash], default: []

# linux only - DISPLAY must match running instance of Xvfb, x11vnc or equivalent
attribute :xdisplay, kind_of: String, default: ':0'

# mac/windows only - set username/password to run service in gui or leave nil to run service in background
attribute :username, kind_of: [String, NilClass], default: nil
attribute :password, kind_of: [String, NilClass], default: nil
