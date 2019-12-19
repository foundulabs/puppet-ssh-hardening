Facter.add(:ssh_version) do
  setcode 'ssh -V 2>&1 | cut -f1 -d" " | cut -f2 -d"_"'
end