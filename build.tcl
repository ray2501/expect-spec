#!/usr/bin/tclsh

set arch "x86_64"
set base "expect-5.45.4"
set fileurl "http://core.tcl.tk/expect/tarball/Expect-0a2dd35d85.tar.gz?r=0a2dd35d85cdf6253e8fcf1abf16ab421bf97ec2"

set var [list wget $fileurl -O expect.tar.gz]
exec >@stdout 2>@stderr {*}$var

set var [list tar xzvf expect.tar.gz]
exec >@stdout 2>@stderr {*}$var

file delete expect.tar.gz

set var [list mv Expect-0a2dd35d85 $base]
exec >@stdout 2>@stderr {*}$var

set var [list tar czvf $base.tar.gz $base]
exec >@stdout 2>@stderr {*}$var

if {[file exists build]} {
    file delete -force build
}

file mkdir build/BUILD build/RPMS build/SOURCES build/SPECS build/SRPMS
file copy -force $base.tar.gz build/SOURCES
file copy -force config-guess-sub-update.patch build/SOURCES
file copy -force expect-fixes.patch build/SOURCES
file copy -force expect-log.patch build/SOURCES
file copy -force expect-rpmlintrc build/SOURCES
file copy -force expect.patch build/SOURCES

set buildit [list rpmbuild --target $arch --define "_topdir [pwd]/build" -bb expect.spec]
exec >@stdout 2>@stderr {*}$buildit

# Remove our source code
file delete -force $base
file delete $base.tar.gz
