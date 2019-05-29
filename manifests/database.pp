# == Define pgbouncer::database
#
# defines a database for pgbouncer to service
# currently, the "connect_query" option needs to be extra quoted because of how it's set up in the template
# example: options => { connect_query => '"select 1"' }
# I hope to fix this in a later version
#
define pgbouncer::database (
  $database = $title,
  $dbname   = undef,
  $user     = undef,
  $password = undef,
  $host     = undef,
  $port     = undef,
  Hash $options  = {},
) {
  include pgbouncer

  concat::fragment { "pgbouncer_database_${name}":
    target  => $pgbouncer::configfile,
    order   => "20_database_10_${name}",
    content => template('pgbouncer/pgbouncer.ini.database_fragment.erb'),
  }
}
