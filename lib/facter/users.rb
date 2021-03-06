Facter.add(:have_psql) do

  confine :kernel => %w{Linux SunOS}
  setcode do
    if Facter::Core::Execution.exec("ps -ef").match(/^postgres/)
        true
    else
        false
    end
  end
end

Facter.add(:pgusers_array) do
  confine :have_psql => true
  setcode do
   pgusers_array = Facter::Util::Resolution.exec('psql -qAtX -d postgres -c \'SELECT usename from pg_shadow where passwd is not null order by 1\'').split("\n")
   pgusers_array
  end
end

Facter.add(:pgusers_hash) do
  confine :have_psql => true
  setcode do
    pgusers_array = Facter.value(:pgusers_array)
    pgusers_hash = {}

    pgusers_array.each do |user|
      passwd = Facter::Util::Resolution.exec("psql -qAtX -d postgres -c \"SELECT passwd from pg_shadow where usename='#{user}'\"")
      if passwd
        pgusers_hash[user] = {'password' => passwd, 'username' => user}
      end
    end

    pgusers_hash
  end
end
