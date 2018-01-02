From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH for sg3_utils 1/4] configure.ac: Suppress an autoconf warning
Date: Tue,  2 Jan 2018 10:13:38 -0800
Message-ID: <20180102181341.13435-2-bart.vanassche@wdc.com>
References: <20180102181341.13435-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36146 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeABSNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:13:45 -0500
In-Reply-To: <20180102181341.13435-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Avoid that autoconf reports the following warning:

configure.ac:15: warning: LT_INIT was called before AM_PROG_AR

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 configure    | 352 +++++++++++++++++++++++++++++------------------------------
 configure.ac |   6 +-
 2 files changed, 179 insertions(+), 179 deletions(-)

diff --git a/configure b/configure
index 4a664c1bc343..5fe9a187a373 100755
--- a/configure
+++ b/configure
@@ -661,8 +661,6 @@ NMEDIT
 DSYMUTIL
 MANIFEST_TOOL
 RANLIB
-ac_ct_AR
-AR
 DLLTOOL
 OBJDUMP
 LN_S
@@ -683,6 +681,8 @@ build_vendor
 build_cpu
 build
 LIBTOOL
+ac_ct_AR
+AR
 am__fastdepCC_FALSE
 am__fastdepCC_TRUE
 CCDEPMODE
@@ -3920,6 +3920,180 @@ fi
 # AC_PROG_CXX
 
 
+# AM_PROG_AR is supported and needed since automake v1.12+
+
+if test -n "$ac_tool_prefix"; then
+  for ac_prog in ar lib "link -lib"
+  do
+    # Extract the first word of "$ac_tool_prefix$ac_prog", so it can be a program name with args.
+set dummy $ac_tool_prefix$ac_prog; ac_word=$2
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for $ac_word" >&5
+$as_echo_n "checking for $ac_word... " >&6; }
+if ${ac_cv_prog_AR+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  if test -n "$AR"; then
+  ac_cv_prog_AR="$AR" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+    for ac_exec_ext in '' $ac_executable_extensions; do
+  if as_fn_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_AR="$ac_tool_prefix$ac_prog"
+    $as_echo "$as_me:${as_lineno-$LINENO}: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+  done
+IFS=$as_save_IFS
+
+fi
+fi
+AR=$ac_cv_prog_AR
+if test -n "$AR"; then
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $AR" >&5
+$as_echo "$AR" >&6; }
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+fi
+
+
+    test -n "$AR" && break
+  done
+fi
+if test -z "$AR"; then
+  ac_ct_AR=$AR
+  for ac_prog in ar lib "link -lib"
+do
+  # Extract the first word of "$ac_prog", so it can be a program name with args.
+set dummy $ac_prog; ac_word=$2
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for $ac_word" >&5
+$as_echo_n "checking for $ac_word... " >&6; }
+if ${ac_cv_prog_ac_ct_AR+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  if test -n "$ac_ct_AR"; then
+  ac_cv_prog_ac_ct_AR="$ac_ct_AR" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+    for ac_exec_ext in '' $ac_executable_extensions; do
+  if as_fn_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_ac_ct_AR="$ac_prog"
+    $as_echo "$as_me:${as_lineno-$LINENO}: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+  done
+IFS=$as_save_IFS
+
+fi
+fi
+ac_ct_AR=$ac_cv_prog_ac_ct_AR
+if test -n "$ac_ct_AR"; then
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_ct_AR" >&5
+$as_echo "$ac_ct_AR" >&6; }
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+fi
+
+
+  test -n "$ac_ct_AR" && break
+done
+
+  if test "x$ac_ct_AR" = x; then
+    AR="false"
+  else
+    case $cross_compiling:$ac_tool_warned in
+yes:)
+{ $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: using cross tools not prefixed with host triplet" >&5
+$as_echo "$as_me: WARNING: using cross tools not prefixed with host triplet" >&2;}
+ac_tool_warned=yes ;;
+esac
+    AR=$ac_ct_AR
+  fi
+fi
+
+: ${AR=ar}
+
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking the archiver ($AR) interface" >&5
+$as_echo_n "checking the archiver ($AR) interface... " >&6; }
+if ${am_cv_ar_interface+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+
+   am_cv_ar_interface=ar
+   cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+int some_variable = 0;
+_ACEOF
+if ac_fn_c_try_compile "$LINENO"; then :
+  am_ar_try='$AR cru libconftest.a conftest.$ac_objext >&5'
+      { { eval echo "\"\$as_me\":${as_lineno-$LINENO}: \"$am_ar_try\""; } >&5
+  (eval $am_ar_try) 2>&5
+  ac_status=$?
+  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
+  test $ac_status = 0; }
+      if test "$ac_status" -eq 0; then
+        am_cv_ar_interface=ar
+      else
+        am_ar_try='$AR -NOLOGO -OUT:conftest.lib conftest.$ac_objext >&5'
+        { { eval echo "\"\$as_me\":${as_lineno-$LINENO}: \"$am_ar_try\""; } >&5
+  (eval $am_ar_try) 2>&5
+  ac_status=$?
+  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
+  test $ac_status = 0; }
+        if test "$ac_status" -eq 0; then
+          am_cv_ar_interface=lib
+        else
+          am_cv_ar_interface=unknown
+        fi
+      fi
+      rm -f conftest.lib libconftest.a
+
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+   ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $am_cv_ar_interface" >&5
+$as_echo "$am_cv_ar_interface" >&6; }
+
+case $am_cv_ar_interface in
+ar)
+  ;;
+lib)
+  # Microsoft lib, so override with the ar-lib wrapper script.
+  # FIXME: It is wrong to rewrite AR.
+  # But if we don't then we get into trouble of one sort or another.
+  # A longer-term fix would be to have automake use am__AR in this case,
+  # and then we could set am__AR="$am_aux_dir/ar-lib \$(AR)" or something
+  # similar.
+  AR="$am_aux_dir/ar-lib $AR"
+  ;;
+unknown)
+  as_fn_error $? "could not determine $AR interface" "$LINENO" 5
+  ;;
+esac
+
+
 # Adding libtools to the build seems to bring in C++ environment
 case `pwd` in
   *\ * | *\	*)
@@ -5491,7 +5665,6 @@ test -z "$sharedlib_from_linklib_cmd" && sharedlib_from_linklib_cmd=$ECHO
 
 
 
-
 if test -n "$ac_tool_prefix"; then
   for ac_prog in ar
   do
@@ -11987,179 +12160,6 @@ CC=$lt_save_CC
 
 
 
-# AM_PROG_AR is supported and needed since automake v1.12+
-if test -n "$ac_tool_prefix"; then
-  for ac_prog in ar lib "link -lib"
-  do
-    # Extract the first word of "$ac_tool_prefix$ac_prog", so it can be a program name with args.
-set dummy $ac_tool_prefix$ac_prog; ac_word=$2
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for $ac_word" >&5
-$as_echo_n "checking for $ac_word... " >&6; }
-if ${ac_cv_prog_AR+:} false; then :
-  $as_echo_n "(cached) " >&6
-else
-  if test -n "$AR"; then
-  ac_cv_prog_AR="$AR" # Let the user override the test.
-else
-as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
-for as_dir in $PATH
-do
-  IFS=$as_save_IFS
-  test -z "$as_dir" && as_dir=.
-    for ac_exec_ext in '' $ac_executable_extensions; do
-  if as_fn_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
-    ac_cv_prog_AR="$ac_tool_prefix$ac_prog"
-    $as_echo "$as_me:${as_lineno-$LINENO}: found $as_dir/$ac_word$ac_exec_ext" >&5
-    break 2
-  fi
-done
-  done
-IFS=$as_save_IFS
-
-fi
-fi
-AR=$ac_cv_prog_AR
-if test -n "$AR"; then
-  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $AR" >&5
-$as_echo "$AR" >&6; }
-else
-  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
-$as_echo "no" >&6; }
-fi
-
-
-    test -n "$AR" && break
-  done
-fi
-if test -z "$AR"; then
-  ac_ct_AR=$AR
-  for ac_prog in ar lib "link -lib"
-do
-  # Extract the first word of "$ac_prog", so it can be a program name with args.
-set dummy $ac_prog; ac_word=$2
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for $ac_word" >&5
-$as_echo_n "checking for $ac_word... " >&6; }
-if ${ac_cv_prog_ac_ct_AR+:} false; then :
-  $as_echo_n "(cached) " >&6
-else
-  if test -n "$ac_ct_AR"; then
-  ac_cv_prog_ac_ct_AR="$ac_ct_AR" # Let the user override the test.
-else
-as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
-for as_dir in $PATH
-do
-  IFS=$as_save_IFS
-  test -z "$as_dir" && as_dir=.
-    for ac_exec_ext in '' $ac_executable_extensions; do
-  if as_fn_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
-    ac_cv_prog_ac_ct_AR="$ac_prog"
-    $as_echo "$as_me:${as_lineno-$LINENO}: found $as_dir/$ac_word$ac_exec_ext" >&5
-    break 2
-  fi
-done
-  done
-IFS=$as_save_IFS
-
-fi
-fi
-ac_ct_AR=$ac_cv_prog_ac_ct_AR
-if test -n "$ac_ct_AR"; then
-  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_ct_AR" >&5
-$as_echo "$ac_ct_AR" >&6; }
-else
-  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
-$as_echo "no" >&6; }
-fi
-
-
-  test -n "$ac_ct_AR" && break
-done
-
-  if test "x$ac_ct_AR" = x; then
-    AR="false"
-  else
-    case $cross_compiling:$ac_tool_warned in
-yes:)
-{ $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: using cross tools not prefixed with host triplet" >&5
-$as_echo "$as_me: WARNING: using cross tools not prefixed with host triplet" >&2;}
-ac_tool_warned=yes ;;
-esac
-    AR=$ac_ct_AR
-  fi
-fi
-
-: ${AR=ar}
-
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking the archiver ($AR) interface" >&5
-$as_echo_n "checking the archiver ($AR) interface... " >&6; }
-if ${am_cv_ar_interface+:} false; then :
-  $as_echo_n "(cached) " >&6
-else
-  ac_ext=c
-ac_cpp='$CPP $CPPFLAGS'
-ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
-ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
-ac_compiler_gnu=$ac_cv_c_compiler_gnu
-
-   am_cv_ar_interface=ar
-   cat confdefs.h - <<_ACEOF >conftest.$ac_ext
-/* end confdefs.h.  */
-int some_variable = 0;
-_ACEOF
-if ac_fn_c_try_compile "$LINENO"; then :
-  am_ar_try='$AR cru libconftest.a conftest.$ac_objext >&5'
-      { { eval echo "\"\$as_me\":${as_lineno-$LINENO}: \"$am_ar_try\""; } >&5
-  (eval $am_ar_try) 2>&5
-  ac_status=$?
-  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
-  test $ac_status = 0; }
-      if test "$ac_status" -eq 0; then
-        am_cv_ar_interface=ar
-      else
-        am_ar_try='$AR -NOLOGO -OUT:conftest.lib conftest.$ac_objext >&5'
-        { { eval echo "\"\$as_me\":${as_lineno-$LINENO}: \"$am_ar_try\""; } >&5
-  (eval $am_ar_try) 2>&5
-  ac_status=$?
-  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
-  test $ac_status = 0; }
-        if test "$ac_status" -eq 0; then
-          am_cv_ar_interface=lib
-        else
-          am_cv_ar_interface=unknown
-        fi
-      fi
-      rm -f conftest.lib libconftest.a
-
-fi
-rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
-   ac_ext=c
-ac_cpp='$CPP $CPPFLAGS'
-ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
-ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
-ac_compiler_gnu=$ac_cv_c_compiler_gnu
-
-fi
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $am_cv_ar_interface" >&5
-$as_echo "$am_cv_ar_interface" >&6; }
-
-case $am_cv_ar_interface in
-ar)
-  ;;
-lib)
-  # Microsoft lib, so override with the ar-lib wrapper script.
-  # FIXME: It is wrong to rewrite AR.
-  # But if we don't then we get into trouble of one sort or another.
-  # A longer-term fix would be to have automake use am__AR in this case,
-  # and then we could set am__AR="$am_aux_dir/ar-lib \$(AR)" or something
-  # similar.
-  AR="$am_aux_dir/ar-lib $AR"
-  ;;
-unknown)
-  as_fn_error $? "could not determine $AR interface" "$LINENO" 5
-  ;;
-esac
-
-
 # check for headers
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for ANSI C header files" >&5
 $as_echo_n "checking for ANSI C header files... " >&6; }
diff --git a/configure.ac b/configure.ac
index 1cce0b25f583..129c2f9d4d4d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,13 +7,13 @@ AM_CONFIG_HEADER(config.h)
 AC_PROG_CC
 # AC_PROG_CXX
 AC_PROG_INSTALL
-		
-# Adding libtools to the build seems to bring in C++ environment
-AC_PROG_LIBTOOL
 
 # AM_PROG_AR is supported and needed since automake v1.12+
 ifdef([AM_PROG_AR], [AM_PROG_AR], []) 
 
+# Adding libtools to the build seems to bring in C++ environment
+AC_PROG_LIBTOOL
+
 # check for headers
 AC_HEADER_STDC
 
-- 
2.15.1
