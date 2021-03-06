/*
== Definition: postfix::config

Uses the "postconf" command to add/alter/remove options in postfix main
configuation file (/etc/postfix/main.cf).

Parameters:
- *name*: name of the parameter.
- *ensure*: present/absent. defaults to present.
- *value*: value of the parameter.

Requires:
- Class["postfix"]

Example usage:

  node "toto.example.com" {

    include postfix

    postfix::config {
      "smtp_use_tls"            => "yes";
      "smtp_sasl_auth_enable"   => "yes";
      "smtp_sasl_password_maps" => "hash:/etc/postfix/my_sasl_passwords";
      "relayhost"               => "[mail.example.com]:587";
    }
  }

*/
define postfix::config ($ensure = present, $value) {

  Augeas {
    context => "/files/etc/postfix/main.cf",
    notify  => Service["postfix"],
    require => File["/etc/postfix/main.cf"],
  }

  case $ensure {
    present: {
      augeas { "set-postfix-${name}":
        changes => "set $name $value",
      }
    }

    absent: {
      augeas { "unset-postfix-${name}":
        changes => "rm $name",
      }
    }
  }
}
