Summary: Lepton
Name: lepton
Version: 1.0
Release: 1%{?dist}
URL: https://github.com/dropbox/lepton
Source0: https://github.com/dropbox/lepton/archive/%{version}.tar.gz
License: ASL 2.0
Group: Applications/Archiving
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: autoconf automake bash gcc-c++ make

%description
Lepton is a tool and file format for losslessly compressing JPEGs by an average of 22%.
This can be used to archive large photo collections, or to serve images live and save 22% bandwidth.

%prep
%setup -q

%build
./autogen.sh
CFLAGS=$RPM_OPT_FLAGS ./configure --prefix=%{_prefix}
make %{?_smp_mflags}

%check
make check %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
install -d -m 755 $RPM_BUILD_ROOT/%{_bindir}
install -p -m 755 lepton $RPM_BUILD_ROOT/%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%attr(755,root,root) %{_bindir}/lepton
%doc AUTHORS README.md license.txt 

%changelog
* Fri Jul 15 2016 AIZAWA Hina <hina@bouhime.com> - 1.0-1
- v1.0
