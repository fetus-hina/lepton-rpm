#!/bin/bash

set -eu

for i in 7; do
  rm -rf centos${i}.build
  docker pull centos:$i
  make centos${i}
  find centos${i}.build -type f -name '*.rpm' | xargs ./sign.exp
  cp -f centos${i}.build/RPMS/x86_64/lepton-*.rpm /var/www/sites/fetus.jp/rpm.fetus.jp/public_html/el${i}/x86_64/lepton/
  createrepo /var/www/sites/fetus.jp/rpm.fetus.jp/public_html/el${i}/x86_64/

  cp -f centos${i}.build/SRPMS/lepton-*.rpm /var/www/sites/fetus.jp/rpm.fetus.jp/public_html/el${i}/src/lepton/
  createrepo /var/www/sites/fetus.jp/rpm.fetus.jp/public_html/el${i}/src/
done
