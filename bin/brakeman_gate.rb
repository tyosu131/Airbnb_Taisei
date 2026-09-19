require "json"

report_path = "/tmp/brakeman.json"
scan_command = [
  "bundle", "exec", "brakeman",
  "--no-pager",
  "--no-exit-on-warn",
  "--format", "json",
  "--output", report_path
]

abort "Brakeman did not complete successfully" unless system(*scan_command)

report = JSON.parse(File.read(report_path))
warnings = report.fetch("warnings")
errors = report.fetch("errors", [])
accepted, unexpected = warnings.partition do |warning|
  warning["check_name"] == "EOLRails" &&
    warning["message"] == "Support for Rails 6.0.4.7 ended on 2023-06-01"
end

puts "Accepted Brakeman warnings:"
puts JSON.pretty_generate(accepted)
puts "Unexpected Brakeman warnings:"
puts JSON.pretty_generate(unexpected)
puts "Brakeman scan errors:"
puts JSON.pretty_generate(errors)

exit(unexpected.empty? && errors.empty? ? 0 : 1)
