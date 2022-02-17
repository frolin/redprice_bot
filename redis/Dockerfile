FROM ruby:3.0.1-alpine AS ruby_base
CMD ["chown", "redis:redis", "-R", "/etc"]
CMD ["chown", "redis:redis", "-R", "/var/lib"]
CMD ["chown", "redis:redis", "-R", "/run"]

CMD ["sudo", "chmod", "644", "/data/dump.rdb" ]
CMD ["sudo", "chmod", "755", "/etc" ]
CMD ["sudo", "chmod", "770", "/var/lib" ]
CMD ["sudo", "chmod", "777", "/run" ]
