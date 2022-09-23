cat isi.s tests/m2.s > exe.s
~dp1092/bin/spim -file exe.s | sed -e 1d
