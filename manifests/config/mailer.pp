# == Class: jenkins::config::mailer
#
# This is a public class. To be instantiated directly.
#
# Configure Jenkins' mailer. This is a standalone file with a flat
# structure, so we can do it in a fairly noddy way. Because the parent
# directory is owned by Jenkins it is not possible to prevent the Jenkins UI
# from changing these values.
#
# TODO: Refactor this to use a generic type/provider that could be used for
# other Jenkins configs that are standalone files. Would need to use a real
# XML parser that supports roots, attributes and nested items. Possibly
# activesupport's #to_xml method - although it requires pulling in
# additional dependencies as gems.
#
# === Parameters
#
# [*config_hash*]
#   A flat hash of keys and values to render as XML.
#   Default: {}
#
# [*config_defaults*]
#   A flat hash of defaults to which `config_hash` will be merged on top.
#   Default: {'charset' => 'UTF-8'}
#
# [*plugin*]
#   Name of the plugin. The version may change in the future.
#   Default: 'mailer@1.4'
#
class jenkins::config::mailer(
  $config_hash = {},
  $config_defaults = {
    'charset' => 'UTF-8',
  },
  $plugin = 'mailer@1.4'
) {
  validate_hash($config_hash, $config_defaults)
  $config_merged = merge($config_defaults, $config_hash)

  file { '/var/lib/jenkins/hudson.tasks.Mailer.xml':
    ensure  => present,
    content => template('jenkins/hudson.tasks.Mailer.xml.erb'),
    notify  => Class['jenkins::service'],
  }
}
