Libguestfs is tools and a library for accessing and modifying guest
disk images.  For more information see the home page:

  http://libguestfs.org/

For discussion, development, patches, etc. please use the mailing
list:

  http://www.redhat.com/mailman/listinfo/libguestfs

To find out how to build libguestfs from source, read:

  docs/guestfs-building.pod
  http://libguestfs.org/guestfs-building.1.html
  man docs/guestfs-building.1

Copyright (C) 2009-2020 Red Hat Inc.

The library is distributed under the LGPLv2+.  The programs are
distributed under the GPLv2+.  Please see the files COPYING and
COPYING.LIB for full license information.  The examples are under a
very liberal license.

####################################################################

To build libguestfs from this repository

To build packages on CentOS 8
=============================

Packages for CentOS 8
=====================
You may want to build the following packages if you are building on CentOS 8

```
sudo yum -y install glibc-devel gcc flex bison ncurses-devel libtirpc-devel pcre-devel
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install https://rpmfind.net/linux/centos/8.4.2105/BaseOS/x86_64/os/Packages/augeas-1.12.0-6.el8.x86_64.rpm
sudo yum install https://rpmfind.net/linux/centos/8.4.2105/PowerTools/x86_64/os/Packages/augeas-devel-1.12.0-6.el8.x86_64.rpm
sudo yum install http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/file-devel-5.33-16.el8_3.1.x86_64.rpm
sudo dnf install jansson-devel
sudo dnf install jansson
sudo dnf install fuse
sudo dnf install fuse-level
dnf --enablerepo=powertools install gperf
sudo yum install libcap-devel hivex hivex-devel supermin
 sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
sudo yum install patch make

sudo dnf --enablerepo=powertools install libconfig-devel
opam init
sudo dnf --enablerepo=powertools install ocaml
opam install ocamlfind
opam install ocamlbuild
sudo yum install http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/ocaml-hivex-1.3.18-20.module_el8.4.0+547+a85d02ba.x86_64.rpm
sudo yum install http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/ocaml-hivex-devel-1.3.18-20.module_el8.4.0+547+a85d02ba.x86_64.rpm
sudo yum install autoconf automake libtool gettext-devel
sudo yum install yum-utils
sudo dnf --enablerepo=powertools install ocaml-findlib-devel
sudo dnf --enablerepo=powertools install glibc-static lua-devel rpcgen ocaml-ocamldoc po4a perl-Test-Pod perl-Test-Pod-Coverage
sudo dnf --enablerepo=powertools install ocaml-camlp4
sudo yum install https://cbs.centos.org/kojifiles/packages/ocaml-fileutils/0.5.2/12.el8/x86_64/ocaml-fileutils-0.5.2-12.el8.x86_64.rpm
sudo yum install https://cbs.centos.org/kojifiles/packages/ocaml-gettext/0.3.7/7.el8/x86_64/ocaml-gettext-devel-0.3.7-7.el8.x86_64.rpm
sudo yum install https://cbs.centos.org/kojifiles/packages/ocaml-fileutils/0.5.2/12.el8/x86_64/ocaml-fileutils-devel-0.5.2-12.el8.x86_64.rpm
sudo yum install https://cbs.centos.org/kojifiles/packages/ocaml-fileutils/0.5.2/12.el8/x86_64/ocaml-fileutils-0.5.2-12.el8.x86_64.rpm
sudo yum-builddep libguestfs
sudo yum install syslinux
sudo dnf install ocaml-ounit-devel
sudo yum install syslinux-extlinux
```

```
$ git clone https://github.com/trilioData/libguestfs-1.44.1.encr.git
$ cd libguestfs-1.44.1.encr
$ export GO111MODULE=auto # Need this as the golang working directory is not a module, hence this env should be set to 'auto' instead of 'on'.
$ sudo yum install automake
$ aclocal
$ ./autogen.sh # you may need to run it again if the first invocation fails
$ make
```


To build RPMs:
==============

```
cd libguestfs-1.44.1.encr/buildingrpms
rpm -i libguestfs-1.44.1-1.fc33.src.rpm
cd ~/rpmbuild/SPECS
copy libguestfs-1.44.1.encr/buildingrpms/encr.patch into ~/rpmbuild/SOURCES
```

Modify ~/rpmbuild/SPECS/libguestfs.spec to add the following line after Source0

```
Patch0:        encr.patch
rpmbuild -v -ba --nosignature ~/rpmbuild/SPECS/libguestfs.spec
```

Your rpms will be available at ~/rpmbuild/RPMS/x86_64/.

To Build Debian packages
========================
Choose the package that is appropriate for your Ubuntu releases.

$ cat /etc/debian_version
buster/sid


All source packages can be found at: https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords=libguestfs.
Choose the package liguestfs0.

For example, for buster the right package is at: https://packages.debian.org/buster/libguestfs0

Download the source tar file from the right side of the page:

```
$ curl -O http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.40.2.orig.tar.gz
$ tar xzvf libguestfs_1.40.2.orig.tar.gz

$ cd libguestfs-1.40.2
```

Apply the patch file https://raw.githubusercontent.com/trilioData/libguestfs-1.44.1.encr/master/buildingrpms/encr.patch to the source.

Download debian build files at  http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.40.2-2.debian.tar.xz

```
curl -O http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.40.2-2.debian.tar.xz
# you may need to install xz-utils for uncompressing *.xz files.
$ sudo apt install xz-utils devscripts debhelper dh-ocaml dh-python3 dh-python dh-ruby ruby1.9.1-full gem2deb dh-gir dh-make dh-sequence-gir dh-lua dh-php gperf genisoimage flex pcre-devel libpcre-devel libpcre3 libpcre3 libpcre3 libpcre3-devel libpcre3-dev libxml2-dev install libxml2-dev libfile-dev libmagic-dev jansson libjansson libjansson-dev hivex libcap-dev hivex-deve hivex-dev python-hivex libhivex-dev libhivex qemu-system ocaml-findlib-dev ocaml-findlib supermin ocaml-hivex ocaml-findlib libhivex-ocaml libhivex-ocaml-dev openjdk-8-jdk-headless
$ tar xvf libguestfs_1.40.2-2.debian.tar.xz

curl -O http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.44.0.orig.tar.gz
curl -O curl -O http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.40.2-2.debian.tar.xz
curl -O http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.40.2-2.debian.tar.xz
curl -O http://deb.debian.org/debian/pool/main/libg/libguestfs/libguestfs_1.44.0-2.debian.tar.xz
curl -O http://ftp.us.debian.org/debian/pool/main/a/augeas/libaugeas0_1.12.0-2_amd64.deb
curl -O http://ftp.us.debian.org/debian/pool/main/a/augeas/augeas-lenses_1.12.0-2_all.deb
curl -O https://packages.debian.org/bullseye/amd64/libaugeas-dev/download
curl -O http://http.us.debian.org/debian/pool/main/a/augeas/libaugeas-dev_1.12.0-2_amd64.deb

sudo dpkg -i libaugeas0_1.12.0-2_amd64.deb
sudo dpkg -i augeas-lenses_1.12.0-2_all.deb
sudo dpkg -i libaugeas0_1.12.0-2_amd64.deb
sudo dpkg -i libaugeas-dev_1.12.0-2_amd64.deb
sudo dpkg -i libaugeas-dev_1.12.0-2_amd64.deb
```

Run the following command to build debian packages
```
$ debuild -i -d -us -uc -b 2>&1 | tee /tmp/log
```

After succesful build, the parent directory will contain debian packages

To update the patch file with new changes
=========================================
Modify the code, build the appliance and test the changes.
Create patch file that includes the differences between the original sources and new sources as follows
diff -urN libguestfs-1.44.1.orig/ libguestfs/  > encr.patch
Now use the new patch file to create new rpms.

Verify build with encryption changes
====================================
To verify that the build is successful and the new binary supports encrypted qcow2 images, follow these steps:
$ dd if=/dev/urandom of=/tmp/base bs=1M count=1024
$ qemu-img convert -p --object secret,id=sec0,data=backing --object secret,id=sec2,data=backing --image-opts driver=raw,file.filename=/tmp/base -O qcow2 -o encrypt.format=luks,encrypt.key-secret=sec2 /tmp/base.qcow2
$ qemu-img create -f qcow2 --object secret,id=sec0,data=backing -b 'json:{ "encrypt.key-secret": "sec0", "driver": "qcow2", "file": { "driver": "file", "filename": "/tmp/base.qcow2" }}' -o encrypt.format=luks,encrypt.key-secret=sec0 /tmp/overlay.qcow2 1G

$ ./run guestfish
<fs> add driver=qcow2,file.filename=/tmp/overlay.qcow2,encrypt.key-secret=sec0 secobject:secret,id=sec0,data=backing
<fs> run

The appliance should successfully boot and provide with a prompt.

######################################################################

To build packages on CentOS 9
=============================

Packages for CentOS 9
=====================
You may want to build the following packages if you are building on CentOS 9

```
## add the following to /etc/yum.repos.d/AlmaLinux-PowerTools.repo
[almaLinux-9.6-CRB-PowerTools]
name=Alma Linux $releasever - PowerTools
baseurl=https://rpmfind.net/linux/almalinux/9.6/CRB/$basearch/os/
enabled=1
gpgcheck=0

## add the following to /etc/yum.repos.d/AlmaLinux-BaseOS.repo
[almaLinux-9.6-BaseOs-PowerTools]
name=Alma Linux $releasever - BaseOS
baseurl=https://rpmfind.net/linux/almalinux/9.6/BaseOS/$basearch/os/
enabled=1
gpgcheck=0

## add the following to /etc/yum.repos.d/AlmaLinux-BaseOS.repo
[almaLinux-9.6-AppStream-PowerTools]
name=Alma Linux $releasever - AppStream
baseurl=https://rpmfind.net/linux/almalinux/9.6/AppStream/$basearch/os/
enabled=1
gpgcheck=0
```

```
yum install -y autoconf automake bash-completion bison createrepo_c file-devel flex fuse-devel \
gcc-c++ gettext-devel gjs glibc-static gobject-introspection-devel gperf icoutils jansson-devel \
libacl-devel libcap-devel libconfig-devel libtirpc-devel libtool libvirt-daemon-kvm libvirt-devel \
lsof lua lua-devel netpbm-progs pciutils perl-* perl-devel perl-generators perl-macros php-devel po4a \
python3-devel python3-libvirt readline-devel rpcgen rpm-devel rsync ruby-devel  rubygem-rake strace \
supermin-devel systemd-devel xorriso ruby-* ruby-irb
```

```
$ git clone https://github.com/trilioData/libguestfs-1.44.1.encr.git
$ cd libguestfs-1.44.1.encr
$ export GO111MODULE=auto # Need this as the golang working directory is not a module, hence this env should be set to 'auto' instead of 'on'.
$ sudo yum install automake
$ aclocal
$ ./autogen.sh # you may need to run it again if the first invocation fails
$ make
```


To build RPMs:
==============

```
cd libguestfs-1.44.1.encr/buildingrpms
rpm -i libguestfs-1.44.1-1.fc33.src.rpm
cp ~/rpmbuild/SOURCES/libguestfs-1.44.1.tar.gz <tmpbuilddir>
cd <tmpbuilddir>
tar xzvf libguestfs-1.44.1.tar.gz
mv libguestfs-1.44.1 libguestfs-1.44.1.org
tar xzvf libguestfs-1.44.1.tar.gz
mv libguestfs-1.44.1 libguestfs-1.44.1.mod

# apply agregate changes from libguestfs-1.44.1.encr/buildingrpms/encr.patch and your changes to libguestfs-1.44.1.mod
patch -s -p0 < encr.patch

# for example libguestfs-1.44.1.encr/buildingrpms/encr.patch has following changes made
diff -ruN libguestfs-1.44.1.orig/generator/actions_core.ml libguestfs-1.44.1.mod/generator/actions_core.ml
diff -ruN libguestfs-1.44.1.orig/lib/drives.c libguestfs-1.44.1.mod/lib/drives.c
diff -ruN libguestfs-1.44.1.orig/lib/guestfs-internal.h libguestfs-1.44.1.mod/lib/guestfs-internal.h
diff -ruN libguestfs-1.44.1.orig/lib/launch-direct.c libguestfs-1.44.1.mod/lib/launch-direct.c
diff -ruN libguestfs-1.44.1.orig/lib/qemu.c libguestfs-1.44.1.mod/lib/qemu.c
diff -ruN libguestfs-1.44.1.orig/README.md libguestfs-1.44.1.mod/README.md

# So copy those files to libguestfs-1.44.1.mod
cp /tmp/libguestfs-1.44.1.encr/lib/qemu.c libguestfs-1.44.1.mod/lib/qemu.c
cp /tmp/libguestfs-1.44.1.encr/lib/launch-direct.c libguestfs-1.44.1.mod/lib/launch-direct.c
cp /tmp/libguestfs-1.44.1.encr/lib/guestfs-internal.h libguestfs-1.44.1.mod/lib/guestfs-internal.h
cp /tmp/libguestfs-1.44.1.encr/lib/drives.c libguestfs-1.44.1.mod/lib/drives.c
cp /tmp/libguestfs-1.44.1.encr/generator/actions_core.ml libguestfs-1.44.1.mod/generator/actions_core.ml
cp /tmp/libguestfs-1.44.1.encr/README.md libguestfs-1.44.1.mod/

# calculate new disk
cd <tmpbuilddir>
diff -ruN libguestfs-1.44.1.orig/ libguestfs-1.44.1.mod/ > encr.patch

copy encr.patch into ~/rpmbuild/SOURCES
cd ~/rpmbuild/SPECS
```

Modify ~/rpmbuild/SPECS/libguestfs.spec to add the following line after Source0

```
Patch0:        encr.patch

rpmbuild -v -ba --nosignature ~/rpmbuild/SPECS/libguestfs.spec
```

Your rpms will be available at ~/rpmbuild/RPMS/x86_64/.
cp -r ~/rpmbuild/RPMS/ libguestfs-1.44.1.encr/buildingrpms

# push new encr.diff and new rpms to git repo and announce the new rpms to slack channel at libguestfs-qemu