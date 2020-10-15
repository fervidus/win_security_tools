plan win_security_tools::stig_report_2016 (
  TargetSpec $targets,
) {
  apply_prep($targets)

  $results = apply($targets, _noop => true) {
    package { 'nokogiri':
      ensure   => installed,
      provider => gem,
    }

    class { '::secure_windows': }
  }

  $report = $results[0].report

  $statuses = $report['resource_statuses']

  $changes = $statuses.map | $resource, $value | {

    {
      resource => $resource,
      # message  => $value['events'][0]['message'],
      # stig     => grep($value['tags'], '^v\d+'),
    }
  }

  return $changes
}
