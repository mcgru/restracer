Name:           restracer
Version:        0.2.0
Release:        1%{?dist}
Summary:        Resource tracing, debugging and profiling tool

License:        GPL-3+
URL:            https://github.com/larkvirtual/restracer

# Static build — no runtime dependencies on libxml++ or glibmm

%description
Cross-platform method to trace software errors in runtime during
resource manipulation. Uses XML to describe abstract resources and
their functions, allowing new resource classes to be added without
changing the analyzer core. Detected errors often have an influence
on security, safety, robustness and resource optimal usage.

This package contains statically linked binaries with no external
library dependencies.

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libdir}/restracer/templates
cp -a %{_sourcedir}/artlibgen      %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/artrepgen      %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/rt-make        %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-make %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/rt-gmake       %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-gmake %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-gcc  %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-g++  %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-cc   %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-c++  %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer-ld   %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/restracer      %{buildroot}%{_bindir}/
cp -a %{_sourcedir}/templates      %{buildroot}%{_libdir}/restracer/

%files
%{_bindir}/artlibgen
%{_bindir}/artrepgen
%{_bindir}/rt-make
%{_bindir}/restracer-make
%{_bindir}/rt-gmake
%{_bindir}/restracer-gmake
%{_bindir}/restracer-gcc
%{_bindir}/restracer-g++
%{_bindir}/restracer-cc
%{_bindir}/restracer-c++
%{_bindir}/restracer-ld
%{_bindir}/restracer
%{_libdir}/restracer/templates/

%changelog
* Mon Jun 15 2026 larkvirtual - 0.2.0-1
- Initial static build package
